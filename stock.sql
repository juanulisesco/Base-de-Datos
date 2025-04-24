-- phpMyAdmin SQL Dump
-- version 5.0.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 23-05-2020 a las 17:01:14
-- Versión del servidor: 10.4.11-MariaDB
-- Versión de PHP: 7.2.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `stock`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `borrarForaneasPedidos` (IN `idPedido` INT)  begin
delete from pedido_producto where Pedido_idPedido=idPedido;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `calcular_y_actualizar_categoria` (IN `codCliente` VARCHAR(45))  begin
declare montoTotal decimal(10,2);
declare categoriaNueva varchar(45);
select sum(precioUnitario*cantidad) into montoTotal from pedido join pedido_producto on idPedido=Producto_codProducto where Cliente_codCliente=codCliente and timestampdiff(year,now(),fecha)<2; 
if montoTotal<50000 then
set categoriaNueva="chico";
else if montoTotal>50000 and montoTotal<= 1000000 then
set categoriaNueva="mediano";
else
set categoriaNueva="grande";
end if;
end if;
update cliente set categoria=categoriaNueva;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categoria`
--

CREATE TABLE `categoria` (
  `idCategoria` int(11) NOT NULL,
  `nombre` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `categoria`
--

INSERT INTO `categoria` (`idCategoria`, `nombre`) VALUES
(1, 'Frutas');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cliente`
--

CREATE TABLE `cliente` (
  `codCliente` varchar(20) NOT NULL,
  `razonSocial` varchar(45) DEFAULT NULL,
  `contacto` varchar(45) DEFAULT NULL,
  `direccion` varchar(45) DEFAULT NULL,
  `telefono` varchar(45) DEFAULT NULL,
  `codPost` varchar(10) DEFAULT NULL,
  `porcDescuento` decimal(10,2) DEFAULT NULL,
  `Provincia_idProvincia` int(11) NOT NULL,
  `categoria` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `cliente`
--

INSERT INTO `cliente` (`codCliente`, `razonSocial`, `contacto`, `direccion`, `telefono`, `codPost`, `porcDescuento`, `Provincia_idProvincia`, `categoria`) VALUES
('1', NULL, 'PEPE', 'Capdevilla 2345', '4521-7896', '1431', '0.00', 1, 'grande');

--
-- Disparadores `cliente`
--
DELIMITER $$
CREATE TRIGGER `cliente_after_insert` AFTER INSERT ON `cliente` FOR EACH ROW begin
insert into clientes_audit set operacion="insert", user=current_user(), last_date_modified=now(),codCliente=new.codCliente, razonSocial=new.razonSocial, contacto=new.contacto,
direccion=new.direccion, telefono=new.telefono, codPost=new.codPost, porcDescuento=new.porcDescuento, Provincia_idProvincia=new.Provincia_idProvincia;	
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `cliente_before_delete` BEFORE DELETE ON `cliente` FOR EACH ROW begin
insert into clientes_audit set operacion="delete", user=current_user(), last_date_modified=now(), codCliente=old.codCliente, razonSocial=old.razonSocial, contacto=old.contacto,
direccion=old.direccion, telefono=old.telefono, codPost=old.codPost, porcDescuento=old.porcDescuento, Provincia_idProvincia=old.Provincia_idProvincia;
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `cliente_before_update` BEFORE UPDATE ON `cliente` FOR EACH ROW begin
insert into clientes_audit set operacion="update", user=current_user(), last_date_modified=now(), codCliente=old.codCliente, razonSocial=old.razonSocial, contacto=old.contacto,
direccion=old.direccion, telefono=old.telefono, codPost=old.codPost, porcDescuento=old.porcDescuento, Provincia_idProvincia=old.Provincia_idProvincia;
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes_audit`
--

CREATE TABLE `clientes_audit` (
  `idAudit` int(11) NOT NULL,
  `operacion` char(6) DEFAULT NULL,
  `user` varchar(45) DEFAULT NULL,
  `last_date_modified` date DEFAULT NULL,
  `codCliente` varchar(20) DEFAULT NULL,
  `razonSocial` varchar(45) DEFAULT NULL,
  `contacto` varchar(45) DEFAULT NULL,
  `direccion` varchar(45) DEFAULT NULL,
  `telefono` varchar(45) DEFAULT NULL,
  `codPost` varchar(10) DEFAULT NULL,
  `porcDescuento` decimal(10,2) DEFAULT NULL,
  `Provincia_idProvincia` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `clientes_audit`
--

INSERT INTO `clientes_audit` (`idAudit`, `operacion`, `user`, `last_date_modified`, `codCliente`, `razonSocial`, `contacto`, `direccion`, `telefono`, `codPost`, `porcDescuento`, `Provincia_idProvincia`) VALUES
(1, 'insert', 'root@localhost', '2020-05-23', '1', NULL, 'PEPE', 'Capdevilla 2345', '4521-7896', '1431', '0.00', 1),
(2, 'update', 'root@localhost', '2020-05-23', '1', NULL, 'PEPE', 'Capdevilla 2345', '4521-7896', '1431', '0.00', 1),
(3, 'delete', 'root@localhost', '2020-05-23', '1', NULL, 'Pepe', 'Capdevilla 2345', '4521-7896', '1431', '0.00', 1),
(4, 'insert', 'root@localhost', '2020-05-23', '1', NULL, 'PEPE', 'Capdevilla 2345', '4521-7896', '1431', '0.00', 1),
(5, 'update', 'root@localhost', '2020-05-23', '1', NULL, 'PEPE', 'Capdevilla 2345', '4521-7896', '1431', '0.00', 1),
(6, 'update', 'root@localhost', '2020-05-23', '1', NULL, 'PEPE', 'Capdevilla 2345', '4521-7896', '1431', '0.00', 1),
(7, 'update', 'root@localhost', '2020-05-23', '1', NULL, 'PEPE', 'Capdevilla 2345', '4521-7896', '1431', '0.00', 1),
(8, 'update', 'root@localhost', '2020-05-23', '1', NULL, 'PEPE', 'Capdevilla 2345', '4521-7896', '1431', '0.00', 1),
(9, 'update', 'root@localhost', '2020-05-23', '1', NULL, 'PEPE', 'Capdevilla 2345', '4521-7896', '1431', '0.00', 1),
(10, 'update', 'root@localhost', '2020-05-23', '1', NULL, 'PEPE', 'Capdevilla 2345', '4521-7896', '1431', '0.00', 1),
(11, 'update', 'root@localhost', '2020-05-23', '1', NULL, 'PEPE', 'Capdevilla 2345', '4521-7896', '1431', '0.00', 1),
(12, 'update', 'root@localhost', '2020-05-23', '1', NULL, 'PEPE', 'Capdevilla 2345', '4521-7896', '1431', '0.00', 1),
(13, 'update', 'root@localhost', '2020-05-23', '1', NULL, 'PEPE', 'Capdevilla 2345', '4521-7896', '1431', '0.00', 1),
(14, 'update', 'root@localhost', '2020-05-23', '1', NULL, 'PEPE', 'Capdevilla 2345', '4521-7896', '1431', '0.00', 1),
(15, 'update', 'root@localhost', '2020-05-23', '1', NULL, 'PEPE', 'Capdevilla 2345', '4521-7896', '1431', '0.00', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estado`
--

CREATE TABLE `estado` (
  `idEstado` int(11) NOT NULL,
  `nombre` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `estado`
--

INSERT INTO `estado` (`idEstado`, `nombre`) VALUES
(1, 'Por enviar');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ingresostock`
--

CREATE TABLE `ingresostock` (
  `idIngreso` int(11) NOT NULL,
  `fecha` datetime DEFAULT NULL,
  `remitoNro` varchar(45) DEFAULT NULL,
  `Proveedor_idProveedor` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `ingresostock`
--

INSERT INTO `ingresostock` (`idIngreso`, `fecha`, `remitoNro`, `Proveedor_idProveedor`) VALUES
(1, '2020-02-02 00:00:00', '1', 1);

--
-- Disparadores `ingresostock`
--
DELIMITER $$
CREATE TRIGGER `ingresoStock_before_delete` BEFORE DELETE ON `ingresostock` FOR EACH ROW begin
delete from ingresostock_producto where IngresoStock_idIngreso=old.idIngreso;
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ingresostock_producto`
--

CREATE TABLE `ingresostock_producto` (
  `item` int(11) NOT NULL,
  `cantidad` int(11) DEFAULT NULL,
  `IngresoStock_idIngreso` int(11) NOT NULL,
  `Producto_codProducto` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `ingresostock_producto`
--

INSERT INTO `ingresostock_producto` (`item`, `cantidad`, `IngresoStock_idIngreso`, `Producto_codProducto`) VALUES
(1, 20, 1, 1);

--
-- Disparadores `ingresostock_producto`
--
DELIMITER $$
CREATE TRIGGER `incrementarStock_before_insert` BEFORE INSERT ON `ingresostock_producto` FOR EACH ROW begin
update producto set stock=stock+new.cantidad;
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedido`
--

CREATE TABLE `pedido` (
  `idPedido` int(11) NOT NULL,
  `fecha` datetime DEFAULT NULL,
  `Estado_idEstado` int(11) NOT NULL,
  `Cliente_codCliente` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `pedido`
--

INSERT INTO `pedido` (`idPedido`, `fecha`, `Estado_idEstado`, `Cliente_codCliente`) VALUES
(2, '2020-05-24 00:00:00', 1, '1'),
(3, '2005-05-24 00:00:00', 1, '1'),
(4, '2005-05-24 00:00:00', 1, '1'),
(5, '2005-05-24 00:00:00', 1, '1'),
(6, '2005-05-24 00:00:00', 1, '1');

--
-- Disparadores `pedido`
--
DELIMITER $$
CREATE TRIGGER `actualizarCategoria_after_insert` AFTER INSERT ON `pedido` FOR EACH ROW begin
call calcular_Y_Actualizar_Categoria(new.Cliente_codCliente);
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `pedido_before_delete` BEFORE DELETE ON `pedido` FOR EACH ROW begin
call borrarForaneasPedidos(old.idPedido);
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedido_producto`
--

CREATE TABLE `pedido_producto` (
  `item` int(11) NOT NULL,
  `cantidad` int(11) DEFAULT NULL,
  `precioUnitario` decimal(10,2) DEFAULT NULL,
  `Producto_codProducto` int(11) NOT NULL,
  `Pedido_idPedido` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `pedido_producto`
--

INSERT INTO `pedido_producto` (`item`, `cantidad`, `precioUnitario`, `Producto_codProducto`, `Pedido_idPedido`) VALUES
(3, 5, '20.00', 1, 2);

--
-- Disparadores `pedido_producto`
--
DELIMITER $$
CREATE TRIGGER `actualizar_stock` AFTER INSERT ON `pedido_producto` FOR EACH ROW begin
update ingresostock_producto set cantidad=cantidad-new.cantidad where producto_codProducto=new.producto_codProducto;
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto`
--

CREATE TABLE `producto` (
  `codProducto` int(11) NOT NULL,
  `descripcion` varchar(100) DEFAULT NULL,
  `precio` decimal(10,2) DEFAULT NULL,
  `Categoria_idCategoria` int(11) NOT NULL,
  `stock` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `producto`
--

INSERT INTO `producto` (`codProducto`, `descripcion`, `precio`, `Categoria_idCategoria`, `stock`) VALUES
(1, 'Manzanas', '20.00', 1, 60);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto_proveedor`
--

CREATE TABLE `producto_proveedor` (
  `Proveedor_idProveedor` int(11) NOT NULL,
  `Producto_codProducto` int(11) NOT NULL,
  `precio` decimal(10,2) DEFAULT NULL,
  `demoraEntrega` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto_ubicacion`
--

CREATE TABLE `producto_ubicacion` (
  `idProducto_Ubicacion` int(11) NOT NULL,
  `cantidad` int(11) DEFAULT NULL,
  `estanteria` varchar(45) DEFAULT NULL,
  `Producto_codProducto` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedor`
--

CREATE TABLE `proveedor` (
  `idProveedor` int(11) NOT NULL,
  `razonSocial` varchar(45) DEFAULT NULL,
  `contacto` varchar(45) DEFAULT NULL,
  `direccion` varchar(45) DEFAULT NULL,
  `telefono` varchar(45) DEFAULT NULL,
  `codPost` varchar(10) DEFAULT NULL,
  `Provincia_idProvincia` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `proveedor`
--

INSERT INTO `proveedor` (`idProveedor`, `razonSocial`, `contacto`, `direccion`, `telefono`, `codPost`, `Provincia_idProvincia`) VALUES
(1, NULL, 'Manuel', 'Ciudad de la paz 2334', '1551263578', '1425', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `provincia`
--

CREATE TABLE `provincia` (
  `idProvincia` int(11) NOT NULL,
  `nombre` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `provincia`
--

INSERT INTO `provincia` (`idProvincia`, `nombre`) VALUES
(1, 'Buenos Aires'),
(2, 'Buenos Aires');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `categoria`
--
ALTER TABLE `categoria`
  ADD PRIMARY KEY (`idCategoria`);

--
-- Indices de la tabla `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`codCliente`),
  ADD KEY `fk_Cliente_Provincia` (`Provincia_idProvincia`);

--
-- Indices de la tabla `clientes_audit`
--
ALTER TABLE `clientes_audit`
  ADD PRIMARY KEY (`idAudit`);

--
-- Indices de la tabla `estado`
--
ALTER TABLE `estado`
  ADD PRIMARY KEY (`idEstado`);

--
-- Indices de la tabla `ingresostock`
--
ALTER TABLE `ingresostock`
  ADD PRIMARY KEY (`idIngreso`),
  ADD KEY `fk_IngresoStock_Proveedor1_idx` (`Proveedor_idProveedor`);

--
-- Indices de la tabla `ingresostock_producto`
--
ALTER TABLE `ingresostock_producto`
  ADD PRIMARY KEY (`item`,`IngresoStock_idIngreso`),
  ADD KEY `fk_IngresoStock_Producto_IngresoStock1_idx` (`IngresoStock_idIngreso`),
  ADD KEY `fk_IngresoStock_Producto_Producto1_idx` (`Producto_codProducto`);

--
-- Indices de la tabla `pedido`
--
ALTER TABLE `pedido`
  ADD PRIMARY KEY (`idPedido`),
  ADD KEY `fk_Pedido_Estado1_idx` (`Estado_idEstado`),
  ADD KEY `fk_Pedido_Cliente1_idx` (`Cliente_codCliente`);

--
-- Indices de la tabla `pedido_producto`
--
ALTER TABLE `pedido_producto`
  ADD PRIMARY KEY (`item`,`Pedido_idPedido`),
  ADD KEY `fk_Pedido_Producto_Producto1_idx` (`Producto_codProducto`),
  ADD KEY `fk_Pedido_Producto_Pedido1_idx` (`Pedido_idPedido`);

--
-- Indices de la tabla `producto`
--
ALTER TABLE `producto`
  ADD PRIMARY KEY (`codProducto`),
  ADD KEY `fk_Producto_Categoria1_idx` (`Categoria_idCategoria`);

--
-- Indices de la tabla `producto_proveedor`
--
ALTER TABLE `producto_proveedor`
  ADD PRIMARY KEY (`Proveedor_idProveedor`,`Producto_codProducto`),
  ADD KEY `fk_Proveedor_has_Producto_Producto1_idx` (`Producto_codProducto`),
  ADD KEY `fk_Proveedor_has_Producto_Proveedor1_idx` (`Proveedor_idProveedor`);

--
-- Indices de la tabla `producto_ubicacion`
--
ALTER TABLE `producto_ubicacion`
  ADD PRIMARY KEY (`idProducto_Ubicacion`),
  ADD KEY `fk_Producto_Ubicacion_Producto1_idx` (`Producto_codProducto`);

--
-- Indices de la tabla `proveedor`
--
ALTER TABLE `proveedor`
  ADD PRIMARY KEY (`idProveedor`),
  ADD KEY `fk_Proveedor_Provincia1_idx` (`Provincia_idProvincia`);

--
-- Indices de la tabla `provincia`
--
ALTER TABLE `provincia`
  ADD PRIMARY KEY (`idProvincia`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `categoria`
--
ALTER TABLE `categoria`
  MODIFY `idCategoria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `clientes_audit`
--
ALTER TABLE `clientes_audit`
  MODIFY `idAudit` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT de la tabla `estado`
--
ALTER TABLE `estado`
  MODIFY `idEstado` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `pedido_producto`
--
ALTER TABLE `pedido_producto`
  MODIFY `item` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `producto`
--
ALTER TABLE `producto`
  MODIFY `codProducto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `provincia`
--
ALTER TABLE `provincia`
  MODIFY `idProvincia` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `cliente`
--
ALTER TABLE `cliente`
  ADD CONSTRAINT `fk_Cliente_Provincia` FOREIGN KEY (`Provincia_idProvincia`) REFERENCES `provincia` (`idProvincia`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `ingresostock`
--
ALTER TABLE `ingresostock`
  ADD CONSTRAINT `fk_IngresoStock_Proveedor1` FOREIGN KEY (`Proveedor_idProveedor`) REFERENCES `proveedor` (`idProveedor`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `ingresostock_producto`
--
ALTER TABLE `ingresostock_producto`
  ADD CONSTRAINT `fk_IngresoStock_Producto_IngresoStock1` FOREIGN KEY (`IngresoStock_idIngreso`) REFERENCES `ingresostock` (`idIngreso`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_IngresoStock_Producto_Producto1` FOREIGN KEY (`Producto_codProducto`) REFERENCES `producto` (`codProducto`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `pedido`
--
ALTER TABLE `pedido`
  ADD CONSTRAINT `fk_Pedido_Cliente1` FOREIGN KEY (`Cliente_codCliente`) REFERENCES `cliente` (`codCliente`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Pedido_Estado1` FOREIGN KEY (`Estado_idEstado`) REFERENCES `estado` (`idEstado`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `pedido_producto`
--
ALTER TABLE `pedido_producto`
  ADD CONSTRAINT `fk_Pedido_Producto_Pedido1` FOREIGN KEY (`Pedido_idPedido`) REFERENCES `pedido` (`idPedido`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Pedido_Producto_Producto1` FOREIGN KEY (`Producto_codProducto`) REFERENCES `producto` (`codProducto`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `producto`
--
ALTER TABLE `producto`
  ADD CONSTRAINT `fk_Producto_Categoria1` FOREIGN KEY (`Categoria_idCategoria`) REFERENCES `categoria` (`idCategoria`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `producto_proveedor`
--
ALTER TABLE `producto_proveedor`
  ADD CONSTRAINT `fk_Proveedor_has_Producto_Producto1` FOREIGN KEY (`Producto_codProducto`) REFERENCES `producto` (`codProducto`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Proveedor_has_Producto_Proveedor1` FOREIGN KEY (`Proveedor_idProveedor`) REFERENCES `proveedor` (`idProveedor`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `producto_ubicacion`
--
ALTER TABLE `producto_ubicacion`
  ADD CONSTRAINT `fk_Producto_Ubicacion_Producto1` FOREIGN KEY (`Producto_codProducto`) REFERENCES `producto` (`codProducto`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `proveedor`
--
ALTER TABLE `proveedor`
  ADD CONSTRAINT `fk_Proveedor_Provincia1` FOREIGN KEY (`Provincia_idProvincia`) REFERENCES `provincia` (`idProvincia`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

#tema 1:
#punto 1) 

delimiter //
create function ClienteFrecuente (codCliente int) returns varchar (45) deterministic 
begin
declare frecuente varchar(45);
declare cantTotal int default 0;
declare cantCliente int default 0;
select count(idPedido) into cantTotal from pedido where timestampdiff(month, fecha, current_date()) < 6 ;
select count(Cliente_codCliente) into cantCliente from pedido where codCliente = Cliente_codCliente 
and timestampdiff(month, fecha, current_date()) < 6 ;
if cantCliente / cantTotal >= 0.05 then set frecuente= "Es frecuente";
else set frecuente = "No es frecuente";
end if;
return frecuente;
end //
delimiter ;
select ClienteFrecuente ('1');

#punto 4)
drop function Estados;
delimiter //
create function Estados (codCliente int) returns int deterministic 
begin
declare cantTotale int default 0;
select count(idPedido) into cantTotale from pedido 
join estado on Estado_idEstado= idEstado where nombre= "No pagado" and codCliente= Cliente_codCliente;  
return cantTotale;
end //
delimiter ;
select Estados ('1');

#tema 2:
#punto 1)
delimiter //
create function pepe (codProv int) returns int deterministic 
begin
declare cantTotale int default 0;
declare cantTotales int default 0;
declare prove varchar(45);
declare canta varchar(45);
select count(idIngreso) into cantToales;
select count(idPoveedor) into prove from proveedor where idProveedor= codProv;  
return cantTotale;
end //
delimiter ;
select pepe ('1');

#punto 2)

delimiter //
create function promProve ( codeprod int) returns int deterministic 
begin
declare promedio int default 0;
select avg (precio) into promedio from producto where codeprod = codProducto ;  
return promedio;
end //
delimiter ;
select promProve(1);

#tema 3:
#punto 1)
delimiter //
create function cantidades ( codeprod int) returns int deterministic 
begin
declare cantidad int default 0;
select sum(cantEntradas) into cantidad from compra where funcion_idFuncion = codeprod;  
return promedio;
end //
delimiter ;
select promProve(1);

#punto 2)
delimiter //
create function calcula ( codClie int) returns int deterministic 
begin
declare cantidad int;
select sum(cantEntradas) into cantidad from compra where funcion_idFuncion = codClientes;  
return cantidad;
end //
delimiter ;
delete from cliente where cantidades(codCliente)<=0;

#Triggers

#1) 
delimiter //
create trigger a_pedido_producto_u after update on pedido_producto for each row
begin
update ingresostock_producto set cantidad = cantidad - new.cantidad 
where Producto_codProducto = new.Producto_codProducto;
end//
delimiter ;	

#2)



