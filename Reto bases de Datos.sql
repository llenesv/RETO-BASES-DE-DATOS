#. Lista los nombres de los juegos ordenados de forma descendente.
SELECT *
FROM juegos j
ORDER BY nombre_juego DESC;

#. Lista los nombres de los clientes ordenados de manera Ascendente
SELECT *
FROM clientes c 
ORDER BY nombre_cliente ASC;

#. Lista el código de los jefes mostrando los códigos sin repetición de la tabla empleado.
SELECT DISTINCT id_jefe
FROM empleados e; 

#Traer los 3 juegos que tienen menor precio.
 #...SELECT MIN(precio_unitario) 
 #...FROM juegos;
SELECT nombre_juego
FROM juegos j
WHERE precio_unitario = 5000;

#. Traer los 5 empleado con mayor salario.
 #...SELECT MAX(salario) 
 #...FROM empleados e;
SELECT nombre_empleado
FROM empleados e 
WHERE salario = 2100000;

#. Realizar la inserción de tres nuevos clientes.
INSERT INTO clientes (id_cliente, nombre_cliente, celular)
VALUES (86,"Luis Lenes", 3113332366),
	   (87,"Luisa Mosquera", 3133333366),
       (88,"Laura Jerez", 3222222266);
SELECT * FROM clientes c ;

# Consultar los juegos cuyo tipo de juego sea código 7.
SELECT *
FROM juegos j 
WHERE id_tipo = 7;

# Eliminar uno de los clientes creados. 
DELETE FROM clientes 
WHERE id_cliente = 85;

# Actualizar el número de celular de uno de los clientes creados.
UPDATE clientes SET celular= 3235252324
WHERE id_cliente = 83;

#Traer los empleados cuyo salario este dentro del rango de [1.000.000 , 2.050.000].
SELECT *
FROM empleados e 
WHERE salario BETWEEN 1000000 AND  2050000;

#De la tabla juegos, ordenar la columna del campo fecha_creacion de acuerdo con los meses del año en orden cronológico.
SELECT fecha_creacion
FROM	juegos j 
ORDER BY fecha_creacion ASC;

#.Obtener las ventas realizadas por todos los clientes junto con la información del aliado y el medio de pago utilizado
SELECT *
FROM  clientes c , aliados a, medio_pagos mp;

#Cuántos apoyos técnicos recibe un callcenter por día.
SELECT COUNT(*)
FROM	apoyos_tecnicos at2 , callcenters c ;
#R/918

#Mostrar la cantidad de ventas por ciudad
SELECT cantidad, nombre_ciudad 
FROM ventas, ciudades c ;

#.Mostrar el número de ventas por empleado
SELECT cantidad, nombre_empleado 
FROM ventas, empleados e  ;

#.Mostrar los empleados de todas las sedes de Cartagena con sus respectivas ventas, organizado por id_venta
SELECT nombre_empleado ,cantidad, nombre_ciudad
FROM empleados e , ventas v,sedes s, ciudades c 
WHERE nombre_ciudad='Cartagena'
ORDER BY id_venta;

#. Mostrar el id de la sede de Cali con el nombre de sus empleados
SELECT id_sede,nombre_ciudad, nombre_empleado
FROM ciudades c, empleados e 
WHERE nombre_ciudad='Cali';

#.Mostar todas las ventas y en qué ciudad se realizaron
SELECT cantidad, nombre_ciudad
from ventas v , ciudades c;

#Mostrar la suma de ventas que se hacen por año y mes
SELECT SUM(cantidad), fecha_venta
FROM ventas 
GROUP BY fecha_venta;

#.Mostrar la cantidad de apoyos técnicos que recibió cada cliente
SELECT nombre_cliente, SUM(id_at) 
FROM apoyos_tecnicos at2 , clientes c
GROUP BY nombre_cliente;

#Mostrar los 3 aliados que más reportaron ventas.
SELECT nombre_aliado, MAX(cantidad)
FROM aliados a , ventas v
GROUP BY nombre_aliado
LIMIT 3;

#.Mostrar los clientes que empiecen por "Ju" mostrando la cantidad de apoyos solicitados
SELECT nombre_cliente, SUM(id_at) 
FROM apoyos_tecnicos at2 , clientes c
WHERE nombre_cliente LIKE 'Ju%'
GROUP BY nombre_cliente;

#Obtener las ventas realizadas en un rango de fechas específico, para este caso será: '2019-01-12' al '2020-01-20'
SELECT *
FROM ventas v 
WHERE fecha_venta BETWEEN '2019-01-12' AND '2020-01-20';

#.Obtener el nombre y método de pago de los clientes, pero si el método de pago es 'Letra de cambio' remplazarlo por: 'Este medio ya no se usa'
SELECT  nombre_cliente, nombre_medio
FROM	clientes c , ventas v , medio_pagos mp 
WHERE nombre_medio='Letra de cambio';
UPDATE medio_pagos 
SET nombre_medio='Este medio ya no se usa'
WHERE nombre_medio='Letra de cambio';

# Teniendo en cuenta el esquema “EmpresaVideojuegos” ejecutar el procedimiento almacenado creado con la siguiente sentencia, y explicar cuál es la salida:
CREATE DEFINER=`yfranco@``%`
PROCEDURE `EmpresaVideojuegos`.`Ventas_por_empleado`()
BEGIN
	SELECT e.id_empleado, e.nombre_empleado, SUM(v.valor_total)AS total_ventas
	FROM empleados e 
	JOIN ventas v ON e.id_empleado = v.id_empleado
	GROUP BY e.id_empleado
	ORDER BY total_ventas DESC;
END


#-- ------------------------------------------------ MIN()|MAX()  
SELECT MIN(precio) AS precio_minimo, MAX(precio) AS precio_maximo
FROM producto;

SELECT MIN(nombre) 
FROM fabricante; 

SELECT MAX(nombre) 
FROM fabricante; 

-- ------------------------------------------------ COUNT(), AVG() y SUM() 
SELECT COUNT(*) AS cantidad_productos, 
	   AVG(precio) AS precio_promedio, 
	   SUM(precio) AS precio_total
FROM producto;

-- ------------------------------------------------ AND, OR, NOT 
# El operador AND muestra un registro si todas las condiciones separadas por AND son VERDADERAS.   
SELECT *
FROM producto 
WHERE nombre = 'Memoria RAM DDR4 8GB' AND precio = 120;

# El operador OR muestra un registro si alguna de las condiciones separadas por OR es VERDADERA. 
SELECT *
FROM producto 
WHERE nombre = 'Memoria RAM DDR4 8GB' OR precio = 889000;

# El operador NOT muestra un registro si la(s) condición(es) NO ES VERDADERA. (En MySql el NOT lo antecede el AND)
SELECT *
FROM producto 
WHERE nombre = 'Memoria RAM DDR4 8GB' AND NOT precio = 889000;

# Que se cumplan todas las condiciones
SELECT *
FROM producto
WHERE (precio < 1000 AND codigo_fabricante = '4')
   OR (precio >= 1000 
   AND NOT nombre LIKE '%Samsung%');
  
-- ------------------------------------------------ CASE
/*Si el precio es menor a 50000, se asigna la categoría 'Barato'. 
  Si el precio está entre 50000 y 500000 (inclusive), se asigna la categoría 'Moderado'. 
  Para cualquier otro precio, se asigna la categoría 'Caro'.*/
SELECT nombre, precio,
  CASE
    WHEN precio < 50000 THEN 'Barato'
    WHEN precio >= 50000 AND precio < 500000 THEN 'Moderado'
    ELSE 'Caro'
  END AS categoria_precio
FROM producto
ORDER BY categoria_precio;

  
-- ------------------------------------------------ BETWEEN & IN
# Selecciona el nombre y el precio de los productos de la tabla "producto" que cumplan con las condiciones
SELECT nombre, precio
FROM producto
WHERE precio BETWEEN 1000 AND 2000000
   AND codigo_fabricante IN ('1', '10');


-- ------------------------------------------------ LIKE
# Busca palabras o datos que inician con la letra a. 

SELECT * FROM producto
WHERE nombre LIKE 'a%';


# Busca palabras o datos que finalizan con la letra a. 
SELECT * FROM producto
WHERE nombre LIKE '%a';

# Busca palabras o datos que tienen la r en la 3ra posición. 
SELECT * FROM producto
WHERE nombre LIKE '__r%';

-- ------------------------------------------------ IS NULL
# Verifica todos los campos de la tabla "producto" donde la columna "codigo_fabricante" es NULL.
SELECT *
FROM producto
WHERE codigo_fabricante IS NULL;

-- ------------------------------------------------ HAVING
# Muestra el código de fabricante y la cantidad de productos para aquellos fabricantes que tengan más de 5 productos.
SELECT codigo_fabricante, COUNT(*) AS cantidad_productos
FROM producto
GROUP BY codigo_fabricante  -- agrupa filas que tienen los mismos valores
HAVING COUNT(*) > 5;


-- ------------------------------------------------ GROUP BY
#Cuenta los códigos y los agrupa por nombre
SELECT COUNT(codigo), nombre 
FROM producto 
GROUP BY nombre; 

-- ------------------------------------------------ UNION 
# Este operador se utiliza para combinar el conjunto de resultados de dos o más SELECT. (UNION|UNION ALL) 
SELECT nombre FROM producto
UNION 
SELECT nombre FROM fabricante
ORDER BY nombre; 

-- ------------------------------------------------ INTERSECT ( no está disponible en MySQL)


-- ------------------------------------------------ TOP (TOP para MySQL sería LIMIT)
# Muestra las primeras 5 líneas organizadas descendente
SELECT nombre, precio
FROM producto
ORDER BY precio DESC
LIMIT 5;


-- ------------------------------------------------ OFFSET y FETCH (no disponible en MySql)
# Nombres y precios de los productos desde la fila 11 hasta la fila 15 en función del orden descendente del precio.
--  OFFSET 10 indica que se deben omitir las primeras 10 filas.
SELECT nombre, precio
FROM producto
ORDER BY precio DESC
LIMIT 5 OFFSET 10;

-- ------------------------------------------------ DISTINCT
# Devolver solo valores distintos de la tabla producto 
SELECT DISTINCT nombre, precio
FROM producto;

# Cuenta los nombres diferente en tabla la producto
SELECT  COUNT(DISTINCT nombre) 
FROM producto;

-- ------------------------------------------------ HAVING
# Cantidad de nombres repetido en la tabla producto
SELECT nombre, COUNT(*) as conteo
FROM producto 
GROUP BY nombre
HAVING COUNT(*) > 1;


-- ------------------------------------------------------ INSERT 
#Realizar la inserción de tres nuevos productos.
INSERT INTO producto (nombre, precio, codigo_fabricante) 
VALUES ('Lenovo 3 14ADA05', 889000, 2),
	   ('Lenovo ThinkPad P15 2da Gen', 10599000, 2),
	   ('Asus Core I7 Ram', 3019000, 1);

#Realizar la inserción de 1 nuevo producto
INSERT INTO producto 
VALUES (195, 'SmartWatch Galaxy 4', 1500000, 4);


-- ----------------------------------------------------- UPDATE 
#Actualizar 1 registro Ej 1
UPDATE producto  
SET precio = 2000000, nombre = 'Galaxy Buds Live'
WHERE codigo = 10;

#Actualizar 1 registro Ej 2
UPDATE producto  
SET precio = 115951
WHERE nombre = 'Impresora HP Laserjet Pro M26nw';

-- ------------------------------------------------------ DELETE 
#Borrar varios registros
DELETE FROM producto  
WHERE nombre IN ('Asus Core I7 Ram','Lenovo 3 14ADA05', 'Lenovo ThinkPad P15 2da Gen' 'SmartWatch Galaxy 4');

-- ------------------------------------------------------ WHERE  

-- Operador "=" (igual):
SELECT p.codigo, p.nombre
FROM producto p 
WHERE p.nombre = 'Asus Core I7 Ram';

-- Operador "<" (menor que):
SELECT * FROM fabricante f WHERE f.codigo < 3;


-- Operador ">" (mayor que):
SELECT * FROM producto p WHERE p.precio  > 1000000;


-- Operador ">=" (mayor o igual que):
SELECT * FROM fabricante f WHERE f.codigo  >= 10;


-- Operador "<=" (menor o igual que):
SELECT * FROM producto p  WHERE precio <= 10000;


-- Operador "<>" o "!=" (diferente de):
SELECT * FROM fabricante f WHERE codigo  <> 5;


-- Operador BETWEEN (entre un rango):
SELECT * FROM producto p  WHERE precio BETWEEN 1000000 AND 1900000;


-- Operador LIKE (coincidencia de patrones):
SELECT * FROM fabricante f WHERE nombre LIKE '%iao%';


-- Operador IN (coincidencia en una lista de valores):
SELECT * FROM producto p  WHERE nombre IN ('Portátil Lenovo 500', 'Lenovo 3 14ADA05', 'Galaxy Buds Live');


-- ------------------------------------------------------ ORDER BY 
# Lista los nombres de los fabricantes ordenados de forma descendente.
SELECT nombre
FROM fabricante 
ORDER BY nombre DESC;

# Lista los nombres de los productos ordenados de manera Ascendente.
SELECT nombre
FROM producto ORDER BY nombre ASC;


-- ------------------------------------------------------ JOIN ------------------------------------------------------ 
# Consultar cada producto con el nombre de cada fabricante. 
SELECT p.nombre AS nombre_Producto, f.nombre AS nombre_Fabricante
FROM producto p
JOIN fabricante f
ON p.codigo_fabricante = f.codigo;

# Traer los productos asociados cuyo fabricante es “Crucial” con su respectivo nombre. 
SELECT p.nombre, f.nombre AS nombre_Fabricante
FROM producto p
JOIN fabricante f ON p.codigo  = f.codigo 
WHERE f.nombre = 'Crucial';

-- ------------------------------------------------------ INNER JOIN

# Traer los fabricantes que tienen más de 3 productos asociados
SELECT f.codigo, f.nombre, COUNT(f.codigo) AS cantidad_productos
FROM fabricante f 
INNER JOIN producto p 
ON f.codigo = p.codigo_fabricante 
GROUP BY f.codigo, f.nombre

-- ------------------------------------------------------ LEFT JOIN
# Consultar el nombre de cada fabricante con los productos asociados a ellos incluso mostrando los fabricantes que no tienen algún producto asignado. 
SELECT f.nombre, p.nombre
FROM fabricante f
LEFT JOIN producto p ON f.codigo = p.codigo_fabricante
ORDER BY f.nombre;

-- ------------------------------------------------------ RIGTH JOIN
# compara el campo codigo de la tabla fabricante con el campo codigo_fabricante de la tabla producto.
SELECT f.codigo, f.nombre, p.nombre, p.precio
FROM fabricante f
RIGHT JOIN producto p ON f.codigo = p.codigo_fabricante;


-- ------------------------------------------------------ CROSS JOIN
#Todas las posibles combinaciones de nombres de productos y nombres de fabricantes de ambas tablas.
SELECT p.nombre, f.nombre
FROM fabricante f
CROSS JOIN producto p;

#Selecciona todos los fabricantes y todos los productos 
SELECT * 
FROM fabricante f 
CROSS JOIN producto p
ON f.codigo = p.codigo_fabricante ORDER BY f.codigo;

-- ------------------------------------------------------ JOIN EN MULTIPLES TABLAS
# Consultar el nombre de cada fabricante con los productos asociados a ellos incluso mostrando los fabricantes que no tienen algún producto asignado. 
SELECT f.nombre, p.nombre
FROM fabricante f
LEFT JOIN producto p ON f.codigo = p.codigo_fabricante
ORDER BY f.nombre;

# Consultar cada producto con el nombre de cada fabricante. 
SELECT producto.nombre AS nombre_Producto, fabricante.nombre AS nombre_Fabricante
FROM producto
JOIN fabricante
ON producto.codigo_fabricante = fabricante.codigo;

# Traer los productos asociados cuyo fabricante es “Crucial” con su respectivo nombre. 
SELECT producto.nombre, fabricante.nombre AS nombre_Fabricante
FROM producto
JOIN fabricante ON producto.codigo  = fabricante.codigo 
WHERE fabricante.nombre = 'Crucial';


-- ------------------------------------------------------ DELETE y UPDATE con JOIN 
# Elimina los productos fabricados por un fabricante específico y actualizará los productos restantes con un nuevo precio
-- Actualiza losproductos que tienen un código de fabricante igual a 4
UPDATE producto
SET precio = 333000
WHERE codigo_fabricante = '4';
/* Elimina los productos que están relacionados con el fabricante 4 
	JOIN combina las tablas "producto" y "fabricante" en base a la igualdad de los códigos de fabricante. 
	WHERE filtra los registros para eliminar solo los productos relacionados con el fabricante específico.*/
DELETE producto
FROM producto
JOIN fabricante ON producto.codigo_fabricante = fabricante.codigo
WHERE fabricante.codigo = '4';
 

-- ------------------------------------------------------ Update con Inner Join
-- En la tabla producto reemplazar los producto que sean del fabricante 'X' con un nuevo precio
UPDATE producto p
INNER JOIN fabricante f ON p.codigo_fabricante = f.codigo
SET p.precio = 444000
WHERE f.nombre = 'Gigabyte';

-- ------------------------------------------------  
/*Trae el nombre de los fabricantes sin repetición que tienen precios superiores a 1.000.000*/


SELECT DISTINCT f.nombre nombre_fabricante
FROM producto p join fabricante f 
WHERE f.codigo=p.codigo_fabricante and 
p.precio > 1000000
order by nombre_fabricante;


-- ------------------------------------------------Subconsultas ECALARES: Devuelve un solo valor.
# Muestra los nombres de los productos cuyo precio está por encima del promedio. - Único valor→el promedio de los precios,
SELECT nombre, precio
FROM producto
WHERE precio > 
	         (SELECT AVG(precio) FROM producto); -- Calcula  el promedio de los precios de la tabla "producto" 


# Precios entre el precio de Galaxy Buds Live y el de JF Reloj digital
SELECT nombre, precio
FROM producto 
WHERE precio <=
		      (SELECT precio FROM producto  
			   WHERE nombre = 'Galaxy Buds Live') -- 1000000
  AND precio >=
			 (SELECT precio FROM producto 
 			  WHERE nombre = 'JF Reloj digital'); -- 2025

 			  
-- ------------------------------------------------ Subconsultas de múltiples filas: Devuelve varios valores
# Muestra los productos que son de marca OPUS
SELECT nombre
FROM producto
WHERE codigo_fabricante IN 
						  (SELECT codigo FROM fabricante WHERE nombre = 'opus'); 			  
 
# El producto con mayor valor
SELECT nombre, precio  
FROM producto 
WHERE precio >= ALL (SELECT precio FROM producto ); 

