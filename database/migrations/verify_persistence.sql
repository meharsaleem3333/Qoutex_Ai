-- Run after 0001_initial.sql against the persistent Neon database.
BEGIN;

INSERT INTO system_logs (level, component, message, metadata)
VALUES ('INFO', 'persistence-check', 'Phase 0 PostgreSQL persistence test', '{"test":"phase0"}'::jsonb);

SELECT count(*) AS persistence_test_rows
FROM system_logs
WHERE component = 'persistence-check'
  AND metadata->>'test' = 'phase0';

ROLLBACK;
