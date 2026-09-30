-- Phase 0/1 persistence foundation
-- PostgreSQL 17+ compatible. All timestamps are UTC.

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS market_pairs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    market_type TEXT NOT NULL CHECK (market_type IN ('LIVE','OTC')),
    symbol TEXT NOT NULL,
    display_name TEXT,
    enabled BOOLEAN NOT NULL DEFAULT TRUE,
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (market_type, symbol)
);

CREATE TABLE IF NOT EXISTS candles (
    id BIGSERIAL PRIMARY KEY,
    market_type TEXT NOT NULL CHECK (market_type IN ('LIVE','OTC')),
    symbol TEXT NOT NULL,
    timeframe_seconds INTEGER NOT NULL CHECK (timeframe_seconds > 0),
    ts TIMESTAMPTZ NOT NULL,
    open NUMERIC NOT NULL,
    high NUMERIC NOT NULL,
    low NUMERIC NOT NULL,
    close NUMERIC NOT NULL,
    volume NUMERIC,
    source TEXT NOT NULL,
    source_record_id TEXT,
    received_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    quality_status TEXT NOT NULL DEFAULT 'PENDING'
        CHECK (quality_status IN ('PENDING','VALID','INVALID','STALE')),
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    UNIQUE (market_type, symbol, timeframe_seconds, ts, source)
);

CREATE INDEX IF NOT EXISTS idx_candles_lookup
    ON candles (market_type, symbol, timeframe_seconds, ts DESC);

CREATE TABLE IF NOT EXISTS data_quality_events (
    id BIGSERIAL PRIMARY KEY,
    market_type TEXT NOT NULL CHECK (market_type IN ('LIVE','OTC')),
    symbol TEXT,
    timeframe_seconds INTEGER,
    event_type TEXT NOT NULL,
    severity TEXT NOT NULL CHECK (severity IN ('INFO','WARN','ERROR','BLOCK')),
    event_ts TIMESTAMPTZ NOT NULL DEFAULT now(),
    details JSONB NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS model_versions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    model_version TEXT NOT NULL UNIQUE,
    market_type TEXT NOT NULL CHECK (market_type IN ('LIVE','OTC')),
    timeframe_seconds INTEGER NOT NULL,
    dataset_id TEXT,
    feature_version TEXT,
    code_version TEXT NOT NULL,
    hyperparameters JSONB NOT NULL DEFAULT '{}'::jsonb,
    validation_summary JSONB NOT NULL DEFAULT '{}'::jsonb,
    artifact_uri TEXT,
    artifact_sha256 TEXT,
    status TEXT NOT NULL DEFAULT 'candidate'
        CHECK (status IN ('candidate','challenger','champion','retired')),
    trained_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS predictions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    market_type TEXT NOT NULL CHECK (market_type IN ('LIVE','OTC')),
    symbol TEXT NOT NULL,
    timeframe_seconds INTEGER NOT NULL,
    candle_ts TIMESTAMPTZ NOT NULL,
    model_version TEXT NOT NULL,
    predicted_direction TEXT NOT NULL CHECK (predicted_direction IN ('CALL','PUT','NO_TRADE')),
    raw_probability NUMERIC,
    calibrated_confidence NUMERIC,
    regime TEXT,
    data_quality_ok BOOLEAN NOT NULL,
    model_agreement NUMERIC,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_predictions_lookup
    ON predictions (market_type, symbol, timeframe_seconds, candle_ts DESC);

CREATE TABLE IF NOT EXISTS signals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    prediction_id UUID REFERENCES predictions(id),
    market_type TEXT NOT NULL CHECK (market_type IN ('LIVE','OTC')),
    symbol TEXT NOT NULL,
    signal_ts TIMESTAMPTZ NOT NULL,
    direction TEXT NOT NULL CHECK (direction IN ('CALL','PUT','NO_TRADE')),
    confidence NUMERIC,
    quality_score NUMERIC,
    no_trade_reason TEXT,
    decision_version TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS actual_outcomes (
    id BIGSERIAL PRIMARY KEY,
    prediction_id UUID REFERENCES predictions(id),
    target_candle_ts TIMESTAMPTZ NOT NULL,
    actual_direction TEXT CHECK (actual_direction IN ('CALL','PUT','FLAT')),
    open_price NUMERIC,
    close_price NUMERIC,
    evaluated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS forecast_opportunities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    market_type TEXT NOT NULL CHECK (market_type IN ('LIVE','OTC')),
    symbol TEXT NOT NULL,
    horizon_minutes INTEGER NOT NULL CHECK (horizon_minutes IN (5,10,15,30,60)),
    opportunity_ts TIMESTAMPTZ NOT NULL,
    direction TEXT NOT NULL CHECK (direction IN ('CALL','PUT')),
    confidence NUMERIC NOT NULL,
    strength NUMERIC,
    model_version TEXT NOT NULL,
    reason JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_forecast_lookup
    ON forecast_opportunities (market_type, symbol, horizon_minutes, opportunity_ts);

CREATE TABLE IF NOT EXISTS experiments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    experiment_key TEXT NOT NULL UNIQUE,
    code_version TEXT NOT NULL,
    dataset_id TEXT,
    feature_version TEXT,
    parameters JSONB NOT NULL DEFAULT '{}'::jsonb,
    validation_results JSONB NOT NULL DEFAULT '{}'::jsonb,
    status TEXT NOT NULL DEFAULT 'planned'
        CHECK (status IN ('planned','running','completed','rejected')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    completed_at TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS performance_metrics (
    id BIGSERIAL PRIMARY KEY,
    metric_ts TIMESTAMPTZ NOT NULL DEFAULT now(),
    market_type TEXT NOT NULL CHECK (market_type IN ('LIVE','OTC')),
    symbol TEXT,
    timeframe_seconds INTEGER,
    model_version TEXT,
    metric_name TEXT NOT NULL,
    metric_value NUMERIC NOT NULL,
    sample_count INTEGER,
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS system_logs (
    id BIGSERIAL PRIMARY KEY,
    event_ts TIMESTAMPTZ NOT NULL DEFAULT now(),
    level TEXT NOT NULL CHECK (level IN ('DEBUG','INFO','WARN','ERROR','CRITICAL')),
    component TEXT NOT NULL,
    message TEXT NOT NULL,
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb
);
