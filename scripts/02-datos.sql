-- =============================================================================
-- McKing - Casa de comidas rápidas
-- Script 02: Datos iniciales (menú + pedidos de ejemplo)
-- Ejecutar después de 01-schema.sql
-- Los pedidos de ejemplo se generan relativos a la fecha actual:
--   * Día anterior: pedidos cerrados (entregados / cancelados).
--   * Día actual: pedidos en curso, para que la pantalla del cliente muestre datos.
-- =============================================================================

SET NAMES utf8mb4;
USE mcking;

SET @hoy  = CURDATE();
SET @ayer = CURDATE() - INTERVAL 1 DAY;

-- -----------------------------------------------------------------------------
-- Categorías
-- -----------------------------------------------------------------------------
INSERT INTO categorias (id, nombre, descripcion, orden) VALUES
    (1, 'Hamburguesas',    'Hamburguesas a la parrilla y sándwiches de pollo', 1),
    (2, 'Combos',          'Sándwich + acompañamiento + bebida a precio promocional', 2),
    (3, 'Acompañamientos', 'Papas, aros y nuggets', 3),
    (4, 'Bebidas',         'Gaseosas, agua y café', 4),
    (5, 'Postres',         'Helados y dulces', 5);

-- -----------------------------------------------------------------------------
-- Productos
-- -----------------------------------------------------------------------------
INSERT INTO productos (id, categoria_id, nombre, descripcion, precio, es_combo, disponible, estacion, tiempo_preparacion_min) VALUES
    ( 1, 1, 'Hamburguesa Clásica',     'Medallón de carne, lechuga, tomate y aderezo de la casa', 6500.00, 0, 1, 'Parrilla', 4),
    ( 2, 1, 'Hamburguesa con Queso',   'Medallón de carne, doble cheddar, pepinos y ketchup',     7200.00, 0, 1, 'Parrilla', 4),
    ( 3, 1, 'Doble King Bacon',        'Doble medallón, cheddar, panceta crocante y barbacoa',     9800.00, 0, 1, 'Parrilla', 6),
    ( 4, 1, 'Pollo Crispy',            'Pechuga de pollo rebozada, lechuga y mayonesa',            7900.00, 0, 1, 'Freidora', 5),
    ( 5, 1, 'Veggie',                  'Medallón de garbanzos y vegetales, rúcula y tomate',       7500.00, 0, 1, 'Parrilla', 5),
    ( 6, 3, 'Papas Fritas Medianas',   'Porción mediana de papas fritas',                          3200.00, 0, 1, 'Freidora', 3),
    ( 7, 3, 'Papas Fritas Grandes',    'Porción grande de papas fritas',                           3900.00, 0, 1, 'Freidora', 3),
    ( 8, 3, 'Aros de Cebolla',         'Ocho aros de cebolla rebozados',                           3600.00, 0, 0, 'Freidora', 4),
    ( 9, 3, 'Nuggets x6',              'Seis nuggets de pollo con salsa a elección',               4200.00, 0, 1, 'Freidora', 4),
    (10, 4, 'Gaseosa Mediana',         'Vaso de 500 ml',                                           2500.00, 0, 1, 'Bebidas',  1),
    (11, 4, 'Gaseosa Grande',          'Vaso de 750 ml',                                           2900.00, 0, 1, 'Bebidas',  1),
    (12, 4, 'Agua Mineral',            'Botella de 500 ml',                                        2000.00, 0, 1, 'Bebidas',  1),
    (13, 4, 'Café',                    'Café americano 240 ml',                                    2200.00, 0, 1, 'Bebidas',  2),
    (14, 5, 'Helado Cono',             'Cono de helado de vainilla',                               1800.00, 0, 1, 'Postres',  1),
    (15, 5, 'Sundae Dulce de Leche',   'Helado de vainilla con salsa de dulce de leche',           3500.00, 0, 1, 'Postres',  2),
    (16, 5, 'Brownie',                 'Brownie de chocolate con nueces',                          3000.00, 0, 1, 'Postres',  1),
    (17, 2, 'Combo Clásico',           'Hamburguesa Clásica + Papas Medianas + Gaseosa Mediana',  10900.00, 1, 1, 'Armado',   5),
    (18, 2, 'Combo Doble King Bacon',  'Doble King Bacon + Papas Grandes + Gaseosa Grande',       14900.00, 1, 1, 'Armado',   7),
    (19, 2, 'Combo Crispy',            'Pollo Crispy + Papas Medianas + Gaseosa Mediana',         11900.00, 1, 1, 'Armado',   6),
    (20, 2, 'Combo Infantil',          'Nuggets x6 + Papas Medianas + Agua Mineral + Helado Cono', 9900.00, 1, 1, 'Armado',   5);

INSERT INTO combo_componentes (combo_id, producto_id, cantidad) VALUES
    (17,  1, 1), (17,  6, 1), (17, 10, 1),
    (18,  3, 1), (18,  7, 1), (18, 11, 1),
    (19,  4, 1), (19,  6, 1), (19, 10, 1),
    (20,  9, 1), (20,  6, 1), (20, 12, 1), (20, 14, 1);

-- -----------------------------------------------------------------------------
-- Pedidos de ejemplo
-- -----------------------------------------------------------------------------
INSERT INTO secuencias_retiro (fecha_operativa, ultimo_numero) VALUES
    (@ayer, 103),
    (@hoy,  104);

INSERT INTO pedidos (id, numero_retiro, fecha_operativa, canal, tipo_consumo, estado, nombre_cliente, total, fecha_creacion, fecha_actualizacion) VALUES
    -- Día anterior
    (1, 101, @ayer, 'Mostrador', 'Salon',      'Entregado',     'Lucía',     10900.00, @ayer + INTERVAL '12:05' HOUR_MINUTE, @ayer + INTERVAL '12:14' HOUR_MINUTE),
    (2, 102, @ayer, 'Totem',     'ParaLlevar', 'Entregado',     'Martín',    29800.00, @ayer + INTERVAL '12:10' HOUR_MINUTE, @ayer + INTERVAL '12:22' HOUR_MINUTE),
    (3, 103, @ayer, 'DriveThru', 'ParaLlevar', 'Cancelado',     NULL,         7200.00, @ayer + INTERVAL '12:30' HOUR_MINUTE, @ayer + INTERVAL '12:32' HOUR_MINUTE),
    -- Día actual
    (4, 101, @hoy,  'Mostrador', 'Salon',      'Listo',         'Sofía',     15400.00, NOW() - INTERVAL 14 MINUTE, NOW() - INTERVAL 1 MINUTE),
    (5, 102, @hoy,  'Totem',     'ParaLlevar', 'EnPreparacion', 'Diego',     13700.00, NOW() - INTERVAL 9 MINUTE,  NOW() - INTERVAL 5 MINUTE),
    (6, 103, @hoy,  'DriveThru', 'ParaLlevar', 'Confirmado',    NULL,        21800.00, NOW() - INTERVAL 4 MINUTE,  NOW() - INTERVAL 3 MINUTE),
    (7, 104, @hoy,  'Mostrador', 'Salon',      'PendientePago', 'Valentina',  9900.00, NOW() - INTERVAL 1 MINUTE,  NOW() - INTERVAL 1 MINUTE);

INSERT INTO pedido_items (pedido_id, producto_id, cantidad, precio_unitario, subtotal, observaciones) VALUES
    (1, 17, 1, 10900.00, 10900.00, NULL),
    (2, 18, 2, 14900.00, 29800.00, 'Una sin pepinos'),
    (3,  2, 1,  7200.00,  7200.00, NULL),
    (4, 19, 1, 11900.00, 11900.00, NULL),
    (4, 15, 1,  3500.00,  3500.00, NULL),
    (5,  3, 1,  9800.00,  9800.00, 'Sin pepinos'),
    (5,  7, 1,  3900.00,  3900.00, NULL),
    (6, 17, 2, 10900.00, 21800.00, 'Gaseosas sin hielo'),
    (7, 20, 1,  9900.00,  9900.00, NULL);

INSERT INTO pagos (pedido_id, medio_pago, monto, monto_recibido, vuelto, fecha_pago) VALUES
    (1, 'Efectivo', 10900.00, 15000.00, 4100.00, @ayer + INTERVAL '12:06' HOUR_MINUTE),
    (2, 'Debito',   29800.00, 29800.00,    0.00, @ayer + INTERVAL '12:11' HOUR_MINUTE),
    (4, 'Credito',  15400.00, 15400.00,    0.00, NOW() - INTERVAL 13 MINUTE),
    (5, 'Qr',       13700.00, 13700.00,    0.00, NOW() - INTERVAL 8 MINUTE),
    (6, 'Debito',   21800.00, 21800.00,    0.00, NOW() - INTERVAL 3 MINUTE);

INSERT INTO historial_estados_pedido (pedido_id, estado_anterior, estado_nuevo, fecha) VALUES
    (1, NULL,            'PendientePago', @ayer + INTERVAL '12:05' HOUR_MINUTE),
    (1, 'PendientePago', 'Confirmado',    @ayer + INTERVAL '12:06' HOUR_MINUTE),
    (1, 'Confirmado',    'EnPreparacion', @ayer + INTERVAL '12:07' HOUR_MINUTE),
    (1, 'EnPreparacion', 'Listo',         @ayer + INTERVAL '12:12' HOUR_MINUTE),
    (1, 'Listo',         'Entregado',     @ayer + INTERVAL '12:14' HOUR_MINUTE),
    (2, NULL,            'PendientePago', @ayer + INTERVAL '12:10' HOUR_MINUTE),
    (2, 'PendientePago', 'Confirmado',    @ayer + INTERVAL '12:11' HOUR_MINUTE),
    (2, 'Confirmado',    'EnPreparacion', @ayer + INTERVAL '12:13' HOUR_MINUTE),
    (2, 'EnPreparacion', 'Listo',         @ayer + INTERVAL '12:20' HOUR_MINUTE),
    (2, 'Listo',         'Entregado',     @ayer + INTERVAL '12:22' HOUR_MINUTE),
    (3, NULL,            'PendientePago', @ayer + INTERVAL '12:30' HOUR_MINUTE),
    (3, 'PendientePago', 'Cancelado',     @ayer + INTERVAL '12:32' HOUR_MINUTE),
    (4, NULL,            'PendientePago', NOW() - INTERVAL 14 MINUTE),
    (4, 'PendientePago', 'Confirmado',    NOW() - INTERVAL 13 MINUTE),
    (4, 'Confirmado',    'EnPreparacion', NOW() - INTERVAL 11 MINUTE),
    (4, 'EnPreparacion', 'Listo',         NOW() - INTERVAL 1 MINUTE),
    (5, NULL,            'PendientePago', NOW() - INTERVAL 9 MINUTE),
    (5, 'PendientePago', 'Confirmado',    NOW() - INTERVAL 8 MINUTE),
    (5, 'Confirmado',    'EnPreparacion', NOW() - INTERVAL 5 MINUTE),
    (6, NULL,            'PendientePago', NOW() - INTERVAL 4 MINUTE),
    (6, 'PendientePago', 'Confirmado',    NOW() - INTERVAL 3 MINUTE),
    (7, NULL,            'PendientePago', NOW() - INTERVAL 1 MINUTE);
