#!/bin/bash
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ ! -d "$script_dir/Tools" ]; then
    mkdir -p "$script_dir/Tools" > /dev/null
fi

if [ ! -d "$script_dir/Game" ]; then
    mkdir -p "$script_dir/Game" > /dev/null
fi

if command -v python3 &>/dev/null; then
    if python3 --version 2>/dev/null | grep -qE "Python 3\.(1[0-9]|[2-9][0-9])"; then
        echo -e "\e[32mPython 3.10+ already installed\e[0m"
    else
        echo "Incompatible Python version found. Please install Python 3.10+." >&2
    fi
else
    echo "Python not found. Please install Python 3.10+." >&2
fi

if command -v dotnet &>/dev/null; then
    if dotnet --version 2>/dev/null | grep -q "^10\."; then
        echo -e "\e[32m.NET 10 already installed\e[0m"
    else
        echo "Incompatible .NET version found. Please install .NET 10 SDK." >&2
    fi
else
    echo ".NET not found. Please install .NET 10 SDK." >&2
fi

if [ -f "$script_dir/Tools/UndertaleModCli/UndertaleModCli" ]; then
    echo -e "\e[32mUndertaleModCli already installed\e[0m"
else
    echo -e "\e[36mdownloading UndertaleModCli\e[0m"
    if wget -q "https://github.com/UnderminersTeam/UndertaleModTool/releases/download/0.8.4.1/UTMT_CLI_v0.8.4.1-Ubuntu.zip" -O "$script_dir/umt.zip"; then
        unzip -q "$script_dir/umt.zip" -d "$script_dir/Tools/UndertaleModCli"
        chmod +x "$script_dir/Tools/UndertaleModCli/UndertaleModCli"
        rm "$script_dir/umt.zip"
        echo -e "\e[32mUndertaleModCli installed\e[0m"
    else
        echo "UndertaleModCli download failed." >&2
    fi
fi

if command -v xdelta3 &>/dev/null; then
    echo -e "\e[32mxdelta3 already installed\e[0m"
else
    echo -e "\e[36minstalling xdelta3\e[0m"
    if command -v apt-get &>/dev/null; then
        sudo apt-get update && sudo apt-get install -y xdelta3
    else
        echo "xdelta3 not found. Please install it using your package manager." >&2
    fi
fi

if [ -f "$script_dir/Tools/DepotDownloader/DepotDownloader" ]; then
    echo -e "\e[32mDepotDownloader already installed\e[0m"
else
    echo -e "\e[36mdownloading DepotDownloader\e[0m"
    if wget -q "https://github.com/SteamRE/DepotDownloader/releases/download/DepotDownloader_3.4.0/DepotDownloader-linux-x64.zip" -O "$script_dir/depot.zip"; then
        unzip -q "$script_dir/depot.zip" -d "$script_dir/Tools/DepotDownloader"
        chmod +x "$script_dir/Tools/DepotDownloader/DepotDownloader"
        rm "$script_dir/depot.zip"
        echo -e "\e[32mDepotDownloader installed\e[0m"
    else
        echo "DepotDownloader download failed." >&2
    fi
fi

needs_old=false
needs_new=false
if [ ! -f "$script_dir/Game/1.42/data.win" ]; then
    needs_old=true
fi

if [ ! -f "$script_dir/Game/2.12/data.win" ]; then
    needs_new=true
fi

if [ "$needs_old" = true ] || [ "$needs_new" = true ]; then
    read -p "Enter your Steam username to download game files: " steam_user
    targets=()
    if [ "$needs_old" = true ]; then
        targets+=("1.42|8825902836070948945")
    fi
    if [ "$needs_new" = true ]; then
        targets+=("2.12|7209330756320585568")
    fi
    for target in "${targets[@]}"; do
        echo -e "\e[36mdownloading ${target%%|*} game files\e[0m"
        "$script_dir/Tools/DepotDownloader/DepotDownloader" -app 1115050 -depot 1115051 -manifest "${target##*|}" -beta sandbox -dir "$script_dir/Game/${target%%|*}" -username "$steam_user" -remember-password
        echo -n "1115050" > "$script_dir/Game/${target%%|*}/steam_appid.txt"
        rm -rf "$script_dir/Game/${target%%|*}/.DepotDownloader" 2>/dev/null
    done
else
    echo -e "\e[32mgame files already installed\e[0m"
fi
