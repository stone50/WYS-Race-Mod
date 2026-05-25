using Godot;

// ─────────────────────────────────────────────
//  CredentialsDialog
// ─────────────────────────────────────────────

/// <summary>
/// A modal window that asks for Steam username and password.
/// Emits <see cref="CredentialsConfirmed"/> when the user clicks Confirm or presses Enter.
/// Emits <see cref="Cancelled"/> when the user clicks Cancel, closes the window, or presses Escape.
/// </summary>
public partial class CredentialsDialog : Window
{
    [Signal] public delegate void CredentialsConfirmedEventHandler(string username, string password);
    [Signal] public delegate void CancelledEventHandler();

    private LineEdit _userEdit = null!;
    private LineEdit _passEdit = null!;
    private Button _confirmBtn = null!;
    private Button _cancelBtn = null!;
    private Label _errorLabel = null!;

    public override void _Ready()
    {
        _userEdit = GetNode<LineEdit>("%UserEdit");
        _passEdit = GetNode<LineEdit>("%PassEdit");
        _confirmBtn = GetNode<Button>("%ConfirmBtn");
        _cancelBtn = GetNode<Button>("%CancelBtn");
        _errorLabel = GetNode<Label>("%ErrorLabel");

        _confirmBtn.Pressed += OnConfirm;
        _cancelBtn.Pressed += OnCancel;
        CloseRequested += OnCancel;   // X button / Escape

        // Enter in either text field confirms — never cancels
        _userEdit.TextSubmitted += _ => OnConfirm();
        _passEdit.TextSubmitted += _ => OnConfirm();
    }

    // ── Visibility ────────────────────────────────────────────────────────────

    public new void Show()
    {
        _userEdit.Text = "";
        _passEdit.Text = "";
        _errorLabel.Text = "";
        base.Show();
        _userEdit.GrabFocus();
    }

    // ── Private ───────────────────────────────────────────────────────────────

    private void OnConfirm()
    {
        if (string.IsNullOrWhiteSpace(_userEdit.Text))
        {
            _errorLabel.Text = "Username cannot be empty.";
            _userEdit.GrabFocus();
            return;
        }
        if (string.IsNullOrWhiteSpace(_passEdit.Text))
        {
            _errorLabel.Text = "Password cannot be empty.";
            _passEdit.GrabFocus();
            return;
        }

        EmitSignal(SignalName.CredentialsConfirmed, _userEdit.Text.Trim(), _passEdit.Text);
        Hide();
    }

    private void OnCancel()
    {
        EmitSignal(SignalName.Cancelled);
        Hide();
    }
}