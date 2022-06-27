---
title: Changelog
nav_order: 100
---

# Changelog

### **1.0.0** - *June 18, 2022*
  - Final stable release.
  - Feature: Change structure of `.values` return hash.
  - Feature: MongoDB driver gets all values at once.
  - Chore: Unify Docker folder structure.

### **0.4.1** - *July 11, 2021*
  - Fix: Update MIT license.
  - Chore: Remove ruby 2.x from github actions.

### **0.4.0** - *July 11, 2021*
  - Feature: Add MongoDB driver.

### **0.3.2** - *April 20, 2021*
  - Fix: Postgres returns empty hash instead of `nil` for missing values.

### **0.3.1** - *April 18, 2021*
  - Fix: `.set` uses correct value in Postgres driver.

### **0.3.0** - *April 18, 2021*
  - Feature: Add Postgres driver.

### **0.2.1** - *April 14, 2021*
  - Fix: Forgotten `set` method on a process driver.

### **0.2.0** - *April 14, 2021*
  - Feature: Add `.assert` method to set values at timestamp.

### **0.1.0** - *January 30, 2021*
  - Feature: Initial version (Transition from BellyWash to Trifle::Ruby 3.x to Trifle::Stats 0.1.0)
  - Chore: Lots of code moved around, but basic functionality is here (`.track` and `.values` methods).