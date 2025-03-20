-- MySQL dump 10.13  Distrib 8.0.36, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: almacen
-- ------------------------------------------------------
-- Server version	8.0.40-0ubuntu0.22.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `almacen`
--

DROP TABLE IF EXISTS `almacen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `almacen` (
  `codigo` int NOT NULL,
  `responsable` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `almacen`
--

LOCK TABLES `almacen` WRITE;
/*!40000 ALTER TABLE `almacen` DISABLE KEYS */;
INSERT INTO `almacen` VALUES (1,'Juan Pérez'),(2,'Ana López'),(3,'Carlos Gómez');
/*!40000 ALTER TABLE `almacen` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `articulo`
--

DROP TABLE IF EXISTS `articulo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `articulo` (
  `codigo` int NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(45) DEFAULT NULL,
  `precio` decimal(10,0) DEFAULT NULL,
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `articulo`
--

LOCK TABLES `articulo` WRITE;
/*!40000 ALTER TABLE `articulo` DISABLE KEYS */;
INSERT INTO `articulo` VALUES (1,'Martillo',7500),(2,'Destornillador',5000),(3,'Taladro',45000),(4,'Sierra',3000);
/*!40000 ALTER TABLE `articulo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `compuesto_por`
--

DROP TABLE IF EXISTS `compuesto_por`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `compuesto_por` (
  `articulo_codigo` int NOT NULL,
  `material_codigo` int NOT NULL,
  PRIMARY KEY (`articulo_codigo`,`material_codigo`),
  KEY `fk_Articulos_has_Material_Material1_idx` (`material_codigo`),
  KEY `fk_Articulos_has_Material_Articulos1_idx` (`articulo_codigo`),
  CONSTRAINT `fk_Articulos_has_Material_Articulos1` FOREIGN KEY (`articulo_codigo`) REFERENCES `articulo` (`codigo`),
  CONSTRAINT `fk_Articulos_has_Material_Material1` FOREIGN KEY (`material_codigo`) REFERENCES `material` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `compuesto_por`
--

LOCK TABLES `compuesto_por` WRITE;
/*!40000 ALTER TABLE `compuesto_por` DISABLE KEYS */;
INSERT INTO `compuesto_por` VALUES (1,2),(2,2),(3,2),(4,2),(1,3),(3,3);
/*!40000 ALTER TABLE `compuesto_por` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `material`
--

DROP TABLE IF EXISTS `material`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `material` (
  `codigo` int NOT NULL,
  `descripcion` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `material`
--

LOCK TABLES `material` WRITE;
/*!40000 ALTER TABLE `material` DISABLE KEYS */;
INSERT INTO `material` VALUES (1,'Madera'),(2,'Metal'),(3,'Plástico'),(4,'Vidrio');
/*!40000 ALTER TABLE `material` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proveedor`
--

DROP TABLE IF EXISTS `proveedor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proveedor` (
  `codigo` int NOT NULL,
  `nombre` varchar(30) DEFAULT NULL,
  `domicilio` varchar(30) DEFAULT NULL,
  `ciudad` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proveedor`
--

LOCK TABLES `proveedor` WRITE;
/*!40000 ALTER TABLE `proveedor` DISABLE KEYS */;
INSERT INTO `proveedor` VALUES (1,'Lopez SA','Av. Siempre Viva 123','La Plata'),(2,'Proveedor B','Calle Falsa 456','Mar del Plata'),(3,'Proveedor C','Av. Los Olivos 789','Rosario');
/*!40000 ALTER TABLE `proveedor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `provisto_por`
--

DROP TABLE IF EXISTS `provisto_por`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `provisto_por` (
  `material_codigo` int NOT NULL,
  `proveedor_codigo` int NOT NULL,
  PRIMARY KEY (`material_codigo`,`proveedor_codigo`),
  KEY `fk_Material_has_Proveedor_Proveedor1_idx` (`proveedor_codigo`),
  KEY `fk_Material_has_Proveedor_Material1_idx` (`material_codigo`),
  CONSTRAINT `fk_Material_has_Proveedor_Material1` FOREIGN KEY (`material_codigo`) REFERENCES `material` (`codigo`),
  CONSTRAINT `fk_Material_has_Proveedor_Proveedor1` FOREIGN KEY (`proveedor_codigo`) REFERENCES `proveedor` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `provisto_por`
--

LOCK TABLES `provisto_por` WRITE;
/*!40000 ALTER TABLE `provisto_por` DISABLE KEYS */;
INSERT INTO `provisto_por` VALUES (1,1),(2,1),(3,2),(4,3);
/*!40000 ALTER TABLE `provisto_por` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tiene`
--

DROP TABLE IF EXISTS `tiene`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tiene` (
  `almacen_codigo` int NOT NULL,
  `articulo_codigo` int NOT NULL,
  `stock` int DEFAULT NULL,
  PRIMARY KEY (`almacen_codigo`,`articulo_codigo`),
  KEY `fk_Almacen_has_Articulos_Articulos1_idx` (`articulo_codigo`),
  KEY `fk_Almacen_has_Articulos_Almacen1_idx` (`almacen_codigo`),
  CONSTRAINT `fk_Almacen_has_Articulos_Almacen1` FOREIGN KEY (`almacen_codigo`) REFERENCES `almacen` (`codigo`),
  CONSTRAINT `fk_Almacen_has_Articulos_Articulos1` FOREIGN KEY (`articulo_codigo`) REFERENCES `articulo` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tiene`
--

LOCK TABLES `tiene` WRITE;
/*!40000 ALTER TABLE `tiene` DISABLE KEYS */;
INSERT INTO `tiene` VALUES (1,1,100),(1,2,104),(2,3,200),(3,4,320);
/*!40000 ALTER TABLE `tiene` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-01-14 16:06:55
