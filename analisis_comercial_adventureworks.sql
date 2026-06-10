-- ============================================================
-- PROYECTO: Análisis Comercial con SQL Server
-- Base de datos: AdventureWorks2025
-- Autor: Alejandro Villodres Romero
-- Descripción: Análisis completo de ventas, clientes, productos,
--              rendimiento territorial y evolución temporal
--              usando consultas avanzadas de SQL Server.
-- Herramientas: SQL Server, T-SQL, CTEs, Window Functions,
--               Subconsultas, Funciones de fecha y texto
-- ============================================================

USE AdventureWorks2025;

-- ============================================================
-- BLOQUE 1: ANÁLISIS DE TERRITORIOS Y VENTAS
-- Pregunta de negocio: ¿Qué territorios superan la media de
-- ventas y qué peso tiene cada uno sobre el total global?
-- ============================================================

-- 1.1 Vista general de territorios y sus ventas anuales
SELECT TerritoryID, [Name] as 'Nombre', [Group] as 'Region', SalesYTD 
FROM Sales.SalesTerritory
ORDER BY SalesYTD DESC;

-- 1.2 Territorios que superan la media global de ventas
-- (candidatos a recibir incentivos por rendimiento)
SELECT [Name] as 'Nombre', SalesYTD, (SELECT AVG(SalesYTD) FROM Sales.SalesTerritory) AS PromedioTotal
FROM Sales.SalesTerritory
WHERE SalesYTD > (SELECT AVG(SalesYTD) FROM Sales.SalesTerritory);

-- 1.3 Peso porcentual de cada territorio sobre el total de ventas
-- ¿Qué territorios concentran más facturación?
SELECT [Name] as 'Nombre', SalesYTD, SUM(SalesYTD) OVER() AS VentasTotal, 
(SalesYTD / SUM(SalesYTD) OVER() * 100) AS PorcentajeTotal
FROM Sales.SalesTerritory
ORDER BY PorcentajeTotal DESC;

-- 1.4 Ventas totales por región geográfica
SELECT [Group] as Region, SUM(SalesYTD) AS VentasRegion, SUM(SUM(SalesYTD)) OVER() AS VentasTotal,
(SUM(SalesYTD) / SUM(SUM(SalesYTD)) OVER() * 100) AS PorcentajeTotal
FROM Sales.SalesTerritory
GROUP BY [Group]
ORDER BY PorcentajeTotal DESC;


-- ============================================================
-- BLOQUE 2: ANÁLISIS DE CLIENTES
-- Pregunta de negocio: ¿Cuáles son nuestros clientes más
-- valiosos y cómo se distribuye su comportamiento de compra?
-- ============================================================

-- 2.1 Gasto total por cliente
SELECT CustomerID,
		COUNT(SalesOrderID) as NumeroPedidos,
		SUM(TotalDue) as GastoTotal,
		AVG(TotalDue) as TicketMedio
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
ORDER BY SUM(TotalDue) DESC;

-- 2.2 Ranking de clientes por gasto total
-- Identifica el top de clientes más rentables según su gasto
WITH GastoCliente AS(
	SELECT CustomerID,
	SUM(TotalDue) AS GastoTotal
	FROM Sales.SalesOrderHeader
	GROUP BY CustomerID)

	SELECT *, RANK() OVER(ORDER BY GastoTotal DESC) AS Ranking,
	CASE
		WHEN RANK() OVER(ORDER BY GastoTotal DESC) <= 10 THEN 'TOP 10'
        WHEN RANK() OVER (ORDER BY GastoTotal DESC) <= 50 THEN 'TOP 50'
		ELSE 'Resto'
	END AS Segmento
	FROM GastoCliente;

-- 2.3 Top 2 pedidos más altos por cliente
-- Útil para identificar los momentos de mayor compra por cliente
SELECT *
	FROM( SELECT CustomerID, SalesOrderID, TotalDue, OrderDate,
		ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY TotalDue DESC) AS Ranking
		FROM Sales.SalesOrderHeader) t
		WHERE Ranking <= 2
		ORDER BY CustomerID, Ranking;

-- 2.4 Primer pedido de cada cliente (fecha de captación)
SELECT * 
	FROM( SELECT CustomerID, SalesOrderID, TotalDue, OrderDate, 
		ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY OrderDate ASC) AS OrdenPedidos
		FROM Sales.SalesOrderHeader) t
		WHERE OrdenPedidos = 1
		ORDER BY CustomerID, OrderDate ASC;

-- 2.5 Segmentación de clientes en cuartiles por gasto total
-- Cuartil 1 = clientes de mayor valor, Cuartil 4 = menor valor
WITH GastoCliente AS ( 
	SELECT CustomerID, SUM(TotalDue) AS GastoTotal
	FROM Sales.SalesOrderHeader
	GROUP BY CustomerID)

SELECT *, NTILE(4) OVER (ORDER BY GastoTotal DESC) AS Grupo,
	CASE
		WHEN NTILE(4) OVER (ORDER BY GastoTotal DESC) = 1 THEN 'Premium'
		WHEN NTILE(4) OVER (ORDER BY GastoTotal DESC) = 2 THEN 'Alto'
		WHEN NTILE(4) OVER (ORDER BY GastoTotal DESC) = 3 THEN 'Medio'
		WHEN NTILE(4) OVER (ORDER BY GastoTotal DESC) = 4 THEN 'Básico'
	END AS TipoGrupo
	FROM GastoCliente;


-- ============================================================
-- BLOQUE 3: ANÁLISIS DE PRODUCTOS Y CATEGORÍAS
-- Pregunta de negocio: ¿Qué productos tienen mayor margen y precio?
-- ¿Cómo se distribuyen por categoría y subcategoría?
-- ¿Qué productos concentran mayor valor en stock?
-- ============================================================

-- 3.0 Vista general por categoría
SELECT c.[Name] AS Categoria,
    COUNT(p.ProductID) AS NumeroProductos,
    ROUND(AVG(p.ListPrice), 2) AS PrecioPromedio,
    ROUND(MIN(p.ListPrice), 2) AS PrecioMinimo,
    ROUND(MAX(p.ListPrice), 2) AS PrecioMaximo
FROM Production.ProductCategory c
JOIN Production.ProductSubcategory s ON c.ProductCategoryID = s.ProductCategoryID
JOIN Production.Product p ON s.ProductSubcategoryID = p.ProductSubcategoryID
WHERE p.ListPrice > 0
GROUP BY c.[Name]
ORDER BY PrecioPromedio DESC;

-- 3.1 Rentabilidad por producto
SELECT [Name], ProductID, Color, ListPrice, StandardCost, 
	(ListPrice - StandardCost) AS MargenBruto,
	((ListPrice - StandardCost) / ListPrice * 100) AS PorcentajeMargen
FROM Production.Product
WHERE ListPrice > 0
ORDER BY PorcentajeMargen DESC;

-- 3.2 Precio promedio por subcategoría de producto
WITH InfoSubcat AS ( SELECT s.[Name], COUNT(p.ProductID) as NumeroProductos, AVG(p.ListPrice) as PrecioPromedio, 
									MIN(p.ListPrice) as PrecioMinimo, MAX(p.ListPrice) as PrecioMaximo
					FROM Production.ProductSubcategory s
					JOIN Production.Product p ON s.ProductSubcategoryID = p.ProductSubcategoryID
					GROUP BY s.[Name])

SELECT * FROM InfoSubcat
ORDER BY PrecioPromedio DESC;

-- 3.3 Productos con mayor stock valorado
-- (cantidad en inventario × coste estándar)
SELECT p.[Name] as Nombre, SUM(i.Quantity) as StockTotal, p.StandardCost,ROUND((SUM(i.Quantity) * p.StandardCost), 2) as ValorStock
	FROM Production.Product p
	JOIN Production.ProductInventory i ON p.ProductID = i.ProductID
	WHERE StandardCost != 0
	GROUP BY p.[Name], p.StandardCost
	ORDER BY ValorStock DESC;

-- 3.4 Ranking de productos dentro de su subcategoría por precio
SELECT s.[Name] as Subcategoria, p.[Name] as Producto, p.ListPrice, 
		RANK() OVER(PARTITION BY s.[Name] ORDER BY p.ListPrice DESC) as Ranking
FROM Production.Product p
JOIN Production.ProductSubcategory s ON p.ProductSubcategoryID = s.ProductSubcategoryID;

-- 3.5 Top 1 producto más caro por subcategoría
SELECT * FROM ( SELECT s.[Name] as Subcategoria, p.[Name] as Producto, p.ListPrice, 
		ROW_NUMBER() OVER(PARTITION BY s.[Name] ORDER BY p.ListPrice DESC) as Ranking
FROM Production.Product p
JOIN Production.ProductSubcategory s ON p.ProductSubcategoryID = s.ProductSubcategoryID) t
WHERE Ranking = 1
ORDER BY ListPrice DESC;


-- ============================================================
-- BLOQUE 4: ANÁLISIS TEMPORAL DE VENTAS
-- Pregunta de negocio: ¿Cómo evolucionan las ventas mes a mes?
-- ¿Dónde están los picos, caídas y tendencias?
-- ============================================================

-- 4.1 Ventas mensuales totales
SELECT YEAR(OrderDate) AS Año, MONTH(OrderDate) AS Mes, DATENAME(MONTH, OrderDate) AS NombreMes, COUNT(SalesOrderID) AS NumeroPedidos,
		ROUND(SUM(TotalDue), 2) AS VentasMensuales
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate), MONTH(OrderDate), DATENAME(MONTH, OrderDate)
ORDER BY Año, Mes;

-- 4.2 Comparativa con el mes anterior usando LAG
-- ¿Cuánto crecemos o caemos respecto al mes previo?
WITH VentasMensuales AS (
    SELECT 
        YEAR(OrderDate) AS Año,
        MONTH(OrderDate) AS Mes,
        SUM(TotalDue) AS VentasMes
    FROM Sales.SalesOrderHeader
    GROUP BY YEAR(OrderDate), MONTH(OrderDate)
)
SELECT 
    Año,
    Mes,
    VentasMes,
    LAG(VentasMes) OVER (ORDER BY Año, Mes) AS VentasMesAnterior,
    VentasMes - LAG(VentasMes) OVER (ORDER BY Año, Mes) AS Diferencia,
    ((VentasMes - LAG(VentasMes) OVER (ORDER BY Año, Mes)) 
    / NULLIF(LAG(VentasMes) OVER (ORDER BY Año, Mes), 0)) * 100 AS CrecimientoPorcentual
FROM VentasMensuales
ORDER BY Año, Mes;

-- 4.3 Acumulado de ventas por año (YTD)
SELECT 
    YEAR(OrderDate) AS Año,
    MONTH(OrderDate) AS Mes,
    SUM(TotalDue) AS VentasMes,
    SUM(SUM(TotalDue)) OVER (
        PARTITION BY YEAR(OrderDate) 
        ORDER BY MONTH(OrderDate)
    ) AS VentasAcumuladasAño
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY Año, Mes;

-- 4.4 Ventas por trimestre y año
SELECT 
    YEAR(OrderDate) AS Año,
    DATEPART(QUARTER, OrderDate) AS Trimestre,
    COUNT(SalesOrderID) AS NumeroPedidos,
    SUM(TotalDue) AS VentasTrimestre
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate), DATEPART(QUARTER, OrderDate)
ORDER BY Año, Trimestre;


-- ============================================================
-- BLOQUE 5: ANÁLISIS DE EMPLEADOS Y EQUIPO COMERCIAL
-- Pregunta de negocio: ¿Qué perfil tienen nuestros empleados?
-- ¿Cómo rinden los comerciales por territorio?
-- ============================================================

-- 5.1 Distribución de empleados por departamento
SELECT 
    d.Name AS Departamento,
    COUNT(edh.BusinessEntityID) AS NumeroEmpleados
FROM HumanResources.EmployeeDepartmentHistory edh
JOIN HumanResources.Department d ON edh.DepartmentID = d.DepartmentID
WHERE edh.EndDate IS NULL
GROUP BY d.Name
ORDER BY NumeroEmpleados DESC;

-- 5.2 Perfil demográfico de empleados
-- Género, estado civil y edad media por departamento
SELECT 
    d.Name AS Departamento,
    e.Gender AS Genero,
    e.MaritalStatus AS EstadoCivil,
    COUNT(*) AS NumeroEmpleados,
    AVG(DATEDIFF(YEAR, e.BirthDate, GETDATE())) AS EdadMedia
FROM HumanResources.Employee e
JOIN HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
JOIN HumanResources.Department d ON edh.DepartmentID = d.DepartmentID
WHERE edh.EndDate IS NULL
GROUP BY d.Name, e.Gender, e.MaritalStatus
ORDER BY d.Name;

-- 5.3 Rendimiento de comerciales por territorio
-- ¿Qué vendedor genera más ventas en su zona?
SELECT 
    p.FirstName + ' ' + p.LastName AS NombreComercial,
    st.Name AS Territorio,
    st.[Group] AS Region,
    ROUND(sp.SalesYTD, 2) AS VentasAnuales,
    ROUND(sp.SalesQuota, 2) AS ObjetivoVentas,
    ROUND(sp.SalesYTD / NULLIF(sp.SalesQuota, 0) * 100, 2) AS CumplimientoObjetivo
FROM Sales.SalesPerson sp
LEFT JOIN Sales.SalesTerritory st ON sp.TerritoryID = st.TerritoryID
JOIN Person.Person p ON sp.BusinessEntityID = p.BusinessEntityID
ORDER BY VentasAnuales DESC;

-- 5.4 Ranking de comerciales dentro de su territorio
WITH RendimientoComercial AS (
    SELECT 
        p.FirstName + ' ' + p.LastName AS NombreComercial,
        st.Name AS Territorio,
        ROUND(sp.SalesYTD, 2) AS VentasAnuales
    FROM Sales.SalesPerson sp
    LEFT JOIN Sales.SalesTerritory st ON sp.TerritoryID = st.TerritoryID
    JOIN Person.Person p ON sp.BusinessEntityID = p.BusinessEntityID
    WHERE st.Name IS NOT NULL
)
SELECT *,
    RANK() OVER (PARTITION BY Territorio ORDER BY VentasAnuales DESC) AS RankingEnTerritorio
FROM RendimientoComercial
ORDER BY Territorio, RankingEnTerritorio;

