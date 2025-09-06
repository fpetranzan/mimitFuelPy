---
layout: default
title: Getting Started
parent: Guides
nav_order: 1
---

# Getting Started Guide
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

This comprehensive guide will help you get started with mimitfuelpy, from installation to your first successful API calls.

## Prerequisites

Before you begin, ensure you have:

- **Python 3.7 or higher** installed on your system
- **pip** package manager
- An internet connection (for API calls)

You can check your Python version:

```bash
python --version
# or
python3 --version
```

## Step 1: Installation

### Option A: Install from PyPI (Recommended)

```bash
pip install mimitfuelpy
```

### Option B: Install from Source

```bash
# Clone the repository
git clone https://github.com/fpetranzan/mimitFuelPy.git
cd mimitFuelPy

# Install in development mode
pip install -e .
```

### Option C: Using Virtual Environment (Recommended)

```bash
# Create virtual environment
python -m venv mimitfuel-env

# Activate it
# On Windows:
mimitfuel-env\Scripts\activate
# On macOS/Linux:
source mimitfuel-env/bin/activate

# Install mimitfuelpy
pip install mimitfuelpy
```

## Step 2: Verify Installation

Create a simple test script to verify everything works:

```python
# test_installation.py
import mimitfuelpy

print(f"mimitfuelpy version: {mimitfuelpy.__version__}")

# Test basic functionality
from mimitfuelpy import Client
client = Client()

try:
    brands = client.registry.brands()
    print(f"✅ Installation successful! Found {len(brands)} fuel brands.")
except Exception as e:
    print(f"❌ Installation issue: {e}")
```

Run the test:

```bash
python test_installation.py
```

## Step 3: Understanding the API Structure

mimitfuelpy is organized into two main areas:

### Registry Operations (`client.registry`)
Access to reference data:
- Fuel brands
- Geographic data (regions, provinces, towns)
- Highway information
- Service area details

### Search Operations (`client.search`)
Search for fuel stations:
- By brand and location
- By geographic zone
- With various filters (fuel type, service type, price ordering)

## Step 4: Your First API Calls

### Get Available Brands

```python
from mimitfuelpy import Client

client = Client()

# Get all fuel brands
brands = client.registry.brands()
print(f"Available brands: {len(brands)}")

for brand in brands[:5]:  # Show first 5
    print(f"  - {brand.name} (ID: {brand.id})")
```

### Explore Geographic Data

```python
# Get Italian regions
regions = client.registry.regions()
print(f"\nItalian regions: {len(regions)}")

# Find Lombardy
lombardy = next((r for r in regions if "LOMBARD" in r.name.upper()), None)
if lombardy:
    print(f"Found Lombardy: {lombardy.name} (ID: {lombardy.id})")
    
    # Get provinces in Lombardy
    provinces = client.registry.provinces(lombardy.id)
    print(f"Provinces in Lombardy: {len(provinces)}")
    
    # Find Milan
    milan = next((p for p in provinces if p.code == "MI"), None)
    if milan:
        print(f"Found Milan: {milan.name} (Code: {milan.code})")
```

## Step 5: Search for Fuel Stations

### Basic Search

```python
from mimitfuelpy.models.search.criteria.search_by_brand_criteria import SearchByBrandCriteria

# Search for stations in Milan
criteria = SearchByBrandCriteria(province="MI")
results = client.search.byBrand(criteria)

if results.success:
    print(f"\n🏪 Found {len(results.results)} stations in Milan")
    
    # Show first 3 results
    for station in results.results[:3]:
        print(f"  - {station.name}")
        print(f"    Brand: {station.brand}")
        print(f"    Address: {station.address}")
        print()
```

### Search with Filters

```python
from mimitfuelpy.models.enums.fuel_type import FuelType
from mimitfuelpy.models.enums.service_type import ServiceType

# Search for self-service petrol stations, sorted by price
criteria = SearchByBrandCriteria(
    province="MI",                    # Milan province
    fuelType=FuelType.PETROL.value,  # Petrol only
    serviceType=ServiceType.SELF.value, # Self-service only
    priceOrder="asc"                 # Cheapest first
)

results = client.search.byBrand(criteria)

if results.success and results.results:
    print(f"\n💰 Found {len(results.results)} petrol stations (cheapest first):")
    
    for station in results.results[:5]:
        print(f"  🏪 {station.name} ({station.brand})")
        
        if station.fuels:
            for fuel in station.fuels:
                print(f"     ⛽ {fuel.name}: €{fuel.price}")
        else:
            print(f"     ⛽ No price data available")
        print()
```

## Step 6: Error Handling

Always wrap your API calls in try-catch blocks:

```python
from mimitfuelpy.utils.exceptions import MimitApiError

def safe_api_call():
    try:
        client = Client(timeout=30)
        brands = client.registry.brands()
        return brands
        
    except MimitApiError as e:
        print(f"API Error: {e}")
        return []
        
    except ConnectionError as e:
        print(f"Connection Error: {e}")
        return []
        
    except Exception as e:
        print(f"Unexpected Error: {e}")
        return []

# Usage
brands = safe_api_call()
if brands:
    print(f"Successfully retrieved {len(brands)} brands")
else:
    print("Failed to retrieve brands")
```

## Step 7: Configuration Options

### Custom Timeout

```python
# Set a longer timeout for slow connections
client = Client(timeout=60)  # 60 seconds
```

### Custom Base URL

```python
# Use a different API endpoint (for testing or proxies)
client = Client(base_url="https://custom-api.example.com")
```

## Common Patterns

### 1. Find Cheapest Stations

```python
def find_cheapest_fuel(province_code, fuel_type, limit=5):
    """Find the cheapest fuel stations for a given fuel type."""
    criteria = SearchByBrandCriteria(
        province=province_code,
        fuelType=fuel_type,
        priceOrder="asc"
    )
    
    results = client.search.byBrand(criteria)
    
    if results.success:
        return results.results[:limit]
    else:
        return []

# Usage
cheap_petrol = find_cheapest_fuel("MI", FuelType.PETROL.value, limit=3)
for station in cheap_petrol:
    print(f"{station.name}: {station.address}")
```

### 2. Geographic Exploration

```python
def explore_region(region_name):
    """Explore a region's provinces and some towns."""
    regions = client.registry.regions()
    region = next((r for r in regions if region_name.upper() in r.name.upper()), None)
    
    if not region:
        print(f"Region '{region_name}' not found")
        return
    
    print(f"🗺️ Exploring {region.name}")
    
    provinces = client.registry.provinces(region.id)
    print(f"   Provinces: {len(provinces)}")
    
    for province in provinces[:3]:  # First 3 provinces
        towns = client.registry.towns(province.id)
        print(f"   • {province.name} ({province.code}): {len(towns)} towns")

# Usage
explore_region("Lombardia")
```

### 3. Service Area Details

```python
def get_full_station_info(province_code):
    """Get detailed info for the first station found."""
    criteria = SearchByBrandCriteria(province=province_code)
    results = client.search.byBrand(criteria)
    
    if results.success and results.results:
        station = results.results[0]
        details = client.registry.service_area(station.id)
        
        print(f"🏪 {details.name}")
        print(f"📍 {details.address}")
        print(f"🏢 Brand: {details.brand}")
        
        if details.phoneNumber:
            print(f"📞 {details.phoneNumber}")
        
        if details.services:
            print(f"🛠️ Services: {', '.join(s.name for s in details.services)}")
        
        if details.fuels:
            print("⛽ Fuel prices:")
            for fuel in details.fuels:
                print(f"   {fuel.name}: €{fuel.price}")

# Usage (uncomment to test)
# get_full_station_info("MI")
```

## Next Steps

Now that you've learned the basics:

1. **Explore the [API Reference]({{ site.baseurl }}{% link api/index.md %})** for complete documentation
2. **Check out [Examples]({{ site.baseurl }}{% link examples/index.md %})** for more complex use cases
3. **Read about [Best Practices]({{ site.baseurl }}{% link guides/best-practices.md %})** for production use

## Complete Starter Script

Here's a complete script that demonstrates the key concepts:

```python
#!/usr/bin/env python3
"""
Complete getting started example for mimitfuelpy.
"""

from mimitfuelpy import Client
from mimitfuelpy.models.search.criteria.search_by_brand_criteria import SearchByBrandCriteria
from mimitfuelpy.models.enums.fuel_type import FuelType
from mimitfuelpy.models.enums.service_type import ServiceType
from mimitfuelpy.utils.exceptions import MimitApiError

def main():
    """Complete getting started demonstration."""
    print("🚀 mimitfuelpy Getting Started Guide")
    print("=" * 50)
    
    try:
        # Initialize client
        client = Client()
        
        # 1. Registry exploration
        print("\n📊 Step 1: Exploring the Registry")
        brands = client.registry.brands()
        regions = client.registry.regions()
        highways = client.registry.highways()
        
        print(f"   • Available brands: {len(brands)}")
        print(f"   • Italian regions: {len(regions)}")
        print(f"   • Highway networks: {len(highways)}")
        
        # 2. Geographic navigation
        print("\n🗺️ Step 2: Geographic Navigation")
        lombardy = next((r for r in regions if "LOMBARD" in r.name.upper()), None)
        
        if lombardy:
            provinces = client.registry.provinces(lombardy.id)
            print(f"   • Lombardy has {len(provinces)} provinces")
            
            milan = next((p for p in provinces if p.code == "MI"), None)
            if milan:
                towns = client.registry.towns(milan.id)
                print(f"   • Milan province has {len(towns)} towns")
        
        # 3. Basic search
        print("\n🔍 Step 3: Basic Station Search")
        criteria = SearchByBrandCriteria(province="MI")
        results = client.search.byBrand(criteria)
        
        if results.success:
            print(f"   • Found {len(results.results)} stations in Milan")
        
        # 4. Advanced search with filters
        print("\n⛽ Step 4: Advanced Search (Cheapest Petrol)")
        criteria = SearchByBrandCriteria(
            province="MI",
            fuelType=FuelType.PETROL.value,
            serviceType=ServiceType.SELF.value,
            priceOrder="asc"
        )
        
        results = client.search.byBrand(criteria)
        
        if results.success and results.results:
            print(f"   • Found {len(results.results)} petrol stations")
            
            top_station = results.results[0]
            print(f"   • Cheapest: {top_station.name}")
            
            if top_station.fuels:
                cheapest_fuel = min(top_station.fuels, key=lambda f: f.price)
                print(f"   • Best price: €{cheapest_fuel.price} for {cheapest_fuel.name}")
        
        print("\n✅ Getting started guide completed successfully!")
        print("\n🎯 Next steps:")
        print("   • Explore the API Reference for complete documentation")
        print("   • Check out Examples for more complex use cases")
        print("   • Read Best Practices for production use")
        
    except MimitApiError as e:
        print(f"❌ API Error: {e}")
    except Exception as e:
        print(f"❌ Unexpected Error: {e}")

if __name__ == "__main__":
    main()
```

Save this as `getting_started.py` and run it to see mimitfuelpy in action!