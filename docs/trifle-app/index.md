---
title: Trifle App
description: Trifle is the companion app to your Stats.
nav_order: 1
svg: M9 17.25v1.007a3 3 0 0 1-.879 2.122L7.5 21h9l-.621-.621A3 3 0 0 1 15 18.257V17.25m6-12V15a2.25 2.25 0 0 1-2.25 2.25H5.25A2.25 2.25 0 0 1 3 15V5.25m18 0A2.25 2.25 0 0 0 18.75 3H5.25A2.25 2.25 0 0 0 3 5.25m18 0V12a2.25 2.25 0 0 1-2.25 2.25H5.25A2.25 2.25 0 0 1 3 12V5.25
---

# Trifle App

Trifle App is visual layer for Trifle Stats. It allows you to create Dashboards, Monitors with Alerts or Reports and expose your analytics to your AI agent of choice.

## Why?

Any developer can build dashboards and widgets with charts. Especially nowadays with all the AI Agents and tools. All you need is a bit of thinking. It's not a rocket science. For everyone else its miles better to build the dashboard themselves than ask someone else to build it for them. Thats why Trifle App was born. It gives non-technical people ability to explore the data and build dashboards as they need it. All that while keeping the data internally within your own infrastructure.

## What you get

- The Metrics API
- Dashboards and monitors
- Integrations with Slack, Discord, Google SSO and others
- Self-hosted deployment with Helm or SaaS at [app.trifle.io](https://app.trifle.io)

## Core concepts

- **Sources**: project sources can read/write; database sources are read-only.
- **Ingestion**: project metrics go through `/api/v1/metrics`; database metrics come from Trifle::Stats (or another Trifle Stats plugin) writing to your DB.
- **Dashboards vs monitors**: dashboards are saved views; monitors schedule reports or fire alerts.
