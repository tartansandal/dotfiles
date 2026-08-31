#!/usr/bin/env bash
# Convert the sample through the cbwiki writer and diff against the golden
# output. Run with -u to update the golden file after an intentional change.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
sample="$here/cbwiki-sample.md"
golden="$here/cbwiki-expected.txt"

render() {
    "$(dirname "$(dirname "$here")")/bin/cbwiki" "$sample"
}

if [[ "${1:-}" == "-u" ]]; then
    # Render to a temp file first: a redirect would truncate the checked-in
    # golden before the writer runs, so a Lua error would empty it.
    tmp="$(mktemp)"
    trap 'rm -f "$tmp"' EXIT
    render >"$tmp"
    mv "$tmp" "$golden"
    trap - EXIT
    echo "updated $golden"
    exit 0
fi

if diff -u "$golden" <(render); then
    echo "cbwiki: output matches golden"
else
    echo "cbwiki: output differs (run '$0 -u' to accept)" >&2
    exit 1
fi
