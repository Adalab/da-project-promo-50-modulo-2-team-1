CREATE DATABASE bd_musicstream;
USE bd_musicstream;

CREATE TABLE genero(
	id_genero INT AUTO_INCREMENT PRIMARY KEY,
    nombre_genero VARCHAR(10));
    
INSERT INTO genero (nombre_genero) 
VALUES ('rock'), ('pop'), ('reggaeton'), ('rap');

CREATE TABLE canciones AS
SELECT * FROM pop_tracks
UNION
SELECT * FROM rock_tracks
UNION
SELECT * FROM reggaeton_tracks
UNION
SELECT * FROM rap_tracks;
-- Limpieza tablas creadas a partir de los datos cargados desde Python
ALTER TABLE rock_albums
DROP COLUMN `Unnamed: 0`;

ALTER TABLE pop_albums
DROP COLUMN `Unnamed: 0`;

ALTER TABLE reggaeton_albums
DROP COLUMN `Unnamed: 0`;

ALTER TABLE rap_albums
DROP COLUMN `Unnamed: 0`;

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
JOIN artistas ON albums.name_artist = artistas.name_artist
SET albums.id_artista = artistas.id_artista;

ALTER TABLE albums
ADD CONSTRAINT fk_album_artista
FOREIGN KEY (id_artista)
REFERENCES artista(id_artista);

-- si queremos podemos borrar las tablas que hemos subido desde python porque tp nos sirven y no se borran los datos insertados






