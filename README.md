# ShopKart Funnel Analytics



## Project Overview



ShopKart India is an e-commerce analytics project focused on understanding customer purchasing behaviour, analysing the conversion funnel, and evaluating revenue and order performance.



The project uses **MySQL for data cleaning, validation, and business analysis** and **Power BI for interactive data visualization and dashboard development**.



The objective is to identify where customers drop off during their purchasing journey, evaluate the performance of different acquisition channels and devices, and generate actionable business insights.



## Business Objectives



- Analyse customer movement through the e-commerce conversion funnel.

- Identify stages with the highest customer drop-offs.

- Evaluate conversion rates across different traffic sources.

- Compare purchasing behaviour across mobile, desktop, and tablet users.

- Analyse revenue trends, order performance, and average order value.

- Identify repeat-purchase patterns and high-value customers.

- Examine product returns, refunds, and delivery performance.

- Evaluate marketing campaign performance using available campaign metrics.



## Tools & Technologies



| Tool | Purpose |

|---|---|

| MySQL 8.0 | Data cleaning, transformation, validation, and SQL analysis |

| MySQL Workbench | SQL development and database management |

| Power BI | Interactive dashboards and data visualization |

| DAX | Calculated measures and business KPIs |

| Power Query | Not used; data preparation was performed in MySQL |

| Git & GitHub | Version control and project documentation |



## Dataset Overview



The project contains seven interconnected datasets with **117,519 records**.



| Dataset | Records |

|---|---:|

| Customers | 5,075 |

| Products | 300 |

| Sessions | 20,000 |

| Session Events | 89,064 |

| Orders | 7,000 |

| Returns | 1,000 |

| Marketing Campaigns | 80 |

| **Total** | **117,519** |



## Data Cleaning & Preparation



Data profiling, cleaning, and validation were performed using MySQL.



Key activities included:



- Identifying and handling invalid customer age values.

- Standardising inconsistent product category values.

- Handling missing session dates, durations, and discount percentages.

- Correcting date formats in marketing campaign data.

- Reviewing repeated session identifiers and preserving distinct session records.

- Validating order statuses and delivery dates.

- Checking data consistency and relationships across datasets.

- Using appropriate data types for identifiers, dates, and numerical fields.



### Important Data Quality Decisions



- Invalid customer ages were replaced with NULL rather than assigning assumed values.

- Missing values were retained as NULL where appropriate.

- Repeated session IDs were investigated because they represented distinct sessions rather than duplicate records.

- Phone numbers were treated as text to preserve formatting and potential leading zeros.



## Data Model & Relationships



The Power BI data model includes relationships between customers, sessions, orders, products, returns, and the date table.



Key modelling decisions:



- Customer information connects to sessions and orders.

- Product information connects to orders.

- Session events connect to sessions.

- Returns connect to orders through a one-to-one relationship.

- The Sessions-to-Orders relationship was kept inactive to avoid ambiguous filter paths.

- Marketing campaign data remained disconnected because no reliable campaign-to-order linking key was available.



## SQL Analysis



SQL was used to answer business questions through aggregations, joins, conditional logic, CTEs, window functions, and date calculations.



Key analysis areas:



1. Overall sales and revenue performance.

2. Revenue associated with cancelled orders.

3. Monthly revenue trends and growth.

4. Repeat-purchase behaviour.

5. Customer revenue contribution and high-value customers.

6. Customer conversion funnel and stage-wise drop-offs.

7. Traffic-source performance.

8. Device-wise conversion and revenue analysis.

9. Marketing campaign performance.

10. Average delivery time and delivery performance.



## Key Business Metrics



| KPI | Result |

|---|---:|

| Total Customers | 5,075 |

| Total Sessions | 20,000 |

| Total Orders | 7,000 |

| Customers With Orders | 3,759 |

| Customer Conversion Rate | 74.07% |

| Session Conversion Rate | 35.00% |

| Total Revenue | ₹80,675,772.26 |

| Average Order Value | ₹11,525.11 |

| Total Quantity Sold | 10,443 |

| Average Delivery Time | 4.62 days |



**Note:** Customer conversion rate, session conversion rate, and funnel completion rate use different denominators and represent different stages of business performance.



## E-commerce Conversion Funnel



The customer journey was analysed across seven stages:



**Home → Search → Product View → Add to Cart → Checkout → Payment → Order Completed**



| Funnel Stage | Sessions |

|---|---:|

| Home | 19,218 |

| Search | 17,459 |

| Product View | 15,053 |

| Add to Cart | 10,872 |

| Checkout | 8,902 |

| Payment | 7,731 |

| Order Completed | 7,170 |



**Overall Funnel Completion Rate: 37.31%**



The largest stage-wise drop-off occurred between Product View and Add to Cart, at approximately 27.78%.



This indicates an opportunity to investigate product-page experience, pricing, product information, and customer purchase intent.



## Key Business Insights



### 1. Traffic Source Performance



Direct traffic generated the highest session conversion rate at approximately 52.64%, followed by Email at 46.58%.



Google Ads generated substantial traffic but had a lower session conversion rate of approximately 24.91%.



**Business implication:** Further investigation of paid advertising targeting and landing-page performance could help improve conversion efficiency.



### 2. Device Performance



| Device | Sessions | Session Conversion Rate |

|---|---:|---:|

| Mobile | 13,971 | 33.81% |

| Desktop | 4,876 | 38.39% |

| Tablet | 1,153 | 35.13% |



Mobile accounted for the largest share of sessions, while desktop had the highest conversion rate.



**Business implication:** Improving the mobile shopping experience could help address the conversion gap.



### 3. Repeat Purchase Behaviour



Among the 3,759 customers who placed orders:



- 46.32% placed one order.

- 30.99% placed two orders.

- 22.69% placed three or more orders.



Approximately 53.68% of ordering customers placed at least two orders.



**Business implication:** Customer engagement and retention initiatives could help encourage additional purchases.



### 4. Revenue Performance



Total recorded revenue was approximately ₹8.07 crore, with an average order value of ₹11,525.11.



Revenue analysis was performed across monthly trends, order statuses, product categories, and individual products.



### 5. Returns & Refunds



Return and refund performance was analysed by return reason.



Size-related issues generated the highest refund amount, approximately ₹17.1 lakh.



**Business implication:** Improving product sizing information and size guides could help reduce size-related returns.



### 6. Delivery Performance



The average delivery time for eligible delivered orders was approximately 4.62 days.



Delivery duration was calculated using the difference between order date and delivery date.



## Power BI Dashboard



The Power BI report contains two main analytical pages.



### Page 1: Funnel & Acquisition Analysis



Focuses on customer acquisition and conversion performance.



Key components:

- Total Sessions

- Sessions With Orders

- Session Conversion Rate

- Seven-stage conversion funnel

- Sessions by traffic source

- Conversion rate by traffic source

- Revenue by traffic source

- Date and traffic-source slicers



### Page 2: Revenue & Order Analysis



Focuses on sales performance and order-related insights.



Key components:

- Total Revenue

- Total Orders

- Average Order Value

- Total Quantity Sold

- Monthly revenue trend

- Order status distribution

- Revenue by product category

- Top 10 products

- Refund amount by return reason

- Date and category slicers



## Repository Structure



```text

ShopKart-Funnel-Analytics

│

├── Dashboard_Screenshots

│   ├── 01_Funnel analysis.png

│   └── 02_Revenue & orders analysis.png

│

├── PowerBI

│   └── shopkart_funnel.pbix

│

├── SQL

│   └── Revenue_analysis.sql

│

└── README.md

```



## Business Recommendations



Based on the analysis:



1. Investigate the Product View to Add to Cart drop-off to identify potential barriers to purchasing.

2. Review Google Ads targeting and campaign landing pages to improve conversion efficiency.

3. Prioritise mobile shopping experience improvements because mobile generates the highest traffic.

4. Encourage repeat purchases through customer engagement and retention initiatives.

5. Investigate size-related product returns and improve product descriptions and sizing information.

6. Monitor delivery performance to identify opportunities for improving fulfilment efficiency.



## Important Analytical Considerations



- Customer conversion rate (74.07%) measures customers with orders against total customers.

- Session conversion rate (35%) measures sessions with orders against total sessions.

- Funnel completion rate (37.31%) measures completed-order events against Home-stage sessions.

- Revenue associated with cancelled orders is not equivalent to realised financial loss.

- Marketing campaign metrics were calculated using available impressions, clicks, conversions, and campaign costs. ROAS was not calculated because reliable campaign-to-order revenue linkage was unavailable.

- The analysis identifies patterns and associations; it does not establish causation.



## Conclusion



This project demonstrates an end-to-end e-commerce analytics workflow involving SQL-based data preparation, relational data modelling, business analysis, KPI development, and interactive Power BI dashboards.



It highlights how customer journey analysis, acquisition performance, revenue trends, and operational metrics can support data-driven business decisions.

