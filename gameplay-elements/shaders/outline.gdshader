shader_type spatial;
render_mode unshaded, cull_front, depth_draw_always, fog_disabled;

uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float outline_width = 2.0;

void vertex() {
    vec4 clip_pos = PROJECTION_MATRIX * MODELVIEW_MATRIX * vec4(VERTEX, 1.0);
    vec3 clip_normal = mat3(PROJECTION_MATRIX) * mat3(MODELVIEW_MATRIX) * NORMAL;
    vec2 offset = normalize(clip_normal.xy);
    offset /= VIEWPORT_SIZE;
    clip_pos.xy += offset * outline_width * clip_pos.w;
    POSITION = clip_pos;
}

void fragment() {
    ALBEDO = outline_color.rgb;
    // No depth test write tricks needed — cull_front handles it
}