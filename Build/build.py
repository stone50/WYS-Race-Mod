import subprocess
import argparse
import os


def build_server(os_target):
    print(f"building Server for {os_target}")
    profile = "win-x64.pubxml" if os_target == "win" else "linux-x64.pubxml"
    cmd = [
        "dotnet", "publish", "../Server/Server.csproj",
        "-c", "Release",
        f"-p:PublishProfile={profile}",
        f"-o", "./Output"
    ]
    subprocess.run(cmd)


def build_mod(game_version):
    print(f"building mod for {game_version}")
    input_win = f"../Game/{game_version}/data.win"
    output_win = f"./Output/{game_version}.win"
    umt_cmd = [
        "./Tools/UndertaleModCli.exe",
        "load", input_win,
        "-s", "./ImportAssets.csx",
        "-o", output_win
    ]
    subprocess.run(umt_cmd)
    patch_path = f"./Output/{game_version}.xdelta"
    xdelta_cmd = [
        "./Tools/xdelta3.exe", "-f", "-e", "-s", input_win, output_win, patch_path
    ]
    subprocess.run(xdelta_cmd)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--old", action="store_true", help="Build mod for WYS v1.42 (speedrunner version)")
    parser.add_argument("--new", action="store_true", help="Build mod for WYS v2.12 (current version)")
    parser.add_argument("--server-win", action="store_true", help="Build server for Windows")
    parser.add_argument("--server-linux", action="store_true", help="Build server for Linux")
    args = parser.parse_args()

    os.makedirs("./Output", exist_ok=True)

    if args.old:
        build_mod("1.42")
    if args.new:
        build_mod("2.12")
    if args.server_win:
        build_server("win")
    if args.server_linux:
        build_server("linux")
