#!/usr/bin/env bash
set -euo pipefail

CONTAINER_NAME="${CONTAINER_NAME:-analytics-postgres}"
DB_USER="${DB_USER:-analytics_user}"
DB_NAME="${DB_NAME:-analytics}"

run_sql () {
  local file="$1"
  echo ""
  echo "▶ Running: ${file}"
  docker exec -i "$CONTAINER_NAME" psql -v ON_ERROR_STOP=1 -U "$DB_USER" -d "$DB_NAME" -f "$file"
}

echo "=== E-commerce Analytics Pipeline (Project #3) ==="
echo "Container: $CONTAINER_NAME | DB: $DB_NAME | User: $DB_USER"

# 0) State (idempotent)
run_sql /sql/04_incremental/00_state.sql

# 1) Staging views
run_sql /sql/01_staging/stg_orders.sql
run_sql /sql/01_staging/stg_order_items.sql

# 2) Mart view (canonical logic)
run_sql /sql/02_marts/fct_orders.sql

# 3) Incremental load (materialized fact)
run_sql /sql/04_incremental/02_incremental_fct_orders_inc.sql

# 4) Quality checks
run_sql /sql/04_incremental/03_quality_checks.sql

echo ""
echo "✅ Pipeline run completed successfully."
