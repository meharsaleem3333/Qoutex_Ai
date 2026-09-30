# Phase 0 Infrastructure Gate

## Planned providers
- PostgreSQL: Neon for persistent development/staging PostgreSQL.
- Object storage: Cloudflare R2 for durable artifacts.

## Why this split
PostgreSQL handles transactional/structured state. R2 handles large immutable datasets and model artifacts.

Neon Free is suitable for development because it provides persistent storage and usage-based compute, but its default scale-to-zero behavior is not the final production configuration. Production must use an always-active/appropriately provisioned database configuration.

R2 provides an included free monthly tier and no internet egress charge; production usage must still be monitored.

## Required user-side provisioning
The project owner must create/authorize the Neon and Cloudflare accounts/projects because external account credentials and billing ownership cannot be safely created from the repository.

Required secrets:
- DATABASE_URL
- OBJECT_STORAGE_ENDPOINT
- OBJECT_STORAGE_BUCKET
- OBJECT_STORAGE_ACCESS_KEY
- OBJECT_STORAGE_SECRET_KEY

Never paste secret values into GitHub source files or chat.

## Verification gate
1. Create Neon project and database.
2. Apply database/migrations/0001_initial.sql.
3. Insert and read a controlled persistence test record.
4. Create R2 bucket.
5. Upload and download a controlled test object.
6. Record checksums and test results.
7. Verify a fresh environment can reconnect and retrieve both.
8. Commit the non-secret configuration/documentation.
9. Only then mark Phase 0 complete.
