# OpenYAMM Android Build

This Android project builds an SDL3-based OpenYAMM APK.

- Debug builds include `arm64-v8a` and `x86_64` for emulator testing.
- Release builds include only `arm64-v8a` for production sideloading.
- APK assets are mounted from the installed APK. Large runtime asset packages are not extracted to app storage.

The project expects an SDL3 source tree. By default it uses the desktop build's
fetched SDL checkout at:

```text
../build/_deps/sdl3-src
```

Build a debug APK from the repository root using the lightweight wrapper:

```sh
JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64 android/gradlew :app:assembleDebug
```

Or point at a different SDL3 source checkout:

```sh
JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64 android/gradlew :app:assembleDebug -POPENYAMM_SDL3_SOURCE_DIR=/path/to/SDL
```

The Android SDK must be discoverable through `ANDROID_HOME`, `ANDROID_SDK_ROOT`,
or `android/local.properties`.

The expected debug output is:

```text
android/app/build/outputs/apk/debug/app-debug.apk
```

Android builds package `android/settings.ini` as the first-launch settings profile. The installed app copies that
profile to its app-specific external `settings.ini` only when the file is missing. Saves and settings are stored under
`Android/data/org.openyamm.android/files/`, where they can be copied through USB file transfer. Android may restrict
on-device file managers from browsing this directory, and uninstalling the app removes it. Profile-version migrations
update Android-required defaults without replacing user-adjustable settings.

To build, start/reuse an emulator, install, launch, and follow logs:

```sh
android/run_debug_emulator.sh
```

Useful overrides:

```sh
OPENYAMM_AVD_NAME=openyamm_api35 android/run_debug_emulator.sh
ANDROID_HOME=/path/to/android-sdk android/run_debug_emulator.sh
JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64 android/run_debug_emulator.sh
```

## Release APK

Release signing can be configured through `android/signing.properties`, Gradle
properties, or the `OPENYAMM_ANDROID_*` environment variables. For local builds,
the release script can create `android/keystores/openyamm-release.jks`.

```sh
android/build_release_apk.sh
```

Outputs:

```text
android/app/build/outputs/apk/release/app-release.apk
android/app-release.apk
```

To build an optimized x86_64 release APK, start or reuse the configured emulator, install the APK, launch it, and
follow logs:

```sh
android/run_release_emulator.sh
```

The emulator runner signs this local release build with the standard Android debug keystore. It does not replace
`android/app-release.apk`, which is reserved for the production-signed hosted build. Pass `--no-logcat` to return after
launching the game.

Useful release-runner overrides:

```sh
OPENYAMM_BUILD_RELEASE_APK=0 android/run_release_emulator.sh
OPENYAMM_ANDROID_UNINSTALL_ON_SIGNATURE_MISMATCH=0 android/run_release_emulator.sh
OPENYAMM_ANDROID_RELEASE_ABIS=arm64-v8a android/run_release_emulator.sh
```

Before each public update, bump `openyamm.android.versionName` and
`openyamm.android.versionCode` in `android/gradle.properties`. See
`android/WEB_HOSTING_CHECKLIST.md` for the hosted APK checklist.

## Nightly CI Signing

The nightly GitHub Actions workflow builds the release APK with the same release path. Configure these repository
secrets before running it:

- `OPENYAMM_ANDROID_KEYSTORE_BASE64`: the release keystore encoded as one-line base64
- `OPENYAMM_ANDROID_KEYSTORE_PASSWORD`: the keystore password

The workflow expects the release script's default `openyamm` key alias and uses the keystore password as the key
password. A keystore created by `android/build_release_apk.sh` has those defaults. On Linux, encode it with:

```sh
base64 -w 0 android/keystores/openyamm-release.jks
```

On Windows PowerShell, use:

```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("android\keystores\openyamm-release.jks"))
```

Keep the keystore and secrets backed up. Every published update for `org.openyamm.android` must use the same signing
key; replacing it requires users to uninstall the existing app before installing the new build.
