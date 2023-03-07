---
title: Timestamp
description: Learn how Timestamp formats time of log entry. 
nav_order: 1
---

# Timestamp Formatter

Dumping timestamp into logs is not necessary, but it is a nice to have. If you don't want to have log lines prefixed with timestamp, simply define a custom formatter that returns empty string instead of formatted timestamp. Duh.

## Format

Build in `Trifle::Logs::Formatter::Timestamp` formatter formats timestamp using `strftime('%Y-%m-%dT%H:%M:%S.%6N')` and thats it.
