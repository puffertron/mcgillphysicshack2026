shader_type spatial;

uniform vec3 color1:	source_color;
uniform vec3 color2: source_color;

uniform vec3 wind_input_vel;
uniform float wind_noise_intensity = 1;

uniform sampler2D noise;
uniform float noise_scale = 20.0;

varying vec3 world_pos;

void vertex() {

	world_pos= (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	vec3 wind_displace = wind_input_vel * sin(TIME) * 0.2;
	vec3 secondary_displace = wind_input_vel * cos(TIME*1.32)/ 1.87;
	wind_displace *= 0.3;
	secondary_displace *= 0.1;
	vec3 displace = mix(wind_displace, secondary_displace, sin(TIME/0.9 + 16.4));
	VERTEX += mix(displace, vec3(0,0,0), UV.y);
}

void fragment() {
	vec3	 noiselevel = texture(noise, world_pos.xz /noise_scale).rgb;
	ALBEDO =mix(color1, color2, UV.y);
	
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
