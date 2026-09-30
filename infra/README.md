# Infrastructure

Persistent infrastructure is intentionally separated from disposable Codespaces.

## Development/staging
- GitHub: source of truth.
- Neon PostgreSQL: structured persistent state.
- Cloudflare R2: durable object storage.

## Production
Production must use a continuously available backend and an appropriately provisioned database configuration. Development free-tier constraints must not be mistaken for production guarantees.

Secrets belong in managed secret storage/environment variables, never in Git.
