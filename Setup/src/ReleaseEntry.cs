using Godot;

public partial class ReleaseEntry : PanelContainer
{
    [Signal] public delegate void DownloadRequestedEventHandler(string releaseName);
    [Signal] public delegate void PlayRequestedEventHandler(string releaseName);
    [Signal] public delegate void RemoveRequestedEventHandler(string releaseName);

    private Label  _nameLabel   = null!;
    private Label  _tagLabel    = null!;
    private Label  _statusLabel = null!;
    private Button _downloadBtn = null!;
    private Button _playBtn     = null!;
    private Button _removeBtn   = null!;

    private string _releaseName = "";

    public bool IsDownloading       { get; private set; }
    public bool IsMarkedAsDownloaded { get; private set; }

    public override void _Ready()
    {
        _nameLabel   = GetNode<Label>("%NameLabel");
        _tagLabel    = GetNode<Label>("%TagLabel");
        _statusLabel = GetNode<Label>("%StatusLabel");
        _downloadBtn = GetNode<Button>("%DownloadBtn");
        _playBtn     = GetNode<Button>("%PlayBtn");
        _removeBtn   = GetNode<Button>("%RemoveBtn");

        _downloadBtn.Pressed += () => EmitSignal(SignalName.DownloadRequested, _releaseName);
        _playBtn.Pressed     += () => EmitSignal(SignalName.PlayRequested,     _releaseName);
        _removeBtn.Pressed   += () => EmitSignal(SignalName.RemoveRequested,   _releaseName);
    }

    // ── Public API ────────────────────────────────────────────────────────────

    public void Setup(Release release, bool isDownloaded)
    {
        _releaseName    = release.Name;
        _nameLabel.Text = release.Name;
        _tagLabel.Text  = release.TagName;
        SetDownloadedState(isDownloaded);
    }

    /// <summary>Switches between downloaded (Play + Remove) and not-downloaded (Download) state.</summary>
    public void SetDownloadedState(bool downloaded)
    {
        if (IsDownloading) return; // don't clobber in-progress state
        IsMarkedAsDownloaded = downloaded;

        _downloadBtn.Visible  = !downloaded;
        _downloadBtn.Disabled = false;
        _downloadBtn.Text     = "Download";
        _playBtn.Visible      =  downloaded;
        _removeBtn.Visible    =  downloaded;

        _statusLabel.Text = downloaded ? "✓  Ready" : "Not downloaded";
        _statusLabel.AddThemeColorOverride("font_color",
            downloaded
                ? new Color(0.4f, 0.9f, 0.4f)
                : new Color(0.65f, 0.65f, 0.65f));
    }

    /// <summary>Shows the "Queued" state while this version waits in the download queue.</summary>
    public void SetQueued(bool queued)
    {
        if (queued)
        {
            _downloadBtn.Visible  = true;
            _downloadBtn.Disabled = true;
            _downloadBtn.Text     = "Queued…";
            _playBtn.Visible      = false;
            _removeBtn.Visible    = false;
            _statusLabel.Text     = "⏳  Queued";
            _statusLabel.AddThemeColorOverride("font_color", new Color(0.85f, 0.75f, 0.35f));
        }
        else
        {
            SetDownloadedState(IsVersionDownloadedOnDisk());
        }
    }

    /// <summary>Marks this entry as actively downloading (disables button, updates label).</summary>
    public void SetDownloading(bool downloading)
    {
        IsDownloading = downloading;

        if (downloading)
        {
            _downloadBtn.Visible  = true;
            _downloadBtn.Disabled = true;
            _downloadBtn.Text     = "Downloading…";
            _playBtn.Visible      = false;
            _removeBtn.Visible    = false;
            _statusLabel.Text     = "⏳  Downloading…";
            _statusLabel.AddThemeColorOverride("font_color", new Color(0.55f, 0.75f, 1.0f));
        }
        else
        {
            SetDownloadedState(IsVersionDownloadedOnDisk());
        }
    }

    // ── Private ───────────────────────────────────────────────────────────────

    /// <summary>Checks disk so state resets correctly after download/remove without a full rebuild.</summary>
    private bool IsVersionDownloadedOnDisk()
    {
        string root = OS.GetUserDataDir() + "/versions/" + _releaseName + "/";
        return Godot.FileAccess.FileExists(root + "v1_42/data.win")
            && Godot.FileAccess.FileExists(root + "v2_12/data.win");
    }
}
