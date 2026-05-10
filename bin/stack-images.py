#!/usr/bin/env -S uv run
# /// script
# requires-python = ">=3.8"
# dependencies = [
#     "pillow>=10.0.0",
# ]
# ///
"""
Image Stacker - Prepare overlapping images for manual alignment in GIMP

OVERVIEW:
    This tool creates a layered TIFF file where each image becomes a separate layer
    in GIMP, pre-positioned with spacing for easy alignment. Alternatively, it can
    create a stacked PNG with images arranged vertically.

    Why manual alignment? For complex images with overlapping content, automatic
    alignment can be unreliable. Manual alignment in GIMP gives you full control
    and better results.

QUICK START:
    # Default: Create layered TIFF and open in GIMP
    ./stack_images.py --open-gimp

    # Layers are pre-positioned with spacing - just fine-tune alignment!
    # In GIMP: Set guide → For each layer: clean up → align → next layer

    # Or specify custom output filename
    ./stack_images.py my_images.tif
    gimp my_images.tif

    # ALTERNATIVE: Create stacked PNG (old workflow)
    ./stack_images.py --stacked stacked.png

REQUIREMENTS:
    - Python 3.8+
    - Pillow (automatically installed by uv)
    - GIMP 2.10+ (for manual alignment)

USAGE METHODS:
    1. Direct execution (uv auto-manages dependencies):
       ./stack_images.py [output.tif] [directory]

    2. Explicit uv run:
       uv run stack_images.py [output.tif] [directory]

    3. System Python (if Pillow installed):
       python3 stack_images.py [output.tif] [directory]

    Note: Both arguments are optional (defaults: layers.tif, current directory)

FILE NAMING AND ORDERING:
    Images are sorted by timestamp in the filename, with alphabetical fallback.

    How ordering works:
    1. Script searches for timestamps in filenames (YYYY-MM-DD_HH-MM format)
    2. Files are sorted by their timestamps
    3. Files without timestamps are sorted alphabetically by full filename
    4. This determines the top-to-bottom stacking order

    Recommended naming formats:
    - Timestamp format: 2025-10-27_20-42.png (best - sorts chronologically)
    - Multiple at same time: 2025-10-27_20-42_1.png, 2025-10-27_20-42_2.png
    - Sequential numbering: image_001.png, image_002.png (sorts alphabetically)
    - Any consistent naming that sorts correctly alphabetically

    IMPORTANT: Verify the stacking order when the script lists found images.
    The list shows the order they will be stacked (top to bottom).

GIMP WORKFLOW:
    The workflow is: Create layered TIFF → Crop each layer → Align layers

    1. Create layered TIFF:
       ./stack_images.py --open-gimp

       This creates a multi-layer TIFF file and opens it in GIMP.
       Each image becomes a separate layer, ready to work with!

    2. GIMP opens with all images as layers
       - Each layer is a separate image from your directory
       - Layers are stacked on top of each other
       - All layer tools work normally

    3. Set alignment guide (recommended):
       - Drag vertical guide from ruler to a reference point
       - Or: Image → Guides → New Guide
       - Use consistent features (e.g., bar lines, edges) as reference

    4. For each layer (work through one at a time):
       a) Select the layer in the Layers panel
       b) Clean up the layer:
          - Use Rectangle Select (R) to select extraneous parts
          - Press Del to remove unwanted content
          - Or: Select just the content → Image → Crop to Selection
       c) Align the layer:
          - Press M (Move Tool)
          - Reduce opacity ([ key) to see overlap with layers below
          - Drag or use arrow keys to align to the guide/reference
          - Restore opacity (] key) when aligned
       d) Move to next layer and repeat

    5. Alternative: Align all first, then clean up
       - If you prefer, align all layers first using Move Tool (M)
       - Then go back and crop/clean each layer
       - Either workflow works - choose what feels natural

    6. Merge and finalize:
       - Once all layers are aligned:
         Image → Flatten Image
       - Or merge selectively:
         Layer → Merge Down (Ctrl+M)
       - If layers extend beyond canvas:
         Image → Fit Canvas to Layers before flattening

    7. Export final result:
       - File → Export As → PNG
       - Choose your output location and filename

ALTERNATIVE WORKFLOW (Stacked PNG):
    If you prefer the old manual extraction approach:
    ./stack_images.py --stacked stacked.png

    Then in GIMP:
    1. Set alignment guide (drag from ruler to reference point like first bar line)
    2. For each fragment:
       - Select region → Ctrl+Shift+L (cut and float)
       - Align with arrow keys
       - Click to anchor
       - Select extraneous parts with R tool → Del to remove
    3. Image → Fit Canvas to Layers (if fragments extend beyond edges)
    4. Image → Flatten Image → Crop → Export

GIMP KEYBOARD SHORTCUTS:
    R              - Rectangle Select Tool
    Ctrl+Shift+L   - Cut selection and float (enters move mode)
    Arrow keys     - Move selection 1px
    Shift+Arrow    - Move selection 10px
    Click          - Anchor floating selection (returns to rectangle select)
    Del            - Delete selected region (for cleanup)
    M              - Move Tool
    C              - Crop Tool
    [ / ]          - Decrease/increase opacity
    Ctrl+Z         - Undo
    +/-            - Zoom in/out

    Other shortcuts:
    Ctrl+Shift+A   - Select none
    Ctrl+C         - Copy selection
    Ctrl+V         - Paste (creates floating selection)
    Shift+Ctrl+N   - Floating selection to new layer
    Ctrl+M         - Merge down

ALIGNMENT TIPS:
    - Set a vertical guideline at a consistent reference point (e.g., first bar line)
      Image → Guides → New Guide (by Percent or Position)
      Drag from the ruler to position, then align all fragments to it
    - Look for repeating elements (lines, edges, patterns)
    - Reduce layer opacity to 50% to see overlap clearly
    - Zoom in (press +) for precise alignment
    - Use "Difference" blend mode - aligned areas turn black
    - If fragments extend beyond canvas edges:
      Image → Fit Canvas to Layers (expands to fit all content)
      Then Image → Flatten Image (merges and adjusts canvas)
    - Work on a large monitor for better visibility
    - Take breaks - fresh eyes catch misalignments

COMMON USE CASES:
    - Screenshot stitching (scrolling captures)
    - Panorama preparation
    - Document scanning (multi-page overlaps)
    - Image sequence alignment
    - Any overlapping image set requiring manual alignment

TROUBLESHOOTING:
    "No PNG files found"
    → Check you're pointing to the correct directory with PNG files

    "Error: Pillow not found" (when using system Python)
    → Install: sudo dnf install python3-pillow (Fedora/RHEL)
    → Or: sudo apt install python3-pil (Ubuntu/Debian)
    → Or use uv: ./stack_images.py (auto-installs dependencies)

    GIMP alignment is tedious
    → Use keyboard shortcuts (see list above)
    → Work on dual monitors (reference on one, GIMP on other)
    → Zoom in for precision, zoom out to verify overall alignment

OPTIONS:
    output            Output TIFF filename (default: layers.tif)
    directory         Directory with PNG images (default: current directory)
    --open-gimp       Auto-launch GIMP with the layered TIFF
    --stacked FILE    Create stacked PNG instead of layered TIFF (alternative workflow)
    --spacing N       Vertical spacing between layers/images (default: 120px)
                      Used by both layered TIFF and stacked PNG workflows
    --force           Overwrite output file without prompting
    -h, --help        Show this help message

AUTHOR:
    Created to solve the problem of preparing overlapping images for
    efficient manual alignment in GIMP, as automatic stitching proved
    unreliable for complex content.

LICENSE:
    MIT License - free to use and modify
"""

import argparse
import re
import sys
from pathlib import Path
from typing import List

from PIL import Image

# Configuration constants
MAX_DIMENSION = 30000  # GIMP/PNG reasonable limit


def extract_timestamp(filename: str) -> str:
    """Extract timestamp from filename for sorting."""
    match = re.search(r'(\d{4}-\d{2}-\d{2}_\d{2}-\d{2}(?:_\d+)?)', filename)
    return match.group(1) if match else filename


def discover_images(image_dir: Path) -> List[Path]:
    """Find and sort all PNG images by timestamp (or alphabetically)."""
    png_files = list(image_dir.glob("*.png"))

    if not png_files:
        raise ValueError(f"No PNG files found in {image_dir}")

    png_files.sort(key=lambda p: extract_timestamp(p.name))

    print(f"Found {len(png_files)} images (sorted by timestamp, then alphabetically):")
    print("Stacking order (top to bottom):")
    for idx, img in enumerate(png_files, 1):
        print(f"  {idx:2d}. {img.name}")

    return png_files


def create_layered_image(png_files: List[Path], output_path: Path, spacing: int = 120) -> None:
    """
    Create a multi-layer TIFF file that GIMP can open with all layers.

    Args:
        png_files: List of image file paths (in order)
        output_path: Path to output TIFF file
        spacing: Vertical spacing between layers (default: 120)
    """
    print(f"\nCreating layered image with {len(png_files)} layers...")

    # Load all images and calculate total canvas needed
    source_images = []
    max_width = 0
    total_height = 0

    for png_file in png_files:
        try:
            img = Image.open(png_file)
            # Convert to RGBA for consistency (supports transparency)
            if img.mode not in ('RGB', 'RGBA'):
                if 'transparency' in img.info or img.mode in ('LA', 'PA'):
                    img = img.convert('RGBA')
                else:
                    img = img.convert('RGB').convert('RGBA')
            elif img.mode == 'RGB':
                img = img.convert('RGBA')

            source_images.append(img)
            max_width = max(max_width, img.width)
            total_height += img.height
        except Exception as e:
            print(f"Warning: Could not load {png_file.name}: {e}")
            continue

    if not source_images:
        raise ValueError("No images could be loaded")

    # Add spacing between layers
    total_height += spacing * (len(source_images) - 1)

    print(f"Canvas size: {max_width}x{total_height}px (with {spacing}px spacing)")

    # Create each layer on the full canvas size, vertically offset with spacing
    # This positions each layer approximately where it should be for alignment
    canvas_layers = []
    y_offset = 0
    for idx, img in enumerate(source_images):
        # Create transparent canvas of full size
        layer = Image.new('RGBA', (max_width, total_height), (0, 0, 0, 0))
        # Paste the image at the calculated vertical offset
        layer.paste(img, (0, y_offset))
        canvas_layers.append(layer)
        print(f"  Layer {idx + 1}: positioned at y={y_offset}")
        y_offset += img.height + spacing

    print("Note: Layers are pre-positioned with spacing - adjust as needed for alignment")

    # Save as multi-page TIFF (GIMP will open each page as a layer)
    print(f"Saving to {output_path}...")
    canvas_layers[0].save(
        output_path,
        save_all=True,
        append_images=canvas_layers[1:],
        compression="tiff_deflate"
    )

    print(f"\n{'='*60}")
    print(f"SUCCESS! Created layered TIFF with {len(canvas_layers)} layers")
    print(f"{'='*60}")
    print("\nTo open in GIMP:")
    print(f"  gimp {output_path}")
    print("\nGIMP will open each page as a separate layer (pre-positioned with spacing).")
    print("\nRecommended workflow (work through layers one at a time):")
    print("1. Set vertical guide at reference point (e.g., first bar line)")
    print("2. For each layer:")
    print("   - Select layer → Clean up (R to select, Del to remove extras)")
    print("   - Press M (Move) → [ to reduce opacity → align to guide → ] to restore")
    print("3. After all layers aligned: Flatten → Crop → Export")


def stack_images_vertically(image_dir: Path, output_path: Path, spacing: int):
    """
    Stack all images vertically with spacing between them.

    Args:
        image_dir: Directory containing PNG images
        output_path: Output image path
        spacing: Vertical spacing between images in pixels
    """
    png_files = discover_images(image_dir)

    print("\nLoading images and calculating dimensions...")

    # Load all images
    images = []
    max_width = 0
    total_height = 0
    has_transparency = False

    for png_file in png_files:
        try:
            img = Image.open(png_file)
        except (IOError, OSError) as e:
            raise IOError(f"Failed to open image {png_file.name}: {e}")
        except Exception as e:
            # Pillow-specific errors (UnidentifiedImageError, etc.)
            raise IOError(f"Invalid or corrupted image {png_file.name}: {e}")

        # Check for transparency
        if img.mode in ('RGBA', 'LA', 'PA') or 'transparency' in img.info:
            has_transparency = True

        images.append((png_file.name, img))
        max_width = max(max_width, img.width)
        total_height += img.height

    # Add spacing
    total_height += spacing * (len(images) - 1)

    # Validate dimensions
    if total_height > MAX_DIMENSION:
        print(f"Warning: Total height ({total_height}px) exceeds {MAX_DIMENSION}px")
        print("         This may cause issues in GIMP or when saving PNG")
        print("         Consider using larger spacing or processing in batches")

    if max_width > MAX_DIMENSION:
        print(f"Warning: Image width ({max_width}px) exceeds {MAX_DIMENSION}px")
        print("         This may cause issues in GIMP")

    print(f"Creating canvas: {max_width}x{total_height}px")

    # Create canvas with appropriate mode
    if has_transparency:
        canvas = Image.new('RGBA', (max_width, total_height), (255, 255, 255, 255))
        print("Note: Preserving transparency (RGBA mode)")
    else:
        canvas = Image.new('RGB', (max_width, total_height), 'white')

    # Paste images vertically
    y_offset = 0
    for idx, (name, img) in enumerate(images):
        print(f"Placing image {idx+1}/{len(images)}: {name} at y={y_offset}")

        # Convert to match canvas mode
        if has_transparency:
            if img.mode != 'RGBA':
                # Convert to RGBA, preserving transparency if present
                if 'transparency' in img.info or img.mode in ('RGBA', 'LA', 'PA'):
                    img = img.convert('RGBA')
                else:
                    # Add opaque alpha channel
                    img = img.convert('RGB').convert('RGBA')
        else:
            if img.mode != 'RGB':
                img = img.convert('RGB')

        # Paste at left edge
        canvas.paste(img, (0, y_offset))

        y_offset += img.height + spacing

    # Save result
    print(f"\nSaving to {output_path}...")
    canvas.save(output_path, 'PNG')

    print("\n" + "="*60)
    print("SUCCESS! Stacked PNG created.")
    print("="*60)
    print("\nNext steps (Extract and align fragments):")
    print(f"1. Open {output_path} in GIMP")
    print("2. Set alignment guide (optional but recommended):")
    print("   - Drag vertical guide from ruler to reference point (e.g., first bar line)")
    print("   - Or: Image → Guides → New Guide")
    print("3. For each fragment, repeat:")
    print("   - Select the region (R starts rectangle select)")
    print("   - Ctrl+Shift+L (cut and float - enters move mode)")
    print("   - Shift+Arrow for coarse alignment (10px)")
    print("   - Arrow keys for fine-tuning (1px)")
    print("   - Click anywhere to anchor (returns to rectangle select)")
    print("   - Clean up: Select extraneous parts (R) → Del to remove")
    print("4. After all fragments aligned:")
    print("   - Image → Fit Canvas to Layers (if fragments extend beyond edges)")
    print("   - Image → Flatten Image")
    print("   - Crop to final size (C)")
    print("5. File → Export As → PNG")


def main():
    parser = argparse.ArgumentParser(
        description="Create layered TIFF for manual alignment in GIMP"
    )
    parser.add_argument(
        "output",
        type=Path,
        nargs='?',
        default=Path("layers.tif"),
        help="Output TIFF filename (default: layers.tif)"
    )
    parser.add_argument(
        "directory",
        type=Path,
        nargs='?',
        default=Path.cwd(),
        help="Directory containing PNG images (default: current directory)"
    )
    parser.add_argument(
        "--open-gimp",
        action="store_true",
        help="Automatically open GIMP with the layered TIFF"
    )
    parser.add_argument(
        "--stacked",
        type=Path,
        metavar="FILE",
        help="Create stacked PNG instead of layered TIFF (old workflow)"
    )
    parser.add_argument(
        "--spacing",
        type=int,
        default=120,
        help="Vertical spacing between layers/images in pixels (default: 120)"
    )
    parser.add_argument(
        "--force",
        action="store_true",
        help="Overwrite output file if it exists without prompting"
    )

    args = parser.parse_args()

    # Validate directory
    if not args.directory.exists():
        print(f"Error: Directory not found: {args.directory}")
        return 1

    if not args.directory.is_dir():
        print(f"Error: Not a directory: {args.directory}")
        return 1

    if args.spacing < 0:
        print("Error: Spacing must be non-negative")
        return 1

    # Determine output file and mode
    if args.stacked:
        output_file = args.stacked
        mode = "stacked"
    else:
        output_file = args.output
        mode = "layered"

    # Check for output file overwrite
    if output_file.exists() and not args.force:
        # Check if running in non-interactive mode (pipe, cron, etc.)
        if not sys.stdin.isatty():
            print(f"Error: Output file '{output_file}' already exists.")
            print("       Use --force to overwrite in non-interactive mode.")
            return 1

        print(f"Warning: Output file '{output_file}' already exists!")
        try:
            response = input("Overwrite? [y/N]: ").strip().lower()
        except EOFError:
            # Input not available (shouldn't happen after isatty check, but be safe)
            print("\nError: Cannot prompt for input in non-interactive mode.")
            print("       Use --force to overwrite.")
            return 1

        if response not in ('y', 'yes'):
            print("Aborted.")
            return 0

    try:
        # Discover images first
        png_files = discover_images(args.directory)

        # Create stacked PNG (old workflow)
        if mode == "stacked":
            stack_images_vertically(args.directory, output_file, args.spacing)

        # Default: Create layered TIFF
        else:
            create_layered_image(png_files, output_file, args.spacing)

            if args.open_gimp:
                import subprocess
                print("\nLaunching GIMP...")
                try:
                    subprocess.Popen(["gimp", str(output_file)],
                                     stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
                    print("GIMP launched!")
                except FileNotFoundError:
                    print("Error: GIMP not found. Please open manually:")
                    print(f"  gimp {output_file}")

        return 0
    except ValueError as e:
        print(f"Error: {e}")
        return 1
    except OSError as e:
        print(f"Error: {e}")
        return 1
    except KeyboardInterrupt:
        print("\n\nInterrupted by user")
        return 130
    except Exception as e:
        print(f"Unexpected error: {e}")
        import traceback
        traceback.print_exc()
        return 1


if __name__ == "__main__":
    exit(main())
