# Project Phase 3 — Incremental Data Pipeline

This phase evolves the analytics warehouse into a production-style data pipeline.

## Key Concepts
- Incremental loading (no full recompute)
- Pipeline state management
- Idempotent reruns
- Data quality validation

## Core Files
- `00_state.sql` — pipeline state tracking
- `01_bootstrap_fct_orders_inc.sql` — initial materialization
- `02_incremental_fct_orders_inc.sql` — delta-based updates
- `03_quality_checks.sql` — data trust guarantees
