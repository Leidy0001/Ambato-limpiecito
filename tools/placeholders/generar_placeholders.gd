extends SceneTree
## Genera los sprites y el tileset PLACEHOLDER del vertical slice (Zona 1).
##
## Son figuras de colores hechas por código para poder probar el juego antes de
## tener el pixel art definitivo. Reemplazar por arte real (ver CREDITS.md).
##
## Uso (desde la raíz del repo):
##   godot --headless --path game --script <ruta-absoluta>/tools/placeholders/generar_placeholders.gd

const OUT_SPRITES := "res://assets/sprites/placeholder/"
const OUT_TILESET := "res://assets/tilesets/"

# Paleta base (colores vivos: la zona se ve en gris hasta purificarla).
const SKIN := Color("f1c27d")
const HAIR := Color("4a2c17")
const SHIRT := Color("2e9e57")
const PANTS := Color("2b3a67")
const SHOE := Color("1b1b1b")
const EYE := Color("111111")
const VEST := Color("f28c28")
const HAT := Color("c9a227")


func _init() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUT_SPRITES))
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUT_TILESET))
	_save(_tileset(), OUT_TILESET + "placeholder_zona1.png")
	_save(_player_sheet(), OUT_SPRITES + "player.png")
	_save(_player_back(), OUT_SPRITES + "player_back.png")
	_save(_npc_guide(), OUT_SPRITES + "npc_guia.png")
	_save(_plasti_golem(), OUT_SPRITES + "plasti_golem.png")
	_save(_maleza_toxica(), OUT_SPRITES + "maleza_toxica.png")
	_save(_trash(), OUT_SPRITES + "trash.png")
	_save(_capsule_zona1(), OUT_SPRITES + "capsula_zona1.png")
	print("Placeholders generados.")
	quit()


func _save(img: Image, path: String) -> void:
	var err := img.save_png(path)
	if err != OK:
		push_error("No se pudo guardar %s (%d)" % [path, err])
	else:
		print("  ", path)


func _new(w: int, h: int) -> Image:
	var img := Image.create(w, h, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))
	return img


func _rect(img: Image, x: int, y: int, w: int, h: int, c: Color) -> void:
	img.fill_rect(Rect2i(x, y, w, h), c)


func _dots(img: Image, ox: int, oy: int, points: Array, c: Color) -> void:
	for p: Vector2i in points:
		img.set_pixel(ox + p.x, oy + p.y, c)


# --- Tileset 16x16: 0 césped, 1 camino, 2 seto, 3 agua, 4 tejado, 5 flores ---
func _tileset() -> Image:
	var img := _new(96, 16)
	var grass := Color("5cb85c")
	# 0 césped
	_rect(img, 0, 0, 16, 16, grass)
	_dots(img, 0, 0, [Vector2i(3, 4), Vector2i(10, 2), Vector2i(7, 11), Vector2i(13, 13), Vector2i(1, 14)], Color("449d44"))
	# 1 camino de tierra
	_rect(img, 16, 0, 16, 16, Color("d9b77e"))
	_dots(img, 16, 0, [Vector2i(4, 3), Vector2i(11, 6), Vector2i(6, 12), Vector2i(13, 14)], Color("b8945a"))
	# 2 seto / cerca
	_rect(img, 32, 0, 16, 16, Color("2f6b2f"))
	_rect(img, 32, 0, 16, 2, Color("3f8f3f"))
	_dots(img, 32, 0, [Vector2i(3, 5), Vector2i(9, 4), Vector2i(12, 9), Vector2i(5, 11), Vector2i(10, 13)], Color("1f4d1f"))
	# 3 agua
	_rect(img, 48, 0, 16, 16, Color("3b82f6"))
	_rect(img, 50, 4, 5, 1, Color("93c5fd"))
	_rect(img, 57, 10, 5, 1, Color("93c5fd"))
	# 4 tejado de teja (casa vista desde arriba)
	_rect(img, 64, 0, 16, 16, Color("b5532f"))
	for row in [3, 7, 11, 15]:
		_rect(img, 64, row, 16, 1, Color("8a3b1f"))
	# 5 flores sobre césped
	_rect(img, 80, 0, 16, 16, grass)
	_dots(img, 80, 0, [Vector2i(3, 3), Vector2i(11, 5)], Color("e63946"))
	_dots(img, 80, 0, [Vector2i(6, 10), Vector2i(13, 12)], Color("ffd60a"))
	_dots(img, 80, 0, [Vector2i(2, 13), Vector2i(9, 2)], Color("ff70a6"))
	return img


# --- Jugador 16x16: columnas = frame 0/1, filas = abajo, arriba, izquierda, derecha ---
func _player_sheet() -> Image:
	var img := _new(32, 64)
	for row in 4:
		for frame in 2:
			_draw_person(img, frame * 16, row * 16, row, frame, SHIRT, HAIR, Color(0, 0, 0, 0))
	return img


func _npc_guide() -> Image:
	var img := _new(16, 16)
	_draw_person(img, 0, 0, 0, 0, VEST, HAIR, HAT)
	return img


## dir: 0 abajo, 1 arriba, 2 izquierda, 3 derecha
func _draw_person(img: Image, ox: int, oy: int, dir: int, frame: int, shirt: Color, hair: Color, hat: Color) -> void:
	# cabeza
	_rect(img, ox + 5, oy + 1, 6, 6, SKIN)
	_rect(img, ox + 5, oy + 1, 6, 2, hair)
	if dir == 1:
		_rect(img, ox + 5, oy + 1, 6, 5, hair)
	elif dir == 0:
		_dots(img, ox, oy, [Vector2i(6, 4), Vector2i(9, 4)], EYE)
	elif dir == 2:
		_dots(img, ox, oy, [Vector2i(6, 4)], EYE)
		_rect(img, ox + 9, oy + 3, 2, 3, hair)
	else:
		_dots(img, ox, oy, [Vector2i(9, 4)], EYE)
		_rect(img, ox + 5, oy + 3, 2, 3, hair)
	if hat.a > 0.0:
		_rect(img, ox + 4, oy + 0, 8, 2, hat)
	# cuerpo y brazos
	_rect(img, ox + 4, oy + 7, 8, 5, shirt)
	_rect(img, ox + 4, oy + 11, 8, 1, shirt.darkened(0.3))
	# piernas: el frame 1 alterna el paso
	var l := 1 if frame == 1 else 0
	_rect(img, ox + 5, oy + 12, 2, 3 - l, PANTS)
	_rect(img, ox + 9, oy + 12, 2, 2 + l, PANTS)
	_rect(img, ox + 5, oy + 15 - l, 2, 1, SHOE)
	_rect(img, ox + 9, oy + 14 + l, 2, 1, SHOE)


# --- Jugador de espaldas para el combate (32x32) ---
func _player_back() -> Image:
	var img := _new(32, 32)
	_rect(img, 10, 2, 12, 11, HAIR)  # cabeza (pelo, de espaldas)
	_rect(img, 9, 8, 2, 3, SKIN)  # orejas
	_rect(img, 21, 8, 2, 3, SKIN)
	_rect(img, 6, 13, 20, 19, SHIRT)  # torso
	_rect(img, 10, 14, 12, 12, Color("8d6e63"))  # mochila
	_rect(img, 10, 14, 12, 2, Color("6d4c41"))
	_rect(img, 13, 19, 6, 4, Color("ffd60a"))  # símbolo de reciclaje (placeholder)
	return img


# --- Enemigos 32x32 (de frente) ---
func _plasti_golem() -> Image:
	var img := _new(32, 32)
	var plastic := Color("8ecae6")
	_rect(img, 8, 6, 16, 20, plastic)  # cuerpo de botella
	_rect(img, 12, 1, 8, 5, Color("219ebc"))  # tapa
	_rect(img, 8, 12, 16, 4, Color("e63946"))  # etiqueta
	_rect(img, 2, 10, 6, 10, Color("d9d9d9"))  # brazo-bolsa
	_rect(img, 24, 10, 6, 10, Color("d9d9d9"))
	_rect(img, 9, 26, 5, 6, Color("5c677d"))  # piernas
	_rect(img, 18, 26, 5, 6, Color("5c677d"))
	_rect(img, 11, 8, 3, 3, Color("ff0000"))  # ojos
	_rect(img, 18, 8, 3, 3, Color("ff0000"))
	_rect(img, 12, 20, 8, 2, Color("023047"))  # boca
	return img


func _maleza_toxica() -> Image:
	var img := _new(32, 32)
	var leaf := Color("6a994e")
	var toxic := Color("9d4edd")
	_rect(img, 6, 14, 20, 16, leaf)  # mata
	_rect(img, 3, 8, 6, 14, leaf.darkened(0.2))  # hojas
	_rect(img, 23, 6, 6, 16, leaf.darkened(0.2))
	_rect(img, 13, 2, 6, 14, leaf.lightened(0.1))
	_dots(img, 0, 0, [Vector2i(5, 9), Vector2i(25, 7), Vector2i(15, 3), Vector2i(10, 26), Vector2i(22, 27)], toxic)
	_rect(img, 10, 16, 4, 4, Color("ffe600"))  # ojos
	_rect(img, 18, 16, 4, 4, Color("ffe600"))
	_rect(img, 11, 17, 2, 2, EYE)
	_rect(img, 19, 17, 2, 2, EYE)
	_rect(img, 12, 23, 8, 2, toxic)  # boca
	return img


# --- Basura decorativa 16x16: 0 botella, 1 funda, 2 lata ---
func _trash() -> Image:
	var img := _new(48, 16)
	_rect(img, 5, 6, 7, 4, Color("8ecae6"))  # botella acostada
	_rect(img, 12, 7, 2, 2, Color("219ebc"))
	_rect(img, 20, 5, 8, 7, Color("e0e0e0"))  # funda
	_rect(img, 22, 3, 2, 2, Color("e0e0e0"))
	_rect(img, 25, 3, 2, 2, Color("e0e0e0"))
	_rect(img, 37, 6, 6, 5, Color("e63946"))  # lata
	_rect(img, 37, 6, 6, 1, Color("c0c0c0"))
	return img


# --- Ilustración placeholder de la cápsula histórica (64x64) ---
func _capsule_zona1() -> Image:
	var img := _new(64, 64)
	_rect(img, 0, 0, 64, 40, Color("a8dadc"))  # cielo
	_rect(img, 0, 40, 64, 24, Color("5cb85c"))  # jardín
	_rect(img, 14, 24, 36, 18, Color("f1e3c6"))  # casa
	_rect(img, 10, 18, 44, 7, Color("b5532f"))  # tejado
	_rect(img, 29, 32, 6, 10, Color("6d4c41"))  # puerta
	_rect(img, 18, 29, 6, 5, Color("457b9d"))  # ventanas
	_rect(img, 40, 29, 6, 5, Color("457b9d"))
	_rect(img, 2, 22, 8, 20, Color("2f6b2f"))  # árboles
	_rect(img, 54, 20, 8, 22, Color("2f6b2f"))
	_rect(img, 5, 42, 2, 4, Color("6d4c41"))
	_rect(img, 57, 42, 2, 4, Color("6d4c41"))
	return img
