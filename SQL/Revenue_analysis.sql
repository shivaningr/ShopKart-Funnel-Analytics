USE shopkart;

-- What are ShopKart's total orders, total quantity sold, total revenue, and average order value?

SELECT COUNT(DISTINCT order_id) AS total_orders,
SUM(quantity) AS total_quantity,
ROUND(SUM(revenue),2) AS total_revenue,
ROUND(SUM(revenue)/COUNT(DISTINCT order_id),2) AS AOV
FROM orders;

-- What is the revenue impact of including cancelled orders?

WITH revenue_summary AS (
SELECT ROUND(sum(revenue),2) AS total_revenue,
ROUND(SUM(
         CASE
          WHEN order_status!='Cancelled'
          THEN revenue
          ELSE 0
           END),2) AS revenue_excluding_cancelled
FROM orders)
SELECT 
total_revenue,
revenue_excluding_cancelled,
ROUND(total_revenue - revenue_excluding_cancelled,2) AS cancelled_order_revenue,
ROUND((total_revenue - revenue_excluding_cancelled)/total_revenue*100,2) AS cancelled_revenue_percentage
FROM revenue_summary;

-- Month-over-month revenue growth, excluding cancelled orders.

WITH monthly_revenue AS (
SELECT 
DATE_FORMAT(order_date,'%Y-%m') AS month,
ROUND(
SUM(
CASE
WHEN order_status !='Cancelled'
THEN revenue
ELSE 0
END),2) AS revenue
FROM orders
GROUP BY DATE_FORMAT(order_date,'%Y-%m')),
revenue_with_previous AS(
SELECT
month,
revenue,
LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue
FROM monthly_revenue)
SELECT month,
revenue,
previous_month_revenue,
ROUND(
(revenue - previous_month_revenue)
/previous_month_revenue*100,2) AS mom_grouwth_percentage
FROM revenue_with_previous
ORDER BY month;

/*  How many customers placed 1 order, 2 orders, or 3+ orders, and
 what percentage of customers does each group represent? */
 
WITH customer_orders AS (
SELECT
customer_id,
COUNT(DISTINCT order_id) AS order_count
FROM orders
GROUP BY customer_id
),
customer_segments AS (
SELECT
customer_id,
CASE
WHEN order_count = 1 THEN '1 Order'
WHEN order_count = 2 THEN '2 Orders'
ELSE '3+ Orders'
END AS order_group
FROM customer_orders
)
SELECT
order_group,
COUNT(*) AS customer_count,
ROUND(
COUNT(*) * 100 / SUM(COUNT(*)) OVER (),2) AS customer_percentage
FROM customer_segments
GROUP BY order_group
ORDER BY
CASE order_group
WHEN '1 Order' THEN 1
WHEN '2 Orders' THEN 2
WHEN '3+ Orders' THEN 3
END;

/* Who are the top 10 customers by non-cancelled revenue, and what is the average non-cancelled 
revenue per ordering customer?*/

WITH customer_revenue AS (
SELECT
customer_id,
SUM(
CASE
WHEN order_status <> 'Cancelled'
THEN revenue
ELSE 0
END) AS total_revenue
FROM orders
GROUP BY customer_id
),
ranked_customers AS (
SELECT
customer_id,
ROUND(total_revenue, 2) AS total_revenue,
RANK() OVER (
ORDER BY total_revenue DESC
) AS spending_rank
FROM customer_revenue
),
customer_average AS (
SELECT
ROUND(AVG(total_revenue), 2) AS avg_revenue_per_ordering_customer
FROM customer_revenue)
SELECT
r.customer_id,
r.total_revenue,
r.spending_rank,
a.avg_revenue_per_ordering_customer
FROM ranked_customers r
CROSS JOIN customer_average a
WHERE r.spending_rank <= 10
ORDER BY r.spending_rank;
/* How many unique sessions reached each funnel event, and 
what percentage dropped off between consecutive stages?*/
WITH funnel_counts AS (
SELECT 
event_name,
COUNT(DISTINCT session_id) AS sessions
FROM session_events
WHERE event_name IN (
'Home',
'Search',
'Product View',
'Add To Cart',
'Checkout',
'Payment',
'Order Completed')
GROUP BY event_name),
funnel_with_previous AS (
SELECT 
event_name,
sessions,
LAG(sessions) OVER (
ORDER BY
CASE event_name
WHEN 'Home' THEN 1
WHEN 'Search' THEN 2
WHEN 'Product View' THEN 3
WHEN 'Add To Cart' THEN 4
WHEN 'Checkout' THEN 5
WHEN 'Payment' THEN 6
WHEN 'Order Completed' THEN 7
END ) AS previous_stage_sessions
FROM funnel_counts)
SELECT
event_name,
sessions,
previous_stage_sessions,
ROUND((previous_stage_sessions - sessions)/
previous_stage_sessions * 100,2) AS droff_off_percentage
FROM funnel_with_previous
ORDER BY 
CASE event_name
WHEN 'Home' THEN 1
WHEN 'Search' THEN 2
WHEN 'Product View' THEN 3
WHEN 'Add To Cart' THEN 4
WHEN 'Checkout' THEN 5
WHEN 'Payment' THEN 6
WHEN 'Order Completed' THEN 7
END;

/*How does each traffic source perform in terms of sessions, orders, conversion rate, and revenue?*/

WITH traffic_performance AS (
SELECT
s.traffic_source,
COUNT(DISTINCT s.session_id) AS sessions,
COUNT(DISTINCT o.order_id) AS orders,
ROUND(SUM(o.revenue), 2) AS revenue
FROM sessions s
LEFT JOIN orders o
ON s.session_id = o.session_id
GROUP BY s.traffic_source)
SELECT
traffic_source,
sessions,
orders,
ROUND(
orders * 100 / sessions,2) AS conversion_rate,
revenue
FROM traffic_performance
ORDER BY revenue DESC;

/* How does each device perform in terms of sessions, orders, conversion rate, and revenue?*/

WITH device_performance AS (
SELECT
s.device,
COUNT(DISTINCT s.session_id) AS sessions,
COUNT(DISTINCT o.order_id) AS orders,
ROUND(SUM(o.revenue), 2) AS revenue
FROM sessions s
LEFT JOIN orders o
ON s.session_id = o.session_id
GROUP BY s.device)
SELECT
device,
sessions,
orders,
ROUND(
orders * 100 / sessions,2) AS conversion_rate,
revenue
FROM device_performance
ORDER BY revenue DESC;

/*How efficiently are the marketing campaigns generating clicks and
 conversions relative to impressions and campaign spend?*/
 
SELECT
campaign_id,
campaign_name,
source,
medium,
impressions,
clicks,
conversions,
campaign_cost,
ROUND(
clicks * 100 / NULLIF(impressions, 0),2) AS ctr_percentage,
ROUND(campaign_cost / NULLIF(clicks, 0),2) AS cost_per_click,
ROUND(campaign_cost / NULLIF(conversions, 0),2) AS cost_per_conversion
FROM marketing_campaigns
ORDER BY cost_per_conversion;

/*What is the actual average delivery time for orders that were delivered?*/

SELECT
ROUND(
AVG(DATEDIFF(delivery_date, order_date)),2
) AS avg_delivery_days,
MIN(DATEDIFF(delivery_date, order_date)
) AS min_delivery_days,
MAX(DATEDIFF(delivery_date, order_date)
) AS max_delivery_days
FROM orders
WHERE order_status = 'Delivered'
AND delivery_date IS NOT NULL;