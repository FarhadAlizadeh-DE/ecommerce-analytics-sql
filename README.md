# E-commerce Analytics (SQL)

## Overview
This project demonstrates an end-to-end SQL analytics workflow for an e-commerce business.
Raw transactional data is transformed into analytics-ready tables and business metrics.

## Data Model
- Raw tables: raw_customers, raw_products, raw_orders, raw_order_items
- Staging layer: stg_orders, stg_order_items
- Marts: fct_orders, dim_products
- Metrics: reusable queries in sql/03_metrics

## Key Metrics
- Monthly revenue, orders, customers, AOV
- Month-over-month revenue growth
- First-time vs repeat customers (repeat rate)
- Revenue by product category + category MoM growth
- Basic customer lifetime value (CLV)

## Tech Stack
- PostgreSQL
- Docker
- SQL (views for staging, marts, metrics)

## How to Run

### Start Postgres (Docker)
\`\`\`bash
docker compose up -d
\`\`\`

### Create tables
\`\`\`bash
psql "postgresql://analytics:analytics_pw@localhost:5433/ecom_analytics" -f schema/00_create_tables.sql
\`\`\`

### Load sample data
\`\`\`bash
psql "postgresql://analytics:analytics_pw@localhost:5433/ecom_analytics" -f schema/01_insert_sample_data.sql
\`\`\`

### Build staging + marts + metrics
Run files in this order:
1. sql/01_staging/
2. sql/02_marts/
3. sql/03_metrics/

Example:
\`\`\`bash
psql "postgresql://analytics:analytics_pw@localhost:5433/ecom_analytics" -f sql/01_staging/stg_orders.sql
\`\`\`

## Notes
- Only completed orders are included in analytics outputs.
- Definitions are designed to be explicit and reproducible.
