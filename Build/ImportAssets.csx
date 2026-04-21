using System.IO;
using System.Linq;
using UndertaleModLib;
using UndertaleModLib.Compiler;
using UndertaleModLib.Models;
using UndertaleModLib.Util;

Console.WriteLine("\timporting sprites");
foreach (var file in Directory.GetFiles("../Mod/Sprites", "*.png")) {
    var spriteName = Path.GetFileNameWithoutExtension(file);
    var texture = new UndertaleEmbeddedTexture() {
        Name = Data.Strings.MakeString("tex_" + spriteName)
    };
    Data.EmbeddedTextures.Add(texture);
    var magickImage = TextureWorker.ReadBGRAImageFromFile(file);
    var gmImage = GMImage.FromMagickImage(magickImage);
    texture.TextureData.Image = gmImage.ConvertToPng();
    (var width, var height) = TextureWorker.GetImageSizeFromFile(file);
    var texturePageItem = new UndertaleTexturePageItem() {
        Name = Data.Strings.MakeString("tpag_" + spriteName),
        TexturePage = texture,
        SourceWidth = (ushort)width,
        SourceHeight = (ushort)height,
        TargetWidth = (ushort)width,
        TargetHeight = (ushort)height,
        BoundingWidth = (ushort)width,
        BoundingHeight = (ushort)height
    };
    Data.TexturePageItems.Add(texturePageItem);
    var textureEntry = new UndertaleSprite.TextureEntry() {
        Texture = texturePageItem
    };
    var sprite = Data.Sprites.ByName(spriteName);
    if (sprite == null) {
        sprite = new UndertaleSprite() {
            Name = Data.Strings.MakeString(spriteName)
        };
        Data.Sprites.Add(sprite);
    }
    sprite.Width = (uint)width;
    sprite.Height = (uint)height;
    if (sprite.Textures.Count > 0) {
        sprite.Textures[0] = textureEntry;
    } else {
        sprite.Textures.Add(textureEntry);
    }

    Console.WriteLine($"\t\timported {spriteName}");
}

Console.WriteLine("\tcreating objects");
UndertaleGameObject GetGameObject(string name) {
    var gameObject = Data.GameObjects.ByName(name);
    if (gameObject == null) {
        gameObject = new UndertaleGameObject() { 
            Name = Data.Strings.MakeString(name)
        };
        Data.GameObjects.Add(gameObject);
    }

    return gameObject;
}

var networkManager = GetGameObject("obj_network_manager");
var racingCustomization = GetGameObject("obj_racing_customization");
var leaderboard = GetGameObject("obj_leaderboard");
var racers = GetGameObject("obj_racers");
var spectatorView = GetGameObject("obj_spectator_view");

void AddNewInstance(UndertaleGameObject obj, string roomName, string layerName) {
    var room = Data.Rooms.ByName(roomName);
    if (room == null) {
        Console.WriteLine($"\t\tcould not import game object {obj.Name} because room {roomName} could not be found");
        return;
    }

    var layer = room.Layers.FirstOrDefault(l => l.LayerName.Content == layerName);
    if (layer == null) {
        Console.WriteLine($"\t\tcould not import game object {obj.Name} because layer {layerName} could not be found");
        return;
    }

    var layerInstancesData = (UndertaleRoom.Layer.LayerInstancesData)layer.Data;
    if (!layerInstancesData.Instances.Any(i => i.ObjectDefinition == obj)) {
        var instance = new UndertaleRoom.GameObject() {
            InstanceID = Data.GeneralInfo.LastObj++,
            ObjectDefinition = obj
        };
        layerInstancesData.Instances.Add(instance);
        room.GameObjects.Add(instance);
    }

    Console.WriteLine($"\t\tcreated {obj.Name}");
}

AddNewInstance(networkManager, "empty_start_room", "FadeOutIn");
AddNewInstance(racingCustomization, "empty_start_room", "FadeOutIn");
AddNewInstance(leaderboard, "empty_start_room", "FadeOutIn");
AddNewInstance(racers, "empty_start_room", "Player");
AddNewInstance(spectatorView, "menu", "Spots");

Console.WriteLine("\timporting code");
var compilerGroup = new CompileGroup(Data);
foreach (var file in Directory.GetFiles("../Mod/Code", "*.gml")) {
    var entryName = Path.GetFileNameWithoutExtension(file);
    var gmlCode = File.ReadAllText(file);
    var code = Data.Code.ByName(entryName);
    if (code == null) {
        code = new UndertaleCode() {
            Name = Data.Strings.MakeString(entryName)
        };
        Data.Code.Add(code);
    }

    compilerGroup.QueueCodeReplace(code, gmlCode);
    Console.WriteLine($"\t\tqueued {entryName}");
    if (!entryName.StartsWith("gml_Object_")) {
        continue;
    }

    var objectScriptName = entryName.Replace("gml_Object_", "");
    var parts = objectScriptName.Split('_');
    if (parts.Length < 3) {
        Console.WriteLine($"\t\tcould not link {entryName} because the file name format is incorrect");
        continue;
    }

    var objectName = string.Join("_", parts.Take(parts.Length - 2));
    var eventType = parts[parts.Length - 2];
    var eventSubtype = parts[parts.Length - 1];
    var gameObject = Data.GameObjects.ByName(objectName);
    if (gameObject == null) {
        Console.WriteLine($"\t\tcould not link {entryName} because the game object {objectName} could not be found");
        continue;
    }

    uint eventTypeIndex;
    if (!uint.TryParse(eventType, out eventTypeIndex)) {
        if (!Enum.TryParse<EventType>(eventType, true, out var eventTypeId)) {
            Console.WriteLine($"\t\tcould not link {entryName} because the event type {eventType} is unknown");
            continue;
        }
        
        eventTypeIndex = (uint)eventTypeId;
    }

    if (!uint.TryParse(eventSubtype, out uint eventSubtypeId)) {
        Console.WriteLine($"\t\tcould not link {entryName} because the event sub-type {eventSubtype} is unknown");
        continue;
    }

    var eventGroup = gameObject.Events[(int)eventTypeIndex];
    var eventEntry = eventGroup.FirstOrDefault(e => e.EventSubtype == eventSubtypeId);
    if (eventEntry == null) {
        eventEntry = new UndertaleGameObject.Event() {
            EventSubtype = eventSubtypeId
        };
        eventGroup.Add(eventEntry);
    }

    var action = new UndertaleGameObject.EventAction() {
        CodeId = code,
        Kind = 7,
        ExeType = 2
    };
    if (eventEntry.Actions.Count == 0) {
        eventEntry.Actions.Add(action);
    } else {
        eventEntry.Actions[0] = action;
    }

    Console.WriteLine($"\t\tlinked {entryName} to {objectName}");
}

var compilationResult = compilerGroup.Compile();
if (compilationResult.Errors?.Any() == true) {
    foreach (var error in compilationResult.Errors) {
        Console.WriteLine($"\t{error}");
    }
} else {
    Console.WriteLine("\tall code imported");
}
