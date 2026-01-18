---
title: Trifle App
description: Trifle is the companion app to your Stats.
nav_order: 1
svg: M9 17.25v1.007a3 3 0 0 1-.879 2.122L7.5 21h9l-.621-.621A3 3 0 0 1 15 18.257V17.25m6-12V15a2.25 2.25 0 0 1-2.25 2.25H5.25A2.25 2.25 0 0 1 3 15V5.25m18 0A2.25 2.25 0 0 0 18.75 3H5.25A2.25 2.25 0 0 0 3 5.25m18 0V12a2.25 2.25 0 0 1-2.25 2.25H5.25A2.25 2.25 0 0 1 3 12V5.25
---

# Trifle App

Trifle App is the full UI + API for Trifle analytics. It gives you dashboards, monitors, alerting, and a clean ingestion API to push metrics into your own stack.

## What you get

- Metrics ingestion over HTTP
- Dashboards and monitors
- Slack, Discord, and Google SSO integrations
- Self-hosted deployment with Helm

## Start here

- [Installation](/trifle-app/installation)
- [Getting Started](/trifle-app/getting_started)
- [Configuration](/trifle-app/configuration)
- [API Endpoints](/trifle-app/api)
- [How-to Guides](/trifle-app/guides)

## Core concepts

- **Sources**: project sources can read/write; database sources are read-only.
- **Ingestion**: project metrics go through `/api/v1/metrics`; database metrics come from Trifle::Stats (or another Trifle Stats plugin) writing to your DB.
- **Dashboards vs monitors**: dashboards are saved views; monitors schedule reports or fire alerts.
