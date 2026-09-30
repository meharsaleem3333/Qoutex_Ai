# Durable Object Storage

Selected design: **Cloudflare R2** for large datasets, model artifacts, validation outputs, and backups.

R2 is S3-compatible and currently includes 10 GB-month of Standard storage, 1 million Class A operations, 10 million Class B operations, and free egress per month. Costs beyond the included tier are usage-based.

## Object layout
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

Every important object must have a corresponding metadata record containing dataset/model version, checksum, source, and processing version.

## Security
Credentials are never committed. Use environment/secret storage.
