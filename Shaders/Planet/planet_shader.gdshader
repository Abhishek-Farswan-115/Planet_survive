shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx;

uniform float min_height;
uniform float max_height;

uniform vec4 albedo : source_color = vec4(0.8, 0.8, 0.8, 1.0);
uniform float roughness : hint_range(0,1) = 1.0;
uniform float specular;
uniform float metallic;

uniform sampler2D height_gradient;

varying float height;

void vertex() {
	height = length(VERTEX);
}

void fragment() {
	float t = height / (max_height - min_height) - (min_height / (max_height-min_height));
	vec4 height_gradient_color = texture(height_gradient, vec2(t, 0.0));
	
	ALBEDO = height_gradient_color.rgb;
	//ALBEDO = albedo.rgb;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	SPECULAR = specular;
}
