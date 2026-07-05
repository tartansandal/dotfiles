#!/usr/bin/env bash
# Download a package + its missing shared-lib deps from the configured
# zypper repos (internal mirror) and unpack it under a user-owned prefix,
# without ever needing root.
#
# Usage: fetch-rpm-userspace.sh <package-name> [install-prefix]
#   e.g. fetch-rpm-userspace.sh neovim ~/.local

set -euo pipefail

# DEBUG=1 ./fetch-rpm-userspace.sh ... for a full command trace on top of the
# informational messages below.
if [[ "${DEBUG:-0}" == "1" ]]; then
  PS4='+ ${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]:-main}: '
  set -x
fi

PKG="${1:?usage: $0 <package-name> [install-prefix]}"
PREFIX="${2:-$HOME/.local}"
CACHE_DIR="$HOME/.cache/rpm-fetch/cache"
EXTRACT_DIR="$HOME/.cache/rpm-fetch/extract"
MAX_ITER=10

mkdir -p "$CACHE_DIR" "$EXTRACT_DIR" "$PREFIX"

ZYPPER=(zypper --pkg-cache-dir "$CACHE_DIR" --no-refresh)

declare -A SEEN

# Declared Requires (from the rpm header) are clean package/soname
# capabilities zypper can actually resolve — unlike the raw file paths ldd
# reports post-extraction, which zypper's provides search can't match on
# anything outside a handful of well-known legacy dirs.
declared_requires() {
  local rpm="$1"
  rpm -qp --requires "$rpm" 2>/dev/null \
    | sed -E 's/[[:space:]]+[<>=]+.*$//' \
    | grep -vE '^rpmlib\(' \
    | sort -u
}

is_satisfied() {
  rpm -q --whatprovides "$1" >/dev/null 2>&1
}

download_pkg() {
  local pkg="$1" rpmfile cap provider
  [[ -n "${SEEN[$pkg]:-}" ]] && return
  SEEN[$pkg]=1
  echo "==> downloading $pkg"
  "${ZYPPER[@]}" download "$pkg"

  # Old test runs leave stale rpms for the same package name (different
  # version/repo) sitting in the cache — -print -quit has no ordering
  # guarantee, so pick whichever match is newest, i.e. what we just fetched.
  rpmfile="$(find "$CACHE_DIR" -name "${pkg}-[0-9]*.rpm" -printf '%T@ %p\n' 2>/dev/null \
    | sort -rn | head -1 | sed 's/^[^ ]* //')"
  echo "    rpm file for $pkg: ${rpmfile:-<none found in cache>}"
  [[ -z "$rpmfile" ]] && return

  local -a reqs
  mapfile -t reqs < <(declared_requires "$rpmfile")
  echo "    $pkg declared requires (${#reqs[@]}): ${reqs[*]:-<none>}"

  for cap in "${reqs[@]}"; do
    [[ -z "$cap" ]] && continue
    if is_satisfied "$cap"; then
      echo "    [$cap] already satisfied on system — skipping"
      continue
    fi
    provider="$(resolve_provider "$cap")"
    if [[ -z "$provider" ]]; then
      echo "!! no provider found for declared requires '$cap' of $pkg — resolve manually"
      continue
    fi
    if [[ -n "${SEEN[$provider]:-}" ]]; then
      echo "    [$cap] -> provider: $provider (already seen — skipping)"
    else
      echo "    [$cap] -> provider: $provider"
      download_pkg "$provider"
    fi
  done
}

VERIFY_LOG="$EXTRACT_DIR/verify.log"

verify_rpm() {
  local rpm="$1" result
  result="$(rpm -K "$rpm" 2>&1)" || true
  { echo "[$(date -Iseconds)] $result"; } >>"$VERIFY_LOG"
  echo "    $result"
  if ! grep -q 'digests OK\|digests signatures OK' <<<"$result"; then
    echo "!! digest check FAILED for $rpm — aborting" >&2
    exit 1
  fi
  if ! grep -qi 'signatures OK' <<<"$result"; then
    echo "!! no verified GPG signature for $(basename "$rpm") (key not in local db, or repo is unsigned) — digest-only pass, flag for manual review"
  fi
}

extract_new() {
  local rpm marker
  while IFS= read -r -d '' rpm; do
    marker="$EXTRACT_DIR/.extracted-$(basename "$rpm")"
    [[ -f "$marker" ]] && continue
    echo "==> verifying $(basename "$rpm")"
    verify_rpm "$rpm"
    echo "==> extracting $(basename "$rpm")"
    ( cd "$EXTRACT_DIR" && rpm2cpio "$rpm" | cpio -idmu )
    touch "$marker"
  done < <(find "$CACHE_DIR" -name '*.rpm' -print0)
}

# Both helpers below run their body in a `( set +e; ...; true )` subshell:
# any internal grep/head stage finding zero matches is a normal, expected
# outcome here, not an error, but under the script's own `set -e -o pipefail`
# it's one non-zero exit status away from silently killing the whole run at
# whatever assignment happens to call this. Scoping errexit off inside an
# isolated subshell (and forcing a clean exit via the trailing `true`) means
# "found nothing" is signalled purely through empty stdout, never through
# exit status — so no call site, present or future, needs its own `|| true`.
resolve_provider() {
  local cap="$1"
  (
    set +e
    xml="$("${ZYPPER[@]}" -x wp "$cap" 2>/dev/null)"
    echo "        [resolve_provider] query='$cap' solvables=$(grep -c '<solvable ' <<<"$xml")" >&2
    # Prefer a real x86_64/noarch package; a bare capability match can otherwise
    # resolve to an unrelated arch, an already-installed dupe, or a non-package
    # solvable (patch/srcpackage) ahead of the one we actually want.
    pick="$(grep '<solvable ' <<<"$xml" | grep -E 'kind="package"' | grep -E 'arch="(x86_64|noarch)"' | head -1)"
    [[ -z "$pick" ]] && pick="$(grep '<solvable ' <<<"$xml" | grep -E 'kind="package"' | head -1)"
    [[ -n "$pick" ]] && grep -o 'name="[^"]*"' <<<"$pick" | head -1 | cut -d'"' -f2
    true
  )
}

# Every directory actually containing a .so* file, not just the two
# conventional top-level ones — plugin/module libs commonly live nested
# (e.g. usr/lib64/lua/5.1), and LD_LIBRARY_PATH doesn't search recursively.
lib_dirs() {
  find "$1" -name '*.so*' -printf '%h\n' 2>/dev/null | sort -u | paste -sd: -
}

missing_libs() {
  local f
  (
    set +e
    while IFS= read -r -d '' f; do
      file "$f" | grep -q 'ELF' && {
        # ldd only searches RPATH/LD_LIBRARY_PATH/ld.so.cache/default dirs, none
        # of which cover $EXTRACT_DIR — without this, every lib we've already
        # vendored still reads back as "not found" on every subsequent pass.
        LD_LIBRARY_PATH="$(lib_dirs "$EXTRACT_DIR/usr")${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}" \
          ldd "$f" 2>/dev/null
      }
    done < <(find "$EXTRACT_DIR" -type f \( -perm -u+x -o -name '*.so*' \) -print0) \
      | awk '/not found/ {print $1}' \
      | sort -u
    true
  )
}

# Some binaries record a dependency by absolute path (e.g. dlopen'd Lua C
# modules linked with -l:/full/path) rather than a bare soname. The dynamic
# linker treats an absolute NEEDED entry as a literal path to open — it never
# consults RPATH/LD_LIBRARY_PATH/ld.so.cache for it — so no amount of
# LD_LIBRARY_PATH tweaking can redirect it at our vendored copy. Rewriting it
# to a bare soname via patchelf makes it go through the normal search path.
patch_absolute_needed() {
  local f needed target patchelf_bin
  while IFS= read -r -d '' f; do
    file "$f" | grep -q ELF || continue
    while IFS= read -r needed; do
      [[ "$needed" == /* ]] || continue
      target="$EXTRACT_DIR$needed"
      [[ -f "$target" ]] || continue
      if command -v patchelf >/dev/null 2>&1; then
        patchelf_bin=patchelf
      elif [[ -x "$EXTRACT_DIR/usr/bin/patchelf" ]]; then
        patchelf_bin="$EXTRACT_DIR/usr/bin/patchelf"
      else
        echo "==> absolute-path NEEDED ($needed in $(basename "$f")) — fetching patchelf to fix it"
        download_pkg patchelf
        extract_new
        patchelf_bin="$EXTRACT_DIR/usr/bin/patchelf"
      fi
      echo "    patching $(basename "$f"): NEEDED $needed -> $(basename "$needed")"
      "$patchelf_bin" --replace-needed "$needed" "$(basename "$needed")" "$f"
    done < <(readelf -d "$f" 2>/dev/null | sed -n 's/.*(NEEDED).*\[\(.*\)\]/\1/p')
  done < <(find "$EXTRACT_DIR" -type f \( -perm -u+x -o -name '*.so*' \) -print0)
}

download_pkg "$PKG"
extract_new
patch_absolute_needed

resolved=0
for ((i = 0; i < MAX_ITER; i++)); do
  libs="$(missing_libs)" || true
  if [[ -z "$libs" ]]; then
    echo "==> all shared libs resolved"
    resolved=1
    break
  fi

  echo "==> pass $i, missing libs:"
  echo "$libs" | sed 's/^/    /'

  new=0
  while IFS= read -r lib; do
    [[ -z "$lib" ]] && continue
    # ldd sometimes reports a dependency by absolute path rather than bare
    # soname (e.g. vendored Lua C modules). RPM's file-based Requires use the
    # literal path as the capability — the ()(64bit) soname marker only
    # applies to bare sonames and makes the lookup match nothing.
    if [[ "$lib" == /* ]]; then
      cap="$lib"
    else
      cap="${lib}()(64bit)"
    fi
    provider="$(resolve_provider "$cap")" || true
    if [[ -z "$provider" ]]; then
      echo "!! no provider found for $lib — resolve manually"
      continue
    fi
    if [[ -n "${SEEN[$provider]:-}" ]]; then
      echo "    [$lib] -> provider: $provider (already seen — skipping)"
    else
      echo "    [$lib] -> provider: $provider"
      download_pkg "$provider"
      new=1
    fi
  done <<<"$libs"

  if [[ "$new" -eq 0 ]]; then
    echo "!! could not resolve remaining libs automatically, stopping"
    break
  fi
  extract_new
  patch_absolute_needed
done

if [[ "$resolved" -ne 1 ]]; then
  libs="$(missing_libs)" || true
  if [[ -n "$libs" ]]; then
    echo "!! unresolved shared libs remain after $((i < MAX_ITER ? i + 1 : MAX_ITER)) pass(es):" >&2
    echo "$libs" | sed 's/^/    /' >&2
  fi
fi

echo "==> merging $EXTRACT_DIR/usr into $PREFIX"
cp -a "$EXTRACT_DIR"/usr/. "$PREFIX"/

RUNTIME_LIBDIRS="$(lib_dirs "$PREFIX")" || true
echo "==> done. downloaded packages: ${!SEEN[*]}"
echo "==> signature/digest log: $VERIFY_LOG"
echo "==> spot-check with: find $PREFIX/bin -newer $EXTRACT_DIR -type f -exec env LD_LIBRARY_PATH=\"$RUNTIME_LIBDIRS\" ldd {} \;"
echo "==> binaries under $PREFIX/bin need this to find their libs at runtime — add to your shell rc:"
echo "    export LD_LIBRARY_PATH=\"$RUNTIME_LIBDIRS\${LD_LIBRARY_PATH:+:\$LD_LIBRARY_PATH}\""
