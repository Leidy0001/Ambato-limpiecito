# Pipeline OpenStreetMap → Tiled → Godot

1. Abrir https://overpass-turbo.eu y ejecutar la consulta de `queries/` de la zona. Exportar como **GeoJSON** a `output/`.
2. Crear entorno e instalar dependencias:
   ```bash
   python -m venv .venv && source .venv/bin/activate   # Windows: .venv\Scripts\activate
   pip install -r requirements.txt
   ```
3. Convertir:
   ```bash
   python osm_to_tiled.py output/zona1.geojson --tile 16 --out output/zona1.csv
   ```
4. Usar la grilla generada como guía en Tiled, guardar el `.tmx` en `game/maps/` e importarlo con el plugin YATI.

Los datos de OSM están bajo licencia ODbL: mantener la atribución en `CREDITS.md`.
