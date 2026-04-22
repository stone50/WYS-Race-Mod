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
    log_path = get_path(f"./Logs/server_{os_target}.log")

    profile = "win-x64.pubxml" if os_target == "win" else "linux-x64.pubxml"
    cmd = [
        "dotnet", "publish", get_path("../Server/Server.csproj"),
        "-c", "Release",
        f"-p:PublishProfile={profile}",
        f"-o", get_path("./Output")
    ]

    with open(log_path, "w") as f:
        subprocess.run(cmd, stdout=f, stderr=f)

    print(f"done building server for {os_target}")


def build_mod(game_version):
    print(f"building mod for {game_version}")
    log_path = get_path(f"./Logs/{game_version}.log")

    input_win = get_path(f"./Game/{game_version}/data.win")
    output_win = get_path(f"./Output/{game_version}.win")

    if sys.platform == "win32":
        umt_exe = get_path("./Tools/UndertaleModCli/UndertaleModCli.exe")
        xdelta_exe = get_path("./Tools/xdelta3/xdelta3.exe")
    else:
        umt_exe = get_path("./Tools/UndertaleModCli/UndertaleModCli")
        xdelta_exe = "xdelta3"

    umt_cmd = [
        umt_exe,
        "load", input_win,
        "-s", get_path("./ImportAssets.csx"),
        "-o", output_win
    ]

    xdelta_cmd = [
        xdelta_exe, "-f", "-e", "-s", input_win, output_win, get_path(f"./Output/{game_version}.xdelta")
    ]

    with open(log_path, "w") as f:
        subprocess.run(umt_cmd, stdout=f, stderr=f)
        subprocess.run(xdelta_cmd, stdout=f, stderr=f)

    print(f"done building mod for {game_version}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--all", action="store_true", help="Build everything")
    parser.add_argument("--old", action="store_true", help="Build mod for WYS v1.42 (speedrunner version)")
    parser.add_argument("--new", action="store_true", help="Build mod for WYS v2.12 (current version)")
    parser.add_argument("--server-win", action="store_true", help="Build server for Windows")
    parser.add_argument("--server-linux", action="store_true", help="Build server for Linux")
    args = parser.parse_args()

    os.makedirs(get_path("./Output"), exist_ok=True)
    os.makedirs(get_path("./Logs"), exist_ok=True)

    with ThreadPoolExecutor() as executor:
        if args.old or args.all:
            executor.submit(build_mod, "1.42")
        if args.new or args.all:
            executor.submit(build_mod, "2.12")
        if args.server_win or args.all:
            executor.submit(build_server, "win")
        if args.server_linux or args.all:
            executor.submit(build_server, "linux")
