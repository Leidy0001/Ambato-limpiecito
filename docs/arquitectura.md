# Arquitectura

## Singletons (autoload)
- **GameState** → zona actual, zonas desbloqueadas/purificadas, inventario, criaturas purificadas, cápsulas vistas.
- **MissionManager** → registro de misiones y su estado (PENDIENTE, EN_CURSO, COMPLETADA). Emite `mission_state_changed` y `zone_purified`.

## Custom Resources (`game/resources/`)
- `CreatureData` → nombre, sprite, vida, ataques, zona, si es jefe.
- `AttackData` → nombre, tipo ecológico, poder, precisión, descripción.
- `HistoricCapsule` → título, ilustración, páginas de texto, trivia opcional.
- `MissionData` → id, zona, descripción, NPC que la otorga, objetivo.

## Flujo
Overworld (zona) → encuentro → BattleScene (máquina de estados) → victoria → MissionManager marca la misión → si era el jefe: purificación visual + cápsula histórica + desbloqueo de la siguiente zona.

## Pipeline de mapas
Overpass Turbo (.geojson) → `tools/osm_pipeline/osm_to_tiled.py` (proyección EPSG:32717, UTM 17S) → Tiled (.tmx) → plugin YATI → `game/maps/`.
