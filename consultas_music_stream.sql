USE bd_musicstream;

-- Artista con más valoración: ratio_reception, cuantas veces en promedio escucha un oyente la cancion mas popular de un artista
SELECT DISTINCT
artistas.nombre,
t1.ratio_reception
FROM artistas
INNER JOIN (
	SELECT
	id_artista,
	ROUND(playcount/listeners, 2) AS ratio_reception
	FROM estadisticas_canciones) t1
ON artistas.id_artista = t1.id_artista
ORDER BY ratio_reception DESC
LIMIT 1;

-- También podría ser por oyentes únicos
SELECT DISTINCT
artistas.nombre,
estadisticas_canciones.listeners
FROM artistas
INNER JOIN estadisticas_canciones
ON artistas.id_artista = estadisticas_canciones.id_artista
ORDER BY listeners DESC
LIMIT 1;

-- Canción más valorada de los años pares: ratio_reception
SELECT DISTINCT
c.name_track,
c.year,
ROUND(ec.playcount / ec.listeners, 2) AS ratio_reception
FROM canciones c
JOIN estadisticas_canciones ec 
ON c.id_cancion = ec.id_cancion
WHERE (c.year, ROUND(ec.playcount / NULLIF(ec.listeners, 0), 2)) IN (
	SELECT 
    c2.year,
    MAX(ROUND(ec2.playcount / NULLIF(ec2.listeners, 0), 2))
	FROM canciones c2
	JOIN estadisticas_canciones ec2 
    ON c2.id_cancion = ec2.id_cancion
	WHERE c2.year IN (2020, 2022, 2024)
	GROUP BY c2.year
)
ORDER BY c.year;



