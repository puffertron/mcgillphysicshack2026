shader_type spatial;

uniform float pressure_vis;
uniform float temperature_vis;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = vec3(pressure_vis/10.0, temperature_vis/100.0, 0);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
