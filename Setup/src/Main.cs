using Godot;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Reflection;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Threading;
using System.Threading.Tasks;

// ─────────────────────────────────────────────
//  Models
// ─────────────────────────────────────────────

public enum WYSGameVersion
{
    [Display(Name = "v1.42")] V1_42,
    [Display(Name = "v2.12")] V2_12
}

public class UserCredentials
{
    public string UserName { get; set; }
    public string Password { get; set; }
    public UserCredentials(string username, string password) { UserName = username; Password = password; }
}

/// <summary>Persisted alongside each downloaded version so we can list local versions without GitHub.</summary>
public class VersionMeta
{
    [JsonPropertyName("name")] public string Name { get; set; } = "";
    [JsonPropertyName("tag_name")] public string TagName { get; set; } = "";
    [JsonPropertyName("published_at")] public string? PublishedAt { get; set; }
}

// ─────────────────────────────────────────────
//  Main
// ─────────────────────────────────────────────

public partial class Main : Control
{
    // ── Constants ─────────────────────────────────────────────────────────────

    private const double DISK_FILE_REFRESH_CYCLE = 0.8d;
    private const string APP_ID = "1115050";
    private const string DEPOT_ID = "1115051";
    private const string MANIFEST_V1_42 = "8825902836070948945";

    // ── Directories ───────────────────────────────────────────────────────────

    private static string _dataRootDir => OS.GetUserDataDir();
    private static string _depotDir => _dataRootDir + "/DD/";
    private static string _xdeltaDir => _dataRootDir + "/xdelta/";
    private static string _tempDir => _dataRootDir + "/temp/";
    private static string _versionDir => _dataRootDir + "/versions/";
    private static string _extractedXdeltaDir => _xdeltaDir + "win_extr/";
    private static string _extractedXdeltaExe => _extractedXdeltaDir + "xdelta3-3.1.0-x86_64.exe";
    private static string _extractedDDDir => _depotDir + "win_extr/";
    private static string _extractedDDExe => _extractedDDDir + "DepotDownloader.exe";
    private static string _depotDirV1_42 => _depotDir + "v1_42/";
    private static string _depotDirV2_12 => _depotDir + "v2_12/";
    private static string _steamPathFile => _dataRootDir + "/steam_path.txt";
    private static string _versionFile => _dataRootDir + "/selected_version.txt";

    private readonly List<string> FILES_TO_DELETE_TO_MAKE_IT_RUN_LOCALLY =
        ["options.ini", "steam_api64.dll", "steam_appid.txt", "Steamworks_x64.dll"];

    // ── State ─────────────────────────────────────────────────────────────────

    private WYSGameVersion _wysVersion = WYSGameVersion.V1_42;
    private UserCredentials? _creds;
    private string _steamDirectory = "";
    private double _timeSinceLastDiskRefresh;
    private Process? _gameProcess;
    private bool _setupDone = false;
    private bool _isGameRunning = false;
    private Label? _releasesPlaceholder;

    // Credentials handshake
    private TaskCompletionSource<UserCredentials>? _credentialsTcs;

    // Steam Guard handshake
    private readonly ManualResetEventSlim _steamGuardGate = new ManualResetEventSlim(false);
    private volatile string? _steamGuardCode;

    // Download queue — ensures only one xdelta process runs at a time
    private readonly Queue<string> _downloadQueue = new();
    private bool _isDownloading = false;

    private List<Release> _availableReleases = new();
    private readonly Dictionary<string, ReleaseEntry> _releaseEntries = new();

    private DepotDownloader? _currentDD;

    private readonly GitHubReleaseManager _raceModManager =
        new GitHubReleaseManager("stone50", "WYS-Race-Mod");

    // ── Exports ───────────────────────────────────────────────────────────────

    [Export] public PackedScene? ReleaseEntryScene { get; set; }
    [Export] public TextureRect? BgTextureRect { get; set; }
    [Export] public Texture2D? DefaultBG { get; set; }
    [Export] public Texture2D? EasterEggBG { get; set; }

    // ── Node refs ─────────────────────────────────────────────────────────────

    private Label _statusLabel = null!;
    private ProgressBar _statusProgress = null!;
    private PanelContainer _setupPanel = null!;
    private Label _setupLabel = null!;
    private ProgressBar _setupProgress = null!;
    private LineEdit _steamPathEdit = null!;
    private VBoxContainer _releasesList = null!;
    private Button _refreshBtn = null!;
    private AcceptDialog _errorDialog = null!;
    private CredentialsDialog _credsDialog = null!;
    private CheckButton _versionToggle = null!;
    private PanelContainer _sandboxPanel = null!;
    private Button _dlSandboxesBtn = null!;
    private Button _steamBrowseBtn = null!;
    private FileDialog _steamPathDialog = null!;
    private SteamGuardDialog _steamGuardDialog = null!;
    private Control _releasesSection = null!;
    private PanelContainer _playingPanel = null!;
    private Label _playingNameLabel = null!;
    private Label _playingStepLabel = null!;
    private Button _forceCloseBtn = null!;

    // ── Lifecycle ─────────────────────────────────────────────────────────────

    public override void _Ready()
    {
        Engine.MaxFps = 60;

        _statusLabel = GetNode<Label>("%StatusLabel");
        _statusProgress = GetNode<ProgressBar>("%StatusProgress");
        _setupPanel = GetNode<PanelContainer>("%SetupPanel");
        _setupLabel = GetNode<Label>("%SetupLabel");
        _setupProgress = GetNode<ProgressBar>("%SetupProgress");
        _steamPathEdit = GetNode<LineEdit>("%SteamPathEdit");
        _releasesList = GetNode<VBoxContainer>("%ReleasesList");
        _refreshBtn = GetNode<Button>("%RefreshBtn");
        _errorDialog = GetNode<AcceptDialog>("%ErrorDialog");
        _credsDialog = GetNode<CredentialsDialog>("%CredentialsDialog");
        _versionToggle = GetNode<CheckButton>("%VersionToggle");
        _sandboxPanel = GetNode<PanelContainer>("%SandboxPanel");
        _dlSandboxesBtn = GetNode<Button>("%DlSandboxesBtn");
        _steamBrowseBtn = GetNode<Button>("%SteamBrowseBtn");
        _steamPathDialog = GetNode<FileDialog>("%SteamPathDialog");
        _steamGuardDialog = GetNode<SteamGuardDialog>("%SteamGuardDialog");
        _releasesSection = GetNode<Control>("%ReleasesSection");
        _playingPanel = GetNode<PanelContainer>("%PlayingPanel");
        _playingNameLabel = GetNode<Label>("%PlayingNameLabel");
        _playingStepLabel = GetNode<Label>("%PlayingStepLabel");
        _forceCloseBtn = GetNode<Button>("%ForceCloseBtn");

        GetNode<VersionShaderController>("ShaderController").Init(_versionToggle);

        _versionToggle.Toggled += on => {
            _wysVersion = on ? WYSGameVersion.V2_12 : WYSGameVersion.V1_42;
            _versionToggle.Text = on ? "v2.12" : "v1.42";
            SaveVersionToggle(on);
        };

        _refreshBtn.Pressed += () => _ = RunSafe(RefreshAvailableVersions, "Refresh releases");
        _dlSandboxesBtn.Pressed += () => _ = RunSafe(OnDownloadSandboxesPressed, "Download sandboxes");
        _forceCloseBtn.Pressed += OnForceClosePressed;

        _steamBrowseBtn.Pressed += () => {
            // Pre-navigate FileDialog to the current saved path
            if (!string.IsNullOrEmpty(_steamDirectory) && Directory.Exists(_steamDirectory))
                _steamPathDialog.CurrentDir = _steamDirectory;
            _steamPathDialog.PopupCentered(new Vector2I(720, 520));
        };
        _steamPathDialog.DirSelected += OnSteamDirSelected;
        _steamPathEdit.TextChanged += txt => { _steamDirectory = txt; SaveSteamPath(txt); };
        _credsDialog.CredentialsConfirmed += OnCredentialsConfirmed;
        _credsDialog.Cancelled += OnCredentialsCancelled;
        _steamGuardDialog.CodeSubmitted += OnSteamGuardCodeSubmitted;

        // Lock releases list until initial setup is done
        _refreshBtn.Disabled = true;
        _sandboxPanel.Visible = false;
        _playingPanel.Visible = false;

        _releasesPlaceholder = new Label
        {
            Text = "⏳  Setup in progress — please wait for all tools to finish downloading.",
            AutowrapMode = TextServer.AutowrapMode.WordSmart,
            HorizontalAlignment = HorizontalAlignment.Center,
        };
        _releasesPlaceholder.AddThemeColorOverride("font_color", new Color(0.55f, 0.55f, 0.55f));
        _releasesList.AddChild(_releasesPlaceholder);

        TryLoadOrAutoDetectSteamPath();
        LoadVersionToggle();

        ShowSetupPanel("Initialising…", 0);
        _ = RunSafe(InitialSetup, "Initial setup");
    }

    bool f7easteregg = false, f7e_toggle = false;
    public override void _Process(double delta)
    {
        _timeSinceLastDiskRefresh += delta;
        if (_timeSinceLastDiskRefresh >= DISK_FILE_REFRESH_CYCLE)
        {
            RefreshVersionFilesOnDisk();
            _timeSinceLastDiskRefresh = 0;
        }

        if (BgTextureRect != null)
            BgTextureRect.Texture = f7e_toggle ? EasterEggBG : DefaultBG;
        if (Input.IsKeyPressed(Key.F7))
        {
            if (f7easteregg) f7e_toggle = !f7e_toggle;
            f7easteregg = false;
        }
        else f7easteregg = true;
    }

    public override void _ExitTree()
    {
        _currentDD?.Kill();
        if (_gameProcess is { HasExited: false })
            _gameProcess.Kill();
        _raceModManager.Dispose();
    }

    // ── Setup flow ────────────────────────────────────────────────────────────

    private async Task InitialSetup()
    {
        await DownloadDDIfNonExistant();
        await DownloadXdeltaIfNonExistant();
        Callable.From(HideSetupPanel).CallDeferred(); // sets _setupDone, shows local versions

        if (!SandboxesExisting())
            Callable.From(() => {
                _sandboxPanel.Visible = true;
                SetStatusDirect("Tools ready. Click 'Download Sandboxes' to continue setup.");
            }).CallDeferred();
        else
            await RefreshAvailableVersions();
    }

    private async Task OnDownloadSandboxesPressed()
    {
        Callable.From(() => {
            _sandboxPanel.Visible = false;
            _dlSandboxesBtn.Disabled = true;
        }).CallDeferred();

        try { await DownloadSandboxesIfNonExistant(); }
        finally
        {
            bool missing = !SandboxesExisting();
            Callable.From(() => {
                _sandboxPanel.Visible = missing;
                _dlSandboxesBtn.Disabled = false;
                if (missing) SetStatusDirect("Sandbox download incomplete. You can try again.");
            }).CallDeferred();
            HideProgress();
        }

        if (SandboxesExisting())
            await RefreshAvailableVersions();
    }

    private async Task DownloadDDIfNonExistant()
    {
        if (File.Exists(_extractedDDExe)) return;

        SetSetupStatus("Downloading DepotDownloader…", 0);
        Directory.CreateDirectory(_depotDir);

        string zipPath = _depotDir + "DepotDownloader-windows-x64.zip";
        if (!File.Exists(zipPath))
            await DownloadLatestGitHubAsset("SteamRE", "DepotDownloader", "windows-x64.zip", zipPath);

        SetSetupStatus("Extracting DepotDownloader…", 50);
        await FileHelper.UnzipAsync(zipPath, _extractedDDDir, overwrite: true);
        SetSetupStatus("DepotDownloader ready.", 100);
    }

    private async Task DownloadXdeltaIfNonExistant()
    {
        if (File.Exists(_extractedXdeltaExe)) return;

        SetSetupStatus("Downloading xdelta3…", 0);
        Directory.CreateDirectory(_xdeltaDir);

        string zipPath = _xdeltaDir + "xdelta3-3.1.0-x86_64.exe.zip";
        if (!File.Exists(zipPath))
            await DownloadLatestGitHubAsset("jmacd", "xdelta-gpl", "x86_64.exe.zip", zipPath);

        SetSetupStatus("Extracting xdelta3…", 50);
        await FileHelper.UnzipAsync(zipPath, _extractedXdeltaDir, overwrite: true);
        SetSetupStatus("xdelta3 ready.", 100);
    }

    private async Task DownloadSandboxesIfNonExistant()
    {
        if (SandboxesExisting()) return;

        ShowProgress("Steam credentials required — enter credentials to continue.", 0);

        _credentialsTcs = new TaskCompletionSource<UserCredentials>();
        Callable.From(() => _credsDialog.Show()).CallDeferred();
        _creds = await _credentialsTcs.Task;

        _currentDD = new DepotDownloader(_extractedDDExe);
        var dd = _currentDD;
        var cb = MakeDDStatusCallback();

        if (!Directory.Exists(_depotDirV1_42))
        {
            string dlDir = _depotDir + "dl_v1_42/";
            if (Directory.Exists(dlDir)) Directory.Delete(dlDir, true);
            Directory.CreateDirectory(dlDir);

            ShowProgress("Downloading WYS v1.42 sandbox — this may take a while…", 0);
            int exit = await dd.RunAsync(
                $"-app {APP_ID} -depot {DEPOT_ID} -manifest {MANIFEST_V1_42} " +
                $"-beta sandbox -dir \"{dlDir}\" " +
                $"-username {_creds.UserName} -password {_creds.Password}",
                onOutput: cb, onError: cb, onInputRequired: GetSteamInput
            );
            if (exit != 0)
                throw new Exception($"DepotDownloader exited with code {exit} for v1.42 download.");

            string? gameRoot = FindGameRootInDir(dlDir);
            if (gameRoot == null)
                throw new Exception($"Could not find data.win under '{dlDir}'. Check DepotDownloader output for errors.");

            ShowProgress("Copying v1.42 sandbox files…", 100);
            Directory.CreateDirectory(_depotDirV1_42);
            await Task.Run(() => CopyDirectory(gameRoot, _depotDirV1_42, overwrite: true));
            try { Directory.Delete(dlDir, true); } catch { /* non-fatal */ }
        }

        if (!Directory.Exists(_depotDirV2_12))
        {
            string dlDir = _depotDir + "dl_v2_12/";
            if (Directory.Exists(dlDir)) Directory.Delete(dlDir, true);
            Directory.CreateDirectory(dlDir);

            ShowProgress("Downloading WYS v2.12 sandbox — this may take a while…", 0);
            int exit = await dd.RunAsync(
                $"-app {APP_ID} -beta sandbox -dir \"{dlDir}\" " +
                $"-username {_creds.UserName} -password {_creds.Password}",
                onOutput: cb, onError: cb, onInputRequired: GetSteamInput
            );
            if (exit != 0)
                throw new Exception($"DepotDownloader exited with code {exit} for v2.12 download.");

            string? gameRoot = FindGameRootInDir(dlDir);
            if (gameRoot == null)
                throw new Exception($"Could not find data.win under '{dlDir}'. Check DepotDownloader output for errors.");

            ShowProgress("Copying v2.12 sandbox files…", 100);
            Directory.CreateDirectory(_depotDirV2_12);
            await Task.Run(() => CopyDirectory(gameRoot, _depotDirV2_12, overwrite: true));
            try { Directory.Delete(dlDir, true); } catch { /* non-fatal */ }
        }

        _currentDD = null;
        ShowProgress("Sandbox files ready.", 100);
    }

    // ── Release management ────────────────────────────────────────────────────

    public async Task RefreshAvailableVersions()
    {
        if (!_setupDone) return;
        SetStatus("Fetching available versions…");
        var releases = await _raceModManager.GetReleasesAsync(perPage: 20);
        _availableReleases = releases;
        Callable.From(() => RebuildReleaseList(releases)).CallDeferred();
        SetStatus("Ready.");
    }

    private void LoadAndDisplayLocalVersions()
    {
        var local = ListLocalVersions();
        RebuildReleaseList(new List<Release>(), localOnly: local);
        if (local.Count > 0)
            SetStatus($"{local.Count} locally cached version(s) found. Press Refresh to fetch all.");
        else
            SetStatus("Ready. Press Refresh to fetch available mod versions.");
    }

    /// <summary>
    /// Merges GitHub releases with local-only versions, sorts downloaded first (desc),
    /// then undownloaded (desc), with a separator between the groups.
    /// </summary>
    private void RebuildReleaseList(List<Release> githubReleases, List<Release>? localOnly = null)
    {
        foreach (var child in _releasesList.GetChildren()) child.QueueFree();
        _releaseEntries.Clear();

        if (ReleaseEntryScene == null)
        {
            GD.PrintErr("[Main] ReleaseEntryScene export is not assigned in the Inspector!");
            return;
        }

        // Merge: GitHub releases + any local versions not in the GitHub list
        var allVersions = new List<Release>(githubReleases);
        foreach (var local in (localOnly ?? ListLocalVersions()))
            if (!allVersions.Any(r => r.Name == local.Name))
                allVersions.Add(local);

        // VersionTagComparer.Compare already returns newest-first (descending).
        // Use OrderBy — not OrderByDescending — so the comparer isn't negated.
        var downloaded = allVersions.Where(r => IsVersionDownloaded(r.Name)).OrderBy(r => r.TagName, VersionTagComparer.Instance).ToList();
        var notDownloaded = allVersions.Where(r => !IsVersionDownloaded(r.Name)).OrderBy(r => r.TagName, VersionTagComparer.Instance).ToList();

        foreach (var r in downloaded) AddReleaseEntry(r, isDownloaded: true);
        if (downloaded.Count > 0 && notDownloaded.Count > 0)
            _releasesList.AddChild(new HSeparator());
        foreach (var r in notDownloaded) AddReleaseEntry(r, isDownloaded: false);
    }

    private void AddReleaseEntry(Release release, bool isDownloaded)
    {
        var entry = ReleaseEntryScene!.Instantiate<ReleaseEntry>();
        _releasesList.AddChild(entry);
        entry.Setup(release, isDownloaded);
        entry.DownloadRequested += name => OnDownloadRequested(name);
        entry.PlayRequested += name => OnPlayRequested(name);
        entry.RemoveRequested += name => OnRemoveRequested(name);
        _releaseEntries[release.Name] = entry;
    }

    private void RefreshVersionFilesOnDisk()
    {
        bool anyChange = false;
        foreach (var (name, entry) in _releaseEntries)
        {
            bool downloaded = IsVersionDownloaded(name);
            bool wasDownloaded = entry.IsMarkedAsDownloaded;
            if (downloaded != wasDownloaded)
            {
                anyChange = true;
                break;
            }
        }
        // If any entry changed state, do a full rebuild so sorting is also corrected.
        if (anyChange)
            RebuildReleaseList(_availableReleases);
        else
        {
            foreach (var (name, entry) in _releaseEntries)
                entry.SetDownloadedState(IsVersionDownloaded(name));
        }
    }

    private bool IsVersionDownloaded(string releaseName) =>
        File.Exists(_versionDir + releaseName + "/v1_42/data.win") &&
        File.Exists(_versionDir + releaseName + "/v2_12/data.win");

    private static List<Release> ListLocalVersions()
    {
        var result = new List<Release>();
        if (!Directory.Exists(_versionDir)) return result;
        foreach (string dir in Directory.GetDirectories(_versionDir))
        {
            // Clean up partial installs immediately before listing
            if (IsPartialInstall(dir))
            {
                GD.PrintErr($"[Main] Partial install detected, removing: {dir}");
                try { Directory.Delete(dir, true); } catch (Exception ex) { GD.PrintErr($"[Main] Could not remove partial install: {ex.Message}"); }
                continue;
            }

            string jsonPath = Path.Combine(dir, "version.json");
            if (!File.Exists(jsonPath)) continue;
            try
            {
                var meta = JsonSerializer.Deserialize<VersionMeta>(File.ReadAllText(jsonPath));
                if (meta != null)
                    result.Add(new Release
                    {
                        Name = meta.Name,
                        TagName = meta.TagName,
                        PublishedAt = DateTimeOffset.TryParse(meta.PublishedAt, out var dt) ? dt : null,
                    });
            }
            catch { /* skip corrupt metadata */ }
        }
        return result;
    }

    /// <summary>
    /// A version directory is considered a partial install when it exists but
    /// does NOT have both data.win files present.  An empty directory or a
    /// directory missing either data.win means the download was interrupted.
    /// </summary>
    private static bool IsPartialInstall(string versionDir)
    {
        bool has142 = File.Exists(Path.Combine(versionDir, "v1_42", "data.win"));
        bool has212 = File.Exists(Path.Combine(versionDir, "v2_12", "data.win"));
        // If neither exists it might just be an empty/leftover folder — remove it.
        // If only one exists the install was interrupted mid-patch — remove it.
        if (!has142 && !has212)
        {
            // Only flag as partial if directory actually has some content (not just stray empty dir)
            string[] files = Directory.GetFiles(versionDir, "*", SearchOption.AllDirectories);
            return files.Length > 0; // non-empty but missing data.wins = partial
        }
        return has142 != has212; // exactly one is present = partial
    }

    private static void WriteVersionMetadata(Release release)
    {
        string metaPath = _versionDir + release.Name + "/version.json";
        var meta = new VersionMeta
        {
            Name = release.Name,
            TagName = release.TagName,
            PublishedAt = release.PublishedAt?.ToString("O"),
        };
        File.WriteAllText(metaPath, JsonSerializer.Serialize(meta));
    }

    // ── Download + patch ──────────────────────────────────────────────────────

    private void OnDownloadRequested(string releaseName)
    {
        // Avoid duplicate queuing
        if (_downloadQueue.Contains(releaseName)) return;
        if (_isDownloading && _releaseEntries.TryGetValue(releaseName, out var e) && e.IsDownloading) return;

        var release = _availableReleases.FirstOrDefault(r => r.Name == releaseName);
        if (release == null) return;

        _downloadQueue.Enqueue(releaseName);

        if (_releaseEntries.TryGetValue(releaseName, out var entry))
            entry.SetQueued(true);

        if (!_isDownloading)
            _ = RunSafe(ProcessDownloadQueue, "Download queue");
    }

    private async Task ProcessDownloadQueue()
    {
        _isDownloading = true;
        while (_downloadQueue.TryDequeue(out string? releaseName))
        {
            var release = _availableReleases.FirstOrDefault(r => r.Name == releaseName);
            if (release == null)
            {
                Callable.From(() => {
                    if (_releaseEntries.TryGetValue(releaseName!, out var e)) e.SetDownloading(false);
                }).CallDeferred();
                continue;
            }

            Callable.From(() => {
                if (_releaseEntries.TryGetValue(releaseName, out var e)) e.SetDownloading(true);
            }).CallDeferred();

            try { await DownloadAndPatchRelease(release); }
            catch (Exception ex)
            {
                ShowError($"Download '{releaseName}' failed", ex.Message);
                Callable.From(() => {
                    if (_releaseEntries.TryGetValue(releaseName, out var e)) e.SetDownloading(false);
                }).CallDeferred();
            }
            finally { HideProgress(); }
        }
        _isDownloading = false;
    }

    private async Task DownloadAndPatchRelease(Release release)
    {
        ShowProgress($"Downloading {release.Name}…", 0);
        ClearTemp();

        await _raceModManager.DownloadAsync(
            release: release,
            directory: _tempDir,
            overwrite: true,
            onProgress: (asset, p) => SetSetupStatus(
                $"{Path.GetFileName(asset.Name)}: {p}", p.Percentage ?? -1)
        );

        var patcher = new XDeltaPatcher { XDeltaBinaryPath = _extractedXdeltaExe, Overwrite = true };
        string versionRoot = _versionDir + release.Name + "/";

        string patch142 = FindXdeltaFile(_tempDir, "1.42", "1_42")
            ?? throw new FileNotFoundException(
                $"Could not find a 1.42 xdelta patch in temp directory '{_tempDir}'. " +
                "Expected a file with '1.42' or '1_42' in its name.");

        string patch212 = FindXdeltaFile(_tempDir, "2.12", "2_12")
            ?? throw new FileNotFoundException(
                $"Could not find a 2.12 xdelta patch in temp directory '{_tempDir}'. " +
                "Expected a file with '2.12' or '2_12' in its name.");

        ShowProgress($"Patching {release.Name} — v1.42…", 50);
        await patcher.ApplyPatchToFileAsync(
            _depotDirV1_42 + "data.win",
            patch142,
            versionRoot + "v1_42/data.win"
        );

        ShowProgress($"Patching {release.Name} — v2.12…", 75);
        await patcher.ApplyPatchToFileAsync(
            _depotDirV2_12 + "data.win",
            patch212,
            versionRoot + "v2_12/data.win"
        );

        WriteVersionMetadata(release);
        ClearTemp();

        Callable.From(() => {
            if (_releaseEntries.TryGetValue(release.Name, out var entry))
            {
                entry.SetDownloadedState(true);
                entry.SetDownloading(false);
            }
            // Re-sort list so this version moves to the downloaded section
            RebuildReleaseList(_availableReleases);
        }).CallDeferred();

        SetStatus($"{release.Name} is ready to play.");
    }

    private void OnRemoveRequested(string releaseName)
    {
        try
        {
            string versionRoot = _versionDir + releaseName + "/";
            if (Directory.Exists(versionRoot))
                Directory.Delete(versionRoot, recursive: true);
            // Rebuild list: version moves back to not-downloaded section
            Callable.From(() => RebuildReleaseList(_availableReleases)).CallDeferred();
            SetStatus($"Removed {releaseName}.");
        }
        catch (Exception ex) { ShowError("Remove failed", ex.Message); }
    }

    // ── Launch ────────────────────────────────────────────────────────────────

    private static readonly List<string> _steamOverlayDirs =
        ["/Squids Secret Presentation", "/Fonts", "/Colors"];

    private void OnPlayRequested(string releaseName)
        => _ = RunSafe(() => StartGameInstance(releaseName), $"Launch {releaseName}");

    private async Task StartGameInstance(string versionName)
    {
        if (_isGameRunning) return;

        // Show playing panel immediately on the main thread
        string versionSubdir = _wysVersion == WYSGameVersion.V1_42 ? "v1_42" : "v2_12";
        Callable.From(() => {
            _releasesSection.Visible = false;
            _playingPanel.Visible = true;
            _playingNameLabel.Text = $"{versionName}  ({typeof(WYSGameVersion)
                .GetField(_wysVersion.ToString())!
                .GetCustomAttribute<DisplayAttribute>()!
                .Name})";
            _playingStepLabel.Text = "Preparing…";
        }).CallDeferred();

        _isGameRunning = true;

        try
        {
            await Task.Run(() => {
                SetPlayingStep("Checking sandbox files…");
                string sandboxDir = _wysVersion == WYSGameVersion.V1_42 ? _depotDirV1_42 : _depotDirV2_12;
                string dataWinSrc = _versionDir + versionName + $"/{versionSubdir}/data.win";
                string gameExe = _tempDir + "Will You Snail.exe";

                if (!Directory.Exists(sandboxDir))
                    throw new DirectoryNotFoundException($"Sandbox not found: {sandboxDir}");
                if (!File.Exists(dataWinSrc))
                    throw new FileNotFoundException($"Patched data.win not found: {dataWinSrc}", dataWinSrc);

                SetPlayingStep("Copying sandbox files to temp…");
                ClearTemp();
                CopyDirectory(sandboxDir, _tempDir, overwrite: true);

                if (!string.IsNullOrWhiteSpace(_steamDirectory))
                {
                    SetPlayingStep("Overlaying Steam content…");
                    foreach (string rel in _steamOverlayDirs)
                    {
                        string src = _steamDirectory + rel;
                        if (Directory.Exists(src))
                            CopyDirectory(src, _tempDir + rel, overwrite: true);
                    }
                }

                SetPlayingStep("Placing mod data.win…");
                FileHelper.CopyFile(dataWinSrc, _tempDir + "data.win", overwrite: true);

                foreach (string tfile in FILES_TO_DELETE_TO_MAKE_IT_RUN_LOCALLY)
                {
                    string p = _tempDir + tfile;
                    if (File.Exists(p)) File.Delete(p);
                }

                if (!File.Exists(gameExe))
                    throw new FileNotFoundException("Game executable not found in sandbox.", gameExe);

                SetPlayingStep("Launching game…");
                _gameProcess = new Process
                {
                    StartInfo = new ProcessStartInfo
                    {
                        FileName = gameExe,
                        WorkingDirectory = _tempDir,
                        UseShellExecute = false,
                    }
                };
                _gameProcess.Start();
                SetPlayingStep($"Game is running.  Close the game window or press Force Close.");
                _gameProcess.WaitForExit();
            });
        }
        finally
        {
            _isGameRunning = false;
            Callable.From(() => {
                _playingPanel.Visible = false;
                _releasesSection.Visible = true;
            }).CallDeferred();
            SetStatus("Game closed.");
        }
    }

    // ── Playing panel ─────────────────────────────────────────────────────────

    private void SetPlayingStep(string step)
        => Callable.From(() => _playingStepLabel.Text = step).CallDeferred();

    private void OnForceClosePressed()
    {
        if (_gameProcess is { HasExited: false })
        {
            _gameProcess.Kill(entireProcessTree: true);
            _gameProcess.Dispose();
            _gameProcess = null;
        }
        // _isGameRunning cleared + panel hidden by the finally block in StartGameInstance
    }

    // ── Credentials ───────────────────────────────────────────────────────────

    private void OnSteamDirSelected(string dir)
    {
        _steamDirectory = dir;
        _steamPathEdit.Text = dir;
        SaveSteamPath(dir);
    }

    private void OnCredentialsConfirmed(string username, string password)
    {
        _creds = new UserCredentials(username, password);
        _credentialsTcs?.TrySetResult(_creds);
        _credentialsTcs = null;
    }

    private void OnCredentialsCancelled()
    {
        _credentialsTcs?.TrySetCanceled();
        _credentialsTcs = null;
    }

    // ── Steam Guard ───────────────────────────────────────────────────────────

    private string GetSteamInput(string prompt)
    {
        _steamGuardCode = null;
        _steamGuardGate.Reset();
        Callable.From(() => _steamGuardDialog.ShowForPrompt(prompt)).CallDeferred();
        if (!_steamGuardGate.Wait(TimeSpan.FromMinutes(5)))
            throw new TimeoutException("Steam Guard input timed out after 5 minutes.");
        return _steamGuardCode ?? "";
    }

    private void OnSteamGuardCodeSubmitted(string code)
    {
        _steamGuardCode = code;
        _steamGuardGate.Set();
    }

    // ── Steam path persistence ────────────────────────────────────────────────

    private void TryLoadOrAutoDetectSteamPath()
    {
        if (File.Exists(_steamPathFile))
        {
            try
            {
                string saved = File.ReadAllText(_steamPathFile).Trim();
                if (!string.IsNullOrEmpty(saved))
                {
                    _steamDirectory = saved;
                    _steamPathEdit.Text = saved;
                    GD.Print($"[Main] Loaded saved Steam path: {saved}");
                    return;
                }
            }
            catch (Exception ex) { GD.PrintErr($"[Main] Failed to read steam_path.txt: {ex.Message}"); }
        }
        TryAutoDetectSteamPath();
    }

    private void SaveSteamPath(string path)
    {
        try { File.WriteAllText(_steamPathFile, path); }
        catch (Exception ex) { GD.PrintErr($"[Main] Failed to save Steam path: {ex.Message}"); }
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    private void ClearTemp()
    {
        if (Directory.Exists(_tempDir)) Directory.Delete(_tempDir, recursive: true);
        Directory.CreateDirectory(_tempDir);
    }

    /// <summary>
    /// Scans <paramref name="dir"/> for an xdelta file matching any of the given
    /// <paramref name="keywords"/> (case-insensitive, dot and underscore both accepted).
    /// Returns the first match, or null if none found.
    /// Example: FindXdeltaFile(tempDir, "1.42", "1_42") matches
    ///   "1.42.xdelta", "patch_1_42.xd3", "WYS Race Mod 1.42.xdelta", etc.
    /// </summary>
    private static string? FindXdeltaFile(string dir, params string[] keywords)
    {
        if (!Directory.Exists(dir)) return null;

        // Accept any extension commonly used for xdelta patches
        string[] candidates = Directory.GetFiles(dir)
            .Where(f => {
                string ext = Path.GetExtension(f).ToLowerInvariant();
                return ext is ".xdelta" or ".vcdiff" or ".xd3" or ".patch";
            })
            .ToArray();

        foreach (string candidate in candidates)
        {
            string nameLower = Path.GetFileName(candidate).ToLowerInvariant();
            // Normalise so "1.42" and "1_42" both match "142" tokens
            string normalised = nameLower.Replace('.', '_').Replace('-', '_');
            foreach (string kw in keywords)
            {
                string kwNorm = kw.ToLowerInvariant().Replace('.', '_').Replace('-', '_');
                if (normalised.Contains(kwNorm))
                {
                    GD.Print($"[Main] FindXdeltaFile: '{kw}' matched '{candidate}'");
                    return candidate;
                }
            }
        }

        GD.PrintErr($"[Main] FindXdeltaFile: no file matching [{string.Join(", ", keywords)}] found in '{dir}'");
        return null;
    }

    private bool SandboxesExisting() =>
        Directory.Exists(_depotDirV1_42) && Directory.Exists(_depotDirV2_12);

    private static string? FindGameRootInDir(string root)
    {
        try
        {
            foreach (string file in Directory.EnumerateFiles(root, "data.win", SearchOption.AllDirectories))
            {
                string? dir = Path.GetDirectoryName(file);
                GD.Print($"[Main] Found data.win at: {file}");
                return dir;
            }
        }
        catch (Exception ex) { GD.PrintErr($"[Main] FindGameRootInDir error: {ex.Message}"); }
        GD.PrintErr($"[Main] data.win not found anywhere under: {root}");
        return null;
    }

    private async Task DownloadLatestGitHubAsset(string owner, string repo, string assetFilter, string destPath)
    {
        using var manager = new GitHubReleaseManager(owner, repo);
        var releases = await manager.GetReleasesAsync(perPage: 5);
        if (releases.Count == 0)
            throw new Exception($"No releases found for {owner}/{repo}.");

        var asset = releases[0].Assets
            .FirstOrDefault(a => a.Name.Contains(assetFilter, StringComparison.OrdinalIgnoreCase))
            ?? throw new Exception($"No asset matching '{assetFilter}' in latest release of {owner}/{repo}.");

        string dir = Path.GetDirectoryName(destPath)!;
        await manager.DownloadAssetAsync(asset, dir,
            onProgress: (a, p) => SetSetupStatus($"{a.Name}: {p}", p.Percentage ?? -1));

        string downloaded = Path.Combine(dir, asset.Name);
        if (!downloaded.Equals(destPath, StringComparison.OrdinalIgnoreCase) && File.Exists(downloaded))
            FileHelper.RenameFile(downloaded, destPath, overwrite: true);
    }

    private static void CopyDirectory(string src, string dst, bool overwrite = false)
    {
        Directory.CreateDirectory(dst);
        foreach (string file in Directory.GetFiles(src))
            File.Copy(file, Path.Combine(dst, Path.GetFileName(file)), overwrite);
        foreach (string dir in Directory.GetDirectories(src))
            CopyDirectory(dir, Path.Combine(dst, Path.GetFileName(dir)), overwrite);
    }

    /// <summary>
    /// Returns a callback suitable for DepotDownloader output.
    /// Lines like " 96.79% C:/path/to/file" → progress bar + filename only in label.
    /// Other lines → plain label update, no progress change.
    /// </summary>
    private Action<string> MakeDDStatusCallback()
    {
        return line =>
        {
            string trimmed = line.TrimStart();
            int pctIdx = trimmed.IndexOf('%');
            if (pctIdx > 0 && double.TryParse(
                    trimmed[..pctIdx],
                    NumberStyles.Float,
                    CultureInfo.InvariantCulture,
                    out double pct))
            {
                // Show just the filename to keep the label short
                string rest = trimmed[(pctIdx + 1)..].Trim();
                string fileName = string.IsNullOrEmpty(rest) ? "" : Path.GetFileName(rest);
                SetSetupStatus($"{pct:F1}%  {fileName}", pct);
            }
            else
            {
                SetSetupStatus(line, -1);
            }
        };
    }

    // ── Steam path auto-detection ─────────────────────────────────────────────

    private static readonly string[] _wysDefaultPaths =
    [
        @"C:\Program Files (x86)\Steam\steamapps\common\Will You Snail",
        @"C:\Program Files\Steam\steamapps\common\Will You Snail",
        @"D:\Steam\steamapps\common\Will You Snail",
        @"D:\SteamLibrary\steamapps\common\Will You Snail",
        @"E:\Steam\steamapps\common\Will You Snail",
        @"E:\SteamLibrary\steamapps\common\Will You Snail",
    ];

    private void TryAutoDetectSteamPath()
    {
        foreach (string path in _wysDefaultPaths)
        {
            if (!Directory.Exists(path)) continue;
            _steamDirectory = path;
            _steamPathEdit.Text = path;
            GD.Print($"[Main] Auto-detected WYS Steam path: {path}");
            return;
        }
        GD.Print("[Main] WYS Steam path not found in common locations; leaving field empty.");
    }

    private void SaveVersionToggle(bool isV2_12)
    {
        try { File.WriteAllText(_versionFile, isV2_12 ? "v2_12" : "v1_42"); }
        catch (Exception ex) { GD.PrintErr($"[Main] Failed to save version toggle: {ex.Message}"); }
    }

    /// <summary>
    /// Loads the persisted version toggle, sets the button state, updates _wysVersion,
    /// and fires Toggled so the shader controller initialises to the correct state.
    /// </summary>
    private void LoadVersionToggle()
    {
        if (!File.Exists(_versionFile)) return;
        try
        {
            bool isV2_12 = File.ReadAllText(_versionFile).Trim() == "v2_12";
            if (!isV2_12) return; // V1_42 is already the default, nothing to do
            _wysVersion = WYSGameVersion.V2_12;
            // SetPressedNoSignal flips the visual without triggering Toggled (avoids re-saving).
            // Then we emit Toggled manually so the shader controller also gets notified.
            _versionToggle.SetPressedNoSignal(true);
            _versionToggle.Text = "v2.12";
            _versionToggle.EmitSignal(CheckButton.SignalName.Toggled, Variant.From(true));
        }
        catch (Exception ex) { GD.PrintErr($"[Main] Failed to load version toggle: {ex.Message}"); }
    }

    // ── Thread-safe UI helpers ────────────────────────────────────────────────

    private void SetStatus(string text) =>
        Callable.From(() => SetStatusDirect(text)).CallDeferred();

    private void SetStatusDirect(string text) => _statusLabel.Text = text;

    /// <summary>Shows the SetupPanel with initial state (only during InitialSetup).</summary>
    private void ShowSetupPanel(string text, double pct) =>
        Callable.From(() => {
            _setupPanel.Visible = true;
            _setupLabel.Text = text;
            _setupProgress.Value = pct;
        }).CallDeferred();

    /// <summary>Shows the SetupPanel for any in-progress operation (sandbox download, patching, etc.).</summary>
    private void ShowProgress(string text, double pct = 0) =>
        Callable.From(() => {
            _setupPanel.Visible = true;
            _setupLabel.Text = text;
            _setupProgress.Value = pct;
        }).CallDeferred();

    /// <summary>Updates the SetupPanel label and optionally the progress bar (pct &lt; 0 = no change).</summary>
    private void SetSetupStatus(string text, double pct) =>
        Callable.From(() => {
            _setupLabel.Text = text;
            if (pct >= 0) _setupProgress.Value = pct;
        }).CallDeferred();

    /// <summary>Hides the SetupPanel without changing _setupDone.</summary>
    private void HideProgress() =>
        Callable.From(() => _setupPanel.Visible = false).CallDeferred();

    /// <summary>Called once after initial tool downloads complete.</summary>
    private void HideSetupPanel()
    {
        _setupPanel.Visible = false;
        _setupDone = true;
        _refreshBtn.Disabled = false;
        _releasesPlaceholder?.QueueFree();
        _releasesPlaceholder = null;
        LoadAndDisplayLocalVersions();
    }

    private void ShowError(string title, string detail) =>
        Callable.From(() => {
            _errorDialog.Title = title;

            // AcceptDialog.DialogText forces a single line; use a RichTextLabel child instead
            // so long messages wrap properly and the dialog auto-sizes vertically.
            var rtl = _errorDialog.GetNodeOrNull<RichTextLabel>("ErrorRTL");
            if (rtl == null)
            {
                rtl = new RichTextLabel
                {
                    Name = "ErrorRTL",
                    BbcodeEnabled = false,
                    FitContent = true,
                    AutowrapMode = TextServer.AutowrapMode.WordSmart,
                    CustomMinimumSize = new Vector2(400, 0),
                };
                // Ensure dialog is wide enough for the label
                _errorDialog.AddChild(rtl);
            }
            rtl.Text = detail;
            _errorDialog.DialogText = ""; // clear built-in single-line area
            _errorDialog.PopupCentered();
        }).CallDeferred();

    private async Task RunSafe(Func<Task> fn, string opName)
    {
        try { await fn(); }
        catch (OperationCanceledException) { /* user cancelled — no dialog */ }
        catch (Exception ex) { ShowError($"{opName} failed", ex.Message); }
    }
}

// ─────────────────────────────────────────────
//  VersionTagComparer  (descending semver sort)
// ─────────────────────────────────────────────

public sealed class VersionTagComparer : IComparer<string>
{
    public static readonly VersionTagComparer Instance = new();

    private static Version? TryParse(string tag)
    {
        // strip non-digit prefix (e.g. "v", "WYS Race Mod v")
        string s = tag.TrimStart();
        int digitStart = 0;
        while (digitStart < s.Length && !char.IsDigit(s[digitStart])) digitStart++;
        s = s[digitStart..];
        // cut at first space (e.g. "1.2.3 beta")
        int spaceIdx = s.IndexOf(' ');
        if (spaceIdx >= 0) s = s[..spaceIdx];
        return Version.TryParse(s, out var v) ? v : null;
    }

    public int Compare(string? x, string? y)
    {
        var vx = TryParse(x ?? "");
        var vy = TryParse(y ?? "");
        if (vx != null && vy != null) return vy.CompareTo(vx); // descending
        return string.Compare(y, x, StringComparison.OrdinalIgnoreCase);
    }
}

// ─────────────────────────────────────────────
//  ReleaseAsset / Release / DownloadProgress
// ─────────────────────────────────────────────

public class ReleaseAsset
{
    [JsonPropertyName("id")] public long Id { get; init; }
    [JsonPropertyName("name")] public string Name { get; init; } = "";
    [JsonPropertyName("label")] public string? Label { get; init; }
    [JsonPropertyName("content_type")] public string ContentType { get; init; } = "";
    [JsonPropertyName("size")] public long Size { get; init; }
    [JsonPropertyName("download_count")] public int DownloadCount { get; init; }
    [JsonPropertyName("browser_download_url")] public string DownloadUrl { get; init; } = "";
    [JsonPropertyName("created_at")] public DateTimeOffset CreatedAt { get; init; }
    [JsonPropertyName("updated_at")] public DateTimeOffset UpdatedAt { get; init; }

    public string FormattedSize => Size switch
    {
        >= 1_073_741_824 => $"{Size / 1_073_741_824.0:F1} GB",
        >= 1_048_576 => $"{Size / 1_048_576.0:F1} MB",
        >= 1_024 => $"{Size / 1_024.0:F1} KB",
        _ => $"{Size} B"
    };

    public override string ToString() => $"{Name} ({FormattedSize})";
}

public class Release
{
    [JsonPropertyName("id")] public long Id { get; init; }
    [JsonPropertyName("tag_name")] public string TagName { get; init; } = "";
    [JsonPropertyName("name")] public string Name { get; init; } = "";
    [JsonPropertyName("body")] public string? Body { get; init; }
    [JsonPropertyName("draft")] public bool IsDraft { get; init; }
    [JsonPropertyName("prerelease")] public bool IsPreRelease { get; init; }
    [JsonPropertyName("created_at")] public DateTimeOffset CreatedAt { get; init; }
    [JsonPropertyName("published_at")] public DateTimeOffset? PublishedAt { get; init; }
    [JsonPropertyName("html_url")] public string HtmlUrl { get; init; } = "";
    [JsonPropertyName("zipball_url")] public string ZipballUrl { get; init; } = "";
    [JsonPropertyName("tarball_url")] public string TarballUrl { get; init; } = "";
    [JsonPropertyName("assets")] public List<ReleaseAsset> Assets { get; init; } = [];
}

public sealed class DownloadProgress
{
    public long BytesReceived { get; init; }
    public long? TotalBytes { get; init; }
    public double? Percentage => TotalBytes > 0 ? (double)BytesReceived / TotalBytes * 100 : null;

    public override string ToString() =>
        Percentage.HasValue
            ? $"{Percentage:F1}%  ({BytesReceived:N0} / {TotalBytes:N0} bytes)"
            : $"{BytesReceived:N0} bytes received";
}

// ─────────────────────────────────────────────
//  GitHubReleaseManager
// ─────────────────────────────────────────────

public sealed class GitHubReleaseManager : IDisposable
{
    private const string ApiBase = "https://api.github.com";
    private const string AcceptHeader = "application/vnd.github+json";
    private const string ApiVersionHeader = "2022-11-28";
    private const int BufferSize = 81_920;

    private readonly System.Net.Http.HttpClient _http;
    private readonly string _owner, _repo;

    public GitHubReleaseManager(string owner, string repo, string? pat = null)
    {
        _owner = owner; _repo = repo;
        _http = new System.Net.Http.HttpClient();
        _http.DefaultRequestHeaders.UserAgent.ParseAdd("GitHubReleaseManager/1.0");
        _http.DefaultRequestHeaders.Accept.ParseAdd(AcceptHeader);
        _http.DefaultRequestHeaders.Add("X-GitHub-Api-Version", ApiVersionHeader);
        if (!string.IsNullOrWhiteSpace(pat))
            _http.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", pat);
    }

    public async Task<List<Release>> GetReleasesAsync(int perPage = 30, int page = 1)
    {
        string url = $"{ApiBase}/repos/{_owner}/{_repo}/releases?per_page={perPage}&page={page}";
        string json = await FetchJsonAsync(url).ConfigureAwait(false);
        return JsonSerializer.Deserialize<List<Release>>(json)
               ?? throw new InvalidOperationException("Null response from GitHub API.");
    }

    public async Task<IReadOnlyList<string>> DownloadAsync(
        Release release, string directory, bool overwrite = false,
        Action<ReleaseAsset, DownloadProgress>? onProgress = null)
    {
        ArgumentNullException.ThrowIfNull(release);
        Directory.CreateDirectory(directory);
        if (release.Assets.Count == 0) return [];

        var written = new List<string>();
        foreach (var asset in release.Assets)
        {
            string dest = Path.Combine(directory, asset.Name);
            if (!overwrite && File.Exists(dest)) continue;
            await DownloadToPathAsync(asset, dest, onProgress).ConfigureAwait(false);
            written.Add(dest);
        }
        return written;
    }

    public async Task<string> DownloadAssetAsync(
        ReleaseAsset asset, string directory,
        Action<ReleaseAsset, DownloadProgress>? onProgress = null)
    {
        Directory.CreateDirectory(directory);
        string dest = Path.Combine(directory, asset.Name);
        await DownloadToPathAsync(asset, dest, onProgress).ConfigureAwait(false);
        return dest;
    }

    private async Task DownloadToPathAsync(ReleaseAsset asset, string dest,
        Action<ReleaseAsset, DownloadProgress>? onProgress)
    {
        GD.Print($"[GitHub] Downloading '{asset.Name}'…");
        using var resp = await _http
            .GetAsync(asset.DownloadUrl, HttpCompletionOption.ResponseHeadersRead)
            .ConfigureAwait(false);
        resp.EnsureSuccessStatusCode();
        long? total = resp.Content.Headers.ContentLength;

        await using var src = await resp.Content.ReadAsStreamAsync().ConfigureAwait(false);
        await using var dst = new FileStream(dest, FileMode.Create,
            System.IO.FileAccess.Write, FileShare.None, BufferSize, useAsync: true);

        var buf = new byte[BufferSize]; long received = 0; int read;
        while ((read = await src.ReadAsync(buf).ConfigureAwait(false)) > 0)
        {
            await dst.WriteAsync(buf.AsMemory(0, read)).ConfigureAwait(false);
            received += read;
            onProgress?.Invoke(asset, new DownloadProgress { BytesReceived = received, TotalBytes = total });
        }
        GD.Print($"[GitHub] Saved '{asset.Name}' → {dest}");
    }

    private async Task<string> FetchJsonAsync(string url)
    {
        using var resp = await _http.GetAsync(url).ConfigureAwait(false);
        if (!resp.IsSuccessStatusCode)
        {
            string body = await resp.Content.ReadAsStringAsync().ConfigureAwait(false);
            throw new HttpRequestException($"GitHub API {(int)resp.StatusCode} for {url}: {body}");
        }
        return await resp.Content.ReadAsStringAsync().ConfigureAwait(false);
    }

    public void Dispose() => _http.Dispose();
}

// ─────────────────────────────────────────────
//  XDeltaPatcher / XDeltaException
// ─────────────────────────────────────────────

public sealed class XDeltaPatcher
{
    public string XDeltaBinaryPath { get; set; } = "xdelta3";
    public bool Overwrite { get; set; } = false;

    public string ApplyPatch(string src, string patch, string outDir)
    {
        ValidateInputs(src, patch, outDir);
        string outPath = BuildOutputPath(patch, outDir);
        GuardOverwrite(outPath);
        Directory.CreateDirectory(outDir);
        return RunAndHandle(src, patch, outPath);
    }

    public Task<string> ApplyPatchAsync(string src, string patch, string outDir)
        => Task.Run(() => ApplyPatch(src, patch, outDir));

    public string ApplyPatchToFile(string src, string patch, string outFile)
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(outFile);
        ValidateInputs(src, patch, Path.GetDirectoryName(outFile) ?? ".");
        GuardOverwrite(outFile);
        Directory.CreateDirectory(Path.GetDirectoryName(outFile)!);
        return RunAndHandle(src, patch, outFile);
    }

    public Task<string> ApplyPatchToFileAsync(string src, string patch, string outFile)
        => Task.Run(() => ApplyPatchToFile(src, patch, outFile));

    private string RunAndHandle(string src, string patch, string outFile)
    {
        GD.Print($"[XDelta] {src} + {patch} → {outFile}");
        var r = RunXDelta(src, patch, outFile);
        if (!string.IsNullOrWhiteSpace(r.Stdout)) GD.Print($"[XDelta] {r.Stdout.Trim()}");
        if (r.ExitCode == 0) { GD.Print($"[XDelta] OK → {outFile}"); return outFile; }
        if (File.Exists(outFile)) File.Delete(outFile);
        throw new XDeltaException($"xdelta3 exited {r.ExitCode}: {(string.IsNullOrWhiteSpace(r.Stderr) ? "no detail" : r.Stderr.Trim())}");
    }

    private static string BuildOutputPath(string patch, string outDir)
    {
        string file = Path.GetFileName(patch);
        string name = Path.GetExtension(file).ToLowerInvariant() is ".xdelta" or ".vcdiff" or ".xd3"
            ? Path.GetFileNameWithoutExtension(file)
            : file + ".patched";
        return Path.Combine(outDir, name);
    }

    private ProcessResult RunXDelta(string src, string patch, string outFile)
    {
        using var p = new Process
        {
            StartInfo = new ProcessStartInfo
            {
                FileName = XDeltaBinaryPath,
                Arguments = $"-f -d -s \"{src}\" \"{patch}\" \"{outFile}\"",
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                UseShellExecute = false,
                CreateNoWindow = true,
            }
        };
        p.Start();
        string stdout = p.StandardOutput.ReadToEnd();
        string stderr = p.StandardError.ReadToEnd();
        p.WaitForExit();
        return new ProcessResult(p.ExitCode, stdout, stderr);
    }

    private static void ValidateInputs(string src, string patch, string outDir)
    {
        if (!File.Exists(src)) throw new FileNotFoundException($"Source not found: {src}", src);
        if (!File.Exists(patch)) throw new FileNotFoundException($"Patch not found: {patch}", patch);
        ArgumentException.ThrowIfNullOrWhiteSpace(outDir);
    }

    private void GuardOverwrite(string outPath)
    {
        if (!Overwrite && File.Exists(outPath))
            throw new IOException($"Output already exists: {outPath}. Set Overwrite = true.");
    }

    private readonly record struct ProcessResult(int ExitCode, string Stdout, string Stderr);
}

public sealed class XDeltaException : Exception
{
    public XDeltaException(string message) : base(message) { }
}

// ─────────────────────────────────────────────
//  FileHelper
// ─────────────────────────────────────────────

public static class FileHelper
{
    public static void CopyFile(string src, string dst, bool overwrite = false)
    {
        if (!File.Exists(src)) throw new FileNotFoundException($"Source not found: {src}", src);
        Directory.CreateDirectory(Path.GetDirectoryName(dst)!);
        File.Copy(src, dst, overwrite);
    }

    public static void RenameFile(string src, string dst, bool overwrite = false)
    {
        if (!File.Exists(src)) throw new FileNotFoundException($"File to rename not found: {src}", src);
        if (!overwrite && File.Exists(dst)) throw new IOException($"Destination already exists: {dst}");
        Directory.CreateDirectory(Path.GetDirectoryName(dst)!);
        File.Move(src, dst, overwrite);
    }

    public static void Unzip(string zip, string destDir, bool overwrite = false)
    {
        if (!File.Exists(zip)) throw new FileNotFoundException($"ZIP not found: {zip}", zip);
        Directory.CreateDirectory(destDir);
        using var archive = ZipFile.OpenRead(zip);

        string destRoot = Path.GetFullPath(destDir)
            .TrimEnd(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar)
            + Path.DirectorySeparatorChar;

        GD.Print($"[FileHelper] Unzip archive  : '{zip}'");
        GD.Print($"[FileHelper] Unzip destRoot : '{destRoot}'");

        int extracted = 0;
        foreach (var entry in archive.Entries)
        {
            if (string.IsNullOrEmpty(entry.Name)) continue;
            string destPath = Path.GetFullPath(Path.Combine(destRoot, entry.FullName));

            GD.Print($"[FileHelper] Unzip entry '{entry.FullName}' -> '{destPath}'");

            if (!destPath.StartsWith(destRoot, StringComparison.OrdinalIgnoreCase))
            {
                GD.PrintErr($"[FileHelper] BLOCKED unsafe entry '{entry.FullName}'");
                throw new InvalidOperationException($"Unsafe ZIP entry: {entry.FullName}");
            }
            Directory.CreateDirectory(Path.GetDirectoryName(destPath)!);
            if (!overwrite && File.Exists(destPath)) continue;
            entry.ExtractToFile(destPath, overwrite);
            extracted++;
        }
        GD.Print($"[FileHelper] Unzip complete — {extracted} file(s) -> '{destRoot}'");
    }

    public static Task CopyFileAsync(string src, string dst, bool overwrite = false) => Task.Run(() => CopyFile(src, dst, overwrite));
    public static Task RenameFileAsync(string src, string dst, bool overwrite = false) => Task.Run(() => RenameFile(src, dst, overwrite));
    public static Task UnzipAsync(string zip, string dir, bool overwrite = false) => Task.Run(() => Unzip(zip, dir, overwrite));
}

// ─────────────────────────────────────────────
//  DepotDownloader
// ─────────────────────────────────────────────

public sealed class DepotDownloader
{
    private readonly string _exePath;
    private volatile Process? _currentProcess;

    public DepotDownloader(string exePath)
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(exePath);
        if (!File.Exists(exePath))
            throw new FileNotFoundException($"DepotDownloader not found: {exePath}", exePath);
        _exePath = exePath;
    }

    public void Kill()
    {
        try { _currentProcess?.Kill(entireProcessTree: true); }
        catch { /* already exited */ }
    }

    public int Run(
        string arguments,
        Action<string>? onOutput = null,
        Action<string>? onError = null,
        Func<string, string>? onInputRequired = null)
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(arguments);

        int pwIdx = arguments.IndexOf("-password ", StringComparison.OrdinalIgnoreCase);
        string safeArgs = arguments;
        if (pwIdx >= 0)
        {
            int valStart = pwIdx + "-password ".Length;
            int valEnd = arguments.IndexOf(' ', valStart);
            safeArgs = arguments[..valStart] + "[REDACTED]" + (valEnd >= 0 ? arguments[valEnd..] : "");
        }
        GD.Print($"[DepotDownloader] {_exePath} {safeArgs}");

        string workDir = Path.GetDirectoryName(Path.GetFullPath(_exePath)) ?? ".";
        bool needsInput = onInputRequired != null;

        using var process = new Process
        {
            StartInfo = new ProcessStartInfo
            {
                FileName = _exePath,
                Arguments = arguments,
                WorkingDirectory = workDir,
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                RedirectStandardInput = needsInput,
                UseShellExecute = false,
                CreateNoWindow = true,
            }
        };

        var stdoutThread = new Thread(() =>
        {
            var buf = new System.Text.StringBuilder();
            int ch;
            while ((ch = process.StandardOutput.Read()) != -1)
            {
                char c = (char)ch;
                if (c == '\r') continue;
                if (c == '\n')
                {
                    string line = buf.ToString();
                    if (line.Length > 0) { GD.Print($"[DepotDownloader] {line}"); onOutput?.Invoke(line); }
                    buf.Clear();
                }
                else
                {
                    buf.Append(c);
                    string partial = buf.ToString();
                    if (needsInput && IsInputPrompt(partial) && onInputRequired != null)
                    {
                        GD.Print($"[DepotDownloader] Auth prompt (stdout): '{partial}'");
                        onOutput?.Invoke(partial);
                        string code = onInputRequired(partial);
                        process.StandardInput.WriteLine(code); process.StandardInput.Flush();
                        buf.Clear();
                    }
                }
            }
            if (buf.Length > 0) { string t = buf.ToString(); GD.Print($"[DepotDownloader] {t}"); onOutput?.Invoke(t); }
        });
        stdoutThread.IsBackground = true;

        var stderrThread = new Thread(() =>
        {
            var buf = new System.Text.StringBuilder();
            int ch;
            while ((ch = process.StandardError.Read()) != -1)
            {
                char c = (char)ch;
                if (c == '\r') continue;
                if (c == '\n')
                {
                    string line = buf.ToString();
                    if (line.Length > 0) { GD.Print($"[DepotDownloader] ERR: {line}"); onError?.Invoke(line); }
                    buf.Clear();
                }
                else
                {
                    buf.Append(c);
                    string partial = buf.ToString();
                    if (needsInput && IsInputPrompt(partial) && onInputRequired != null)
                    {
                        GD.Print($"[DepotDownloader] Auth prompt (stderr): '{partial}'");
                        onError?.Invoke(partial);
                        string code = onInputRequired(partial);
                        process.StandardInput.WriteLine(code); process.StandardInput.Flush();
                        buf.Clear();
                    }
                }
            }
            if (buf.Length > 0) { string t = buf.ToString(); GD.Print($"[DepotDownloader] ERR: {t}"); onError?.Invoke(t); }
        });
        stderrThread.IsBackground = true;

        _currentProcess = process;
        process.Start();
        stdoutThread.Start();
        stderrThread.Start();
        process.WaitForExit();
        stdoutThread.Join(TimeSpan.FromSeconds(5));
        stderrThread.Join(TimeSpan.FromSeconds(5));
        _currentProcess = null;

        GD.Print($"[DepotDownloader] Exited with code {process.ExitCode}");
        return process.ExitCode;
    }

    public Task<int> RunAsync(
        string arguments,
        Action<string>? onOutput = null,
        Action<string>? onError = null,
        Func<string, string>? onInputRequired = null)
        => Task.Run(() => Run(arguments, onOutput, onError, onInputRequired));

    private static bool IsInputPrompt(string line)
    {
        string t = line.TrimEnd();
        if (!t.EndsWith(':') && !t.EndsWith(": ")) return false;
        return line.Contains("auth code", StringComparison.OrdinalIgnoreCase)
            || line.Contains("Steam Guard", StringComparison.OrdinalIgnoreCase)
            || line.Contains("two factor", StringComparison.OrdinalIgnoreCase)
            || line.Contains("2-factor", StringComparison.OrdinalIgnoreCase)
            || line.Contains("Please enter", StringComparison.OrdinalIgnoreCase);
    }
}