"""Convierte un GeoJSON de OpenStreetMap en una grilla de tiles (CSV) para Tiled.

Proyecta a UTM 17S (EPSG:32717), rasteriza cada capa en celdas de `tile` metros
y asigna un id de tile según el tipo de elemento. El CSV resultante puede pegarse
como capa en Tiled o servir de guía para dibujar el mapa.
"""
import argparse

import geopandas as gpd
import numpy as np
from shapely.geometry import box

UTM_17S = "EPSG:32717"

# id de tile en Tiled por tipo de elemento (ajustar al tileset del equipo)
TILE_IDS = {
    "vacio": 0,
    "cesped": 1,
    "calle": 2,
    "edificio": 3,
    "agua": 4,
}


def clasificar(row) -> str:
    if row.get("waterway") or row.get("natural") == "water":
        return "agua"
    if row.get("building"):
        return "edificio"
    if row.get("highway"):
        return "calle"
    if row.get("leisure") or row.get("landuse"):
        return "cesped"
    return "vacio"


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("geojson")
    parser.add_argument("--tile", type=float, default=4.0, help="metros reales por tile")
    parser.add_argument("--out", default="output/mapa.csv")
    args = parser.parse_args()

    gdf = gpd.read_file(args.geojson).to_crs(UTM_17S)
    gdf["tipo"] = gdf.apply(clasificar, axis=1)
    # Las calles son líneas: se engrosan para que ocupen celdas
    calles = gdf["tipo"] == "calle"
    gdf.loc[calles, "geometry"] = gdf.loc[calles, "geometry"].buffer(args.tile)

    minx, miny, maxx, maxy = gdf.total_bounds
    cols = int(np.ceil((maxx - minx) / args.tile))
    rows = int(np.ceil((maxy - miny) / args.tile))
    grid = np.zeros((rows, cols), dtype=int)

    # Orden de prioridad: lo último pintado gana
    for tipo in ["cesped", "calle", "agua", "edificio"]:
        capa = gdf[gdf["tipo"] == tipo]
        if capa.empty:
            continue
        union = capa.geometry.union_all()
        for r in range(rows):
            for c in range(cols):
                x0 = minx + c * args.tile
                y1 = maxy - r * args.tile
                if union.intersects(box(x0, y1 - args.tile, x0 + args.tile, y1)):
                    grid[r, c] = TILE_IDS[tipo]

    np.savetxt(args.out, grid, fmt="%d", delimiter=",")
    print(f"Grilla {cols}x{rows} guardada en {args.out}")


if __name__ == "__main__":
    main()
