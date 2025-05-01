CREATE DATABASE bd_musicstream;
USE bd_musicstream;

CREATE TABLE genero(
	id_genero INT AUTO_INCREMENT PRIMARY KEY,
    nombre_genero VARCHAR(10));
    
INSERT INTO genero (nombre_genero) 
VALUES ('rock'), ('pop'), ('reggaeton'), ('rap');



-- Fer
CREATE TABLE artistas (
    id_artista INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    biografia TEXT,
    pais VARCHAR(100)
);

INSERT IGNORE INTO artistas (nombre)
SELECT DISTINCT name_artist FROM rock_tracks;

INSERT IGNORE INTO artistas (nombre)
SELECT DISTINCT name_artist FROM rock_albums;

INSERT IGNORE INTO artistas (nombre)
SELECT DISTINCT name_artist FROM pop_tracks;

INSERT IGNORE INTO artistas (nombre)
SELECT DISTINCT name_artist FROM pop_albums;

INSERT IGNORE INTO artistas (nombre)
SELECT DISTINCT name_artist FROM rap_tracks;

INSERT IGNORE INTO artistas (nombre)
SELECT DISTINCT name_artist FROM rap_albums;

INSERT IGNORE INTO artistas (nombre)
SELECT DISTINCT name_artist FROM reggaeton_tracks;

INSERT IGNORE INTO artistas (nombre)
SELECT DISTINCT name_artist FROM reggaeton_albums;

SET SQL_SAFE_UPDATES = 0;
UPDATE artistas a
JOIN artist_info i ON a.nombre = i.Artist
SET a.biografia = i.Biography;


-- Lidia
CREATE TABLE canciones AS
SELECT * FROM pop_tracks
UNION ALL
SELECT * FROM rock_tracks
UNION ALL
SELECT * FROM reggaeton_tracks
UNION ALL
SELECT * FROM rap_tracks;

ALTER TABLE canciones ADD COLUMN id_genero INT;

UPDATE canciones p
JOIN genero g ON p.genre = g.nombre_genero
SET p.id_genero = g.id_genero;

ALTER TABLE canciones DROP COLUMN genre;

ALTER TABLE canciones DROP COLUMN type;

ALTER TABLE canciones CHANGE COLUMN `Unnamed: 0` id_cancion BIGINT;

ALTER TABLE canciones ADD COLUMN id_artista INT;

UPDATE canciones p
JOIN artistas a ON p.name_artist = a.nombre
SET p.id_artista = a.id_artista;

ALTER TABLE canciones DROP COLUMN name_artist;

ALTER TABLE canciones DROP COLUMN ID_cancion;

ALTER TABLE canciones ADD COLUMN id_cancion INT AUTO_INCREMENT PRIMARY KEY;

ALTER TABLE canciones
MODIFY COLUMN id_artista INT;

ALTER TABLE canciones
ADD CONSTRAINT fk_cancion_artista
FOREIGN KEY (id_artista) REFERENCES artistas(id_artista);

-- Maria
-- Limpieza tablas creadas a partir de los datos cargados desde Python

ALTER TABLE rock_albums
DROP COLUMN `type`;

ALTER TABLE pop_albums
DROP COLUMN `type`;

ALTER TABLE reggaeton_albums
DROP COLUMN `type`;

ALTER TABLE rap_albums
DROP COLUMN `type`;



-- Unión de las tablas de albums con la de género para tener el id_género correspondiente
ALTER TABLE rock_albums
ADD COLUMN id_genero INT;
UPDATE rock_albums
JOIN genero ON rock_albums.genre = genero.nombre_genero
SET rock_albums.id_genero = genero.id_genero;

ALTER TABLE pop_albums
ADD COLUMN id_genero INT;
UPDATE pop_albums
JOIN genero ON pop_albums.genre = genero.nombre_genero
SET pop_albums.id_genero = genero.id_genero;

ALTER TABLE reggaeton_albums
ADD COLUMN id_genero INT;
UPDATE reggaeton_albums
JOIN genero ON reggaeton_albums.genre = genero.nombre_genero
SET reggaeton_albums.id_genero = genero.id_genero;

ALTER TABLE rap_albums
ADD COLUMN id_genero INT;
UPDATE rap_albums
JOIN genero ON rap_albums.genre = genero.nombre_genero
SET rap_albums.id_genero = genero.id_genero;
-- Crear tabla albums a partir de ellas
CREATE TABLE albums AS
SELECT * FROM pop_albums
UNION
SELECT * FROM rock_albums
UNION
SELECT * FROM reggaeton_albums
UNION
SELECT * FROM rap_albums;

-- Primero, agregamos la columna 'id_album' como PK al principio
ALTER TABLE albums
ADD COLUMN id_album INT AUTO_INCREMENT PRIMARY KEY FIRST;

-- Cambiamos el orden de las demás columnas
ALTER TABLE albums
CHANGE COLUMN name_album titulo VARCHAR(255) AFTER id_album;

ALTER TABLE albums
ADD COLUMN id_artista INT AFTER titulo;

ALTER TABLE albums
MODIFY COLUMN id_genero INT AFTER name_artist;

ALTER TABLE albums
CHANGE COLUMN year año_lanzamiento YEAR AFTER genre;  

-- Añado las FK
ALTER TABLE albums
ADD CONSTRAINT fk_album_genero
FOREIGN KEY (id_genero)
REFERENCES genero(id_genero);

-- Falta por ejecutar porque hay que meter el id_artista en vez de nombre artista
UPDATE albums
JOIN artistas ON albums.name_artist = artistas.nombre
SET albums.id_artista = artistas.id_artista;

ALTER TABLE albums
ADD CONSTRAINT fk_album_artistas
FOREIGN KEY (id_artista)
REFERENCES artistas(id_artista);

-- Lucia
CREATE TABLE estadisticas_canciones (
	id_cancion INT,
    artist VARCHAR(255),
    listeners INT,
    playcount INT,
    PRIMARY KEY (id_cancion),
    FOREIGN KEY (id_cancion) REFERENCES canciones(id_cancion)
);


INSERT INTO estadisticas_canciones (id_cancion, artist, listeners, playcount)
SELECT
    c.id_cancion,
    tt.artist,
    tt.listeners,
    tt.playcount
FROM top_tracks tt
JOIN (
    SELECT artist, MAX(listeners) AS max_listeners
    FROM top_tracks
    GROUP BY artist
) tmax ON tt.artist = tmax.artist AND tt.listeners = tmax.max_listeners
JOIN canciones c ON tt.track = c.name_track;

ALTER TABLE estadisticas_canciones
ADD COLUMN id_artista INT;

UPDATE estadisticas_canciones e
JOIN artistas a ON e.artist = a.nombre
SET e.id_artista = a.id_artista;

ALTER TABLE estadisticas_canciones
DROP COLUMN artist;

ALTER TABLE estadisticas_canciones
ADD CONSTRAINT fk_estadisticas_artista
FOREIGN KEY (id_artista)
REFERENCES artistas(id_artista);


ALTER TABLE similar_artist
ADD COLUMN id_artista INT;

UPDATE similar_artist s
JOIN artistas a ON s.Artist = a.nombre
SET s.id_artista = a.id_artista;

ALTER TABLE similar_artist
DROP COLUMN Artist;

ALTER TABLE similar_artist
ADD CONSTRAINT fk_similar_artista
FOREIGN KEY (id_artista)
REFERENCES artistas(id_artista);

ALTER TABLE similar_artist
ADD PRIMARY KEY (id_artista);

DROP TABLE pop_albums;
DROP TABLE rock_albums;
DROP TABLE reggaeton_albums;
DROP TABLE rap_albums;
DROP TABLE pop_tracks;
DROP TABLE rock_tracks;
DROP TABLE reggaeton_tracks;
DROP TABLE rap_tracks;
DROP TABLE artist_info;
DROP TABLE top_tracks;

ALTER TABLE albums
DROP COLUMN genre;

