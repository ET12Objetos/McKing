-- =============================================================================
-- McKing - Casa de comidas rápidas
-- Script 01: Estructura de la base de datos (schema)
-- Motor: MySQL 8.0.16+ / MariaDB 10.4+ (InnoDB, utf8mb4)
-- =============================================================================

SET NAMES utf8mb4;

DROP DATABASE IF EXISTS mcking;
CREATE DATABASE mcking CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE mcking;

-- -----------------------------------------------------------------------------
-- Menú
-- -----------------------------------------------------------------------------

CREATE TABLE categorias (
    id          INT          NOT NULL AUTO_INCREMENT,
    nombre      VARCHAR(60)  NOT NULL,
    descripcion VARCHAR(200) NULL,
    orden       INT          NOT NULL DEFAULT 0,
    CONSTRAINT pk_categorias PRIMARY KEY (id),
    CONSTRAINT uq_categorias_nombre UNIQUE (nombre)
) ENGINE = InnoDB;

CREATE TABLE productos (
    id                     INT           NOT NULL AUTO_INCREMENT,
    categoria_id           INT           NOT NULL,
    nombre                 VARCHAR(100)  NOT NULL,
    descripcion            VARCHAR(255)  NULL,
    precio                 DECIMAL(10,2) NOT NULL,
    es_combo               TINYINT(1)    NOT NULL DEFAULT 0,
    disponible             TINYINT(1)    NOT NULL DEFAULT 1,
    estacion               VARCHAR(20)   NOT NULL,
    tiempo_preparacion_min INT           NOT NULL DEFAULT 3,
    CONSTRAINT pk_productos PRIMARY KEY (id),
    CONSTRAINT uq_productos_nombre UNIQUE (nombre),
    CONSTRAINT fk_productos_categoria FOREIGN KEY (categoria_id) REFERENCES categorias (id),
    CONSTRAINT ck_productos_precio CHECK (precio >= 0),
    CONSTRAINT ck_productos_estacion CHECK (estacion IN ('Parrilla', 'Freidora', 'Armado', 'Bebidas', 'Postres')),
    CONSTRAINT ck_productos_tiempo CHECK (tiempo_preparacion_min >= 0)
) ENGINE = InnoDB;

-- Un combo es un producto (es_combo = 1) compuesto por otros productos.
CREATE TABLE combo_componentes (
    combo_id    INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad    INT NOT NULL DEFAULT 1,
    CONSTRAINT pk_combo_componentes PRIMARY KEY (combo_id, producto_id),
    CONSTRAINT fk_combo_componentes_combo FOREIGN KEY (combo_id) REFERENCES productos (id),
    CONSTRAINT fk_combo_componentes_producto FOREIGN KEY (producto_id) REFERENCES productos (id),
    CONSTRAINT ck_combo_componentes_cantidad CHECK (cantidad > 0)
) ENGINE = InnoDB;

-- -----------------------------------------------------------------------------
-- Pedidos
-- -----------------------------------------------------------------------------

-- Numerador de retiro: se reinicia cada día operativo (primer número del día = 101).
CREATE TABLE secuencias_retiro (
    fecha_operativa DATE NOT NULL,
    ultimo_numero   INT  NOT NULL,
    CONSTRAINT pk_secuencias_retiro PRIMARY KEY (fecha_operativa)
) ENGINE = InnoDB;

CREATE TABLE pedidos (
    id                  BIGINT        NOT NULL AUTO_INCREMENT,
    numero_retiro       INT           NOT NULL,
    fecha_operativa     DATE          NOT NULL,
    canal               VARCHAR(20)   NOT NULL,
    tipo_consumo        VARCHAR(20)   NOT NULL,
    estado              VARCHAR(20)   NOT NULL,
    nombre_cliente      VARCHAR(60)   NULL,
    total               DECIMAL(10,2) NOT NULL,
    fecha_creacion      DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_pedidos PRIMARY KEY (id),
    CONSTRAINT uq_pedidos_retiro UNIQUE (fecha_operativa, numero_retiro),
    CONSTRAINT ck_pedidos_canal CHECK (canal IN ('Mostrador', 'Totem', 'DriveThru')),
    CONSTRAINT ck_pedidos_tipo_consumo CHECK (tipo_consumo IN ('Salon', 'ParaLlevar')),
    CONSTRAINT ck_pedidos_estado CHECK (estado IN ('PendientePago', 'Confirmado', 'EnPreparacion', 'Listo', 'Entregado', 'Cancelado')),
    CONSTRAINT ck_pedidos_total CHECK (total >= 0)
) ENGINE = InnoDB;

CREATE INDEX ix_pedidos_fecha_estado ON pedidos (fecha_operativa, estado);

CREATE TABLE pedido_items (
    id              BIGINT        NOT NULL AUTO_INCREMENT,
    pedido_id       BIGINT        NOT NULL,
    producto_id     INT           NOT NULL,
    cantidad        INT           NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal        DECIMAL(10,2) NOT NULL,
    observaciones   VARCHAR(200)  NULL,
    CONSTRAINT pk_pedido_items PRIMARY KEY (id),
    CONSTRAINT fk_pedido_items_pedido FOREIGN KEY (pedido_id) REFERENCES pedidos (id),
    CONSTRAINT fk_pedido_items_producto FOREIGN KEY (producto_id) REFERENCES productos (id),
    CONSTRAINT ck_pedido_items_cantidad CHECK (cantidad > 0),
    CONSTRAINT ck_pedido_items_precio CHECK (precio_unitario >= 0)
) ENGINE = InnoDB;

-- Un pedido tiene a lo sumo un pago aprobado.
CREATE TABLE pagos (
    id             BIGINT        NOT NULL AUTO_INCREMENT,
    pedido_id      BIGINT        NOT NULL,
    medio_pago     VARCHAR(20)   NOT NULL,
    monto          DECIMAL(10,2) NOT NULL,
    monto_recibido DECIMAL(10,2) NOT NULL,
    vuelto         DECIMAL(10,2) NOT NULL DEFAULT 0,
    fecha_pago     DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_pagos PRIMARY KEY (id),
    CONSTRAINT uq_pagos_pedido UNIQUE (pedido_id),
    CONSTRAINT fk_pagos_pedido FOREIGN KEY (pedido_id) REFERENCES pedidos (id),
    CONSTRAINT ck_pagos_medio CHECK (medio_pago IN ('Efectivo', 'Debito', 'Credito', 'Qr')),
    CONSTRAINT ck_pagos_montos CHECK (monto >= 0 AND monto_recibido >= monto AND vuelto >= 0)
) ENGINE = InnoDB;

-- Auditoría de cada cambio de estado (permite medir tiempos de espera y preparación).
CREATE TABLE historial_estados_pedido (
    id              BIGINT      NOT NULL AUTO_INCREMENT,
    pedido_id       BIGINT      NOT NULL,
    estado_anterior VARCHAR(20) NULL,
    estado_nuevo    VARCHAR(20) NOT NULL,
    fecha           DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_historial_estados_pedido PRIMARY KEY (id),
    CONSTRAINT fk_historial_pedido FOREIGN KEY (pedido_id) REFERENCES pedidos (id)
) ENGINE = InnoDB;

CREATE INDEX ix_historial_pedido ON historial_estados_pedido (pedido_id, fecha);
