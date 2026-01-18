---
title: /transponders
description: Create and manage expression transponders.
nav_order: 4
---

# /api/v1/transponders

Transponders let you transform metrics using expressions. Only expression transponders are supported right now.

## Auth

`Authorization: Bearer <TOKEN>`

---

## GET /transponders

List expression-based transponders for the current source.

### Response fields

- `id`, `name`, `key`
- `type`, `config`, `enabled`, `order`
- `source_type`, `source_id`

### Request

:::tabs
@tab CURL
```sh
curl -s "https://app.trifle.io/api/v1/transponders" \
  -H "Authorization: Bearer <TOKEN>"
```
:::

---

## POST /transponders

Create a new expression transponder.

:::signature POST /api/v1/transponders
name | String | required | Display name.
key | String | required | Metric key to transform.
type | String | optional | Only `Trifle.Stats.Transponder.Expression` is supported. Defaults to expression.
config | Map | optional | Transponder config (see below). If omitted, you can send `paths`, `expression`, and `response_path` at the top level.
enabled | Boolean | optional | Defaults to `true`.
order | Integer | optional | Display order. Defaults to next available.
:::

### Expression config

:::signature config
paths | Array<String> | required | Metric paths (assigned to a, b, c...).
expression | String | required | Math expression using variables a, b, c.
response_path | String | required | Where to store the computed result.
:::

### Request

:::tabs
@tab CURL
```sh
curl -X POST "https://app.trifle.io/api/v1/transponders" \
  -H "Authorization: Bearer <TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Double count",
    "key": "event::signup",
    "config": {
      "paths": ["count"],
      "expression": "a * 2",
      "response_path": "count_twice"
    }
  }'
```
:::

---

## PUT /transponders/:id

Update an existing transponder by id.

:::signature PUT /api/v1/transponders/:id
name | String | optional | Display name.
key | String | optional | Metric key to transform.
config | Map | optional | Transponder config (paths/expression/response_path).
enabled | Boolean | optional | Toggle on/off.
order | Integer | optional | Sort order.
:::

### Request

:::tabs
@tab CURL
```sh
curl -X PUT "https://app.trifle.io/api/v1/transponders/TRANS_ID" \
  -H "Authorization: Bearer <TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{ "enabled": false }'
```
:::

:::callout warn "No other types yet"
- If you pass a non-expression type, the API returns `422`.
:::
