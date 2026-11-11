CREATE DATABASE IF NOT EXISTS dw_ciencia_ficcion

CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE dw_ciencia_ficcion;

-- 1. Dimensión Subgénero (12 subgéneros extraídos de los archivos)
CREATE TABLE IF NOT EXISTS dimension_subgenero (
    id_subgenero INT AUTO_INCREMENT PRIMARY KEY,
    nombre_subgenero VARCHAR(100) NOT NULL UNIQUE
);

-- 2. Dimensión Idioma (14 idiomas + 1 para los nulos)
CREATE TABLE IF NOT EXISTS dimension_idioma (
    id_idioma INT AUTO_INCREMENT PRIMARY KEY,
    idioma_edicion VARCHAR(50) NOT NULL UNIQUE
);

-- 3. Dimensión Autor (3,973 autores únicos)
CREATE TABLE IF NOT EXISTS dimension_autor (
    id_autor INT AUTO_INCREMENT PRIMARY KEY,
    nombre_autor VARCHAR(255) NOT NULL UNIQUE
);

-- 4. Dimensión Tiempo de Publicación (Años únicos + registro para año 0)
CREATE TABLE IF NOT EXISTS dimension_tiempo_publicacion (
    id_tiempo INT AUTO_INCREMENT PRIMARY KEY,
    anio_publicacion INT NOT NULL UNIQUE,
    decada VARCHAR(30) NOT NULL,
    siglo VARCHAR(30) NOT NULL
);

-- 5. Dimensión Libro (11,104 obras únicas identificadas por URL)
CREATE TABLE IF NOT EXISTS dimension_libro (
    id_libro INT AUTO_INCREMENT PRIMARY KEY,
    url_goodreads VARCHAR(500) NOT NULL UNIQUE,
    titulo_libro VARCHAR(500) NOT NULL,
    titulo_original VARCHAR(500),
    descripcion_libro TEXT
);

-- 6. Tabla de Hechos: Presencia y métricas del libro por subgénero
CREATE TABLE IF NOT EXISTS tabla_hechos_libros_subgenero (
    id_hecho INT AUTO_INCREMENT PRIMARY KEY,
    id_libro INT NOT NULL,
    id_autor INT NOT NULL,
    id_idioma INT NOT NULL,
    id_subgenero INT NOT NULL,
    id_tiempo INT NOT NULL,
    calificacion_promedio DECIMAL(4,2) NOT NULL,
    cantidad_votos INT NOT NULL,
    cantidad_resenas INT NOT NULL,
    -- Restricción para evitar duplicados exactos (como los 15 de sf_space_opera)
    UNIQUE KEY uk_libro_subgenero (id_libro, id_subgenero),
    FOREIGN KEY (id_libro) REFERENCES dimension_libro(id_libro),
    FOREIGN KEY (id_autor) REFERENCES dimension_autor(id_autor),
    FOREIGN KEY (id_idioma) REFERENCES dimension_idioma(id_idioma),
    FOREIGN KEY (id_subgenero) REFERENCES dimension_subgenero(id_subgenero),
    FOREIGN KEY (id_tiempo) REFERENCES dimension_tiempo_publicacion(id_tiempo)
);


USE dw_ciencia_ficcion;

CREATE TABLE IF NOT EXISTS fuente_libros_crudos (
    id_fila_fuente INT AUTO_INCREMENT PRIMARY KEY,
    subgenero_archivo VARCHAR(100),
    titulo_libro VARCHAR(500),
    titulo_original VARCHAR(500),
    nombre_autor VARCHAR(255),
    idioma_edicion VARCHAR(50),
    calificacion_promedio DECIMAL(4,2),
    cantidad_votos INT,
    cantidad_resenas INT,
    descripcion_libro TEXT,
    anio_publicacion INT,
    generos_json TEXT,
    url_goodreads VARCHAR(500)
);
