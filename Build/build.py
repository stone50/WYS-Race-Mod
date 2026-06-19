import subprocess
import argparse
import os
import sys
from concurrent.futures import ThreadPoolExecutor

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))


def get_path(rel_path):
    return os.path.join(SCRIPT_DIR, rel_path)


def build_server(os_target):
    print(f"building Server for {os_target}")

    with open(get_path(f"./Logs/server_{os_target}.log"), "w") as f:
        subprocess.run([
            "dotnet", "publish", get_path("../Server/Server.csproj"),
            "-v", "n",
            f"-p:PublishProfile={"win-x64" if os_target == "win" else "linux-x64"}",
            f"-o", get_path(f"./Output")
        ], stdout=f, stderr=f)

    print(f"done building server for {os_target}")


def build_mod(game_version):
    print(f"building mod for {game_version}")

    with open(get_path(f"./Logs/umt_{game_version}.log"), "w") as f:
        subprocess.run([
            get_path("./Tools/UndertaleModCli/UndertaleModCli"),
            "load", get_path(f"./Game/{game_version}/data.win"),
            "-v",
            "-s", get_path("./ImportAssets.csx"),
            "-o", get_path(f"./Output/{game_version}.win")
        ], stdout=f, stderr=f)

    print(f"done building mod for {game_version}")


def patch_mod(game_version):
    print(f"creating patch for {game_version}")

    with open(get_path(f"./Logs/xdelta_{game_version}.log"), "w") as f:
        subprocess.run([
            get_path("./Tools/xdelta3/xdelta3.exe") if sys.platform == "win32" else "xdelta3",
            "-vv", "-e", "-f", "-9",
            "-S", "lzma",
            "-B", "10268558",
            "-W", "10268558",
            "-s", get_path(f"./Game/{game_version}/data.win"),
            get_path(f"./Output/{game_version}.win"),
            get_path(f"./Output/{game_version}.xdelta")
        ], stdout=f, stderr=f)

    print(f"done creating patch for {game_version}")


def build_and_patch_mod(game_version):
    build_mod(game_version)
    patch_mod(game_version)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--old", action="store_true", help="Build+patch mod for WYS v1.42 (speedrunner version)")
    parser.add_argument("--new", action="store_true", help="Build+patch mod for WYS v2.12 (current version)")
    parser.add_argument("--mod", action="store_true", help="Build+patch mod for both WYS v1.42 and v2.12")
    parser.add_argument("--server-win", action="store_true", help="Build server for Windows")
    parser.add_argument("--server-linux", action="store_true", help="Build server for Linux")
    parser.add_argument("--server", action="store_true", help="Build server for both Windows and Linux")
    parser.add_argument("--all", action="store_true", help="Build everything")
    args = parser.parse_args()

    os.makedirs(get_path("./Output"), exist_ok=True)
    os.makedirs(get_path("./Logs"), exist_ok=True)

    if args.all:
        args.mod = True
        args.server = True

    if args.mod:
        args.old = True
        args.new = True

    if args.server:
        args.server_win = True
        args.server_linux = True

    with ThreadPoolExecutor() as executor:
        if args.old:
            executor.submit(build_and_patch_mod, "1.42")
        if args.new:
            executor.submit(build_and_patch_mod, "2.12")
        if args.server_win:
            executor.submit(build_server, "win")
        if args.server_linux:
            executor.submit(build_server, "linux")
