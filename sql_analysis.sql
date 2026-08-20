-- ============================================================
-- Retail Sales Analysis — SQL Queries
-- Database: retail_sales.db  |  Table: sales
-- Author: Mounika
-- ============================================================

-- 1. Total revenue, orders, and average order value (overall KPIs)
SELECT
    COUNT(DISTINCT order_id)          AS total_orders,
    ROUND(SUM(net_sales), 2)          AS total_revenue,
    ROUND(AVG(net_sales), 2)          AS avg_order_value
FROM sales
WHERE is_returned = 0;


-- 2. Monthly revenue trend (for line chart in Power BI)
SELECT
    strftime('%Y-%m', order_date)     AS order_month,
    ROUND(SUM(net_sales), 2)          AS monthly_revenue,
    COUNT(DISTINCT order_id)          AS monthly_orders
FROM sales
WHERE is_returned = 0
GROUP BY order_month
ORDER BY order_month;


-- 3. Revenue and order count by region
SELECT
    region,
    ROUND(SUM(net_sales), 2)          AS revenue,
    COUNT(DISTINCT order_id)          AS orders,
    ROUND(AVG(net_sales), 2)          AS avg_order_value
FROM sales
WHERE is_returned = 0
GROUP BY region
ORDER BY revenue DESC;


-- 4. Top 10 products by revenue
SELECT
    product,
    category,
    ROUND(SUM(net_sales), 2)          AS revenue,
    SUM(quantity)                     AS units_sold
FROM sales
WHERE is_returned = 0
GROUP BY product, category
ORDER BY revenue DESC
LIMIT 10;


-- 5. Category-wise performance with % contribution to total revenue
SELECT
    category,
    ROUND(SUM(net_sales), 2)          AS revenue,
    ROUND(100.0 * SUM(net_sales) / (SELECT SUM(net_sales) FROM sales WHERE is_returned = 0), 2) AS pct_of_total
FROM sales
WHERE is_returned = 0
GROUP BY category
ORDER BY revenue DESC;


-- 6. Month-over-month revenue growth (%)
WITH monthly AS (
    SELECT
        strftime('%Y-%m', order_date) AS order_month,
        SUM(net_sales)                AS revenue
    FROM sales
    WHERE is_returned = 0
    GROUP BY order_month
)
SELECT
    order_month,
    revenue,
    ROUND(revenue - LAG(revenue) OVER (ORDER BY order_month), 2)                                   AS revenue_change,
    ROUND(100.0 * (revenue - LAG(revenue) OVER (ORDER BY order_month)) / LAG(revenue) OVER (ORDER BY order_month), 2) AS mom_growth_pct
FROM monthly
ORDER BY order_month;


-- 7. Customer segment performance (Regular / Premium / New / Wholesale)
SELECT
    customer_segment,
    COUNT(DISTINCT customer_id)       AS unique_customers,
    ROUND(SUM(net_sales), 2)          AS revenue,
    ROUND(AVG(net_sales), 2)          AS avg_order_value
FROM sales
WHERE is_returned = 0
GROUP BY customer_segment
ORDER BY revenue DESC;


-- 8. Top 10 customers by lifetime spend
SELECT
    customer_id,
    customer_segment,
    COUNT(DISTINCT order_id)          AS total_orders,
    ROUND(SUM(net_sales), 2)          AS lifetime_spend
FROM sales
WHERE is_returned = 0
GROUP BY customer_id, customer_segment
ORDER BY lifetime_spend DESC
LIMIT 10;


-- 9. Return rate by category (quality / satisfaction signal)
SELECT
    category,
    COUNT(*)                                                        AS total_orders,
    SUM(is_returned)                                                AS returned_orders,
    ROUND(100.0 * SUM(is_returned) / COUNT(*), 2)                   AS return_rate_pct
FROM sales
GROUP BY category
ORDER BY return_rate_pct DESC;


-- 10. Payment method preference and average order value by method
SELECT
    payment_method,
    COUNT(DISTINCT order_id)          AS orders,
    ROUND(100.0 * COUNT(DISTINCT order_id) / (SELECT COUNT(DISTINCT order_id) FROM sales), 2) AS pct_of_orders,
    ROUND(AVG(net_sales), 2)          AS avg_order_value
FROM sales
GROUP BY payment_method
ORDER BY orders DESC;
