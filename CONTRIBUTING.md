# Guía de contribución

## Ramas
- `main` → versión estable (solo entra por Pull Request revisado).
- `develop` → integración del equipo.
- Ramas de trabajo desde `develop`:
  - `feature/<tema>` → ej. `feature/combate-turnos`
  - `fix/<tema>` → ej. `fix/colision-catedral`
  - `art/<tema>` → ej. `art/tileset-zona1`
  - `docs/<tema>`

## Commits (Conventional Commits, en español)
```
feat(combate): agregar ataque Reciclar
fix(overworld): corregir colisión con la pileta del parque
art(zona1): tileset de la Quinta de Juan León Mera
docs: actualizar requisitos RF-05
```

## Pull Requests
- Siempre hacia `develop`, con al menos **1 revisión** de otra persona.
- Describir qué se hizo y adjuntar captura/GIF si hay cambios visuales.
- No subir archivos de `.godot/` ni exportaciones.

## Roles sugeridos (equipo de ~6)
| Rol | Responsabilidad |
|---|---|
| Líder / Integración | Revisión de PRs, `develop`, tablero de tareas |
| Overworld | Movimiento, cámara, colisiones, transiciones (RF-01, RF-04) |
| Combate | Máquina de estados por turnos, criaturas, ataques (RF-03) |
| Misiones / UI | MissionManager, diálogos, Pokédex Turística (RF-02, RF-05) |
| Mapas | Pipeline OSM → Tiled → Godot |
| Arte / Audio / Contenido | Pixel art, sonidos, textos históricos |

## Convenciones de Godot
- Escenas y carpetas: `snake_case` (`battle_scene.tscn`).
- Clases y nodos: `PascalCase` (`BattleManager`).
- Variables y funciones: `snake_case`. Señales en pasado: `mission_completed`.
- Una escena = un script del mismo nombre.
- Evitar editar la misma escena `.tscn` dos personas a la vez (genera conflictos difíciles).
