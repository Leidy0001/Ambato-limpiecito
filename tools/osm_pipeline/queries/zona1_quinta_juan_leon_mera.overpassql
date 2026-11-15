// Zona 1 – Quinta de Juan León Mera (Atocha, Ambato)
// Ajustar el bbox (sur, oeste, norte, este) según el área que se quiera recrear.
[out:json][timeout:25];
(
  way["highway"](-1.2290,-78.6170,-1.2200,-78.6080);
  way["building"](-1.2290,-78.6170,-1.2200,-78.6080);
  way["waterway"](-1.2290,-78.6170,-1.2200,-78.6080);
  way["leisure"](-1.2290,-78.6170,-1.2200,-78.6080);
  way["landuse"](-1.2290,-78.6170,-1.2200,-78.6080);
);
out body;
>;
out skel qt;
