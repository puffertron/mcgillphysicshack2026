shader_type spatial;

uniform vec3 color1:	source_color;
uniform vec3 color2: source_color;

uniform sampler2D noise;
uniform float noise_scale = 20.0;

varying vec3 world_pos;

void vertex() {
	world_pos= (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	vec3	 noiselevel = texture(noise, world_pos.xz /noise_scale).rgb;
	ALBEDO =mix(color1, color2, UV.y);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
