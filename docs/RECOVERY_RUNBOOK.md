# Recovery Runbook

1. Clone/open the GitHub repository.
2. Checkout the intended release/commit.
3. Restore environment configuration from managed secrets; never from committed secrets.
4. Restore PostgreSQL connectivity and verify schema/migrations.
5. Restore durable object-storage access and verify dataset/model artifact checksums.
6. Read project version and lineage metadata.
7. Run repository integrity and migration checks.
8. Resume only from the last verified milestone.
9. Record the recovery event.

A missing Codespace, notebook, browser session, or local machine must not destroy project state.
