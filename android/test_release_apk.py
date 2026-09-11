#!/usr/bin/env python3
"""Load a rendered map in a disposable emulator using a signed release APK.

The selected emulator is test-owned: this replaces its game settings. Optional
--baseline-apk and --save exercise an in-place update without uninstalling.
"""

import argparse
import configparser
import hashlib
from pathlib import Path
import subprocess
import time
import zipfile


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("apk", type=Path)
    parser.add_argument("--adb", default="adb")
    parser.add_argument("--serial", required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--baseline-apk", type=Path)
    parser.add_argument("--save", type=Path)
    parser.add_argument("--world", default="mm8")
    parser.add_argument("--map", default="out13.odm")
    parser.add_argument("--timeout", type=int, default=180)
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    package = "org.openyamm.android"
    storage = "/sdcard/Android/data/" + package + "/files"

    def adb(*command, check=True):
        result = subprocess.run(
            [args.adb, "-s", args.serial, *command], stdout=subprocess.PIPE,
            stderr=subprocess.PIPE, timeout=240, check=False,
        )
        if check and result.returncode:
            raise RuntimeError(result.stderr.decode(errors="replace") + result.stdout.decode(errors="replace"))
        return result.stdout

    if adb("shell", "getprop", "ro.kernel.qemu").strip() != b"1":
        raise RuntimeError("This test requires a disposable Android emulator, not a physical device.")

    def launch():
        adb("shell", "am", "start", "-n", package + "/.OpenYammActivity")

    with zipfile.ZipFile(args.apk) as apk:
        config = configparser.ConfigParser()
        config.read_string(apk.read("assets/settings.ini").decode())
        shaders = {
            name[len("assets/"):]: apk.read(name) for name in apk.namelist()
            if name.startswith("assets/runtime/shaders/essl/") and name.endswith(".bin")
        }
    if not shaders:
        raise RuntimeError("APK contains no Android shaders.")

    if args.baseline_apk:
        print("Installing baseline APK", flush=True)
        adb("install", "-r", str(args.baseline_apk.resolve()))
        launch()
        time.sleep(10)
        adb("shell", "am", "force-stop", package)

    # No uninstall, clear-data, save conversion or manual shader installation.
    if args.baseline_apk:
        adb("shell", "mkdir", "-p", storage + "/saves", storage + "/logs")
        if args.save:
            adb("push", str(args.save.resolve()), storage + "/saves/upgrade-test.oysav")

    config["startup"]["start_in_main_menu"] = "false"
    config["startup"]["save_file"] = "saves/upgrade-test.oysav" if args.save else ""
    config["debug"]["start_world"] = args.world
    config["debug"]["start_map_file"] = args.map
    config["debug"]["preseed_party"] = "true"
    config["debug"]["immortal"] = "true"
    config["logging"]["gameplay_trace"] = "true"
    config["logging"]["gameplay_trace_file"] = "logs/android-release-test.log"
    config["logging"]["gameplay_trace_append"] = "false"
    # Exercise the new decoration shaders as well as terrain and creature shaders.
    config["video"]["terrain_decorations"] = "true"
    config["video"]["skip_event_cutscenes"] = "true"
    settings = args.output / "settings.ini"
    with settings.open("w") as stream:
        config.write(stream)

    # On updates, settings and saves must survive the package replacement.
    if args.baseline_apk:
        adb("push", str(settings.resolve()), storage + "/settings.ini")
    print("Installing candidate APK with adb install -r", flush=True)
    adb("install", "-r", str(args.apk.resolve()))
    if not args.baseline_apk:
        adb("shell", "mkdir", "-p", storage + "/saves", storage + "/logs")
        adb("push", str(settings.resolve()), storage + "/settings.ini")
        if args.save:
            adb("push", str(args.save.resolve()), storage + "/saves/upgrade-test.oysav")
    if adb("exec-out", "cat", storage + "/settings.ini") != settings.read_bytes():
        raise RuntimeError("Update changed the existing settings file.")
    if args.save:
        actual = adb("exec-out", "cat", storage + "/saves/upgrade-test.oysav")
        if hashlib.sha256(actual).digest() != hashlib.sha256(args.save.read_bytes()).digest():
            raise RuntimeError("Update changed the existing save.")

    adb("logcat", "-c")
    adb("shell", "rm", "-f", storage + "/logs/android-release-test.log")
    launch()
    marker = ('load_game_applied ' if args.save else 'map_loaded ') + 'map="' + args.map + '"'
    ready_since = None
    deadline = time.monotonic() + args.timeout
    try:
        while time.monotonic() < deadline:
            time.sleep(2)
            # Settings initialization can reopen the trace file during a new game;
            # logcat retains the completed renderer initialization marker.
            text = adb("logcat", "-d", "-v", "brief", "-s", "OpenYAMM").decode(errors="replace")
            lines = text.splitlines()
            loaded = any(
                ("load_game_applied " if args.save else "map_loaded ") in line
                and ('map="' + args.map + '"') in line
                and (args.save or "initialize_view=true" in line) for line in lines
            )
            pid = adb("shell", "pidof", package, check=False).strip()
            if loaded and pid:
                ready_since = ready_since or time.monotonic()
                if time.monotonic() - ready_since >= 5:
                    break
            elif ready_since:
                raise RuntimeError("Game exited after initializing the map.")
        else:
            raise RuntimeError("Timed out waiting for rendered map readiness: " + marker)

        for path, expected in shaders.items():
            if adb("exec-out", "cat", storage + "/" + path) != expected:
                raise RuntimeError("Extracted shader differs from installed APK: " + path)
        print("PASS: rendered " + args.map + "; all " + str(len(shaders)) + " shaders match APK", flush=True)
    finally:
        (args.output / "logcat.txt").write_bytes(adb("logcat", "-d", "-v", "threadtime"))
        (args.output / "gameplay.log").write_bytes(
            adb("exec-out", "cat", storage + "/logs/android-release-test.log", check=False))
        (args.output / "screen.png").write_bytes(adb("exec-out", "screencap", "-p", check=False))
        adb("shell", "am", "force-stop", package)


if __name__ == "__main__":
    main()
