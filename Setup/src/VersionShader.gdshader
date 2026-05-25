// Uniforms set by VersionShaderController.cs:
//   tint_a   — colour for V1.42
//   tint_b   — colour for V2.12
//   blend    — 0.0 = full A, 1.0 = full B (animated by controller)
//   time     — OS time passed through for ripple

shader_type canvas_item;

uniform vec4  tint_a   : source_color = vec4(0.72, 0.44, 0.18, 1.0); // warm amber
uniform vec4  tint_b   : source_color = vec4(0.18, 0.44, 0.72, 1.0); // cool steel blue
uniform float blend    : hint_range(0.0, 1.0) = 0.0;
uniform float time     = 0.0;

// ── Helper: smooth diagonal wipe edge ────────────────────────────────────────
float wipe_edge(vec2 uv, float t)
{
    // Diagonal line from top-left to bottom-right
    float diag = (uv.x + uv.y) * 0.5;
    // Soft edge width
    float edge = 0.12;
    return smoothstep(t - edge, t + edge, diag);
}

// ── Helper: subtle ripple on the wipe edge ────────────────────────────────────
float ripple(vec2 uv, float t)
{
    float diag     = (uv.x + uv.y) * 0.5;
    float dist     = diag - t;
    float wave     = sin(dist * 40.0 - time * 6.0) * 0.012;
    float envelope = exp(-abs(dist) * 18.0); // fade away from edge
    return wave * envelope;
}

void fragment()
{
    vec4 tex = texture(TEXTURE, UV);

    // Wipe position includes a ripple offset on the leading edge
    float r    = ripple(UV, blend);
    float mask = wipe_edge(UV, blend + r);

    vec4 tint  = mix(tint_a, tint_b, mask);

    // Multiply-blend the tint over the texture so the image still shows through
    COLOR = vec4(tex.rgb * tint.rgb * 2.2, tex.a);
}
