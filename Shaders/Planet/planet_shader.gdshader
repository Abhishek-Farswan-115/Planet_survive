shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx;

uniform float min_height;
uniform float max_height;

uniform float slope_offset: hint_range(0,1) = 0.5;
uniform vec3 slope_albedo: source_color = vec3(0.3, 0.3, 0.3);

uniform vec4 albedo : source_color = vec4(0.8, 0.8, 0.8, 1.0);
uniform float roughness : hint_range(0,1) = 1.0;
uniform float specular;
uniform float metallic;

uniform sampler2D height_gradient;

varying vec3 vertex_pos;
varying vec3 vertex_normal;

void vertex() {
	vertex_pos = VERTEX;
	vertex_normal = NORMAL;
}

void fragment() {
	float height = length(vertex_pos);
	float t = clamp(height / (max_height - min_height) - (min_height / (max_height-min_height)), 0.0, 1.0);
	vec4 height_gradient_color = texture(height_gradient, vec2(t, 0.0));
	
	float slope = 1.0 - dot(abs(normalize(vertex_pos)), abs(vertex_normal));
	slope *= 3.0;
	float slope_mask = smoothstep(slope_offset - 0.1, slope_offset + 0.1, slope);
	
	vec3 fin_mix = mix(height_gradient_color.rgb, slope_albedo, slope_mask);
	
	ALBEDO = fin_mix;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	SPECULAR = specular;
}
