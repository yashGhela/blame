shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled;

uniform vec4 albedo: source_color;
uniform sampler2D color_gradient;
uniform sampler2D fresnel_gradient;

float fresnel(float amount, vec3 normal, vec3 view){
	return pow((1.0-clamp(dot(normalize(normal),normalize(view)),0.0,1.0)), amount);
}

void vertex(){
	
}

void fragment() {
	float basic_fresnel = fresnel(4.0, NORMAL, VIEW);

	vec3 fresnel_color = texture(
		fresnel_gradient,
		vec2(basic_fresnel, 0.0)
	).rgb;

	ALBEDO = mix(
		albedo.rgb,
		fresnel_color,
		basic_fresnel * 0.2
	);
}

void light() {
    float NdotL = dot(NORMAL, LIGHT);
    float light_amount = (NdotL * 0.5 + 0.5) * ATTENUATION;
    float toon = smoothstep(0.48, 0.52, light_amount);
    vec3 shadow_color = ALBEDO * 0.4;
    vec3 lit_color = ALBEDO;
    // Use = instead of += if this is your only light function
    DIFFUSE_LIGHT = mix(shadow_color, lit_color, toon) * LIGHT_COLOR * ATTENUATION;
}