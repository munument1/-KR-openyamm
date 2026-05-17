# Windows Distribution Build

This document describes the recommended Windows 10 distribution build path using MSYS2 UCRT64 MinGW.

The end result is a single zip file containing `openyamm.exe`, runtime DLLs, shaders, `settings.ini`, and packaged
runtime assets under `assets/`.

## Install Toolchain

Install Git for Windows and MSYS2.

Open the **MSYS2 UCRT64** shell, not the plain MSYS shell, then update MSYS2:

```bash
pacman -Syu
```

If MSYS2 asks you to close the shell, close it, reopen **MSYS2 UCRT64**, then run the update again:

```bash
pacman -Syu
```

Install the build packages:

```bash
pacman -S --needed \
  git \
  mingw-w64-ucrt-x86_64-toolchain \
  mingw-w64-ucrt-x86_64-cmake \
  mingw-w64-ucrt-x86_64-ninja \
  mingw-w64-ucrt-x86_64-pkgconf \
  mingw-w64-ucrt-x86_64-python
```

Optional debugger:

```bash
pacman -S --needed mingw-w64-ucrt-x86_64-gdb
```

## Prepare Source Tree

From the **MSYS2 UCRT64** shell:

```bash
cd /c/Users/YOUR_USER/github
git clone YOUR_REPO_URL OpenYAMM
cd OpenYAMM
```

If the repository already exists, just `cd` into it.

Make sure the final source assets are present:

```bash
ls assets_dev/engine
ls assets_dev/worlds
```

The Windows distribution package target builds runtime asset zips from `assets_dev/`. It does not reuse existing
`assets/*.zip` files.

## Configure Release Build

```bash
cmake -S . -B build-windows-release -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DOPENYAMM_BUILD_TESTS=OFF \
  -DOPENYAMM_BUILD_EDITOR=OFF \
  -DOPENYAMM_BUILD_TOOLS=OFF
```

If the source assets live somewhere else, pass an explicit asset source directory:

```bash
cmake -S . -B build-windows-release -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DOPENYAMM_DEV_ASSETS_DIR=C:/path/to/assets_dev \
  -DOPENYAMM_BUILD_TESTS=OFF \
  -DOPENYAMM_BUILD_EDITOR=OFF \
  -DOPENYAMM_BUILD_TOOLS=OFF
```

The first configure step needs internet access because CMake fetches dependencies.

## Build

```bash
cmake --build build-windows-release --target openyamm --parallel 16
```

Optional smoke test from the build tree:

```bash
./build-windows-release/game/openyamm.exe
```

## Build Distribution Zip

```bash
cmake --build build-windows-release --target openyamm_windows_release_zip --parallel 16
```

Expected output:

```text
build-windows-release/release/OpenYAMM-windows-Release.zip
```

The zip should contain:

```text
OpenYAMM/openyamm.exe
OpenYAMM/settings.ini
OpenYAMM/runtime/...
OpenYAMM/assets/engine.zip
OpenYAMM/assets/worlds/mm6.zip
OpenYAMM/assets/worlds/mm7.zip
OpenYAMM/assets/worlds/mm8.zip
OpenYAMM/assets/worlds/mmmerge.zip
```

The package target also tries to collect required runtime DLLs, including MinGW runtime DLLs if they are dynamically
linked.

## Verify The Package

Inspect the zip:

```bash
cmake -E tar tf build-windows-release/release/OpenYAMM-windows-Release.zip | head -80
```

Test the exact zip from a clean directory:

```bash
mkdir -p /tmp/openyamm-dist-test
cd /tmp/openyamm-dist-test
cmake -E tar xf /c/Users/YOUR_USER/github/OpenYAMM/build-windows-release/release/OpenYAMM-windows-Release.zip
cd OpenYAMM
./openyamm.exe
```

If the game launches from the extracted folder, the distribution package is structurally valid.

## Publish

Rename the zip to include the release version:

```bash
cp build-windows-release/release/OpenYAMM-windows-Release.zip OpenYAMM-0.1.0-windows-x64.zip
```

Create a checksum:

```bash
sha256sum OpenYAMM-0.1.0-windows-x64.zip > OpenYAMM-0.1.0-windows-x64.zip.sha256
```

Publish both files.

End-user install flow:

```text
1. Download the zip.
2. Extract it.
3. Run openyamm.exe.
```

No Visual C++ redistributable should be required when building with MinGW and packaging the required DLLs. Windows
SmartScreen may warn for unsigned executables; signing is the long-term fix for public website distribution.

Only distribute packaged game assets when you have the right to distribute them.

## Running From PowerShell

If invoking the build from PowerShell instead of an already-open **MSYS2 UCRT64** shell, set `MSYSTEM=UCRT64` before
sourcing `/etc/profile` so MSYS2 prepends `/ucrt64/bin` to `PATH`:

```powershell
C:\msys64\usr\bin\bash.exe -lc "export MSYSTEM=UCRT64 && export CHERE_INVOKING=1 && source /etc/profile && cd /home/pjasicek/openyamm && cmake --build build-windows-release --target openyamm --parallel 16"
```
