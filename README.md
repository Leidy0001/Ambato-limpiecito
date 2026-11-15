# 🌿 Ambato Limpiecito

RPG 2D estilo Pokémon clásico para promocionar la carrera de **Ingeniería de Software (FISEI – UTA)** en colegios y difundir la historia y el cuidado ambiental de los sitios emblemáticos del **cantón Ambato**.

El jugador recorre lugares reales de Ambato, combate contra "basura mutada" por turnos, purifica el entorno y desbloquea cápsulas históricas ("Pokédex Turística").

## Zonas
| Zona | Sitio | Enemigos |
|---|---|---|
| 1 – Tutorial | Quinta de Juan León Mera (Atocha) | Plasti-Gólem, Maleza Tóxica |
| 2 – Urbana | Quinta de Montalvo (Ficoa) | Tinta-Contaminante, Smog-Urbano |
| 3 – Centro Histórico | Catedral y Parque Montalvo | Smog-Catedral, Chatarra-Bot |
| 4 – Jefe final | Jardín Botánico La Liria / Parque de la Familia *(por definir)* | Hidro-Mutante, Lodo-Tóxico |

## Stack
- **Motor:** Godot 4.x (GDScript)
- **Mapas reales:** OpenStreetMap (Overpass Turbo) → Python (GeoPandas/Shapely, UTM 17S) → Tiled (.tmx) → plugin YATI
- **Arte/Audio:** LibreSprite/Aseprite, tilesets Kenney/LimeZu, Bfxr/ChipTone, Audacity
- **Control de versiones:** Git + GitHub

## Estructura
```
game/                 Proyecto Godot (abrir game/project.godot)
  scenes/             main, overworld, battle, ui
  scripts/autoload/   GameState, MissionManager (singletons globales)
  scripts/battle/     Máquina de estados del combate
  resources/          Custom Resources: criaturas, ataques, cápsulas, misiones
  assets/             Sprites, tilesets, audio, fuentes (ver CREDITS.md)
  maps/               Mapas .tmx importados desde Tiled
tools/osm_pipeline/   Scripts Python para convertir OSM → Tiled
docs/                 Requisitos, decisiones pendientes, arquitectura
```

## Cómo empezar
1. Instalar [Godot 4.x](https://godotengine.org/download) (versión estándar, no .NET).
2. Clonar el repo y abrir `game/project.godot` desde Godot.
3. Leer [CONTRIBUTING.md](CONTRIBUTING.md) antes de tu primer commit.

## Licencia
Código bajo licencia MIT. Los assets de terceros conservan su propia licencia (ver `CREDITS.md`).
