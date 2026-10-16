CREATE DATABASE Ventas_Tech_DB
USE Ventas_Tech_DB

-- === SECCIÓN 1: DROP ===

DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS categorias;

-- === SECCIÓN 2: CREATE TABLES ===
CREATE TABLE categorias(
id_categoria INT PRIMARY KEY IDENTITY(1,1),
nombre_categoria VARCHAR(50) NOT NULL,
descripcion VARCHAR(200)
);

CREATE TABLE clientes(
id_cliente INT PRIMARY KEY IDENTITY(1,1),
nombre VARCHAR(100)	NOT NULL,
email VARCHAR(100) UNIQUE,
ciudad VARCHAR(50),
fecha_registro DATE NOT NULL
);

CREATE TABLE productos (
id_producto	INT	PRIMARY KEY,
nombre_producto	VARCHAR(100) NOT NULL,
id_categoria INT NOT NULL,
precio DECIMAL(10,2) NOT NULL,
stock INT DEFAULT 0,
activo BIT DEFAULT 1,

FOREIGN KEY (id_categoria) 
	REFERENCES categorias(id_categoria),
);

CREATE TABLE ventas(
id_venta INT PRIMARY KEY,
id_cliente INT NOT NULL,
id_producto	INT NOT NULL,
cantidad INT NOT NULL,
precio_unitario	DECIMAL(10,2) NOT NULL,
fecha_venta	DATE NOT NULL,

FOREIGN KEY (id_cliente)
	REFERENCES clientes(id_cliente),

FOREIGN KEY (id_producto)
	REFERENCES productos(id_producto)
);

-- === SECCIÓN 3: INSERT DATA ===

INSERT INTO categorias(nombre_categoria, descripcion) 
VALUES
  ('Computación', 'Laptops, PCs y monitores'),
  ('Accesorios', 'Periféricos y complementos'),
  ('Audio', 'Auriculares y parlantes'),
  ('Almacenamiento', 'Discos y memorias')
  ;

  
  INSERT INTO clientes(nombre, email, ciudad, fecha_registro) VALUES
  ('María López', 'maria@mail.com', 'Buenos Aires', '2024-01-05'),
  ('Carlos Ruiz', 'carlos@mail.com', 'Córdoba', '2024-01-10'),
  ('Ana Gómez', 'ana@mail.com', 'Rosario', '2024-02-01'),
  ('Pedro Sanz', 'pedro@mail.com', 'Mendoza', '2024-02-15'),
  ('Laura Torres', 'laura@mail.com', 'Tucumán', '2024-03-01');

  INSERT INTO productos(id_producto, nombre_producto, id_categoria, precio, stock, activo) VALUES
  (1, 'Laptop Pro 15', 1, 1200.00, 15, 1),
  (2, 'Mouse Inalámbrico', 2, 28.00, 80, 1),
  (3, 'Monitor 4K 27', 1, 450.00, 12, 1),
  (4, 'Auriculares BT Pro', 3, 120.00, 35, 1),
  (5, 'SSD Externo 1TB', 4, 130.00, 18, 1),
  (6, 'Teclado Mecánico', 2, 95.00, 40, 1);

  INSERT INTO ventas(id_venta, id_cliente, id_producto, cantidad, precio_unitario, fecha_venta) VALUES
  (1, 1, 1, 2, 1200.00, '2024-03-05'),
  (2, 2, 2, 5, 28.00, '2024-03-06'),
  (3, 3, 3, 1, 450.00, '2024-03-07'),
  (4, 1, 4, 2, 120.00, '2024-03-08'),
  (5, 4, 5, 3, 130.00, '2024-03-10'),
  (6, 2, 6, 4, 95.00, '2024-03-11'),
  (7, 5, 1, 1, 1200.00, '2024-03-12'),
  (8, 3, 2, 8, 28.00, '2024-03-13'),
  (9, 4, 4, 1, 120.00, '2024-03-14'),
  (10, 5, 3, 2, 450.00, '2024-03-15');

  -- === SECCIÓN 4: VALIDACION ===

SELECT * FROM categorias;   -- esperado: 4 filas
SELECT * FROM clientes;     -- esperado: 5 filas
SELECT * FROM productos;    -- esperado: 6 filas
SELECT * FROM ventas;       -- esperado: 10 filas

INSERT INTO ventas
    (id_venta, id_cliente, id_producto, cantidad, precio_unitario, fecha_venta)
VALUES
    (11, 1, 1, 1, 1200.00, '2024-04-03'),
    (12, 2, 2, 3, 28.00,   '2024-04-07'),
    (13, 3, 4, 2, 120.00,  '2024-04-12'),
    (14, 4, 5, 1, 130.00,  '2024-04-18'),
    (15, 5, 6, 2, 95.00,   '2024-04-25'),
    (16, 2, 1, 1, 1200.00, '2024-05-04'),
    (17, 3, 2, 6, 28.00,   '2024-05-09'),
    (18, 1, 3, 2, 450.00,  '2024-05-14'),
    (19, 5, 4, 1, 120.00,  '2024-05-20'),
    (20, 4, 6, 3, 95.00,   '2024-05-27'),
    (21, 3, 1, 2, 1200.00, '2024-06-02'),
    (22, 4, 2, 4, 28.00,   '2024-06-08'),
    (23, 2, 3, 1, 450.00,  '2024-06-13'),
    (24, 5, 5, 2, 130.00,  '2024-06-19'),
    (25, 1, 6, 5, 95.00,   '2024-06-26'),
    (26, 5, 1, 1, 1200.00, '2024-07-03'),
    (27, 1, 2, 10, 28.00,  '2024-07-08'),
    (28, 4, 3, 2, 450.00,  '2024-07-15'),
    (29, 3, 4, 3, 120.00,  '2024-07-21'),
    (30, 2, 5, 2, 130.00,  '2024-07-29');


    -- Consulta 1 — Resumen ejecutivo mensual ----
SELECT 
    DATENAME (MONTH, fecha_venta) as nombre_mes,
	SUM (cantidad * precio_unitario) AS total_facturado
	FROM ventas

	GROUP BY
    MONTH(fecha_venta),
    DATENAME (MONTH, fecha_venta)

    ORDER BY 
    MONTH(fecha_venta) ASC;

-- Consulta 2 — Ranking de productos ----

SELECT TOP 5 
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM 
    ventas
GROUP BY 
    id_producto
ORDER BY 
    total_facturado DESC

-- Consulta 3 — Clientes recurrentes ----

SELECT 
    id_cliente, 
    COUNT (id_venta) AS cantidad_pedidos, 
    SUM (cantidad * precio_unitario) AS total_gastado
FROM 
    ventas
GROUP BY 
    id_cliente
HAVING 
    COUNT(*) > 1;

-- Consulta 4 — Meses por encima/por debajo del promedio ----

WITH FacturacionMensual AS (
    SELECT
        MONTH(fecha_venta) AS numero_mes,
        DATENAME(MONTH, fecha_venta) AS nombre_mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY
        MONTH(fecha_venta),
        DATENAME(MONTH, fecha_venta)
)
SELECT
    nombre_mes,
    total_facturado,
    CASE
        WHEN total_facturado > AVG(total_facturado) OVER ()
            THEN 'Por encima'
        WHEN total_facturado < AVG(total_facturado) OVER ()
            THEN 'Por debajo'
        ELSE 'Igual al promedio'
    END AS comparacion_promedio
FROM FacturacionMensual
ORDER BY numero_mes;


-- Bloque de cierre: hallazgos --

-- 1- el producto id_producto 1 representa mas del 54% de las ventas
-- 2- Marzo fué el mes de mas facturacion
-- 3- Marzo fué el mes de menos facturacion, los meses siguientes fueron parejos