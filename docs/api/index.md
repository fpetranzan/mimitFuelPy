---
layout: default
title: API Reference
nav_order: 4
has_children: true
permalink: /api/
---

# API Reference

Complete reference for all mimitfuelpy classes, methods, and utilities.

## Overview

The mimitfuelpy library is organized into several modules:

- **[Client]({{ site.baseurl }}/docs/api/client)** - Main client class for API interactions
- **[Registry]({{ site.baseurl }}/docs/api/registry)** - Access to geographic and brand data
- **[Models]({{ site.baseurl }}/docs/api/models)** - Data models and enums

## Quick Reference

### Client Initialization

```python
from mimitfuelpy import Client

# Default configuration
client = Client()

# Custom configuration
client = Client(
    base_url="https://api.mimit.gov.it",
    timeout=30
)
```

### Main API Categories

| Category | Description | Access |
|----------|-------------|--------|
| Registry | Brands, regions, provinces, towns, highways | `client.registry` |
| Search | Station search by various criteria | `client.search` |

### Common Operations

```python
# Get all brands
brands = client.registry.brands()

# Search stations by brand
from mimitfuelpy.models import SearchByBrandCriteria
criteria = SearchByBrandCriteria(province="MI")
results = client.search.byBrand(criteria)

# Get geographic data
regions = client.registry.regions()
provinces = client.registry.provinces("03")  # Lombardy
towns = client.registry.towns("015")  # Milan
```