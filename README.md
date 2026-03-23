# E-Commerce Analytics Project

## Project Overview
This project analyzes transactional data from an e-commerce platform to provide actionable insights into **sales performance, customer behavior, product trends, and delivery efficiency**. The goal is to turn raw operational data into structured analytical datasets and interactive visualizations.

## How the Project Works

### Data Structure
The data is organized into **fact and dimension tables** to facilitate analysis:

- **Fact Table (`fact_sales`)**: Combines order, payment, and order item details. Key fields include order ID, customer ID, product ID, timestamps, price, and total payments.
- **Dimension Tables**: Contain descriptive attributes to enrich the fact table:
  - `dim_customer`: Customer information and demographics
  - `dim_product`: Product details and categories
  - `dim_seller`: Seller information and location
- **Relationships** are established between fact and dimension tables to allow aggregation by customer, product, seller, category, geography, and time.

### Data Analysis Approach
1. **Aggregating Payments**: Each order may have multiple payments. Payments are summed per order to prevent double-counting revenue.
2. **Joining Tables**: Orders, products, customers, and payments are joined to create a single analytical dataset (`fact_sales`) for reporting and BI visualization.
3. **Building KPIs**: Metrics such as total revenue, order count, average order value, and delivery time are calculated to measure performance.
4. **Visualization in Power BI**: Interactive dashboards allow slicing data by time, category, region, or customer type.

## Key Insights
- **Sales Trends**: Peak sales occurred in November 2017 with over 7,400 orders, while seasonal lows appear in December and September. Average order value ranges between 135–150.  
- **Product Performance**: Categories like `health_beauty`, `watches_gifts`, and `bed_bath_table` generate the highest revenue. Low-priced categories like `fashion_female_clothing` underperform despite affordability.  
- **Customer Behavior**: Most customers are **one-time buyers**, with only a small fraction returning. Average customer spend is ~142, but some high-value customers spend over 13,000.  
- **Delivery Efficiency**: Average delivery is 12 days, with the majority delivered on time. Occasional outliers (e.g., 54-day deliveries) highlight logistic challenges.

## Dashboard Highlights
- **Page 1 — Sales & Revenue**: Trends over time for order count and total revenue.  
- **Page 2 — Customer Insights**: Distribution of new vs. returning customers, regional concentration, and spending patterns.  
- **Page 3 — Product Performance**: Revenue and average price per category.  
- **Page 4 — Delivery**: Delivery time distribution and on-time vs late orders.  
- **Interactive Features**: Filters allow dynamic exploration by date, category, region, or customer type.

## Conclusion
This project demonstrates how raw e-commerce data can be transformed into actionable insights. Businesses can use this analysis to:
- Identify high-performing product categories  
- Target repeat customers with loyalty programs  
- Optimize delivery processes  
- Adjust inventory and marketing strategies based on customer behavior and product trends
