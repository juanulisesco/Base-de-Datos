create database BaseDeDatos;
use BaseDeDatos;

-- Tabla Usuarios
CREATE TABLE Usuarios (
    DNI INT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Apellido VARCHAR(50) NOT NULL,
    Nivel VARCHAR(20),
    Reputacion DECIMAL(3,1),
    Mail VARCHAR(20)
);

-- Tabla Categorias
CREATE TABLE Categorias (
    idCategorias INT PRIMARY KEY,
    Categoria VARCHAR(50)
);

-- Tabla Productos
CREATE TABLE Productos (
    idProductos INT PRIMARY KEY,
    Nombre VARCHAR(100),
    Descripcion VARCHAR(255),
    Categorias_idCategorias INT,
    FOREIGN KEY (Categorias_idCategorias) REFERENCES Categorias(idCategorias)
);

-- Tabla Publicaciones
CREATE TABLE Publicaciones (
    idPublicacion INT PRIMARY KEY,
    Usuarios_idUsuarios INT,
    Fecha DATE,
    Productos_idProductos INT,
    Precio DECIMAL(10,2),
    Estado VARCHAR(30),
    NivelP VARCHAR(30),
    FOREIGN KEY (Usuarios_idUsuarios) REFERENCES Usuarios(DNI),
    FOREIGN KEY (Productos_idProductos) REFERENCES Productos(idProductos)
);

-- Tabla Metodo_De_Pago
CREATE TABLE Metodo_De_Pago (
    idMetodo_De_Pago INT PRIMARY KEY,
    Pago VARCHAR(50)
);

-- Tabla Metodo_De_Envio
CREATE TABLE Metodo_De_Envio (
    idMetodo_De_Envio INT PRIMARY KEY,
    Correo_envio VARCHAR(50)
);

-- Tabla Subasta
CREATE TABLE Subasta (
    idSubasta INT PRIMARY KEY,
    PrecioMin DECIMAL(10,2),
    Finalizacion DATE,
    Comienzo DATE,
    Publicaciones_idPublicaciones INT,
    FOREIGN KEY (Publicaciones_idPublicaciones) REFERENCES Publicaciones(idPublicacion)
);

-- Relación N a N entre Usuarios y Subasta
CREATE TABLE Usuarios_has_Subasta (
    Usuarios_DNI INT,
    Subasta_idSubasta INT,
    PRIMARY KEY (Usuarios_DNI, Subasta_idSubasta),
    FOREIGN KEY (Usuarios_DNI) REFERENCES Usuarios(DNI),
    FOREIGN KEY (Subasta_idSubasta) REFERENCES Subasta(idSubasta)
);

-- Tabla Preguntas
CREATE TABLE Preguntas (
    idPreguntas INT PRIMARY KEY,
    Publicaciones_idPublicaciones INT,
    ContenidoPreg VARCHAR(255),
    FOREIGN KEY (Publicaciones_idPublicaciones) REFERENCES Publicaciones(idPublicacion)
);

-- Tabla Respuestas
CREATE TABLE Respuestas (
    idRespuestas INT PRIMARY KEY,
    Preguntas_idPreguntas INT,
    Contenido VARCHAR(255),
    FOREIGN KEY (Preguntas_idPreguntas) REFERENCES Preguntas(idPreguntas)
);

-- Tabla Pedidos
CREATE TABLE Pedidos (
    idPedidos INT PRIMARY KEY,
    idMetodo_De_Envio INT,
    idMetodo_De_Pago INT,
    FechaPedido DATE,
    idPublicacion INT,
    idUsuario INT,
    idProducto INT,
    FOREIGN KEY (idMetodo_De_Envio) REFERENCES Metodo_De_Envio(idMetodo_De_Envio),
    FOREIGN KEY (idMetodo_De_Pago) REFERENCES Metodo_De_Pago(idMetodo_De_Pago),
    FOREIGN KEY (idPublicacion) REFERENCES Publicaciones(idPublicacion),
    FOREIGN KEY (idUsuario) REFERENCES Usuarios(DNI),
    FOREIGN KEY (idProducto) REFERENCES Productos(idProductos)
);

-- Relación N a N entre Metodo_De_Pago y Publicaciones
CREATE TABLE Metodo_De_Pago_has_Publicaciones (
    Metodo_De_Pago_idMetodo_De_Pago INT,
    idPublicacion INT,
    PRIMARY KEY (Metodo_De_Pago_idMetodo_De_Pago, idPublicacion),
    FOREIGN KEY (Metodo_De_Pago_idMetodo_De_Pago) REFERENCES Metodo_De_Pago(idMetodo_De_Pago),
    FOREIGN KEY (idPublicacion) REFERENCES Publicaciones(idPublicacion)
);

-- Relación N a N entre Pedido y Publicaciones
CREATE TABLE Pedido_has_Publicaciones (
    Pedidos_idPedidos INT,
    Publicaciones_idPublicacion INT,
    PRIMARY KEY (Pedidos_idPedidos, Publicaciones_idPublicacion),
    FOREIGN KEY (Pedidos_idPedidos) REFERENCES Pedidos(idPedidos),
    FOREIGN KEY (Publicaciones_idPublicacion) REFERENCES Publicaciones(idPublicacion)
);

-- Tabla: Categorias
INSERT INTO Categorias (idCategorias, Categoria) VALUES
(1, 'Electrónica'),
(2, 'Ropa'),
(3, 'Hogar'),
(4, 'Libros'),
(5, 'Juguetes');
select * from Categorias;

-- Tabla: Metodo_De_Envio
INSERT INTO Metodo_De_Envio (idMetodo_De_Envio, Correo_envio) VALUES
(20, 'Correo Argentino'),
(30, 'OCA');
select * from Metodo_De_Envio;

-- Tabla: Metodo_De_Pago
INSERT INTO Metodo_De_Pago (idMetodo_De_Pago, Pago) VALUES
(1, 'Tarjeta de Credito'),
(2, 'Tarjeta de Débito'),
(3, 'Pago Facil'),
(4, 'Rapipago');
select * from Metodo_De_Pago;

-- Tabla: Usuarios
INSERT INTO Usuarios (DNI, Nombre, Apellido, Reputacion, Nivel, Mail) VALUES
(1001, 'Juan', 'Pérez', 40, 'Normal', "123abc@live.com"),
(1002, 'Ana', 'Gómez', 71, 'Platinum', "mirthal@gmail.com"),
(1003, 'Agustin', 'Roman', 96, 'Gold', "alumno26@ipm.edu.ar");
select * from Usuarios;

-- Tabla: Productos
INSERT INTO Productos (idProductos, Nombre, Descripcion, Categorias_idCategorias) VALUES
(1, 'Smartphone', 'Teléfono Android 128GB', 1),
(2, 'Campera', 'Campera impermeable de invierno', 2);
select idProductos from Productos;

-- Tabla: Publicaciones
INSERT INTO Publicaciones (idPublicacion, Fecha, Usuarios_idUsuarios, Productos_idProductos, Precio, Estado, NivelP) VALUES
(1, '2024-05-01', 1001, 1, 150000, 'Activa',"Bronce"),
(3, '2024-05-01', 1001, 1, 150000, 'Activa',"Plata"),
(4, '2024-05-01', 1001, 1, 150000, 'Activa',"Oro"),
(2, '2024-05-02', 1002, 2, 80000, 'Activa', "Platinio");
select * from Publicaciones;

-- Tabla: Metodo_De_Pago_has_Publicaciones
INSERT INTO Metodo_De_Pago_has_Publicaciones (Metodo_De_Pago_idMetodo_De_Pago, idPublicacion) VALUES
(1, 1),
(2, 1),
(3, 2);
select * from Metodo_De_Pago_has_Publicaciones;

-- Tabla: Pedidos
INSERT INTO Pedidos (idPedidos, idMetodo_De_Envio, idMetodo_De_Pago, Usuarios_DNI, FechaPedido, CalificacionV, CaliicacionC) VALUES
(1, 1, 1, 1001, '2024-06-01', 5, 3),
(2, 2, 2, 1002, '2024-06-02', 4, 1);
select * from Pedidos;

-- Tabla: Pedidos_has_Publicaciones
INSERT INTO Pedidos_has_Publicaciones (Pedidos_idPedidos, Publicaciones_idPublicaciones) VALUES
(1, 1),
(2, 2);
select * from Pedidos_has_Publicaciones;

-- Tabla: Preguntas
INSERT INTO Preguntas (idPreguntas, Publicaciones_idPublicaciones, ContenidoPreg) VALUES
(1, 1, '¿Viene con cargador?'),
(2, 2, '¿Qué talles disponibles hay?');
select * from Preguntas;

-- Tabla: Respuestas
INSERT INTO Respuestas (idRespuestas, Preguntas_idPreguntas, Contenido) VALUES
(1, 1, 'Sí, incluye cargador.'),
(2, 2, 'Tenemos M y L.');
select * from Respuestas;

-- Tabla: Subasta
INSERT INTO Subasta (idSubasta, PrecioMin, Finalizacion, Comienzo, Publicaciones_idPublicaciones) VALUES
(1, 120000, '2024-06-30', '2024-06-01', 1),
(2, 60000, '2024-06-25', '2024-06-05', 2);
select * from Subasta;

-- Tabla: Usuarios_has_Subasta
INSERT INTO Usuarios_has_Subasta (Usuarios_DNI, Subasta_idSubasta) VALUES
(1001, 1),
(1002, 2);
select * from Usuarios_has_Subasta;
