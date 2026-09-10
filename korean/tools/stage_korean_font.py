#!/usr/bin/env python3
"""Stage the pinned, unmodified Galmuri11 outline font and its OFL license."""

import argparse
import hashlib
import io
from pathlib import Path
import urllib.request
import zipfile

VERSION = "2.40.4"
URL = f"https://github.com/quiple/galmuri/releases/download/v{VERSION}/Galmuri-v{VERSION}.zip"
SHA256 = "c8b3d9861a62ae73c8b1178091401cd79994812437ef386413f6dd54856e60e7"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--archive", type=Path, help="Use an already downloaded official release ZIP")
    args = parser.parse_args()
    if args.archive:
        archive = args.archive.read_bytes()
    else:
        with urllib.request.urlopen(URL, timeout=120) as response:
            archive = response.read()
    actual = hashlib.sha256(archive).hexdigest()
    if actual != SHA256:
        raise SystemExit(f"Galmuri archive checksum mismatch: {actual}")
    with zipfile.ZipFile(io.BytesIO(archive)) as source:
        # Use outlines, not the bitmap-only TTF: the engine rasterizes with stb_truetype.
        font = source.read("Galmuri11.ttf")
        license_text = source.read("LICENSE.txt")
    args.output.mkdir(parents=True, exist_ok=True)
    (args.output / "KoreanFallback.ttf").write_bytes(font)
    (args.output / "Galmuri-OFL.txt").write_bytes(license_text)
    print(f"Staged Galmuri11 {VERSION} and OFL license in {args.output}")


if __name__ == "__main__":
    main()
