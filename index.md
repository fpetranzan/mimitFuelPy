---
layout: default
title: Home
nav_order: 1
description: "Python library for accessing Mimit Fuel Prices API"
permalink: /
---

# mimitfuelpy
{: .fs-9 }

A Python library for accessing the Mimit Fuel Prices API
{: .fs-6 .fw-300 }

[Get started now](#getting-started){: .btn .btn-primary .fs-5 .mb-4 .mb-md-0 .mr-2 } [View on GitHub](https://github.com/fpetranzan/mimitFuelPy){: .btn .fs-5 .mb-4 .mb-md-0 }

---

## Overview

mimitfuelpy provides a clean, object-oriented interface for searching fuel stations and retrieving fuel pricing data in Italy. The library wraps the Mimit Fuel Prices API, making it easy to integrate fuel data into your Python applications.

### Key Features

- 🚗 **Station Search**: Find fuel stations by location, brand, highway, or zone
- 💰 **Price Data**: Get current fuel prices with filtering options
- 🗺️ **Geographic Data**: Access regions, provinces, towns, and highways
- 📊 **Flexible Filtering**: Filter by fuel type and service type
- 🏢 **Service Areas**: Detailed service area information with facilities
- 🔍 **Easy Integration**: Simple, intuitive API design

## Getting Started

### Installation

Install mimitfuelpy using pip:

```bash
pip install mimitfuelpy
```

### Quick Example

```python
from mimitfuelpy import Client
from mimitfuelpy.models.enums.fuel_type import FuelType
from mimitfuelpy.models.enums.service_type import ServiceType
from mimitfuelpy.models.search.criteria.search_by_brand_criteria import SearchByBrandCriteria

# Initialize the client
client = Client()

# Search for fuel stations
criteria = SearchByBrandCriteria(
    province="MI",  # Milan
    priceOrder="asc",
    fuelType=FuelType.PETROL.value,
    serviceType=ServiceType.SELF.value
)

results = client.search.byBrand(criteria)
for station in results.results:
    print(f"{station.name}: {station.address}")
    if station.fuels:
        for fuel in station.fuels:
            print(f"  - {fuel.name}: €{fuel.price}")
```

## What's Next?

- [Installation Guide]({{ site.baseurl }}/installation) - Detailed installation instructions
- [Quick Start]({{ site.baseurl }}/quick-start) - Get up and running quickly  
- [API Reference]({{ site.baseurl }}/api/) - Complete API documentation
- [Examples]({{ site.baseurl }}/examples/) - Code examples and use cases

---

## Support

- **GitHub Issues**: [Report bugs or request features](https://github.com/fpetranzan/mimitFuelPy/issues)
- **PyPI Package**: [https://pypi.org/project/mimitfuelpy/](https://pypi.org/project/mimitfuelpy/)
- **License**: MIT License