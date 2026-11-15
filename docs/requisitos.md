# Especificación de Requisitos — Ambato Limpiecito (v1.0 borrador)

**Propósito:** Promoción de Ingeniería de Software en colegios y difusión cultural/ambiental de Ambato.
**Género:** RPG 2D estilo Pokémon clásico. **Alcance:** solo sitios del cantón Ambato.

## Requisitos funcionales
- **RF-01 Exploración (overworld 2D):** cámara cenital que sigue al jugador en 4 direcciones; colisiones con edificios, monumentos, cercas y agua; mapas basados en el trazado real.
- **RF-02 Misiones turísticas:** cada sitio tiene al menos una misión principal de limpieza (NPC guía o señalética). Estados: Pendiente / En curso / Completada, gestionados globalmente.
- **RF-03 Combate por turnos:** transición animada a escena de batalla (jugador de espaldas, enemigo de frente). Estados: selección → ejecución (Reciclar, Filtro UV, Cortafuegos, Compostaje…) → turno enemigo → resolución. Derrotar o purificar/capturar.
- **RF-04 Purificación visual:** al completar la misión desaparece la basura, la paleta pasa de gris a colores vivos y se desbloquea la siguiente zona.
- **RF-05 Pokédex Turística:** tras vencer al jefe de zona, modal con ilustración pixel art y texto tipo máquina de escribir (3–4 líneas por pantalla, "¿Sabías que…?"). Opcional: mini-trivia que da un ítem.

## Requisitos no funcionales
- **RNF-01:** ejecución fluida en las laptops del club / colegios.
- **RNF-03:** solo herramientas y assets gratuitos o con licencia abierta.

## Zonas
| Zona | Sitio | Enemigos | Cápsula histórica |
|---|---|---|---|
| 1 | Quinta de Juan León Mera (Atocha) | Plasti-Gólem, Maleza Tóxica | Letra del Himno Nacional (1865), riqueza botánica |
| 2 | Quinta de Montalvo (Ficoa) | Tinta-Contaminante, Smog-Urbano | Vida y legado de Juan Montalvo |
| 3 | Catedral y Parque Montalvo | Smog-Catedral, Chatarra-Bot | Reconstrucción tras el terremoto de 1949; "Tierra de Flores y Frutas" |
| 4 | Jardín Botánico La Liria / Parque de la Familia | Hidro-Mutante, Lodo-Tóxico | Importancia hídrica y ecológica de quebradas y parques |
