# Quotex AI Signal Agent

Modular, validation-first AI signal system for Quotex-compatible LIVE and OTC market data.

## Scope
- Primary trading timeframe: 1 minute.
- LIVE and OTC use separate data/model pipelines.
- Outputs: CALL, PUT, or NO TRADE.
- No automatic Quotex order execution.
- 30M and 1H are forecast horizons that scan future 1-minute opportunities.
- Leakage-safe walk-forward validation and untouched OOS testing are mandatory.
- Strong NO-TRADE filtering and confidence calibration are mandatory.
- Planned PWA, persistent backend, PostgreSQL, durable object storage, and optional Telegram notifications.

## Persistence
GitHub is the source of truth for code/config/docs. PostgreSQL stores structured state. Durable object storage stores large datasets, model artifacts, results, and backups. No critical artifact may exist only in a temporary runtime.

See PROJECT_RULES.md, ARCHITECTURE.md, and docs/RECOVERY_RUNBOOK.md.
