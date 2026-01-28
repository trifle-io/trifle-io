---
title: Changelog
description: Releases and changes in a chronological order.
nav_order: 100
---

# Changelog

### **0.7.1** - *January 28, 2026*
  - Feature: AI browsers receive text/plain header for markdown rendered files.

### **0.7.0** - *January 27, 2026*
  - Feature: Automatically generate sitemap.xml.
  - Feature: Support format=md URL param and Accept: text/markdown header to display raw Markdown files.
 gg
### **0.6.0** - *January 27, 2026*
  - Feature: Automatically generate llms.txt and llms-full.txt.

### **0.5.0** - *December 11, 2025*
  - Feature: Detect AI browsers and render markdown-friendly page instead.

### **0.4.0** - Never got released
  - Feature: Search functionality using FuzzySearch and scope.

### **0.3.1** - *February 26, 2024*
  - Fix: Markdown Harvester avoids crashing while parsing broken markdown file.

### **0.3.0** - *September 18, 2022*
  - Feature: Harvester with configurable cache.

### **0.2.0** - *June 29, 2022*
  - Feature: Introduce `Trifle::Docs::Engine` for Rails integration.

### **0.1.1** - *June 28, 2022*
  - Feature: Improved meta parsing for Markdown harvester.

### **0.1.0** - *June 27, 2022*
  - Feature: Initial version (Markdown and File only)
  - Chore: Lots of code moved around. Concepts of Harvester, Walker, Sieve and Conveyor are introduced.
  - Feature: Process files through series of Harvester to find best match.
