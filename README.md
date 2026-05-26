# 📊 Análisis Comercial con SQL Server

Análisis completo de ventas, clientes, productos y rendimiento comercial sobre la base de datos **AdventureWorks2025** usando T-SQL avanzado.

---

## 🎯 Objetivo del proyecto

Responder preguntas de negocio reales a través de consultas SQL estructuradas, simulando el trabajo de un analista de datos en un entorno empresarial. El proyecto cubre desde consultas básicas hasta técnicas avanzadas como CTEs, Window Functions y análisis temporal.

---

## 🗂️ Estructura del análisis

| Bloque | Temática | Pregunta de negocio |
|--------|----------|---------------------|
| 1 | Territorios y ventas | ¿Qué territorios superan la media y qué peso tienen sobre el total? |
| 2 | Análisis de clientes | ¿Cuáles son nuestros clientes más valiosos y cómo se segmentan? |
| 3 | Productos y categorías | ¿Qué productos y categorías generan más ingresos? |
| 4 | Evolución temporal | ¿Cómo evolucionan las ventas mes a mes y dónde están los picos? |
| 5 | Empleados y equipo comercial | ¿Cómo rinden los comerciales por territorio? |

---

## 🛠️ Tecnologías utilizadas

- **SQL Server 2022**
- **T-SQL**
- **SQL Server Management Studio (SSMS)**
- **Base de datos:** AdventureWorks2025

---

## 🧠 Conceptos técnicos aplicados

- `SELECT`, `WHERE`, `GROUP BY`, `HAVING`, `ORDER BY`
- `JOIN` (INNER, LEFT, múltiples tablas)
- Subconsultas escalares, de lista y de tabla
- CTEs (`WITH`)
- Window Functions: `SUM OVER`, `RANK`, `DENSE_RANK`, `ROW_NUMBER`, `NTILE`
- `PARTITION BY`
- Análisis temporal: `LAG`, `LEAD`, acumulados YTD
- Funciones de fecha: `DATEDIFF`, `DATEPART`, `DATENAME`
- Funciones condicionales: `CASE WHEN`, `ISNULL`, `NULLIF`

---

## ▶️ Cómo ejecutar el proyecto

1. Instala **SQL Server 2022** y **SSMS**
2. Descarga e instala la base de datos [AdventureWorks2025](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure)
3. Abre el archivo `analisis_comercial_adventureworks.sql` en SSMS
4. Ejecuta cada bloque de forma independiente o el script completo

---

## 👤 Autor

**Alejandro Villodres Romero**
Analista de Datos | SQL · Power BI · Python
[LinkedIn](https://www.linkedin.com/in/Alejandro-Villodres-Romero) · [GitHub](https://github.com/VR-Alejandro)
