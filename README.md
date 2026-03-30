# Target_ecommerce_analysis
SQL-based analysis of Brazilian e-commerce data covering sales trends, customer behavior, logistics, and payment insights.

# Target E-commerce Sales Analysis (Brazil)

## OVERVIEW
This project analyzes an e-commerce dataset to understand customer behavior, sales trends, logistics efficiency, and payment patterns.
The analysis was performed using **PostgreSQL**, covering data cleaning, exploration, and business insights generation.

---

## OBJECTIVE

- Analyze order trends over time
- Identify regional demand patterns
- Evaluate logistics performance (delivery time & freight)
- Understand payment behavior
- Measure business growth and economic impact

---

## DATASET

The dataset includes:

- Customers
- Orders
- Order Items
- Payments
- Products
- Sellers
- Geolocation

---

## KEY ANALYSIS AREAS

### 1. Exploratory Analysis
- Time range of orders
- Customer distribution across states and cities

### 2. In-depth Exploration
- Yearly and monthly order trends
- Seasonality patterns
- Customer purchase behavior by time of day

### 3. Evolution of Orders
- Month-on-month orders by state
- Customer distribution across regions

### 4. Economic Impact
- Total revenue and freight contribution
- Revenue growth (2017 → 2018)
- State-wise revenue and cost analysis

### 5. Logistics Analysis
- Delivery time calculation
- Difference between estimated vs actual delivery
- Top states by freight cost
- Fastest and slowest delivery regions

### 6. Payment Analysis
- Orders by payment type over time
- Installment usage distribution

---

## KEY INSIGHTS

- Business scaled rapidly from 2016 to 2018
- Strong seasonal spike observed in November (likely Black Friday)
- Majority of orders placed during afternoon and evening
- Revenue heavily concentrated in major states like SP, RJ, MG
- Northern states show higher freight costs and slower delivery
- Credit card dominates payments, with strong installment usage

---

## TOOLS USED
- PostgreSQL
- SQL (Joins, Aggregations, Window Functions)
- Data Cleaning & Transformation

---

## PROJECT STRUCTURE

- `sql/` → All SQL queries
- `data/` → Raw datasets
- `outputs/` → Query results / screenshots
- `docs/` → Detailed case study explanation

---

## FUTURE WORK

This analysis will be extended by building an interactive dashboard using:

- Power BI or Tableau

to visualize trends, compare regions, and present insights in a business-friendly format.

---

## AUTHOR

**Ritu Thakur**  
Data Analyst  
