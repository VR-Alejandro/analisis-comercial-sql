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
SELECT * from Sales.SalesTerritory
-- 1.1 Vista general de territorios y sus ventas anuales
SELECT 
    TerritoryID,
    Name AS Territorio,
    [Group] AS Region,
    SalesYTD
FROM Sales.SalesTerritory
ORDER BY SalesYTD DESC;

-- 1.2 Territorios que superan la media global de ventas
-- (candidatos a recibir incentivos por rendimiento)
SELECT 
    Name AS Territorio,
    SalesYTD,
    ROUND((SELECT AVG(SalesYTD) FROM Sales.SalesTerritory), 2) AS MediaGlobal
FROM Sales.SalesTerritory
WHERE SalesYTD > (SELECT AVG(SalesYTD) FROM Sales.SalesTerritory)
ORDER BY SalesYTD DESC;

-- 1.3 Peso porcentual de cada territorio sobre el total de ventas
-- ¿Qué territorios concentran más facturación?
SELECT 
    TerritoryID,
    Name AS Territorio,
    [Group] AS Region,
    ROUND(SalesYTD, 2) AS VentasAnuales,
    ROUND(SUM(SalesYTD) OVER (), 2) AS TotalGlobalVentas,
    ROUND((SalesYTD / SUM(SalesYTD) OVER ()) * 100, 2) AS PorcentajeSobreTotal
FROM Sales.SalesTerritory
ORDER BY PorcentajeSobreTotal DESC;

-- 1.4 Ventas totales por región geográfica
SELECT 
    [Group] AS Region,
    ROUND(SUM(SalesYTD), 2) AS TotalVentasPorRegion,
    ROUND(SUM(SalesYTD) / SUM(SUM(SalesYTD)) OVER () * 100, 2) AS PorcentajeRegion
FROM Sales.SalesTerritory
GROUP BY [Group]
ORDER BY TotalVentasPorRegion DESC;


-- ============================================================
-- BLOQUE 2: ANÁLISIS DE CLIENTES
-- Pregunta de negocio: ¿Cuáles son nuestros clientes más
-- valiosos y cómo se distribuye su comportamiento de compra?
-- ============================================================

-- 2.1 Gasto total por cliente
SELECT 
    CustomerID,
    COUNT(SalesOrderID) AS NumeroPedidos,
    ROUND(SUM(TotalDue), 2) AS GastoTotal,
    ROUND(AVG(TotalDue), 2) AS TicketMedio
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
ORDER BY GastoTotal DESC;

-- 2.2 Ranking de clientes por gasto total
-- Identifica el top de clientes más rentables
WITH GastoCliente AS (
    SELECT 
        CustomerID,
        COUNT(SalesOrderID) AS NumeroPedidos,
        ROUND(SUM(TotalDue), 2) AS GastoTotal,
        ROUND(AVG(TotalDue), 2) AS TicketMedio
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID
)
SELECT *,
    RANK() OVER (ORDER BY GastoTotal DESC) AS RankingCliente,
    CASE 
        WHEN RANK() OVER (ORDER BY GastoTotal DESC) <= 10 THEN 'TOP 10'
        WHEN RANK() OVER (ORDER BY GastoTotal DESC) <= 50 THEN 'TOP 50'
        ELSE 'Resto'
    END AS Segmento
FROM GastoCliente;

-- 2.3 Top 2 pedidos más altos por cliente
-- Útil para identificar los momentos de mayor compra por cliente
SELECT *
FROM (
    SELECT 
        CustomerID,
        SalesOrderID,
        ROUND(TotalDue, 2) AS ImportePedido,
        OrderDate,
        ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY TotalDue DESC) AS Ranking
    FROM Sales.SalesOrderHeader
) t
WHERE Ranking <= 2
ORDER BY CustomerID, Ranking;

-- 2.4 Primer pedido de cada cliente (fecha de captación)
SELECT *
FROM (
    SELECT 
        CustomerID,
        SalesOrderID,
        OrderDate AS FechaPrimerPedido,
        ROUND(TotalDue, 2) AS ImportePrimerPedido,
        ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate ASC) AS Orden
    FROM Sales.SalesOrderHeader
) t
WHERE Orden = 1
ORDER BY FechaPrimerPedido;

-- 2.5 Segmentación de clientes en cuartiles por gasto total
-- Cuartil 1 = clientes de mayor valor, Cuartil 4 = menor valor
WITH GastoCliente AS (
    SELECT 
        CustomerID,
        ROUND(SUM(TotalDue), 2) AS GastoTotal
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID
)
SELECT *,
    NTILE(4) OVER (ORDER BY GastoTotal DESC) AS Cuartil,
    CASE NTILE(4) OVER (ORDER BY GastoTotal DESC)
        WHEN 1 THEN 'Premium'
        WHEN 2 THEN 'Alto'
        WHEN 3 THEN 'Medio'
        WHEN 4 THEN 'Básico'
    END AS SegmentoCliente
FROM GastoCliente
ORDER BY GastoTotal DESC;


-- ============================================================
-- BLOQUE 3: ANÁLISIS DE PRODUCTOS Y CATEGORÍAS
-- Pregunta de negocio: ¿Qué productos y categorías generan
-- más ingresos? ¿Cuál es el top de cada categoría?
-- ============================================================

-- 3.1 Productos disponibles con precio y categoría
SELECT 
    p.ProductID,
    p.Name AS Producto,
    p.ProductNumber,
    p.Color,
    p.ListPrice AS PrecioLista,
    p.StandardCost AS CostoEstandar,
    ROUND(p.ListPrice - p.StandardCost, 2) AS MargenBruto,
    ROUND(((p.ListPrice - p.StandardCost) / NULLIF(p.ListPrice, 0)) * 100, 2) AS PorcentajeMargen
FROM Production.Product p
WHERE p.ListPrice > 0
ORDER BY MargenBruto DESC;

-- 3.2 Precio promedio por subcategoría de producto
SELECT 
    ps.Name AS Subcategoria,
    COUNT(p.ProductID) AS NumeroProductos,
    ROUND(AVG(p.ListPrice), 2) AS PrecioPromedio,
    ROUND(MIN(p.ListPrice), 2) AS PrecioMinimo,
    ROUND(MAX(p.ListPrice), 2) AS PrecioMaximo
FROM Production.Product p
JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
WHERE p.ListPrice > 0
GROUP BY ps.Name
ORDER BY PrecioPromedio DESC;

-- 3.3 Productos con mayor stock valorado
-- (cantidad en inventario × coste estándar)
SELECT 
    p.Name AS Producto,
    SUM(pi.Quantity) AS StockTotal,
    ROUND(p.StandardCost, 2) AS CostoUnitario,
    ROUND(SUM(pi.Quantity) * p.StandardCost, 2) AS ValorStockTotal
FROM Production.Product p
JOIN Production.ProductInventory pi ON p.ProductID = pi.ProductID
WHERE p.StandardCost > 0
GROUP BY p.Name, p.StandardCost
ORDER BY ValorStockTotal DESC;

-- 3.4 Ranking de productos dentro de su subcategoría por precio
SELECT 
    ps.Name AS Subcategoria,
    p.Name AS Producto,
    p.ListPrice AS Precio,
    RANK() OVER (PARTITION BY ps.Name ORDER BY p.ListPrice DESC) AS RankingEnSubcategoria
FROM Production.Product p
JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
WHERE p.ListPrice > 0
ORDER BY ps.Name, RankingEnSubcategoria;

-- 3.5 Top 1 producto más caro por subcategoría
SELECT *
FROM (
    SELECT 
        ps.Name AS Subcategoria,
        p.Name AS Producto,
        p.ListPrice AS Precio,
        ROW_NUMBER() OVER (PARTITION BY ps.Name ORDER BY p.ListPrice DESC) AS Ranking
    FROM Production.Product p
    JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
    WHERE p.ListPrice > 0
) t
WHERE Ranking = 1
ORDER BY Precio DESC;


-- ============================================================
-- BLOQUE 4: ANÁLISIS TEMPORAL DE VENTAS
-- Pregunta de negocio: ¿Cómo evolucionan las ventas mes a mes?
-- ¿Dónde están los picos, caídas y tendencias?
-- ============================================================

-- 4.1 Ventas mensuales totales
SELECT 
    YEAR(OrderDate) AS Año,
    MONTH(OrderDate) AS Mes,
    DATENAME(MONTH, OrderDate) AS NombreMes,
    COUNT(SalesOrderID) AS NumeroPedidos,
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
        ROUND(SUM(TotalDue), 2) AS VentasMes
    FROM Sales.SalesOrderHeader
    GROUP BY YEAR(OrderDate), MONTH(OrderDate)
)
SELECT 
    Año,
    Mes,
    VentasMes,
    LAG(VentasMes) OVER (ORDER BY Año, Mes) AS VentasMesAnterior,
    ROUND(VentasMes - LAG(VentasMes) OVER (ORDER BY Año, Mes), 2) AS Diferencia,
    ROUND(
        ((VentasMes - LAG(VentasMes) OVER (ORDER BY Año, Mes)) 
        / NULLIF(LAG(VentasMes) OVER (ORDER BY Año, Mes), 0)) * 100
    , 2) AS CrecimientoPorcentual
FROM VentasMensuales
ORDER BY Año, Mes;

-- 4.3 Acumulado de ventas por año (YTD)
SELECT 
    YEAR(OrderDate) AS Año,
    MONTH(OrderDate) AS Mes,
    ROUND(SUM(TotalDue), 2) AS VentasMes,
    ROUND(SUM(SUM(TotalDue)) OVER (
        PARTITION BY YEAR(OrderDate) 
        ORDER BY MONTH(OrderDate)
    ), 2) AS VentasAcumuladasAño
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY Año, Mes;

-- 4.4 Ventas por trimestre y año
SELECT 
    YEAR(OrderDate) AS Año,
    DATEPART(QUARTER, OrderDate) AS Trimestre,
    COUNT(SalesOrderID) AS NumeroPedidos,
    ROUND(SUM(TotalDue), 2) AS VentasTrimestre
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
