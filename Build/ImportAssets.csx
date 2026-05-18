using System.Linq;
using System.Text.Json;
using UndertaleModLib.Util;

var scriptDir = Path.GetDirectoryName(ScriptPath);
string GetFullPath(string relativePath) => Path.GetFullPath(Path.Combine(scriptDir, relativePath));

Console.WriteLine("\timporting sprites");
foreach (var filePath in Directory.GetFiles(GetFullPath("../Mod/Sprites"), "*.png")) {
    var spriteName = Path.GetFileNameWithoutExtension(filePath);
    var texture = new UndertaleEmbeddedTexture() {
        Name = Data.Strings.MakeString("tex_" + spriteName),
        TextureData = {
            Image = GMImage.FromPng(File.ReadAllBytes(filePath))
        }
    };
    Data.EmbeddedTextures.Add(texture);
    (var w, var h) = TextureWorker.GetImageSizeFromFile(filePath);
    var width = (ushort)w;
    var height = (ushort)h;
    var texturePageItem = new UndertaleTexturePageItem() {
        Name = Data.Strings.MakeString("tpag_" + spriteName),
        TexturePage = texture,
        SourceWidth = width,
        SourceHeight = height,
        TargetWidth = width,
        TargetHeight = height,
        BoundingWidth = width,
        BoundingHeight = height
    };
    Data.TexturePageItems.Add(texturePageItem);
    var sprite = new UndertaleSprite() {
        Name = Data.Strings.MakeString(spriteName),
        Width = width,
        Height = height
    };
    sprite.Textures.Add(new() {
        Texture = texturePageItem
    });
    Data.Sprites.Add(sprite);
    Console.WriteLine($"\t\timported {sprite.Name}");
}

Console.WriteLine("\tcreating objects");
class JsonData {
    public class ObjInstanceCreation {
        public string Name { get; set; }
        public string Room { get; set; }
        public string Layer { get; set; }
    }

    public ObjInstanceCreation[] ObjInstanceCreationList { get; set; }
}

var jsonSerializerOptions = new JsonSerializerOptions {
    PropertyNamingPolicy = JsonNamingPolicy.SnakeCaseLower
};
var jsonData = JsonSerializer.Deserialize<JsonData>(File.ReadAllText(GetFullPath("./data.json")), jsonSerializerOptions);
foreach (var objInstanceCreation in jsonData.ObjInstanceCreationList) {
    var gameObject = new UndertaleGameObject() {
        Name = Data.Strings.MakeString(objInstanceCreation.Name)
    };
    Data.GameObjects.Add(gameObject);
    var gameObjectInstance = new UndertaleRoom.GameObject() {
        InstanceID = Data.GeneralInfo.LastObj++,
        ObjectDefinition = gameObject
    };
    var room = Data.Rooms.ByName(objInstanceCreation.Room);
    room.GameObjects.Add(gameObjectInstance);
    var layerInstancesData = (UndertaleRoom.Layer.LayerInstancesData)room.Layers.First(l => l.LayerName.Content == objInstanceCreation.Layer).Data;
    layerInstancesData.Instances.Add(gameObjectInstance);
    Console.WriteLine($"\t\tcreated {gameObject.Name}");
}

Console.WriteLine("\timporting code");
var compilerGroup = new CompileGroup(Data);
foreach (var file in Directory.GetFiles(GetFullPath("../Mod/Code"), "*.gml")) {
    var entryName = Path.GetFileNameWithoutExtension(file);
    var gmlCode = File.ReadAllText(file);
    var code = new UndertaleCode() {
        Name = Data.Strings.MakeString(entryName)
    };
    Data.Code.Add(code);

    compilerGroup.QueueCodeReplace(code, gmlCode);
    Console.WriteLine($"\t\tqueued {entryName}");
    if (!entryName.StartsWith("gml_Object_")) {
        continue;
    }

    var objectScriptName = entryName.Replace("gml_Object_", "");
    var parts = objectScriptName.Split('_');
    var objectName = string.Join("_", parts.Take(parts.Length - 2));
    var eventType = parts[parts.Length - 2];
    var gameObject = Data.GameObjects.ByName(objectName);
    uint eventTypeIndex;
    if (!uint.TryParse(eventType, out eventTypeIndex)) {
        eventTypeIndex = (uint)Enum.Parse(typeof(EventType), eventType, true);
    }

    var eventEntry = new UndertaleGameObject.Event() {
        EventSubtype = uint.Parse(parts[parts.Length - 1])
    };
    eventEntry.Actions.Add(new() {
        CodeId = code,
        Kind = 7,
        ExeType = 2
    });
    gameObject.Events[(int)eventTypeIndex].Add(eventEntry);
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
