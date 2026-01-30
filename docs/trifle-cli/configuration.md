---
title: Configuration
description: Configure the Trifle CLI drivers and connection settings.
nav_order: 2
---

# Configuration

## Config file (YAML)

Trifle CLI reads a YAML config file by default. You can define multiple named sources and pick one with `--source`.

- Default path (varies by OS):
  - macOS: `~/Library/Application Support/trifle/config.yaml`
  - Linux: `~/.config/trifle/config.yaml`
  - Windows: `%AppData%\\trifle\\config.yaml`
- Override with `--config` or `TRIFLE_CONFIG`
- Precedence: flags -> env vars -> config file -> defaults

Example:

```yaml
source: sqlite

api:
  driver: api
  url: https://app.trifle.io
  token: your-token
  timeout: 30s

custom:
  driver: api
  url: https://trifle.example.com
  token: my-token
  timeout: 30s

sqlite:
  driver: sqlite
  db: ./stats.db
  table: trifle_stats
  joined: full
  separator: "::"
  timezone: GMT
  week_start: monday
  granularities: [1m, 5m, 1h, 1d]

test:
  driver: sqlite
  db: ./stats_test.db
  table: trifle_stats
  joined: full
  separator: "::"
  timezone: GMT
  week_start: monday
  granularities: [1m, 5m, 1h, 1d]
```

Each named source must set `driver` (`api` or `sqlite`) and the matching settings.

## Environment variables

- `TRIFLE_CONFIG` (optional): path to YAML config file.
- `TRIFLE_SOURCE` (optional): source name from the config file.
- `TRIFLE_DRIVER` (optional): `api` or `sqlite` (default: `api`).
- `TRIFLE_URL` (api): Base URL for Trifle App (required when using the `api` driver).
- `TRIFLE_TOKEN` (api): API token (required for non-interactive or MCP mode when using the `api` driver).
- `TRIFLE_DB` (sqlite): path to SQLite database file.
- `TRIFLE_TABLE` (sqlite): table name (default: `trifle_stats`).
- `TRIFLE_JOINED` (sqlite): `full`, `partial`, `separated`.
- `TRIFLE_SEPARATOR` (sqlite): key separator (default: `::`).
- `TRIFLE_TIMEZONE` (sqlite): timezone (default: `GMT`).
- `TRIFLE_WEEK_START` (sqlite): week start (`monday`..`sunday`).
- `TRIFLE_GRANULARITIES` (sqlite): comma-separated granularities.

## Flags (override env vars and config)

:::signature Common flags
--config | String | optional |  | YAML config path.
--source | String | optional |  | Source name from the config file.
--url | String | optional |  | Trifle base URL (fallback: `TRIFLE_URL`).
--token | String | optional |  | API token (fallback: `TRIFLE_TOKEN`).
--timeout | Duration | optional | `30s` | HTTP timeout.
--driver | String | optional | `api` | Driver: `api` or `sqlite`.
--db | String | optional |  | SQLite DB path.
--table | String | optional | `trifle_stats` | SQLite table name.
--joined | String | optional | `full` | Identifier mode: `full`, `partial`, `separated`.
--separator | String | optional | `::` | Key separator.
--timezone | String | optional | `GMT` | Time zone.
--week-start | String | optional | `monday` | Week start.
--granularities | String | optional |  | Comma-separated granularities.
:::

:::callout note "SaaS vs self-hosted"
- SaaS: `TRIFLE_URL=https://app.trifle.io`
- Self-hosted: `TRIFLE_URL=https://<your-host>`
:::

:::callout warn "URL scheme matters"
- If you omit the scheme, the CLI assumes `http://`.
- Use `https://` for SaaS and most self-hosted deployments.
:::

:::callout warn "Token scopes"
- Read-only tokens work for all `metrics` read commands and `transponders list`.
- Write tokens are required for `metrics push` and MCP `write_metric`.
:::

:::callout note "Interactive prompt"
- If no token is provided, the CLI prompts on stdin.
- MCP mode skips prompting (token required upfront).
:::
