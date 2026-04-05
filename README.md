# WYS Race Mod

WYS Race Mod is a multiplayer extension for Will You Snail? designed for racing. It synchronizes up to 17 players (1 host + 16 clients) in real-time.

**Not compatible with other mods.**

### Features
* See other snails moving in real-time
* A live-updating HUD to track progress and compare
* "Automatic Difficulty" is disabled by default on new save files
* Snail customization
* Adjust the leaderboard and other players' visuals to minimize distraction

## Installation

1.  **Install the Base Game**: Purchase and install [Will You Snail?](https://store.steampowered.com/app/1115050/Will_You_Snail/) via Steam.
    * *Note: To find your game folder, right-click the game in Steam > Manage > Browse local files.*
2.  **Obtain the Sandbox Version**:
    * **For v2.12 (Current)**:
        1. Right-click the game in Steam > **Properties**.
        2. Select the **Game Versions & Betas** tab.
        3. Choose **sandbox** from the dropdown.
    * **For v1.42 (Speedrunner)**:
        1. Download [DepotDownloader](https://github.com/SteamRE/DepotDownloader/releases).
        2. Run the following command in a terminal (replace placeholders with your Steam credentials):
           `./DepotDownloader -app 1115050 -depot 1115051 -manifest 8825902836070948945 -beta sandbox -username <USER> -password <PASS>`
        3. Replace your Steam game files with the files downloaded by the tool.
3.  **Download the Patch**: Get the `.xdelta` file for your version from the [Releases page](https://github.com/stone50/WYS-Race-Mod/releases).
4.  **Apply the Patch**:
    1. Go to [xdelta-wasm](https://kotcrab.github.io/xdelta-wasm).
    2. Upload the game's original `data.win` as the **Source file**.
    3. Upload the downloaded `.xdelta` file as the **Patch file**.
    4. Click **Apply Patch** and download the resulting file.
    5. Delete the original `data.win` in your game folder and replace it with the new file, ensuring it is named `data.win`.

## Using

### Networking
Press **F1** to toggle the network manager menu.

* **Hosting a Game**:
    1. **Port Forward**: [Forward a port](https://www.wikihow.com/Set-Up-Port-Forwarding-on-a-Router) (Default: `25565`). Ensure the service type is set to **UDP**.
    2. **Configure**: Set your desired port in-game. (Note: Editing the "Host IP" field as a host does not affect the connection).
    3. **Connect**: Click Connect, then provide your IP and Port to other players.
* **Joining a Game**:
    1. **Configure**: Enter the IP and Port provided by the host into the in-game menu.
    2. **Connect**: Click Connect to join the lobby.

### Customization
Press **F2** to toggle the customization menu.

* Changes to your snail’s color and your in-game display name may take a few seconds to synchronize and appear for other players.

### Racing & Leaderboards
* Levels and times will only update while following the standard **any%** route.
* All leaderboard comparisons are calculated using **in-game time**.

## Contributing

1. **Repository Setup**: Fork [this repository](https://github.com/stone50/WYS-Race-Mod) and clone it.
2.  **Preparation**: Install the mod for **Will You Snail? v1.42** (see steps above).
3.  **Modify**: Open `data.win` using [UndertaleModTool](https://github.com/UnderminersTeam/UndertaleModTool/releases) and apply your changes.
4.  **Export**:
    * In UndertaleModTool, go to **Scripts > Resource Exporters > ExportSpecificCode.csx**.
    * Select your local repository directory.
    * Enter the names of the scripts or objects you created or modified.
5.  **Submit**: Commit your changes and create a Pull Request.

### Development Notes
* To launch multiple game instances, create a `steam_appid.txt` file in the game folder containing only the text `1115050`.
* UndertaleModTool may convert references into hardcoded numbers (e.g., `656` instead of `obj_network_manager`). You must manually change these back to named references after exporting to ensure compatibility.
* Do **not** redistribute original game files or code belonging to Will You Snail?, including modified `data.win` files.
