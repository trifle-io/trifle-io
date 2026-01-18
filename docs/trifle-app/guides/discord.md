---
title: Configure Discord
description: Connect Discord for delivery channels.
nav_order: 2
---

# Configure Discord

Discord integration powers monitor delivery to Discord channels.

## 1) Create a Discord application + bot

- Create an application in the Discord Developer Portal.
- Add a bot to the application.
- Set the OAuth2 redirect URL:

```
https://app.trifle.io/integrations/discord/oauth/callback
```

## 2) Set environment variables

```yaml
app:
  env:
    DISCORD_CLIENT_ID: "<DISCORD_CLIENT_ID>"
    DISCORD_CLIENT_SECRET: "<DISCORD_CLIENT_SECRET>"
    DISCORD_REDIRECT_URI: "https://app.trifle.io/integrations/discord/oauth/callback"
    DISCORD_BOT_TOKEN: "<DISCORD_BOT_TOKEN>"
    DISCORD_SCOPES: "bot applications.commands identify guilds"
    DISCORD_BOT_PERMISSIONS: "52224"
```

`DISCORD_BOT_TOKEN` is required for channel sync. If you omit scopes/permissions, Trifle falls back to defaults.

## 3) Connect the server

- Go to **Organization → Delivery**.
- Click **Connect Discord**.
- Choose a server and authorize the bot.

:::callout note "Scopes + permissions"
- If you set custom scopes or permissions, make sure they still allow reading channels and posting messages.
:::
