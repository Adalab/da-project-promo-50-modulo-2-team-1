CREATE DATABASE bd_musicstream;

USE bd_musicstream;
-- Tabla género
CREATE TABLE genero(
	id_genero INT AUTO_INCREMENT PRIMARY KEY,
    nombre_genero VARCHAR(10));
    
INSERT INTO genero (nombre_genero) 
VALUES ('rock'), ('pop'), ('reggaeton'), ('rap');

-- Tabla artistas
CREATE TABLE artistas LIKE artist_info;

INSERT INTO artistas
SELECT *
FROM artist_info;

ALTER TABLE artistas
DROP COLUMN playcount,
DROP COLUMN listeners;

ALTER TABLE artistas
ADD COLUMN id_artista INT AUTO_INCREMENT PRIMARY KEY;

ALTER TABLE artistas
MODIFY COLUMN id_artista INT FIRST,
CHANGE COLUMN artist nombre VARCHAR(255) AFTER id_artista,
CHANGE COLUMN biography biografia TEXT AFTER nombre;

-- Tabla canciones

CREATE TABLE canciones AS
SELECT * FROM pop_tracks
UNION
SELECT * FROM rock_tracks
UNION
SELECT * FROM reggaeton_tracks
UNION
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

ALTER TABLE canciones
MODIFY COLUMN id_cancion INT NOT NULL FIRST,
CHANGE COLUMN name_track titulo VARCHAR(255) AFTER id_cancion,
MODIFY COLUMN id_artista INT AFTER titulo,
MODIFY COLUMN id_genero INT AFTER id_artista,
CHANGE COLUMN year año_lanzamiento INT AFTER id_genero;


-- Tabla albums
ALTER TABLE rock_albums
DROP COLUMN `type`;
ALTER TABLE rock_albums
DROP COLUMN `Unnamed: 0`;

ALTER TABLE pop_albums
DROP COLUMN `type`;
ALTER TABLE pop_albums
DROP COLUMN `Unnamed: 0`;

ALTER TABLE reggaeton_albums
DROP COLUMN `type`;
ALTER TABLE reggaeton_albums
DROP COLUMN `Unnamed: 0`;

ALTER TABLE rap_albums
DROP COLUMN `type`;
ALTER TABLE rap_albums
DROP COLUMN `Unnamed: 0`;

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


CREATE TABLE albums AS
SELECT * FROM pop_albums
UNION
SELECT * FROM rock_albums
UNION
SELECT * FROM reggaeton_albums
UNION
SELECT * FROM rap_albums;

ALTER TABLE albums
DROP COLUMN genre;

ALTER TABLE albums
ADD COLUMN id_album INT AUTO_INCREMENT PRIMARY KEY FIRST;

ALTER TABLE albums
CHANGE COLUMN name_album titulo VARCHAR(255) AFTER id_album,
ADD COLUMN id_artista INT AFTER titulo,
MODIFY COLUMN id_genero INT AFTER name_artist,
CHANGE COLUMN year año_lanzamiento YEAR AFTER id_genero;

ALTER TABLE albums
ADD CONSTRAINT fk_album_genero
FOREIGN KEY (id_genero)
REFERENCES genero(id_genero);

UPDATE albums
JOIN artistas ON albums.name_artist = artistas.nombre
SET albums.id_artista = artistas.id_artista;

ALTER TABLE albums
DROP COLUMN name_artist;

ALTER TABLE albums
ADD CONSTRAINT fk_album_artistas
FOREIGN KEY (id_artista)
REFERENCES artistas(id_artista);

-- Tabla estadisticas_canciones

CREATE TABLE estadisticas_canciones (
    id_estadistica INT AUTO_INCREMENT PRIMARY KEY,
    id_cancion INT,
    artist VARCHAR(255),
    listeners INT,
    playcount INT,
    FOREIGN KEY (id_cancion) REFERENCES canciones(id_cancion)
);

INSERT INTO estadisticas_canciones (id_cancion, artist, listeners, playcount)
SELECT DISTINCT
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
JOIN canciones c ON tt.track = c.titulo;

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

ALTER TABLE estadisticas_canciones
MODIFY COLUMN id_estadistica INT NOT NULL FIRST,
MODIFY COLUMN id_cancion INT AFTER id_estadistica,
MODIFY COLUMN id_artista INT AFTER id_cancion,
MODIFY COLUMN listeners INT AFTER id_artista,
MODIFY COLUMN playcount INT AFTER listeners;

-- Tabla similar artist

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

ALTER TABLE similar_artist
MODIFY COLUMN id_artista INT NOT NULL FIRST,
CHANGE COLUMN Similar similar TEXT AFTER id_artista;

-- Eliminar tablas que no necesitamos

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