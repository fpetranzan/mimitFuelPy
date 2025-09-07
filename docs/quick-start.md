---
layout: default
title: Quick Start
nav_order: 3
permalink: /quick-start/
---

# Quick Start
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

This guide will help you get started with mimitfuelpy quickly. After following this guide, you'll be able to search for fuel stations and retrieve pricing data.

## Basic Setup

First, make sure you have mimitfuelpy installed:

```bash
pip install mimitfuelpy
```

## Your First Script

Create a new Python file and try this basic example:

```python
from mimitfuelpy import Client

# Initialize the client
client = Client()

# Get all available brands
brands = client.registry.brands()
print(f"Available brands: {len(brands)}")
for brand in brands[:5]:  # Show first 5
    print(f"  - {brand.name}")
```

## Searching for Fuel Stations

### Search by Brand and Location

```python
from mimitfuelpy import Client
from mimitfuelpy.models.search.criteria.search_by_brand_criteria import SearchByBrandCriteria
from mimitfuelpy.models.enums.fuel_type import FuelType
from mimitfuelpy.models.enums.service_type import ServiceType

client = Client()

# Create search criteria
criteria = SearchByBrandCriteria(
    province="MI",  # Milan province
    priceOrder="asc",  # Sort by price ascending
    fuelType=FuelType.PETROL.value,
    serviceType=ServiceType.SELF.value
)

# Perform the search
results = client.search.byBrand(criteria)

print(f"Search successful: {results.success}")
print(f"Found {len(results.results)} stations")

# Display results
for station in results.results[:5]:  # Show first 5 results
    print(f"\nStation: {station.name}")
    print(f"Address: {station.address}")
    print(f"Brand: {station.brand}")
    
    if station.fuels:
        print("Fuel prices:")
        for fuel in station.fuels:
            print(f"  - {fuel.name}: €{fuel.price}")
```

### Search by Geographic Zone

```python
from mimitfuelpy.models.search.criteria.search_by_zone_criteria import SearchByZoneCodeCriteria

# Search within a specific geographic zone
zone_criteria = SearchByZoneCodeCriteria(
    zoneCode="12345",  # Example zone code
    priceOrder="asc",
    fuelType=FuelType.DIESEL.value
)

results = client.search.byZone(zone_criteria)
```

## Working with Geographic Data

### Get Regions, Provinces, and Towns

```python
# Get all regions
regions = client.registry.regions()
print(f"Italian regions: {len(regions)}")

# Get provinces for a specific region
lombardy_provinces = client.registry.provinces("03")  # Lombardy region code
print(f"Lombardy provinces: {len(lombardy_provinces)}")

# Get towns for a specific province
milan_towns = client.registry.towns("015")  # Milan province code
print(f"Milan area towns: {len(milan_towns)}")
```

### Working with Highways

```python
# Get all highways
highways = client.registry.highways()
print(f"Available highways: {len(highways)}")

for highway in highways[:3]:  # Show first 3
    print(f"  - {highway.name}: {highway.code}")
```

## Error Handling

Always wrap your API calls in try-catch blocks:

```python
from mimitfuelpy import Client
from mimitfuelpy.utils.exceptions import MimitApiError

client = Client()

try:
    brands = client.registry.brands()
    print(f"Successfully retrieved {len(brands)} brands")
    
except MimitApiError as e:
    print(f"API Error: {e}")
except Exception as e:
    print(f"Unexpected error: {e}")
```

## Configuration Options

### Custom Timeout

```python
# Set a custom timeout (default is 30 seconds)
client = Client(timeout=60)
```

### Base URL Override

```python
# Use a different API base URL (for testing or proxies)
client = Client(base_url="https://custom-api-url.com")
```

## Common Use Cases

### Find Cheapest Gas Stations

```python
def find_cheapest_stations(province_code, fuel_type, limit=5):
    """Find the cheapest gas stations in a province."""
    criteria = SearchByBrandCriteria(
        province=province_code,
        priceOrder="asc",  # Ascending price order
        fuelType=fuel_type,
        serviceType=ServiceType.SELF.value
    )
    
    results = client.search.byBrand(criteria)
    
    return results.results[:limit]

# Usage
cheap_stations = find_cheapest_stations("MI", FuelType.PETROL.value)
for station in cheap_stations:
    print(f"{station.name}: €{station.fuels[0].price if station.fuels else 'N/A'}")
```

### Get Service Area Details

```python
# Get detailed information about a service area
service_area_id = "12345"  # Replace with actual ID
details = client.registry.serviceAreaDetail(service_area_id)

print(f"Service Area: {details.name}")
print(f"Services: {len(details.services)} available")
print(f"Opening hours: {len(details.openingHours)} time slots")
```

## Next Steps

Now that you've mastered the basics:

1. Explore the [API Reference]({{ site.baseurl }}/api/) for complete documentation
2. Check out more [Examples]({{ site.baseurl }}/examples/) for advanced use cases

## Complete Example

Here's a more complete example that demonstrates multiple features:

```python
#!/usr/bin/env python3
"""
Complete example showing various mimitfuelpy features.
"""

from mimitfuelpy import Client
from mimitfuelpy.models.search.criteria.search_by_brand_criteria import SearchByBrandCriteria
from mimitfuelpy.models.enums.fuel_type import FuelType
from mimitfuelpy.models.enums.service_type import ServiceType
from mimitfuelpy.utils.exceptions import MimitApiError

def main():
    client = Client(timeout=30)
    
    try:
        print("=== mimitfuelpy Demo ===\n")
        
        # 1. Show available brands
        brands = client.registry.brands()
        print(f"📊 Found {len(brands)} fuel brands")
        
        # 2. Search for stations in Milan
        criteria = SearchByBrandCriteria(
            province="MI",
            priceOrder="asc",
            fuelType=FuelType.PETROL.value,
            serviceType=ServiceType.SELF.value
        )
        
        results = client.search.byBrand(criteria)
        print(f"🏪 Found {len(results.results)} stations in Milan")
        
        # 3. Show top 3 cheapest
        print("\n💰 Top 3 cheapest stations:")
        for i, station in enumerate(results.results[:3], 1):
            price = station.fuels[0].price if station.fuels else "N/A"
            print(f"  {i}. {station.name}")
            print(f"     Address: {station.address}")
            print(f"     Price: €{price}")
            print()
        
        # 4. Geographic data
        regions = client.registry.regions()
        print(f"🗺️  Italy has {len(regions)} regions")
        
        print("\n✅ Demo completed successfully!")
        
    except MimitApiError as e:
        print(f"❌ API Error: {e}")
    except Exception as e:
        print(f"❌ Error: {e}")

if __name__ == "__main__":
    main()
```

Save this as `demo.py` and run it with:

```bash
python demo.py
```