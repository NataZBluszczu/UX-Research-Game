shader_type canvas_item;
render_mode blend_add;

uniform sampler2D uv_mask;
uniform vec2 uv_light_global_pos;
uniform vec2 uv_light_size;
uniform bool uv_visible = false;

void fragment() {
	if (!uv_visible) {
        discard;
    }
    vec4 fingerprint = texture(TEXTURE, UV);
    
    if (fingerprint.a < 0.1) {
        discard;
    }
    
    vec2 frag_pos = FRAGCOORD.xy;
    vec2 offset = frag_pos - uv_light_global_pos;
    
    float max_size = max(uv_light_size.x, uv_light_size.y);
    vec2 aspect_ratio = uv_light_size / max_size;
    vec2 mask_uv = (offset / max_size) / aspect_ratio + vec2(0.5, 0.5);
    
    if (mask_uv.x < 0.0 || mask_uv.x > 1.0 || 
        mask_uv.y < 0.0 || mask_uv.y > 1.0) {
        discard;
    }
    
    float mask_alpha = texture(uv_mask, mask_uv).a;
    
    // === EKSTREMALNIE JASNY CYJAN ===
    // Bez uniformów - na sztywno zakodowany
    vec3 glow_color = vec3(0.5, 1.5, 2.0);  // Cyjan z wartościami > 1.0
    
    // === PEŁNA ALFA ===
    COLOR = vec4(glow_color, mask_alpha);
}
