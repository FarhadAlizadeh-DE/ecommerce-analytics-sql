# E-commerce Analytics & Incremental Data Pipeline (SQL)

## Overview
This repository demonstrates the evolution of an end-to-end SQL analytics project
into a production-style **incremental data pipeline**.

It starts with a traditional analytics warehouse (staging → marts → metrics)
and then evolves into a **stateful, repeatable data engineering pipeline**
that supports incremental loads, idempotent reruns, and data quality checks.

---

## Project Evolution

### Phase 1 — SQL Foundations
- Raw transactional tables
- Core joins and aggregations

### Phase 2 — Analytics Warehouse
- Raw → staging → marts → metrics
- Reproducible business logic
- Analytics-focused SQL views

### Phase 3 — Incremental Data Pipeline (Data Engineering)
- Materialized fact table (`fct_orders_inc`)
- Pipeline state tracking (`pipeline_state`)
- Incremental delta loading (no full recompute)
- Idempotent reruns
- Data quality checks
- One-command pipeline runner

---

## Data Model

### Raw Layer
- `raw_customers`
- `raw_products`
- `raw_orders`
- `raw_order_items`

### Staging Layer (Views)
- `stg_orders`
- `stg_order_items`

### Analytics Marts
- `fct_orders` (canonical logic as a view)
- `dim_products`

### Incremental Fact (Phase 3)
- `fct_orders_inc` (materialized, incremental table)
- `pipeline_state` (tracks last successful run)

---

## Key Metrics
- Monthly revenue, orders, customers, AOV
- Month-over-month revenue growth
- First-time vs repeat customers
- Revenue by product category + category MoM growth
- Basic customer lifetime value (CLV)

Metrics logic is validated in Phase 2 and can be materialized on top of
`fct_orders_inc` in Phase 3.

---

## Tech Stack
- PostgreSQL
- Docker
- SQL
- Bash (pipeline runner)

---

## How to Run

### Start Postgres (Docker)
```bash
docker compose up -d

