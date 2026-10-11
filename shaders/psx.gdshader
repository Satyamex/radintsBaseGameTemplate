shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;

uniform int resolution_x = 320;
uniform int resolution_y = 240;
uniform int color_bit_depth = 4;
uniform float dither_strength = 0.03;

float hash(vec2 p){
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

void fragment(){
	vec2 px = vec2(1.0 / float(resolution_x), 1.0 / float(resolution_y));
	vec2 uv = floor(SCREEN_UV / px) * px + px * 0.5;
	vec3 col = texture(SCREEN_TEXTURE, uv).rgb;
	float levels = pow(2.0, float(color_bit_depth));
	col = floor(col * levels) / levels;
	float noise = hash(SCREEN_UV * 80.0);
	col += (noise - 0.5) * dither_strength;
	COLOR = vec4(col, 1.0);
}