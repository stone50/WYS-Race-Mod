using Godot;

// ─────────────────────────────────────────────
//  VersionShaderController
// ─────────────────────────────────────────────

public partial class VersionShaderController : Node
{
    [Export] public TextureRect? BackgroundRect { get; set; }

    private ShaderMaterial? _mat;
    private Tween?          _tween;
    private float           _currentBlend = 0f;
    private double          _time         = 0.0;

    [Export] public Color TintA { get; set; } = new Color(0.72f, 0.44f, 0.18f);
    [Export] public Color TintB { get; set; } = new Color(0.18f, 0.44f, 0.72f);

    /// <summary>Duration of the blend transition in seconds.</summary>
    [Export] public float TransitionDuration { get; set; } = 0.65f;

    public void Init(CheckButton versionToggle)
    {
        if (BackgroundRect == null)
        {
            GD.PrintErr("[VersionShaderController] BackgroundRect not assigned.");
            return;
        }

        _mat = BackgroundRect.Material as ShaderMaterial;
        if (_mat == null)
        {
            GD.PrintErr("[VersionShaderController] BackgroundRect has no ShaderMaterial.");
            return;
        }

        // Push initial colours to shader
        _mat.SetShaderParameter("tint_a", TintA);
        _mat.SetShaderParameter("tint_b", TintB);
        _mat.SetShaderParameter("blend",  0f);

        versionToggle.Toggled += on => AnimateTo(on ? 1f : 0f);
    }

    public override void _Process(double delta)
    {
        if (_mat == null) return;
        _time += delta;
        _mat.SetShaderParameter("time", (float)_time);
    }

    // ── Private ───────────────────────────────────────────────────────────────

    private void AnimateTo(float target)
    {
        _tween?.Kill();
        _tween = CreateTween();
        _tween.SetEase(Tween.EaseType.InOut);
        _tween.SetTrans(Tween.TransitionType.Cubic);

        _tween
            .TweenMethod(
                Callable.From((float v) => {
                    _currentBlend = v;
                    _mat?.SetShaderParameter("blend", v);
                }),
                _currentBlend,
                target,
                TransitionDuration
            );
    }
}
