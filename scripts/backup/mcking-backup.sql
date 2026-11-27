-- =============================================================================
-- McKing - Casa de comidas rápidas
-- Backup completo de la base de datos (schema + datos)
-- Generado con mysqldump desde MySQL 8.4. Compatible con MySQL 8.0.16+ y MariaDB 10.4+.
--
-- Restaurar:
--   mysql -u <usuario> -p < scripts/backup/mcking-backup.sql
-- =============================================================================

SET NAMES utf8mb4;

DROP DATABASE IF EXISTS mcking;
CREATE DATABASE mcking CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE mcking;


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
DROP TABLE IF EXISTS `categorias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categorias` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `orden` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_categorias_nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `categorias` WRITE;
/*!40000 ALTER TABLE `categorias` DISABLE KEYS */;
INSERT INTO `categorias` VALUES (1,'Hamburguesas','Hamburguesas a la parrilla y sándwiches de pollo',1),(2,'Combos','Sándwich + acompañamiento + bebida a precio promocional',2),(3,'Acompañamientos','Papas, aros y nuggets',3),(4,'Bebidas','Gaseosas, agua y café',4),(5,'Postres','Helados y dulces',5);
/*!40000 ALTER TABLE `categorias` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `combo_componentes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `combo_componentes` (
  `combo_id` int NOT NULL,
  `producto_id` int NOT NULL,
  `cantidad` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`combo_id`,`producto_id`),
  KEY `fk_combo_componentes_producto` (`producto_id`),
  CONSTRAINT `fk_combo_componentes_combo` FOREIGN KEY (`combo_id`) REFERENCES `productos` (`id`),
  CONSTRAINT `fk_combo_componentes_producto` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`),
  CONSTRAINT `ck_combo_componentes_cantidad` CHECK ((`cantidad` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `combo_componentes` WRITE;
/*!40000 ALTER TABLE `combo_componentes` DISABLE KEYS */;
INSERT INTO `combo_componentes` VALUES (17,1,1),(17,6,1),(17,10,1),(18,3,1),(18,7,1),(18,11,1),(19,4,1),(19,6,1),(19,10,1),(20,6,1),(20,9,1),(20,12,1),(20,14,1);
/*!40000 ALTER TABLE `combo_componentes` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `historial_estados_pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `historial_estados_pedido` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `pedido_id` bigint NOT NULL,
  `estado_anterior` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estado_nuevo` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `ix_historial_pedido` (`pedido_id`,`fecha`),
  CONSTRAINT `fk_historial_pedido` FOREIGN KEY (`pedido_id`) REFERENCES `pedidos` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `historial_estados_pedido` WRITE;
/*!40000 ALTER TABLE `historial_estados_pedido` DISABLE KEYS */;
INSERT INTO `historial_estados_pedido` VALUES (1,1,NULL,'PendientePago','2026-11-26 12:05:00'),(2,1,'PendientePago','Confirmado','2026-11-26 12:06:00'),(3,1,'Confirmado','EnPreparacion','2026-11-26 12:07:00'),(4,1,'EnPreparacion','Listo','2026-11-26 12:12:00'),(5,1,'Listo','Entregado','2026-11-26 12:14:00'),(6,2,NULL,'PendientePago','2026-11-26 12:10:00'),(7,2,'PendientePago','Confirmado','2026-11-26 12:11:00'),(8,2,'Confirmado','EnPreparacion','2026-11-26 12:13:00'),(9,2,'EnPreparacion','Listo','2026-11-26 12:20:00'),(10,2,'Listo','Entregado','2026-11-26 12:22:00'),(11,3,NULL,'PendientePago','2026-11-26 12:30:00'),(12,3,'PendientePago','Cancelado','2026-11-26 12:32:00'),(13,4,NULL,'PendientePago','2026-11-27 02:06:06'),(14,4,'PendientePago','Confirmado','2026-11-27 02:07:06'),(15,4,'Confirmado','EnPreparacion','2026-11-27 02:09:06'),(16,4,'EnPreparacion','Listo','2026-11-27 02:19:06'),(17,5,NULL,'PendientePago','2026-11-27 02:11:06'),(18,5,'PendientePago','Confirmado','2026-11-27 02:12:06'),(19,5,'Confirmado','EnPreparacion','2026-11-27 02:15:06'),(20,6,NULL,'PendientePago','2026-11-27 02:16:06'),(21,6,'PendientePago','Confirmado','2026-11-27 02:17:06'),(22,7,NULL,'PendientePago','2026-11-27 02:19:06');
/*!40000 ALTER TABLE `historial_estados_pedido` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `pagos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pagos` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `pedido_id` bigint NOT NULL,
  `medio_pago` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `monto_recibido` decimal(10,2) NOT NULL,
  `vuelto` decimal(10,2) NOT NULL DEFAULT '0.00',
  `fecha_pago` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_pagos_pedido` (`pedido_id`),
  CONSTRAINT `fk_pagos_pedido` FOREIGN KEY (`pedido_id`) REFERENCES `pedidos` (`id`),
  CONSTRAINT `ck_pagos_medio` CHECK ((`medio_pago` in (_utf8mb4'Efectivo',_utf8mb4'Debito',_utf8mb4'Credito',_utf8mb4'Qr'))),
  CONSTRAINT `ck_pagos_montos` CHECK (((`monto` >= 0) and (`monto_recibido` >= `monto`) and (`vuelto` >= 0)))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `pagos` WRITE;
/*!40000 ALTER TABLE `pagos` DISABLE KEYS */;
INSERT INTO `pagos` VALUES (1,1,'Efectivo',10900.00,15000.00,4100.00,'2026-11-26 12:06:00'),(2,2,'Debito',29800.00,29800.00,0.00,'2026-11-26 12:11:00'),(3,4,'Credito',15400.00,15400.00,0.00,'2026-11-27 02:07:06'),(4,5,'Qr',13700.00,13700.00,0.00,'2026-11-27 02:12:06'),(5,6,'Debito',21800.00,21800.00,0.00,'2026-11-27 02:17:06');
/*!40000 ALTER TABLE `pagos` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `pedido_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedido_items` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `pedido_id` bigint NOT NULL,
  `producto_id` int NOT NULL,
  `cantidad` int NOT NULL,
  `precio_unitario` decimal(10,2) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `observaciones` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_pedido_items_pedido` (`pedido_id`),
  KEY `fk_pedido_items_producto` (`producto_id`),
  CONSTRAINT `fk_pedido_items_pedido` FOREIGN KEY (`pedido_id`) REFERENCES `pedidos` (`id`),
  CONSTRAINT `fk_pedido_items_producto` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`),
  CONSTRAINT `ck_pedido_items_cantidad` CHECK ((`cantidad` > 0)),
  CONSTRAINT `ck_pedido_items_precio` CHECK ((`precio_unitario` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `pedido_items` WRITE;
/*!40000 ALTER TABLE `pedido_items` DISABLE KEYS */;
INSERT INTO `pedido_items` VALUES (1,1,17,1,10900.00,10900.00,NULL),(2,2,18,2,14900.00,29800.00,'Una sin pepinos'),(3,3,2,1,7200.00,7200.00,NULL),(4,4,19,1,11900.00,11900.00,NULL),(5,4,15,1,3500.00,3500.00,NULL),(6,5,3,1,9800.00,9800.00,'Sin pepinos'),(7,5,7,1,3900.00,3900.00,NULL),(8,6,17,2,10900.00,21800.00,'Gaseosas sin hielo'),(9,7,20,1,9900.00,9900.00,NULL);
/*!40000 ALTER TABLE `pedido_items` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `pedidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedidos` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `numero_retiro` int NOT NULL,
  `fecha_operativa` date NOT NULL,
  `canal` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo_consumo` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre_cliente` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `total` decimal(10,2) NOT NULL,
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_pedidos_retiro` (`fecha_operativa`,`numero_retiro`),
  KEY `ix_pedidos_fecha_estado` (`fecha_operativa`,`estado`),
  CONSTRAINT `ck_pedidos_canal` CHECK ((`canal` in (_utf8mb4'Mostrador',_utf8mb4'Totem',_utf8mb4'DriveThru'))),
  CONSTRAINT `ck_pedidos_estado` CHECK ((`estado` in (_utf8mb4'PendientePago',_utf8mb4'Confirmado',_utf8mb4'EnPreparacion',_utf8mb4'Listo',_utf8mb4'Entregado',_utf8mb4'Cancelado'))),
  CONSTRAINT `ck_pedidos_tipo_consumo` CHECK ((`tipo_consumo` in (_utf8mb4'Salon',_utf8mb4'ParaLlevar'))),
  CONSTRAINT `ck_pedidos_total` CHECK ((`total` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `pedidos` WRITE;
/*!40000 ALTER TABLE `pedidos` DISABLE KEYS */;
INSERT INTO `pedidos` VALUES (1,101,'2026-11-26','Mostrador','Salon','Entregado','Lucía',10900.00,'2026-11-26 12:05:00','2026-11-26 12:14:00'),(2,102,'2026-11-26','Totem','ParaLlevar','Entregado','Martín',29800.00,'2026-11-26 12:10:00','2026-11-26 12:22:00'),(3,103,'2026-11-26','DriveThru','ParaLlevar','Cancelado',NULL,7200.00,'2026-11-26 12:30:00','2026-11-26 12:32:00'),(4,101,'2026-11-27','Mostrador','Salon','Listo','Sofía',15400.00,'2026-11-27 02:06:06','2026-11-27 02:19:06'),(5,102,'2026-11-27','Totem','ParaLlevar','EnPreparacion','Diego',13700.00,'2026-11-27 02:11:06','2026-11-27 02:15:06'),(6,103,'2026-11-27','DriveThru','ParaLlevar','Confirmado',NULL,21800.00,'2026-11-27 02:16:06','2026-11-27 02:17:06'),(7,104,'2026-11-27','Mostrador','Salon','PendientePago','Valentina',9900.00,'2026-11-27 02:19:06','2026-11-27 02:19:06');
/*!40000 ALTER TABLE `pedidos` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `productos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `categoria_id` int NOT NULL,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `precio` decimal(10,2) NOT NULL,
  `es_combo` tinyint(1) NOT NULL DEFAULT '0',
  `disponible` tinyint(1) NOT NULL DEFAULT '1',
  `estacion` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tiempo_preparacion_min` int NOT NULL DEFAULT '3',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_productos_nombre` (`nombre`),
  KEY `fk_productos_categoria` (`categoria_id`),
  CONSTRAINT `fk_productos_categoria` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`),
  CONSTRAINT `ck_productos_estacion` CHECK ((`estacion` in (_utf8mb4'Parrilla',_utf8mb4'Freidora',_utf8mb4'Armado',_utf8mb4'Bebidas',_utf8mb4'Postres'))),
  CONSTRAINT `ck_productos_precio` CHECK ((`precio` >= 0)),
  CONSTRAINT `ck_productos_tiempo` CHECK ((`tiempo_preparacion_min` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `productos` WRITE;
/*!40000 ALTER TABLE `productos` DISABLE KEYS */;
INSERT INTO `productos` VALUES (1,1,'Hamburguesa Clásica','Medallón de carne, lechuga, tomate y aderezo de la casa',6500.00,0,1,'Parrilla',4),(2,1,'Hamburguesa con Queso','Medallón de carne, doble cheddar, pepinos y ketchup',7200.00,0,1,'Parrilla',4),(3,1,'Doble King Bacon','Doble medallón, cheddar, panceta crocante y barbacoa',9800.00,0,1,'Parrilla',6),(4,1,'Pollo Crispy','Pechuga de pollo rebozada, lechuga y mayonesa',7900.00,0,1,'Freidora',5),(5,1,'Veggie','Medallón de garbanzos y vegetales, rúcula y tomate',7500.00,0,1,'Parrilla',5),(6,3,'Papas Fritas Medianas','Porción mediana de papas fritas',3200.00,0,1,'Freidora',3),(7,3,'Papas Fritas Grandes','Porción grande de papas fritas',3900.00,0,1,'Freidora',3),(8,3,'Aros de Cebolla','Ocho aros de cebolla rebozados',3600.00,0,0,'Freidora',4),(9,3,'Nuggets x6','Seis nuggets de pollo con salsa a elección',4200.00,0,1,'Freidora',4),(10,4,'Gaseosa Mediana','Vaso de 500 ml',2500.00,0,1,'Bebidas',1),(11,4,'Gaseosa Grande','Vaso de 750 ml',2900.00,0,1,'Bebidas',1),(12,4,'Agua Mineral','Botella de 500 ml',2000.00,0,1,'Bebidas',1),(13,4,'Café','Café americano 240 ml',2200.00,0,1,'Bebidas',2),(14,5,'Helado Cono','Cono de helado de vainilla',1800.00,0,1,'Postres',1),(15,5,'Sundae Dulce de Leche','Helado de vainilla con salsa de dulce de leche',3500.00,0,1,'Postres',2),(16,5,'Brownie','Brownie de chocolate con nueces',3000.00,0,1,'Postres',1),(17,2,'Combo Clásico','Hamburguesa Clásica + Papas Medianas + Gaseosa Mediana',10900.00,1,1,'Armado',5),(18,2,'Combo Doble King Bacon','Doble King Bacon + Papas Grandes + Gaseosa Grande',14900.00,1,1,'Armado',7),(19,2,'Combo Crispy','Pollo Crispy + Papas Medianas + Gaseosa Mediana',11900.00,1,1,'Armado',6),(20,2,'Combo Infantil','Nuggets x6 + Papas Medianas + Agua Mineral + Helado Cono',9900.00,1,1,'Armado',5);
/*!40000 ALTER TABLE `productos` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `secuencias_retiro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `secuencias_retiro` (
  `fecha_operativa` date NOT NULL,
  `ultimo_numero` int NOT NULL,
  PRIMARY KEY (`fecha_operativa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `secuencias_retiro` WRITE;
/*!40000 ALTER TABLE `secuencias_retiro` DISABLE KEYS */;
INSERT INTO `secuencias_retiro` VALUES ('2026-11-26',103),('2026-11-27',104);
/*!40000 ALTER TABLE `secuencias_retiro` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

