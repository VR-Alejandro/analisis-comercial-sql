# 📊 Sales Analysis with SQL Server

> Business Intelligence project focused on analyzing sales, customers, products and sales performance using **SQL Server** and **Advanced T-SQL** over the AdventureWorks2025 database.

![SQL Server](https://img.shields.io/badge/SQL_Server-CC2927?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)
![T-SQL](https://img.shields.io/badge/T--SQL-0078D4?style=for-the-badge&logo=microsoft&logoColor=white)
![SSMS](https://img.shields.io/badge/SSMS-666666?style=for-the-badge)

---

# 📖 Overview

This project simulates the work of a **Data Analyst** in a real business environment by answering key business questions using SQL.

Working with the **AdventureWorks2025** database, the project explores sales performance, customer behavior, product profitability and commercial performance through advanced SQL queries.

---

# 🎯 Business Objectives

The analysis aims to answer questions such as:

- Which sales territories generate the highest revenue?
- Who are our most valuable customers?
- Which products and categories drive the business?
- How have sales evolved over time?
- How does each salesperson perform?

---

# 📂 Project Structure

```text
sales-analysis-sql-server/

│
├── analysis/
│   └── sales_analysis.sql
│
├── images/
│   ├── territories.png
│   ├── customers.png
│   ├── products.png
│   └── sales_trend.png
│
├── CONCLUSIONS.md
│
└── README.md
```

---

# 📊 Analysis Overview

## 🌍 Sales Territories

Business Questions

- Which territories perform above average?
- What percentage of total revenue does each territory represent?

Techniques Used

- GROUP BY
- SUM()
- Window Functions
- Percentage calculations

---

## 👥 Customer Analysis

Business Questions

- Who are the highest-value customers?
- How can customers be segmented?

Techniques Used

- NTILE()
- RANK()
- ROW_NUMBER()
- Customer segmentation

---

## 📦 Products & Categories

Business Questions

- Which products generate the highest revenue?
- Which categories are the most profitable?

Techniques Used

- JOINs
- Aggregations
- Ranking

---

## 📈 Sales Trends

Business Questions

- How have sales evolved over time?
- Are there seasonal peaks?

Techniques Used

- LAG()
- LEAD()
- Running Totals
- Date Functions

---

## 👨‍💼 Sales Performance

Business Questions

- Which salespeople generate the highest revenue?
- How does performance vary across territories?

Techniques Used

- Window Functions
- Ranking
- Performance Analysis

---

# 💻 SQL Concepts Applied

### Core SQL

- SELECT
- WHERE
- GROUP BY
- HAVING
- ORDER BY

### Joins

- INNER JOIN
- LEFT JOIN
- Multi-table JOINs

### Advanced SQL

- Common Table Expressions (CTEs)
- Window Functions
- PARTITION BY
- RANK()
- DENSE_RANK()
- ROW_NUMBER()
- NTILE()

### Time Intelligence

- LAG()
- LEAD()
- Year-to-Date calculations
- DATEPART()
- DATENAME()
- DATEDIFF()

### Conditional Logic

- CASE
- ISNULL()
- NULLIF()

---

# 📷 Example Results

### 🌍 Sales Territories

*(Insert territory ranking screenshot here)*

---

### 👥 Customer Segmentation

*(Insert customer segmentation screenshot here)*

---

### 📦 Product Performance

*(Insert product analysis screenshot here)*

---

### 📈 Sales Trends

*(Insert sales trend screenshot here)*

---

# 💡 Business Insights

The analysis revealed several valuable business insights:

- Certain territories consistently outperform the company average.
- A relatively small percentage of customers generate most of the revenue.
- Product sales are highly concentrated in a few categories.
- Sales show clear seasonal patterns.
- Salesperson performance varies significantly between territories.

Detailed findings and recommendations are available in **CONCLUSIONS.md**.

---

# 🛠 Tech Stack

- SQL Server 2022
- T-SQL
- SQL Server Management Studio (SSMS)
- AdventureWorks2025

---

# 🚀 How to Run

```sql
1. Install SQL Server 2022.

2. Install SQL Server Management Studio (SSMS).

3. Restore the AdventureWorks2025 database.

4. Open:

sales_analysis.sql

5. Execute each analysis block independently or run the complete script.
```

---

# 🔮 Future Improvements

- Create an interactive Power BI dashboard.
- Build stored procedures for automated reporting.
- Optimize complex queries.
- Connect SQL Server directly to Power BI.
- Add KPI monitoring dashboards.

---

# 👨‍💻 Author

**Alejandro Villodres Romero**

Junior Data Analyst

📍 Málaga, Spain

💼 LinkedIn

💻 GitHub

📧 alejandrovillodres.job@gmail.com

---

⭐ If you found this project interesting, feel free to leave a star or connect with me on LinkedIn.
