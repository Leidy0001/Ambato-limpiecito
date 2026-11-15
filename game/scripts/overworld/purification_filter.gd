class_name PurificationFilter
extends CanvasLayer
## Filtro a pantalla completa que pinta la zona en gris hasta purificarla (RF-04).
## Va por encima del mundo y por debajo de la UI, así los diálogos conservan su color.

@onready var _rect: ColorRect = $Rect
@onready var _material: ShaderMaterial = _rect.material as ShaderMaterial


func set_purified(purified: bool) -> void:
	_set_saturation(1.0 if purified else 0.0)


## Transición animada de gris a colores vivos.
func purify(duration: float = 2.0) -> void:
	_rect.visible = true
	var tw := create_tween()
	tw.tween_method(_set_saturation, 0.0, 1.0, duration).set_trans(Tween.TRANS_SINE)
	await tw.finished


func _set_saturation(value: float) -> void:
	_material.set_shader_parameter("saturation", value)
	# Con la zona purificada el filtro no aporta nada: se oculta para ahorrar GPU (RNF-01).
	_rect.visible = value < 1.0
