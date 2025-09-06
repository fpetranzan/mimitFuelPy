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

- **[Client]({{ site.baseurl }}/api/client.html)** - Main client class for API interactions
- **[Registry]({{ site.baseurl }}/api/registry.html)** - Access to geographic and brand data
- **[Search]({{ site.baseurl }}/api/search.html)** - Search functionality for fuel stations
- **[Models]({{ site.baseurl }}/api/models.html)** - Data models and enums
- **[Exceptions]({{ site.baseurl }}/api/exceptions.html)** - Error handling classes

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
from mimitfuelpy.models.search.criteria.search_by_brand_criteria import SearchByBrandCriteria
criteria = SearchByBrandCriteria(province="MI")
results = client.search.byBrand(criteria)

# Get geographic data
regions = client.registry.regions()
provinces = client.registry.provinces("03")  # Lombardy
towns = client.registry.towns("015")  # Milan
```