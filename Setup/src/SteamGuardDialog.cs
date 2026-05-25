using Godot;

// ─────────────────────────────────────────────
//  SteamGuardDialog
// ─────────────────────────────────────────────

/// <summary>
/// A modal window that asks for a Steam Guard auth code.
/// Shown whenever DepotDownloader detects a Steam Guard prompt in its output.
/// Emits <see cref="CodeSubmitted"/> when the user confirms.
/// </summary>
public partial class SteamGuardDialog : Window
{
    [Signal] public delegate void CodeSubmittedEventHandler(string code);

    private Label    _promptLabel = null!;
    private LineEdit _codeEdit    = null!;
    private Label    _errorLabel  = null!;
    private Button   _confirmBtn  = null!;

    public override void _Ready()
    {
        _promptLabel = GetNode<Label>("%PromptLabel");
        _codeEdit    = GetNode<LineEdit>("%CodeEdit");
        _errorLabel  = GetNode<Label>("%ErrorLabel");
        _confirmBtn  = GetNode<Button>("%ConfirmBtn");

        _confirmBtn.Pressed          += OnConfirm;
        _codeEdit.TextSubmitted      += _ => OnConfirm();
        CloseRequested               += Hide;
    }

    // ── Public API ────────────────────────────────────────────────────────────

    /// <summary>
    /// Sets the prompt text (passed from DepotDownloader's output) and shows the window.
    /// </summary>
    public void ShowForPrompt(string prompt)
    {
        _promptLabel.Text = prompt;
        _codeEdit.Text    = "";
        _errorLabel.Text  = "";
        Show();
        _codeEdit.GrabFocus();
    }

    // ── Private ───────────────────────────────────────────────────────────────

    private void OnConfirm()
    {
        string code = _codeEdit.Text.Trim();
        if (string.IsNullOrEmpty(code))
        {
            _errorLabel.Text = "Please enter the auth code.";
            return;
        }
        EmitSignal(SignalName.CodeSubmitted, code);
        Hide();
    }
}
