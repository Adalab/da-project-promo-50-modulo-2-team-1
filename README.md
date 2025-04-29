# da-project-promo-50-modulo-2-team-1

🎵 **Proyecto MusicStream: análisis de popularidad de canciones en la era digital** 🎵

El proyecto consiste en el análisis de la popularidad de canciones y álbumes lanzados entre 2019 y 2024, pertenecientes a los siguientes géneros musicales: rock, pop, reggaetón y rap. 🎸🤘💃📻
Te contamos cómo lo hicimos!

**Para comenzar...**
Hemos extraído la información que necesitábamos para crear la BBDD a través de las APIs Spotify y Last.fm.
El código utilizado en esta primera fase se puede consultar en el archivo llamado **data_api_music_stream.ipynb**. Para ello, hemos diseñado una función que permite obtener 1000 canciones de un determinado género musical, las guarda en una lista y crea un documento CSV con la información 📑. En nuestro caso, hemos llamado a la función en varias ocasiones para los géneros mencionados al inicio: rock, pop, reggaetón y rap. Ajustamos y repetimos el proceso para obtener 1000 álbumes de los cuatro géneros seleccionados. 
A continuación, hemos recopilado todos los artistas identificados en el paso anterior, para luego poder ampliar la información con la biografía de los mismos, artistas similares y canciones top, y guardarla en documentos CSV 💾.

**...Organizando la información...**
Tras la recopilación de datos, organizamos nuestras ideas y, por supuesto, la información!💡💭 Esto nos permitiría crear una BBDD estructurada en SQL para poder realizar las consultas que queramos📋 y responder a algunas curiosidades.

**...SQL, SQL, ¿cuál es el artista con más álbumes del reino👑?**
Llegados a este punto, como si se tratase de un espejo mágico, preguntamos a SQL lo que más nos intriga!🎉


❔
🔍
