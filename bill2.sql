-- 1. Cargar el respaldo de la base de datos unidad2.sql. (2 Puntos)
    --"cargar desde terminal fuera de PSQL"
    -- usar comando: psql -U ludovico bill2 < unidad2.sql
    -- validar que las tablas se hayan cargado las tablas son
    -- cliente compra producto detalle_compra

-- SELECT * FROM cliente;
-- SELECT * FROM compra;
-- SELECT * FROM producto;
-- SELECT * FROM detalle_compra;

--2. El cliente usuario01 ha realizado la siguiente compra:
-- ● producto: producto9.
-- ● cantidad: 5.
-- ● fecha: fecha del sistema.
-- Mediante el uso de transacciones, realiza las consultas correspondientes para este
-- requerimiento y luego consulta la tabla producto para validar si fue efectivamente
-- descontado en el stock. (3 Puntos)
\set AUTOCOMMIT OFF

BEGIN TRANSACTION;
INSERT INTO compra (id,cliente_id,fecha)
VALUES (33,1,CURRENT_DATE);
UPDATE producto SET stock = stock -5 WHERE id =9;
INSERT INTO detalle_compra (id,producto_id, compra_id, cantidad)
VALUES (43, 9, 33, 5);
COMMIT;

SELECT * FROM compra where cliente_id = 1;
-- consulta a la base de datos las transacciones del cliente "1"

--  id | cliente_id |   fecha    
-- ----+------------+------------
--  26 |          1 | 2020-01-31
--  31 |          1 | 2020-03-29
--  33 |          1 | 2022-04-21

SELECT * FROM producto WHERE id = 9;

--  id | descripcion | stock | precio 
-- ----+-------------+-------+--------
--   9 | producto9   |     3 |   4219 

SELECT * FROM detalle_compra WHERE id = 43;

--  id | producto_id | compra_id | cantidad 
-- ----+-------------+-----------+----------
--  43 |           9 |        33 |        5
SAVEPOINT checkpoint;
-- 3. El cliente usuario02 ha realizado la siguiente compra:
-- ● producto: producto1, producto 2, producto 8.
-- ● cantidad: 3 de cada producto.
-- ● fecha: fecha del sistema.
-- Mediante el uso de transacciones, realiza las consultas correspondientes para este
-- requerimiento y luego consulta la tabla producto para validar que si alguno de ellos
-- se queda sin stock, no se realice la compra. (3 Puntos)
BEGIN TRANSACTION;
INSERT INTO compra (id,cliente_id,fecha)
VALUES (34,2,CURRENT_DATE);

BEGIN TRANSACTION;
INSERT INTO detalle_compra (id, producto_id, compra_id, cantidad)
VALUES (44, 1, 34, 3);
UPDATE producto SET stock = stock - 3 WHERE id = 1;
INSERT INTO detalle_compra (id, producto_id, compra_id, cantidad)
VALUES (45, 2, 34, 3);
UPDATE producto SET stock = stock -3 WHERE id = 2;
INSERT INTO detalle_compra (id, producto_id, compra_id, cantidad)
ROLLBACK TO checkpoint;
COMMIT;

-- 4. Realizar las siguientes consultas (2 Puntos):
-- a. Deshabilitar el AUTOCOMMIT.
\set AUTOCOMMIT off
-- -- b. Insertar un nuevo cliente.
INSERT INTO cliente(id, nombre, email)
VALUES(11, 'usuario11', 'usuario11@gmail.com');
-- c. Confirmar que fue agregado en la tabla cliente.
SELECT * FROM cliente WHERE id = 11;
--  id |  nombre   |        email
-- ----+-----------+---------------------
--  11 | usuario11 | usuario11@gmail.com
--(1 row)
-- -- d. Realizar un ROLLBACK.
ROLLBACK;
-- -- e. Confirmar que se restauró la información, sin considerar la inserción del punto b.
SELECT * FROM cliente;
--  id |   nombre   |         email
-- ----+------------+------------------------
--   2 | usuario02  | usuario02@yahoo.com
--   3 | usuario03  | usuario03@hotmail.com
--   4 | usuario04  | usuario04@hotmail.com
--   5 | usuario05  | usuario05@yahoo.com
--   6 | usuario06  | usuario06@hotmail.com
--   7 | usuario07  | usuario07@yahoo.com
--   8 | usuario08  | usuario08@yahoo.com
--   9 | usuario09  | usuario09@hotmail.com
--  10 | usuario010 | usuario010@hotmail.com
--   1 | usuario01  | usuario01@gmail.com


--f. Habilitar de nuevo el AUTOCOMMIT.
\set AUTOCOMMIT on

-- el respaldo de la base se hace desde la terminal
-- \q para salir de la consola sql
-- pg_dump -U ludovico bill2 > respaldo_bill2.sql 
-- respaldamos la base de datos 