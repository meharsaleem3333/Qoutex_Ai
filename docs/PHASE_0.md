# Phase 0 — Foundation + Persistent Development

## Objectives
- Establish GitHub as source-of-truth.
- Establish modular project boundaries.
- Define dev/test/prod separation.
- Define secret handling.
- Define PostgreSQL and durable object-storage integration points.
- Define recovery procedure.
- Verify repository write access and remote persistence.

## Completion gate
Phase 0 is complete only after:
- Repository structure is committed and remotely verified.
- Required documentation is present.
- Recovery procedure is documented and tested.
- PostgreSQL persistence is configured and verified.
- Durable object storage is configured and verified.
- A recovery test demonstrates that the project can resume without relying on a temporary runtime.

Until these gates pass, Phase 0 remains IN PROGRESS.
