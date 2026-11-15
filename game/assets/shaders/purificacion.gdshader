shader_type canvas_item;
// Purificación visual (RF-04): desatura lo que hay detrás.
// saturation = 0 → zona contaminada (gris); 1 → colores originales.

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;
uniform float saturation : hint_range(0.0, 1.0) = 0.0;
// Tono del estado contaminado (gris ligeramente verdoso y oscuro).
uniform vec3 polluted_tint = vec3(0.82, 0.84, 0.78);

void fragment() {
	vec3 color = texture(screen_texture, SCREEN_UV).rgb;
	float luma = dot(color, vec3(0.299, 0.587, 0.114));
	vec3 polluted = vec3(luma) * polluted_tint;
	COLOR = vec4(mix(polluted, color, saturation), 1.0);
}
