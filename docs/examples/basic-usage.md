---
layout: default
title: Basic Usage
parent: Examples
nav_order: 1
---

# Basic Usage Examples
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

This page provides basic examples to get you started with mimitfuelpy.

## Getting Started

### Simple Client Setup

```python
from mimitfuelpy import Client

# Create a client with default settings
client = Client()

# Create a client with custom timeout
client = Client(timeout=60)
```

### Your First API Call

```python
from mimitfuelpy import Client

def get_brand_count():
    """Get the number of available fuel brands."""
    client = Client()
    brands = client.registry.brands()
    return len(brands)

# Usage
count = get_brand_count()
print(f"Found {count} fuel brands")
```

## Working with Brands

### List All Brands

```python
from mimitfuelpy import Client

client = Client()

# Get all available brands
brands = client.registry.brands()

print(f"Available fuel brands ({len(brands)}):")
for brand in brands:
    print(f"  - {brand.name} (ID: {brand.id})")
```

### Get Brand Logos

```python
from mimitfuelpy import Client

client = Client()

# Get brand logos
logos = client.registry.brands_logos()

print(f"Brand logos ({len(logos)}):")
for logo in logos:
    print(f"  - {logo.brand}: {logo.url}")
```

## Geographic Data

### List Regions

```python
from mimitfuelpy import Client

client = Client()

# Get all Italian regions
regions = client.registry.regions()

print(f"Italian regions ({len(regions)}):")
for region in regions:
    print(f"  - {region.name} (ID: {region.id})")
```

### Get Provinces in a Region

```python
from mimitfuelpy import Client

client = Client()

# Get provinces in Lombardy (region ID "03")
lombardy_provinces = client.registry.provinces("03")

print(f"Provinces in Lombardy ({len(lombardy_provinces)}):")
for province in lombardy_provinces:
    print(f"  - {province.name} (Code: {province.code})")
```

### Get Towns in a Province

```python
from mimitfuelpy import Client

client = Client()

# Get towns in Milan province (ID "015")
milan_towns = client.registry.towns("015")

print(f"Towns in Milan province ({len(milan_towns)}):")
for town in milan_towns[:10]:  # Show first 10
    print(f"  - {town.name}")
```

## Basic Station Search

### Search by Province

```python
from mimitfuelpy import Client
from mimitfuelpy.models import SearchByBrandCriteria

client = Client()

# Search for stations in Milan province
criteria = SearchByBrandCriteria(province="MI")
results = client.search.byBrand(criteria)

if results.success:
    print(f"Found {len(results.results)} stations in Milan")
    
    # Show first 5 results
    for station in results.results[:5]:
        print(f"  - {station.name}")
        print(f"    Address: {station.address}")
        print(f"    Brand: {station.brand}")
        print()
else:
    print("Search failed")
```

### Search with Fuel Type Filter

```python
from mimitfuelpy import Client
from mimitfuelpy.models import SearchByBrandCriteria
from mimitfuelpy.models import FuelType

client = Client()

# Search for diesel stations in Rome province
criteria = SearchByBrandCriteria(
    province="RM",  # Rome
    fuelType=FuelType.DIESEL.value
)

results = client.search.byBrand(criteria)

if results.success:
    print(f"Found {len(results.results)} diesel stations in Rome")
    for station in results.results[:3]:
        print(f"  - {station.name} ({station.brand})")
```

## Working with Fuel Prices

### Display Station Prices

```python
from mimitfuelpy import Client
from mimitfuelpy.models import SearchByBrandCriteria

client = Client()

# Search for stations with price information
criteria = SearchByBrandCriteria(
    province="MI",
    priceOrder="asc"  # Sort by price ascending
)

results = client.search.byBrand(criteria)

if results.success and results.results:
    print("Stations with fuel prices:")
    
    for station in results.results[:5]:
        print(f"\n🏪 {station.name}")
        print(f"   📍 {station.address}")
        print(f"   🏢 Brand: {station.brand}")
        
        if station.fuels:
            print("   ⛽ Fuel prices:")
            for fuel in station.fuels:
                print(f"      {fuel.name}: €{fuel.price}")
        else:
            print("   ⛽ No price information available")
```

### Find Cheapest Stations

```python
def find_cheapest_petrol_stations(province_code, limit=5):
    """Find the cheapest petrol stations in a province."""
    from mimitfuelpy import Client
    from mimitfuelpy.models import SearchByBrandCriteria
    from mimitfuelpy.models import FuelType
    
    client = Client()
    
    criteria = SearchByBrandCriteria(
        province=province_code,
        fuelType=FuelType.PETROL.value,
        priceOrder="asc"  # Cheapest first
    )
    
    results = client.search.byBrand(criteria)
    
    if results.success:
        return results.results[:limit]
    else:
        return []

# Usage
cheapest = find_cheapest_petrol_stations("MI", limit=3)

print("💰 Cheapest petrol stations in Milan:")
for i, station in enumerate(cheapest, 1):
    if station.fuels:
        petrol_fuel = next((f for f in station.fuels if "benzina" in f.name.lower()), None)
        price = petrol_fuel.price if petrol_fuel else "N/A"
    else:
        price = "N/A"
    
    print(f"{i}. {station.name}")
    print(f"   Price: €{price}")
    print(f"   Address: {station.address}")
    print()
```

## Service Area Details

### Get Detailed Information

```python
from mimitfuelpy import Client

def get_service_area_details(service_area_id):
    """Get detailed information about a service area."""
    client = Client()
    
    try:
        details = client.registry.service_area(service_area_id)
        
        print(f"🏪 {details.name}")
        print(f"📍 Address: {details.address}")
        print(f"🏢 Brand: {details.brand}")
        print(f"🏭 Plant: {details.nomeImpianto}")
        
        if details.phoneNumber:
            print(f"📞 Phone: {details.phoneNumber}")
        
        if details.email:
            print(f"📧 Email: {details.email}")
            
        if details.website:
            print(f"🌐 Website: {details.website}")
        
        if details.services:
            print(f"\n🛠️ Services ({len(details.services)}):")
            for service in details.services:
                print(f"   - {service.name}")
        
        if details.fuels:
            print(f"\n⛽ Fuel prices ({len(details.fuels)}):")
            for fuel in details.fuels:
                print(f"   - {fuel.name}: €{fuel.price}")
        
        if details.orariapertura:
            print(f"\n🕐 Opening hours ({len(details.orariapertura)} entries):")
            for hours in details.orariapertura:
                print(f"   - {hours.day}: {hours.opening_time} - {hours.closing_time}")
                
    except Exception as e:
        print(f"Error getting details: {e}")

# Usage (replace with actual service area ID from search results)
# get_service_area_details("12345")
```

## Error Handling

### Basic Error Handling

```python
from mimitfuelpy import Client
from mimitfuelpy.utils.exceptions import MimitApiError

def safe_brand_fetch():
    """Safely fetch brands with error handling."""
    try:
        client = Client()
        brands = client.registry.brands()
        print(f"✅ Successfully retrieved {len(brands)} brands")
        return brands
        
    except MimitApiError as e:
        print(f"❌ API Error: {e}")
        return []
        
    except ConnectionError as e:
        print(f"❌ Connection Error: {e}")
        return []
        
    except Exception as e:
        print(f"❌ Unexpected Error: {e}")
        return []

# Usage
brands = safe_brand_fetch()
```

### Robust Search with Retry

```python
import time
from mimitfuelpy import Client
from mimitfuelpy.models import SearchByBrandCriteria
from mimitfuelpy.utils.exceptions import MimitApiError

def search_with_retry(province, max_retries=3):
    """Search for stations with retry logic."""
    client = Client()
    criteria = SearchByBrandCriteria(province=province)
    
    for attempt in range(max_retries):
        try:
            print(f"🔍 Search attempt {attempt + 1}/{max_retries}")
            results = client.search.byBrand(criteria)
            
            if results.success:
                print(f"✅ Found {len(results.results)} stations")
                return results.results
            else:
                print("❌ Search returned no results")
                
        except MimitApiError as e:
            print(f"❌ API Error: {e}")
            if attempt < max_retries - 1:
                print(f"⏳ Retrying in 2 seconds...")
                time.sleep(2)
        except Exception as e:
            print(f"❌ Unexpected error: {e}")
            break
    
    print(f"❌ Failed to search after {max_retries} attempts")
    return []

# Usage
stations = search_with_retry("MI")
```

## Complete Example Script

Here's a complete script that demonstrates multiple features:

```python
#!/usr/bin/env python3
"""
Complete basic usage example for mimitfuelpy.
"""

from mimitfuelpy import Client
from mimitfuelpy.models import SearchByBrandCriteria
from mimitfuelpy.models import FuelType
from mimitfuelpy.models import ServiceType
from mimitfuelpy.utils.exceptions import MimitApiError

def main():
    """Demonstrate basic mimitfuelpy features."""
    try:
        # Initialize client
        client = Client(timeout=30)
        print("=== mimitfuelpy Basic Usage Demo ===\n")
        
        # 1. Registry operations
        print("1. 📊 Registry Information")
        brands = client.registry.brands()
        regions = client.registry.regions()
        print(f"   • Brands: {len(brands)}")
        print(f"   • Regions: {len(regions)}")
        
        # Show some brands
        print(f"   • Sample brands:")
        for brand in brands[:3]:
            print(f"     - {brand.name}")
        print()
        
        # 2. Geographic navigation
        print("2. 🗺️ Geographic Navigation")
        lombardy = next((r for r in regions if "LOMBARD" in r.name.upper()), None)
        
        if lombardy:
            provinces = client.registry.provinces(lombardy.id)
            milan = next((p for p in provinces if p.code == "MI"), None)
            
            if milan:
                towns = client.registry.towns(milan.id)
                print(f"   • Lombardy has {len(provinces)} provinces")
                print(f"   • Milan province has {len(towns)} towns")
            else:
                print("   • Milan province not found")
        else:
            print("   • Lombardy region not found")
        print()
        
        # 3. Station search
        print("3. 🏪 Station Search")
        criteria = SearchByBrandCriteria(
            province="MI",
            fuelType=FuelType.PETROL.value,
            serviceType=ServiceType.SELF.value,
            priceOrder="asc"
        )
        
        results = client.search.byBrand(criteria)
        
        if results.success and results.results:
            print(f"   • Found {len(results.results)} petrol stations in Milan")
            
            # Show top 3 with prices
            print("   • Top 3 cheapest:")
            for i, station in enumerate(results.results[:3], 1):
                price = "N/A"
                if station.fuels:
                    petrol = next((f for f in station.fuels if "benzina" in f.name.lower()), None)
                    if petrol:
                        price = f"€{petrol.price}"
                
                print(f"     {i}. {station.name}")
                print(f"        Price: {price}")
                print(f"        Address: {station.address[:50]}...")
        else:
            print("   • No stations found")
        
        print("\n✅ Demo completed successfully!")
        
    except MimitApiError as e:
        print(f"❌ API Error: {e}")
    except Exception as e:
        print(f"❌ Unexpected Error: {e}")

if __name__ == "__main__":
    main()
```

Save this as `basic_demo.py` and run it:

```bash
python basic_demo.py
```