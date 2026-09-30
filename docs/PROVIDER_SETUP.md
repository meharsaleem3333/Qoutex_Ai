# Provider Setup Checklist

## 1. Neon PostgreSQL
Create a Neon project for this repository's development/staging database.

Then:
- create the database/branch intended for the project;
- obtain the PostgreSQL connection string;
- apply database/migrations/0001_initial.sql;
- run database/migrations/verify_persistence.sql;
- keep production configuration separate from development.

For production, configure the database to remain appropriately available rather than relying on free-tier scale-to-zero behavior.

## 2. Cloudflare R2
Create an R2 bucket for the project.

Recommended prefixes:
- raw/live/
- raw/otc/
- cleaned/live/
- cleaned/otc/
- features/
- models/
- backtests/
- oos/
- backups/
- manifests/

Create an S3-compatible access key with the minimum required permissions.

## 3. Secrets
Store credentials in the deployment/Codespace secret manager:
- DATABASE_URL
- OBJECT_STORAGE_ENDPOINT
- OBJECT_STORAGE_BUCKET
- OBJECT_STORAGE_ACCESS_KEY
- OBJECT_STORAGE_SECRET_KEY

Never commit actual values.

## 4. Phase 0 completion evidence
Record:
- provider/project identifiers (non-secret)
- migration version
- PostgreSQL persistence test result
- R2 upload/download test result
- SHA-256 checksum of the test object
- recovery test result
- date/time of verification

Do not record passwords, tokens, private keys, or connection strings in this file.
