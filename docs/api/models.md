---
layout: default
title: Models & Enums
parent: API Reference
nav_order: 4
---

# Models & Enums
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

This page documents the data models and enumerations used throughout mimitfuelpy.

## Enumerations

### FuelType

Available fuel types supported by the API.

```python
from mimitfuelpy.models import FuelType
```

**Values:**
- `FuelType.ALL` - All fuel types ('0')
- `FuelType.PETROL` - Petrol/Gasoline ('1')  
- `FuelType.DIESEL` - Diesel ('2')
- `FuelType.METHANE` - Methane/CNG ('3')
- `FuelType.GPL` - LPG ('4')
- `FuelType.GCN` - Compressed Natural Gas ('323')
- `FuelType.GNL` - Liquefied Natural Gas ('324')

**Example:**
```python
from mimitfuelpy.models import SearchByBrandCriteria
from mimitfuelpy.models import FuelType

criteria = SearchByBrandCriteria(
    province="MI",
    fuelType=FuelType.PETROL.value  # Use .value to get the API string
)
```

### ServiceType

Refueling service modes.

```python
from mimitfuelpy.models import ServiceType
```

**Values:**
- `ServiceType.SELF` - Self-service ('1')
- `ServiceType.SERVED` - Full service ('0')
- `ServiceType.ALL` - All service types ('x')

**Example:**
```python
from mimitfuelpy.models import ServiceType

criteria = SearchByBrandCriteria(
    province="MI",
    serviceType=ServiceType.SELF.value  # Self-service only
)
```

## Core Models

### Brand

Represents a fuel brand.

**Attributes:**
- `id` (str): Unique brand identifier
- `name` (str): Brand display name

**Example:**
```python
brand = Brand(id="1", name="ENI")
print(f"Brand: {brand.name} (ID: {brand.id})")
```

### Fuel

Represents fuel pricing information.

**Attributes:**
- `id` (str): Fuel type identifier
- `name` (str): Fuel type name
- `price` (float): Current price per liter
- `date` (str): Price date/time

**Example:**
```python
# From service area details
if service_area.fuels:
    for fuel in service_area.fuels:
        print(f"{fuel.name}: €{fuel.price} (as of {fuel.date})")
```

### ServiceArea

Represents a fuel station/service area.

**Attributes:**
- `id` (str): Unique service area identifier
- `name` (str): Service area name
- `address` (str): Full address
- `brand` (str): Associated brand name
- `fuels` (List[Fuel]): Available fuels and prices

**Example:**
```python
# From search results
for station in results.results:
    print(f"{station.name} ({station.brand})")
    print(f"Address: {station.address}")
    if station.fuels:
        cheapest = min(station.fuels, key=lambda f: f.price)
        print(f"Cheapest fuel: {cheapest.name} at €{cheapest.price}")
```

## Location Models

### Region

Represents an Italian region.

**Attributes:**
- `id` (str): Region identifier
- `name` (str): Region name

**Example:**
```python
regions = client.registry.regions()
lombardy = next(r for r in regions if r.name == "LOMBARDIA")
print(f"Lombardy ID: {lombardy.id}")
```

### Province

Represents a province within a region.

**Attributes:**
- `id` (str): Province identifier  
- `name` (str): Province name
- `code` (str): Province code (e.g., "MI" for Milan)

**Example:**
```python
provinces = client.registry.provinces("03")  # Lombardy
milan = next(p for p in provinces if p.code == "MI")
print(f"Milan: {milan.name} (Code: {milan.code})")
```

### Town

Represents a town within a province.

**Attributes:**
- `id` (str): Town identifier
- `name` (str): Town name

### Highway

Represents a highway.

**Attributes:**
- `id` (str): Highway identifier
- `name` (str): Highway name  
- `code` (str): Highway code

## Search Criteria Models

### SearchByBrandCriteria

Criteria for searching service areas by brand.

**Attributes:**
- `province` (str, optional): Province code (e.g., "MI")
- `priceOrder` (str, optional): Price ordering ("asc" or "desc")
- `fuelType` (str, optional): Fuel type ID (use FuelType enum)
- `serviceType` (str, optional): Service type (use ServiceType enum)

**Example:**
```python
from mimitfuelpy.models import SearchByBrandCriteria
from mimitfuelpy.models import FuelType
from mimitfuelpy.models import ServiceType

criteria = SearchByBrandCriteria(
    province="MI",              # Milan province
    priceOrder="asc",          # Cheapest first
    fuelType=FuelType.PETROL.value,   # Petrol only
    serviceType=ServiceType.SELF.value # Self-service only
)

results = client.search.byBrand(criteria)
```

### SearchByZoneCodeCriteria

Criteria for searching service areas by geographic zone.

**Attributes:**
- `zoneCode` (str): Geographic zone code
- `priceOrder` (str, optional): Price ordering ("asc" or "desc")
- `fuelType` (str, optional): Fuel type ID

**Example:**
```python
from mimitfuelpy.models import SearchByZoneCodeCriteria

criteria = SearchByZoneCodeCriteria(
    zoneCode="12345",
    priceOrder="asc",
    fuelType=FuelType.DIESEL.value
)

results = client.search.byZone(criteria)
```

## Detail Models

### ServiceAreaDetail

Extended information about a service area.

**Attributes:**
- `id` (str): Service area identifier
- `name` (str): Service area name
- `nomeImpianto` (str): Plant/facility name
- `address` (str): Full address
- `brand` (str): Associated brand
- `fuels` (List[Fuel]): Available fuels and prices
- `phoneNumber` (str): Contact phone number
- `email` (str): Contact email address
- `website` (str): Website URL
- `company` (str): Operating company name
- `services` (List[ServiceAreaService]): Available services
- `orariapertura` (List[OpeningHour]): Opening hours

### ServiceAreaService

Represents a service offered at a service area.

**Attributes:**
- `name` (str): Service name
- `description` (str): Service description

### OpeningHour

Represents opening hours for a service area.

**Attributes:**
- `day` (str): Day of the week
- `opening_time` (str): Opening time
- `closing_time` (str): Closing time

### Logo

Represents brand logo information.

**Attributes:**
- `brand` (str): Brand name
- `url` (str): Logo image URL
- `images` (List): Available image formats and sizes

## Response Models

### SearchResponse

Response wrapper for search operations.

**Attributes:**
- `success` (bool): Whether the search was successful
- `results` (List[ServiceArea]): List of matching service areas
- `total` (int): Total number of results

**Example:**
```python
response = client.search.byBrand(criteria)
if response.success:
    print(f"Found {len(response.results)} stations")
    for station in response.results:
        print(f"  - {station.name}")
else:
    print("Search failed")
```

## Common Usage Patterns

### Working with Enums

```python
from mimitfuelpy.models import FuelType
from mimitfuelpy.models import ServiceType

# Get all enum values
all_fuel_types = [ft.value for ft in FuelType]
print(f"Supported fuel types: {all_fuel_types}")

# Use in search criteria
criteria = SearchByBrandCriteria(
    fuelType=FuelType.PETROL.value,
    serviceType=ServiceType.SELF.value
)
```

### Processing Search Results

```python
def analyze_results(results):
    """Analyze search results and extract insights."""
    if not results.success:
        return "Search failed"
    
    stations = results.results
    if not stations:
        return "No stations found"
    
    # Find price range
    all_prices = []
    for station in stations:
        if station.fuels:
            prices = [fuel.price for fuel in station.fuels]
            all_prices.extend(prices)
    
    if all_prices:
        min_price = min(all_prices)
        max_price = max(all_prices)
        avg_price = sum(all_prices) / len(all_prices)
        
        return {
            'count': len(stations),
            'price_range': f"€{min_price:.3f} - €{max_price:.3f}",
            'average_price': f"€{avg_price:.3f}"
        }
    
    return f"Found {len(stations)} stations (no price data)"

# Usage
results = client.search.byBrand(criteria)
analysis = analyze_results(results)
print(analysis)
```