# Database Schema

The project uses PostgreSQL for structured state.

## Initial entities
- market_pairs: LIVE/OTC instrument registry.
- candles: immutable market observations.
- data_quality_events: quality firewall events.
- model_versions: model lineage and artifact metadata.
- predictions: model-level next-candle predictions.
- signals: decision-layer outputs including NO TRADE.
- actual_outcomes: realized target outcomes for evaluation.
- forecast_opportunities: qualifying 1M opportunities found inside forecast horizons.
- experiments: reproducible research registry.
- performance_metrics: production/research metrics.
- system_logs: persistent operational events.

## Rules
- LIVE and OTC are always explicitly identified.
- Candle timestamps are UTC.
- Raw candle rows are never silently overwritten.
- Model artifacts are stored in durable object storage; the database stores metadata and checksums.
- Migrations are version-controlled and applied in order.
