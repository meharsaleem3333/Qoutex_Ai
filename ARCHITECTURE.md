# Architecture

## 16-Phase Roadmap
0. Foundation + Persistent Development
1. LIVE + OTC Data Infrastructure
2. Data Quality & Validation Firewall
3. Advanced Feature & Indicator Engine
4. Market Regime / Market State Engine
5. LIVE 1M AI Engine
6. OTC 1M AI Engine
7. Advanced AI Ensemble
8. Leakage-Safe Validation & OOS
9. Confidence + Signal Quality + NO-TRADE
10. 30M / 1H Forecast Engine
11. Anti-Overfitting + Adversarial Testing
12. PWA / Home-Screen App
13. Production Live Signal Infrastructure
14. Monitoring + Drift + Champion/Challenger
15. Shadow Testing + Release + Future Updates

## Persistence layers
- GitHub: source code, configuration templates, migrations, documentation, experiment definitions, version history.
- PostgreSQL: candles, pairs, signals, predictions, outcomes, forecasts, model metadata, experiments, validation results, performance, regimes, quality events, logs.
- Durable object storage: raw/clean datasets, feature datasets, model artifacts, backtests, OOS outputs, backups.

## Decision flow
Data -> quality firewall -> features -> regime -> model ensemble -> calibration -> agreement/quality checks -> NO-TRADE filter -> signal.

## Forecast
30M scans the next 30 one-minute opportunities.
1H scans the next 60 one-minute opportunities.
Only strong qualifying 1M opportunities are returned; zero is valid.

## Versioning
Models record dataset ID, feature version, code version, hyperparameters, validation/OOS results, training timestamp, and artifact location.
