shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest, repeat_disable;
uniform float pixel_size : hint_range(1.0, 16.0, 1.0) = 1.0;
uniform bool clamp_to_palette = false;
uniform sampler2D palette_texture: hint_default_black;
uniform int palette_size: hint_range(2, 256, 1) = 8;

vec4 clamp_palette (in vec4 albedo){
	float estimation_cutoff = 0.001;
	vec4 closest_color;
	float min_dist = 2.0;
	float n = float(palette_size);

	for (int i = 0; i < palette_size; i++ ){
		float index = 1.000/(2.000*n)+float(i)/n;
		vec4 index_color = texture(palette_texture, vec2(index,0.5));
		float dist = length(index_color.rgb - albedo.rgb);
		if (dist < min_dist) {
			min_dist = dist;
			closest_color = index_color;
			if (min_dist < estimation_cutoff){
				return closest_color;
			}
		}
	}
	return closest_color;
}

vec4 pixel_color(in vec2 pos, in vec2 screen_pixel_size){
	float x = pos.x - mod(pos.x, pixel_size);
	float y = pos.y - mod(pos.y, pixel_size);
	float shift = floor(pixel_size / 2.0);
	return texture(SCREEN_TEXTURE, vec2(x+shift, y+shift) * screen_pixel_size);
}


void fragment() {
	vec4 new_color = pixel_color(vec2(FRAGCOORD.x, FRAGCOORD.y), SCREEN_PIXEL_SIZE);
	if(clamp_to_palette){
		new_color = clamp_palette(new_color);
	}
	COLOR = new_color;
}
