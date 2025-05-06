-- CONSULTAS REALIZADAS EN LA BBDD MUSICSTREAM

-- ¿En qué año se lanzaron más álbumes?

SELECT año_lanzamiento, COUNT(*) AS total_albumes
FROM albums
GROUP BY año_lanzamiento
ORDER BY total_albumes DESC
LIMIT 1;

-- ¿Cuál es la canción mejor valorada?

SELECT 
    c.titulo,
    a.nombre,
    ec.playcount
FROM estadisticas_canciones ec
JOIN canciones c ON ec.id_cancion = c.id_cancion
JOIN artistas a ON c.id_artista = a.id_artista
ORDER BY ec.playcount DESC
LIMIT 1;

-- Artista con más valoración: ratio_reception, cuantas veces en promedio escucha un oyente la cancion mas popular de un artista

SELECT
a.nombre,
t1.ratio_reception
FROM artistas a
INNER JOIN (
	SELECT
	id_artista,
	ROUND(playcount/listeners, 2) AS ratio_reception
	FROM estadisticas_canciones) t1
ON a.id_artista = t1.id_artista
ORDER BY ratio_reception DESC
LIMIT 1;

-- Canción más valorada de los años pares: ratio_reception

SELECT
c.titulo,
c.año_lanzamiento,
ROUND(ec.playcount / ec.listeners, 2) AS ratio_reception
FROM canciones c
JOIN estadisticas_canciones ec
ON c.id_cancion = ec.id_cancion
WHERE (c.año_lanzamiento, ROUND(ec.playcount / NULLIF(ec.listeners, 0), 2)) IN (
	SELECT
    c2.año_lanzamiento,
    MAX(ROUND(ec2.playcount / NULLIF(ec2.listeners, 0), 2))
	FROM canciones c2
	JOIN estadisticas_canciones ec2
    ON c2.id_cancion = ec2.id_cancion
	WHERE c2.año_lanzamiento IN (2020, 2022, 2024)
	GROUP BY c2.año_lanzamiento
)
ORDER BY c.año_lanzamiento;

-- Artista con más lanzamientos en los 4 años

SELECT a.nombre, COUNT(DISTINCT al.titulo) AS lanzamientos
FROM artistas a
JOIN albums al ON a.id_artista = al.id_artista
GROUP BY a.id_artista
ORDER BY lanzamientos DESC
LIMIT 1;

-- ¿Cuál es el genero mejor valorado?

SELECT genero.nombre_genero AS genero, ROUND(AVG(estadisticas_canciones.playcount), 0) AS media_playcount
FROM estadisticas_canciones
INNER JOIN canciones ON estadisticas_canciones.id_cancion = canciones.id_cancion
INNER JOIN genero ON canciones.id_genero = genero.id_genero
GROUP BY genero.nombre_genero
ORDER BY media_playcount DESC
LIMIT 1;

-- ¿Cuál es el género que tiene más artistas?

SELECT g.nombre_genero, COUNT(DISTINCT a.id_artista) AS total_artistas
FROM canciones c
JOIN artistas a ON c.id_artista = a.id_artista
JOIN genero g ON c.id_genero = g.id_genero
WHERE g.nombre_genero IS NOT NULL
GROUP BY g.nombre_genero
ORDER BY total_artistas DESC
LIMIT 1;

-- Numero de artistas por genero

SELECT g.nombre_genero, COUNT(DISTINCT a.id_artista) AS total_artistas
FROM canciones c
JOIN artistas a ON c.id_artista = a.id_artista
JOIN genero g ON c.id_genero = g.id_genero
WHERE g.nombre_genero IS NOT NULL
GROUP BY g.nombre_genero
ORDER BY total_artistas DESC;

-- Comparativa entre géneros por media de oyentes por canción

SELECT g.nombre_genero,
       ROUND(AVG(ec.listeners), 0) AS media_oyentes_por_cancion
FROM canciones c
JOIN genero g ON c.id_genero = g.id_genero
JOIN estadisticas_canciones ec ON c.id_cancion = ec.id_cancion
WHERE g.nombre_genero IS NOT NULL
GROUP BY g.nombre_genero
ORDER BY media_oyentes_por_cancion DESC;

-- ¿Cuál es la canción más escuchada de cada género? 

SELECT DISTINCT g.nombre_genero, c.titulo AS cancion_mas_escuchada, sc.listeners
FROM genero g
JOIN canciones c ON g.id_genero = c.id_genero
JOIN estadisticas_canciones sc ON c.id_cancion = sc.id_cancion
WHERE sc.listeners = (
    SELECT MAX(sc2.listeners)
    FROM estadisticas_canciones sc2
    JOIN canciones c2 ON sc2.id_cancion = c2.id_cancion
    WHERE c2.id_genero = g.id_genero
)
ORDER BY g.nombre_genero;

-- ¿Cuál es la canción más escuchada de cada género y el artista autor de la canción? 

SELECT DISTINCT g.nombre_genero, c.titulo AS cancion_mas_escuchada, a.nombre AS artista, sc.listeners
FROM genero g
JOIN canciones c ON g.id_genero = c.id_genero
JOIN artistas a ON c.id_artista = a.id_artista
JOIN estadisticas_canciones sc ON c.id_cancion = sc.id_cancion
WHERE sc.listeners = (
    SELECT MAX(sc2.listeners)
    FROM estadisticas_canciones sc2
    JOIN canciones c2 ON sc2.id_cancion = c2.id_cancion
    WHERE c2.id_genero = g.id_genero
)
ORDER BY g.nombre_genero;

-- Top 5 artistas más reproducidos (por suma de playcount)

SELECT a.nombre AS artista, SUM(sc.playcount) AS total_reproducciones
FROM artistas a
JOIN estadisticas_canciones sc ON a.id_artista = sc.id_artista
GROUP BY a.id_artista, a.nombre
ORDER BY total_reproducciones DESC
LIMIT 5;

-- Artistas similares al artista con mayor valoración. 

SELECT
    a.nombre AS artista_principal,
    t1.ratio_reception,
    sa.similar AS artista_similar
FROM artistas a
INNER JOIN (
    SELECT
        id_artista,
        ROUND(playcount / listeners, 2) AS ratio_reception
    FROM estadisticas_canciones
    ORDER BY ratio_reception DESC
    LIMIT 1
) t1 ON a.id_artista = t1.id_artista
LEFT JOIN similar_artist sa ON a.id_artista = sa.id_artista
ORDER BY t1.ratio_reception DESC;

-- Evolución de oyentes por género.

SELECT
    c.año_lanzamiento,
    g.nombre_genero,
    SUM(ec.playcount) AS total_playcount
FROM canciones c
JOIN estadisticas_canciones ec ON c.id_cancion = ec.id_cancion
JOIN genero g ON c.id_genero = g.id_genero
WHERE c.año_lanzamiento IN (2019, 2020, 2021, 2022, 2023, 2024)
GROUP BY c.año_lanzamiento, g.nombre_genero
ORDER BY c.año_lanzamiento, total_playcount DESC;