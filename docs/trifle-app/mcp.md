---
title: MCP Server
description: Run Trifle CLI in MCP mode for AI agents.
nav_order: 5
---

# MCP Server

The Trifle CLI ships an MCP server mode that exposes your Trifle App data to AI agents over stdio JSON-RPC.

:::callout note "Protocol"
- MCP protocol version: `2024-11-05`.
:::

## Run the server

:::tabs
@tab SaaS
```sh
TRIFLE_URL=https://app.trifle.io TRIFLE_TOKEN=<TOKEN> trifle mcp
```

@tab Self-hosted
```sh
TRIFLE_URL=https://<your-host> TRIFLE_TOKEN=<TOKEN> trifle mcp
```
:::

:::callout warn "Token required"
- MCP mode does **not** prompt for a token.
- Pass `--token` or set `TRIFLE_TOKEN`.
:::

:::callout warn "URL scheme matters"
- If you omit the scheme, the CLI assumes `http://`.
- Use `https://` for SaaS and most self-hosted deployments.
:::

## Configuration

MCP uses the same configuration as the CLI:

:::signature Common flags
--url | String | optional | Trifle base URL (fallback: `TRIFLE_URL`).
--token | String | optional | API token (fallback: `TRIFLE_TOKEN`).
--timeout | Duration | optional | HTTP timeout (default: `30s`).
:::

## Agent MCP config snippets

Use these examples to register the Trifle MCP server in popular clients.

:::tabs
@tab Claude Desktop
Path: use **Settings → Developer → Edit Config** to open the file.

```json
{
  "mcpServers": {
    "trifle": {
      "command": "trifle",
      "args": ["mcp"],
      "env": {
        "TRIFLE_URL": "https://app.trifle.io",
        "TRIFLE_TOKEN": "<TOKEN>"
      }
    }
  }
}
```

@tab Cursor
File: `~/.cursor/mcp.json` (global) or `.cursor/mcp.json` (per project).

```json
{
  "mcpServers": {
    "trifle": {
      "command": "trifle",
      "args": ["mcp"],
      "env": {
        "TRIFLE_URL": "https://app.trifle.io",
        "TRIFLE_TOKEN": "<TOKEN>"
      }
    }
  }
}
```

@tab Cline (VS Code)
File: `cline_mcp_settings.json` (open via **Cline → MCP Servers → Configure → Configure MCP Servers**).

```json
{
  "mcpServers": {
    "trifle": {
      "command": "trifle",
      "args": ["mcp"],
      "env": {
        "TRIFLE_URL": "https://app.trifle.io",
        "TRIFLE_TOKEN": "<TOKEN>"
      },
      "disabled": false
    }
  }
}
```

@tab Continue
File: `.continue/mcpServers/mcp.json` in your workspace.

```json
{
  "mcpServers": {
    "trifle": {
      "command": "trifle",
      "args": ["mcp"],
      "env": {
        "TRIFLE_URL": "https://app.trifle.io",
        "TRIFLE_TOKEN": "<TOKEN>"
      }
    }
  }
}
```
:::

:::callout note "Agent mode required"
- Some clients only enable MCP tools in **agent mode** (e.g. Continue, Cursor).
:::

:::callout note "Binary path"
- If `trifle` is not on your PATH, replace `command` with the absolute path (e.g. `/usr/local/bin/trifle`).
- On Windows, use `trifle.exe` or a full path like `C:\\path\\to\\trifle.exe`.
:::

## Resources

The MCP server exposes these read-only resources:

:::signature Resource URIs
trifle://source | JSON | Source configuration, defaults, granularities.
trifle://metrics?from&to&granularity | JSON | Available metric keys (system series).
trifle://metrics/{key}?from&to&granularity | JSON | Raw series for a specific key.
trifle://transponders | JSON | Transponders for the active source.
:::

Example URIs:

```text
trifle://source
trifle://metrics?from=2026-01-24T00:00:00Z&to=2026-01-25T00:00:00Z&granularity=1h
trifle://metrics/event::signup?from=2026-01-24T00:00:00Z&to=2026-01-25T00:00:00Z&granularity=1h
trifle://transponders
```

## Tools

The MCP server exposes the following tools:

:::signature Tools
list_metrics | list available metric keys (system series).
fetch_series | fetch raw series for a metric key.
aggregate_series | aggregate series (sum, mean, min, max).
format_timeline | timeline formatting for a metric path.
format_category | category formatting for a metric path.
write_metric | write a metric event (project tokens only).
list_transponders | list transponders for the active source.
delete_transponder | delete a transponder by id.
:::

### Tool arguments

Common argument rules:

- `from` and `to` must be RFC3339.
- If `from`/`to` are omitted for list/fetch, the server uses the last 24 hours.
- `granularity` uses `<number><unit>` like `1h`, `5m`, `1d`.
- `value_path` must be a single path (no wildcards).

#### list_metrics
```json
{ "from": "2026-01-24T00:00:00Z", "to": "2026-01-25T00:00:00Z", "granularity": "1h" }
```

#### fetch_series
```json
{ "key": "event::signup", "from": "2026-01-24T00:00:00Z", "to": "2026-01-25T00:00:00Z", "granularity": "1h" }
```

:::callout note "System key"
- If `key` is omitted, Trifle fetches the internal system series (`__system__key__`).
:::

#### aggregate_series
```json
{
  "key": "event::signup",
  "value_path": "count",
  "aggregator": "sum",
  "from": "2026-01-24T00:00:00Z",
  "to": "2026-01-25T00:00:00Z",
  "granularity": "1h",
  "slices": 1
}
```

#### format_timeline
```json
{
  "key": "service.latency",
  "value_path": "p95",
  "from": "2026-01-24T00:00:00Z",
  "to": "2026-01-25T00:00:00Z",
  "granularity": "1h",
  "slices": 1
}
```

#### format_category
```json
{
  "key": "event::signup",
  "value_path": "country",
  "from": "2026-01-24T00:00:00Z",
  "to": "2026-01-25T00:00:00Z",
  "granularity": "1h",
  "slices": 1
}
```

#### write_metric
```json
{
  "key": "event::signup",
  "at": "2026-01-24T12:00:00Z",
  "values": { "count": 1, "duration": 0.42 }
}
```

#### list_transponders
```json
{}
```

#### delete_transponder
```json
{ "id": "transponder-uuid" }
```

:::callout warn "Write access"
- `write_metric` requires a **project write token**.
- If projects are disabled (self-hosted default), this tool will return `403`.
:::

:::callout note "Transponder deletes"
- Use the `delete_transponder` tool with a transponder id.
:::

## Tool call examples

### list_metrics

Request:

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "tools/call",
  "params": {
    "name": "list_metrics",
    "arguments": {
      "from": "2026-01-24T00:00:00Z",
      "to": "2026-01-25T00:00:00Z",
      "granularity": "1h"
    }
  }
}
```

Response (JSON-RPC):

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": {
    "content": [
      {
        "type": "text",
        "text": "{\n  \"status\": \"ok\",\n  \"timeframe\": {\n    \"from\": \"2026-01-24T00:00:00Z\",\n    \"to\": \"2026-01-25T00:00:00Z\",\n    \"granularity\": \"1h\"\n  },\n  \"paths\": [\n    { \"metric_key\": \"event::signup\", \"observations\": 42 }\n  ],\n  \"total_paths\": 1\n}"
      }
    ]
  }
}
```

Decoded tool result (the `content[0].text` JSON):

```json
{
  "status": "ok",
  "timeframe": {
    "from": "2026-01-24T00:00:00Z",
    "to": "2026-01-25T00:00:00Z",
    "granularity": "1h"
  },
  "paths": [
    { "metric_key": "event::signup", "observations": 42 }
  ],
  "total_paths": 1
}
```

### write_metric

Request:

```json
{
  "jsonrpc": "2.0",
  "id": 2,
  "method": "tools/call",
  "params": {
    "name": "write_metric",
    "arguments": {
      "key": "event::signup",
      "at": "2026-01-24T12:00:00Z",
      "values": { "count": 1, "duration": 0.42 }
    }
  }
}
```

Response (decoded tool result):

```json
{ "data": { "created": "ok" } }
```

### fetch_series

Request:

```json
{
  "jsonrpc": "2.0",
  "id": 5,
  "method": "tools/call",
  "params": {
    "name": "fetch_series",
    "arguments": {
      "key": "event::signup",
      "from": "2026-01-24T00:00:00Z",
      "to": "2026-01-25T00:00:00Z",
      "granularity": "1h"
    }
  }
}
```

Decoded tool result:

```json
{
  "status": "ok",
  "metric_key": "event::signup",
  "timeframe": {
    "from": "2026-01-24T00:00:00Z",
    "to": "2026-01-25T00:00:00Z",
    "granularity": "1h"
  },
  "data": {
    "at": ["2026-01-24T00:00:00Z", "2026-01-24T01:00:00Z"],
    "values": [
      { "count": 1, "duration": 0.42 },
      { "count": 3, "duration": 1.09 }
    ]
  }
}
```

### aggregate_series

Request:

```json
{
  "jsonrpc": "2.0",
  "id": 6,
  "method": "tools/call",
  "params": {
    "name": "aggregate_series",
    "arguments": {
      "key": "event::signup",
      "value_path": "count",
      "aggregator": "sum",
      "from": "2026-01-24T00:00:00Z",
      "to": "2026-01-25T00:00:00Z",
      "granularity": "1h",
      "slices": 1
    }
  }
}
```

Decoded tool result:

```json
{
  "status": "ok",
  "aggregator": "sum",
  "metric_key": "event::signup",
  "value_path": "count",
  "slices": 1,
  "value": 42.0,
  "values": [42.0],
  "count": 1,
  "timeframe": {
    "from": "2026-01-24T00:00:00Z",
    "to": "2026-01-25T00:00:00Z",
    "label": "custom",
    "granularity": "1h"
  },
  "available_paths": ["count", "duration"],
  "matched_paths": ["count"]
}
```

### format_timeline

Request:

```json
{
  "jsonrpc": "2.0",
  "id": 7,
  "method": "tools/call",
  "params": {
    "name": "format_timeline",
    "arguments": {
      "key": "service.latency",
      "value_path": "p95",
      "from": "2026-01-24T00:00:00Z",
      "to": "2026-01-25T00:00:00Z",
      "granularity": "1h",
      "slices": 1
    }
  }
}
```

Decoded tool result:

```json
{
  "status": "ok",
  "formatter": "timeline",
  "metric_key": "service.latency",
  "value_path": "p95",
  "slices": 1,
  "timeframe": {
    "from": "2026-01-24T00:00:00Z",
    "to": "2026-01-25T00:00:00Z",
    "label": "custom",
    "granularity": "1h"
  },
  "result": {
    "p95": [
      { "at": "2026-01-24T12:00:00Z", "value": 350.0 }
    ]
  },
  "available_paths": ["count", "p50", "p95", "p99"],
  "matched_paths": ["p95"]
}
```

### format_category

Request:

```json
{
  "jsonrpc": "2.0",
  "id": 8,
  "method": "tools/call",
  "params": {
    "name": "format_category",
    "arguments": {
      "key": "event::signup",
      "value_path": "country",
      "from": "2026-01-24T00:00:00Z",
      "to": "2026-01-25T00:00:00Z",
      "granularity": "1h",
      "slices": 1
    }
  }
}
```

Decoded tool result:

```json
{
  "status": "ok",
  "formatter": "category",
  "metric_key": "event::signup",
  "value_path": "country",
  "slices": 1,
  "timeframe": {
    "from": "2026-01-24T00:00:00Z",
    "to": "2026-01-25T00:00:00Z",
    "label": "custom",
    "granularity": "1h"
  },
  "result": {
    "country.US": 3.0,
    "country.UK": 1.0
  },
  "available_paths": ["count", "country.US", "country.UK"],
  "matched_paths": ["country.US", "country.UK"]
}
```

### list_transponders

Request:

```json
{
  "jsonrpc": "2.0",
  "id": 9,
  "method": "tools/call",
  "params": {
    "name": "list_transponders",
    "arguments": {}
  }
}
```

Decoded tool result:

```json
{
  "data": [
    {
      "id": "transponder-uuid",
      "name": "Success rate",
      "key": "event::signup",
      "type": "Trifle.Stats.Transponder.Expression",
      "config": {
        "paths": ["success", "count"],
        "expression": "a / b",
        "response_path": "success_rate"
      },
      "enabled": true,
      "order": 1,
      "source_type": "database",
      "source_id": "db-uuid"
    }
  ]
}
```

### delete_transponder

Request:

```json
{
  "jsonrpc": "2.0",
  "id": 12,
  "method": "tools/call",
  "params": {
    "name": "delete_transponder",
    "arguments": { "id": "transponder-uuid" }
  }
}
```

Decoded tool result:

```json
{
  "data": {
    "id": "transponder-uuid",
    "name": "Success rate",
    "key": "event::signup",
    "type": "Trifle.Stats.Transponder.Expression",
    "config": {
      "paths": ["success", "count"],
      "expression": "a / b",
      "response_path": "success_rate"
    },
    "enabled": true,
    "order": 1,
    "source_type": "database",
    "source_id": "db-uuid"
  }
}
```

### Error example

If required fields are missing, MCP returns `isError: true`:

```json
{
  "jsonrpc": "2.0",
  "id": 3,
  "result": {
    "content": [
      { "type": "text", "text": "aggregator is required" }
    ],
    "isError": true
  }
}
```

## Resource examples

### trifle://source

Request:

```json
{
  "jsonrpc": "2.0",
  "id": 4,
  "method": "resources/read",
  "params": { "uri": "trifle://source" }
}
```

Response (JSON-RPC):

```json
{
  "jsonrpc": "2.0",
  "id": 4,
  "result": {
    "contents": [
      {
        "uri": "trifle://source",
        "mimeType": "application/json",
        "text": "{\n  \"data\": {\n    \"api_version\": \"v1\",\n    \"server_version\": \"0.11.8\",\n    \"id\": \"source-uuid\",\n    \"type\": \"database\",\n    \"display_name\": \"Main\",\n    \"default_timeframe\": \"24h\",\n    \"default_granularity\": \"1h\",\n    \"available_granularities\": [\"5m\", \"1h\", \"1d\"],\n    \"time_zone\": \"UTC\"\n  }\n}"
      }
    ]
  }
}
```

Decoded resource payload:

```json
{
  "data": {
    "api_version": "v1",
    "server_version": "0.11.8",
    "id": "source-uuid",
    "type": "database",
    "display_name": "Main",
    "default_timeframe": "24h",
    "default_granularity": "1h",
    "available_granularities": ["5m", "1h", "1d"],
    "time_zone": "UTC"
  }
}
```

### trifle://metrics (listing)

```json
{
  "jsonrpc": "2.0",
  "id": 10,
  "method": "resources/read",
  "params": {
    "uri": "trifle://metrics?from=2026-01-24T00:00:00Z&to=2026-01-25T00:00:00Z&granularity=1h"
  }
}
```

Decoded resource payload:

```json
{
  "status": "ok",
  "timeframe": {
    "from": "2026-01-24T00:00:00Z",
    "to": "2026-01-25T00:00:00Z",
    "granularity": "1h"
  },
  "paths": [
    { "metric_key": "event::signup", "observations": 42 }
  ],
  "total_paths": 1
}
```

### trifle://metrics/{key}

```json
{
  "jsonrpc": "2.0",
  "id": 11,
  "method": "resources/read",
  "params": {
    "uri": "trifle://metrics/event::signup?from=2026-01-24T00:00:00Z&to=2026-01-25T00:00:00Z&granularity=1h"
  }
}
```

Decoded resource payload:

```json
{
  "status": "ok",
  "metric_key": "event::signup",
  "timeframe": {
    "from": "2026-01-24T00:00:00Z",
    "to": "2026-01-25T00:00:00Z",
    "granularity": "1h"
  },
  "data": {
    "at": ["2026-01-24T00:00:00Z", "2026-01-24T01:00:00Z"],
    "values": [
      { "count": 1, "duration": 0.42 },
      { "count": 3, "duration": 1.09 }
    ]
  }
}
```

## Troubleshooting

:::callout note "Granularity errors"
- If you omit `granularity`, MCP uses `/api/v1/source` to pick a default.
- If your source restricts granularities, invalid values return `400`.
:::
