# Arquitectura

## Singletons (autoload)
- **GameState** → zona actual, zonas desbloqueadas/purificadas, inventario, criaturas purificadas, cápsulas vistas.
- **MissionManager** → registro de misiones y su estado (PENDIENTE, EN_CURSO, COMPLETADA). Emite `mission_state_changed` y `zone_purified`.

## Custom Resources (`game/resources/`)
- `CreatureData` → nombre, sprite, vida, ataques, zona, si es jefe.
- `AttackData` → nombre, tipo ecológico, poder, precisión, descripción.
- `HistoricCapsule` → título, ilustración, páginas de texto, trivia opcional.
- `MissionData` → id, zona, descripción, NPC que la otorga, objetivo.

Ejemplos de la Zona 1:

| Tipo | Archivo |
|---|---|
| Criaturas | `creatures/plasti_golem.tres` (jefe), `creatures/maleza_toxica.tres` |
| Ataques del jugador | `attacks/reciclar.tres`, `filtro_uv.tres`, `cortafuegos.tres`, `compostaje.tres` |
| Ataques enemigos | `attacks/enemigos/*.tres` |
| Misión | `missions/zona1_limpieza_quinta.tres` |
| Cápsula | `capsules/zona1_quinta_juan_leon_mera.tres` (**textos con TODO por verificar**) |

## Escenas
Una escena = un script del mismo nombre (excepto `zone.gd`, compartido por todas las zonas).

```
scenes/main/main.tscn                    Main: carga la zona y alterna overworld ↔ combate
scenes/overworld/
  player.tscn                            Player: movimiento, animaciones, cámara, RayCast para interactuar
  npc.tscn                               Npc: líneas según estado de misión + indicador "!"
  encounter.tscn                         Encounter: criatura en el mapa, pide combate
  trash.tscn                             Trash: basura decorativa, desaparece al purificar
  purification_filter.tscn               PurificationFilter: shader gris → color (RF-04)
  zona1/zona1_quinta_juan_leon_mera.tscn Zone 1 (script zone.gd): mapa, entidades, filtro y UI
  zona1/npc_guia_quinta.tscn             Hereda de npc.tscn: diálogos de la guía
scenes/battle/
  battle_scene.tscn                      BattleScene: presentación del combate + nodo BattleManager
  creature_hud.tscn                      CreatureHud: nombre y barra de vida
scenes/ui/
  dialog_box.tscn                        DialogBox: diálogo con máquina de escribir
  capsule_modal.tscn                     CapsuleModal: cápsula histórica (RF-05)
  mission_hud.tscn                       MissionHud: misión y estado (RF-02)
  screen_transition.tscn                 ScreenTransition: destellos y fundidos
```

Scripts de apoyo sin escena: `scripts/ui/typewriter_label.gd` (Label con efecto máquina de escribir) y `scripts/overworld/placeholder_map.gd`.

### Estructura de una zona
```
Zona (Node2D, zone.gd)
├── Ground (TileMapLayer, placeholder_map.gd)
├── Trash (Node2D)             ← instancias de trash.tscn
├── Entities (Node2D, y_sort)  ← Player, NPCs y Encounters
├── PurificationFilter (CanvasLayer 5)
└── UI (CanvasLayer 10)        ← MissionHud, DialogBox, CapsuleModal
```
El filtro está por encima del mundo y por debajo de la UI: solo el mapa se ve gris.

Para que varias personas trabajen sin conflictos: el mapa y la ubicación de las entidades van en la escena de la zona; los diálogos de cada NPC van en su escena heredada (`npc_guia_quinta.tscn`); los textos de misiones, criaturas y cápsulas van en los `.tres`.

### Capas de física
| Capa | Nombre | Quién |
|---|---|---|
| 1 | mundo | Tiles sólidos (seto, agua, tejado), NPCs, criaturas |
| 2 | jugador | Player (choca con la capa 1) |
| 3 | interactuables | NPCs y criaturas (el RayCast del jugador solo mira esta capa) |

### Controles
| Acción | Teclas |
|---|---|
| `move_up/down/left/right` | WASD y flechas |
| `interact` | E, Enter, Enter del teclado numérico |

En el combate también funcionan Enter/Espacio (`ui_accept`) y el ratón.

## Flujo
Overworld (zona) → encuentro → BattleScene (máquina de estados) → victoria → MissionManager marca la misión → si era el jefe: purificación visual + cápsula histórica + desbloqueo de la siguiente zona.

Detalle del vertical slice (Zona 1):
1. La guía tiene un "!" y la misión está **Pendiente**. Al hablar con ella, `MissionManager.start()` la pasa a **En curso**.
2. Las criaturas no aceptan combate hasta que la misión esté En curso.
3. `Encounter.interact()` → `Zone.battle_requested` → `Main` hace la transición, saca la zona del árbol (sin liberarla) y abre `BattleScene`.
4. `BattleManager` resuelve cada turno de forma síncrona y emite `attack_executed` / `battle_finished`. `BattleScene` guarda esos eventos y los reproduce con mensajes y animaciones.
5. Al terminar, `Main` vuelve a poner la zona en el árbol y llama a `Zone.on_battle_finished(won)`.
6. Si se venció a la criatura objetivo (`MissionData.target_creature_id`): `MissionManager.complete()` → `GameState.purify_zone()` (desbloquea la Zona 2) → señal `zone_purified` → la zona retira la basura, anima el filtro de gris a color, muestra la cápsula y avisa del desbloqueo.

## Mapa provisional
`PlaceholderMap` dibuja el `TileMapLayer` a partir de un texto (`layout`, editable en el inspector) con el tileset `assets/tilesets/placeholder_zona1_tileset.tres`. Si la capa ya tiene tiles pintados (por ejemplo, importados con YATI) no hace nada, así que el mapa real puede reemplazarlo sin cambiar código.

## Arte provisional
Los sprites y el tileset de `assets/sprites/placeholder/` y `assets/tilesets/placeholder_zona1*` se generan con:
```
godot --headless --path game --script <ruta-absoluta>/tools/placeholders/generar_placeholders.gd
```

## Renderizado
El proyecto usa el renderizador **Compatibility (OpenGL 3.3)**. Con Forward+ (Vulkan) el juego se cerraba al iniciar en una laptop con GTX 960M (RNF-01). Compatibility además permite exportar a Web.

## Pipeline de mapas
Overpass Turbo (.geojson) → `tools/osm_pipeline/osm_to_tiled.py` (proyección EPSG:32717, UTM 17S) → Tiled (.tmx) → plugin YATI → `game/maps/`.
