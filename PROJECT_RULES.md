# Project Rules

## Hard Rule #1 — Persistence and Recovery
At every phase completion and every meaningful milestone:
1. Persist all work.
2. Commit and push source/config/docs to GitHub.
3. Persist structured records to PostgreSQL.
4. Persist datasets, models, results, and backups to durable object storage.
5. Record versions, checksums, and lineage where applicable.
6. Save documentation and relevant logs.
7. Perform a recovery/resume verification.
8. Do not declare the milestone complete until persistence and recovery verification pass.

If a Codespace/session/runtime disappears, the project must remain recoverable.

## Architecture
LIVE and OTC data/models remain separate. The actual trading timeframe is 1M. Forecast horizons never become trading timeframes.

## Validation
No model is approved from backtest results alone. Walk-forward validation, leakage checks, and untouched OOS evaluation are required.

## Signals
The system may return CALL, PUT, or NO TRADE. It must never force a signal to meet a quota.

## Trading
Signals only. Automatic Quotex order execution is out of scope.

## Modularity
Strategies, features, models, thresholds, UI, and forecast logic must be independently versioned and replaceable.

## Secrets
Secrets must never be committed. Use environment variables or managed secret storage.
