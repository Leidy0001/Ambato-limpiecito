class_name PlaceholderMap
extends TileMapLayer
## Dibuja un mapa provisional a partir de texto mientras no exista el mapa real
## (OSM → Tiled → YATI). Si la capa ya tiene tiles pintados, no hace nada,
## así se puede reemplazar sin tocar este script.
##
## Leyenda: . césped   = camino   # seto (sólido)   ~ agua (sólido)
##          H tejado de la casa (sólido)   * flores

const LEGEND := {
	".": Vector2i(0, 0),
	"=": Vector2i(1, 0),
	"#": Vector2i(2, 0),
	"~": Vector2i(3, 0),
	"H": Vector2i(4, 0),
	"*": Vector2i(5, 0),
}

@export var source_id: int = 0
@export_multiline var layout: String = ""


func _ready() -> void:
	if get_used_cells().is_empty():
		_fill_from_layout()


## Rectángulo del mapa en píxeles, para limitar la cámara.
func get_pixel_bounds() -> Rect2i:
	var cells := get_used_rect()
	var tile := tile_set.tile_size
	return Rect2i(cells.position * tile, cells.size * tile)


func _fill_from_layout() -> void:
	var rows := layout.strip_edges().split("\n")
	for y in rows.size():
		var row := rows[y].strip_edges()
		for x in row.length():
			var symbol := row[x]
			if LEGEND.has(symbol):
				var atlas: Vector2i = LEGEND[symbol]
				set_cell(Vector2i(x, y), source_id, atlas)
			else:
				push_warning("Símbolo desconocido '%s' en (%d, %d)" % [symbol, x, y])
