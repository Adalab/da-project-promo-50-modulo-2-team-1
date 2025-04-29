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