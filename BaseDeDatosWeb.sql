CREATE DATABASE IF NOT EXISTS TpPaginaWeb;

USE TpPaginaWeb;

CREATE TABLE prestamos (
  nombre VARCHAR(100) NOT NULL PRIMARY KEY,
  gmail VARCHAR(100) NOT NULL,
  dni VARCHAR(8) NOT NULL,
  planta VARCHAR(100) NOT NULL,
  fechaEntrega DATE NOT NULL,
  fechaDevolucion DATE NOT NULL
);

select * from prestamos;