---
layout: default
title: Registry
parent: API Reference
nav_order: 2
---

# Registry
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

The `Registry` class provides access to reference data including brands, geographic locations, and service area details. It's accessed through the `client.registry` property.

## Methods

### `brands() -> List[Brand]`

Retrieves the list of all available fuel brands.

**Returns:** List of `Brand` objects

**Example:**
```python
brands = client.registry.brands()
for brand in brands:
    print(f"Brand: {brand.name} (ID: {brand.id})")
```

### `brands_logos() -> List[Logo]`

Retrieves the list of all brand logos.

**Returns:** List of `Logo` objects containing logo information

**Example:**
```python
logos = client.registry.brands_logos()
for logo in logos:
    print(f"Logo for {logo.brand}: {logo.url}")
```

### `highways() -> List[Highway]`

Retrieves the list of all highways in Italy.

**Returns:** List of `Highway` objects

**Example:**
```python
highways = client.registry.highways()
for highway in highways:
    print(f"Highway: {highway.name} (Code: {highway.code})")
```

### `regions() -> List[Region]`

Retrieves the list of all Italian regions.

**Returns:** List of `Region` objects

**Example:**
```python
regions = client.registry.regions()
for region in regions:
    print(f"Region: {region.name} (ID: {region.id})")
```

### `provinces(region_id) -> List[Province]`

Retrieves the list of provinces for a specific region.

**Parameters:**
- `region_id` (str): The region ID

**Returns:** List of `Province` objects

**Example:**
```python
# Get provinces for Lombardy (region ID "03")
lombardy_provinces = client.registry.provinces("03")
for province in lombardy_provinces:
    print(f"Province: {province.name} (ID: {province.id})")
```

### `towns(province_id) -> List[Town]`

Retrieves the list of towns for a specific province.

**Parameters:**
- `province_id` (str): The province ID

**Returns:** List of `Town` objects

**Example:**
```python
# Get towns for Milan province (ID "015")
milan_towns = client.registry.towns("015")
for town in milan_towns:
    print(f"Town: {town.name} (ID: {town.id})")
```

### `service_area(service_area_id) -> ServiceAreaDetail`

Retrieves detailed information about a specific service area.

**Parameters:**
- `service_area_id` (str): The service area ID

**Returns:** `ServiceAreaDetail` object with complete information

**Example:**
```python
details = client.registry.service_area("12345")
print(f"Service Area: {details.name}")
print(f"Address: {details.address}")
print(f"Brand: {details.brand}")
print(f"Phone: {details.phoneNumber}")
print(f"Services: {len(details.services)}")
print(f"Opening hours: {len(details.orariapertura)} time slots")
```

## Data Models

### Brand

Represents a fuel brand.

**Attributes:**
- `id` (str): Brand identifier
- `name` (str): Brand name

### Logo

Represents brand logo information.

**Attributes:**
- `brand` (str): Brand name
- `url` (str): Logo image URL
- `images` (List): Available image formats

### Highway

Represents a highway.

**Attributes:**
- `id` (str): Highway identifier
- `name` (str): Highway name
- `code` (str): Highway code

### Region

Represents an Italian region.

**Attributes:**
- `id` (str): Region identifier
- `name` (str): Region name

### Province

Represents a province within a region.

**Attributes:**
- `id` (str): Province identifier
- `name` (str): Province name
- `code` (str): Province code

### Town

Represents a town within a province.

**Attributes:**
- `id` (str): Town identifier
- `name` (str): Town name

### ServiceAreaDetail

Detailed information about a service area.

**Attributes:**
- `id` (str): Service area identifier
- `name` (str): Service area name
- `nomeImpianto` (str): Plant name
- `address` (str): Full address
- `brand` (str): Associated brand
- `fuels` (List[Fuel]): Available fuels and prices
- `phoneNumber` (str): Contact phone number
- `email` (str): Contact email
- `website` (str): Website URL
- `company` (str): Operating company
- `services` (List[ServiceAreaService]): Available services
- `orariapertura` (List[OpeningHour]): Opening hours

## Usage Patterns

### Geographic Hierarchy Navigation

```python
# Navigate the geographic hierarchy
regions = client.registry.regions()
print(f"Italy has {len(regions)} regions")

# Get provinces for first region
first_region = regions[0]
provinces = client.registry.provinces(first_region.id)
print(f"{first_region.name} has {len(provinces)} provinces")

# Get towns for first province
first_province = provinces[0]
towns = client.registry.towns(first_province.id)
print(f"{first_province.name} has {len(towns)} towns")
```

### Service Area Information

```python
# Get detailed service area information
service_area_id = "12345"  # From search results
details = client.registry.service_area(service_area_id)

print(f"Service Area: {details.name}")
print(f"Brand: {details.brand}")
print(f"Address: {details.address}")

# Check available services
if details.services:
    print("Available services:")
    for service in details.services:
        print(f"  - {service.name}")

# Check fuel prices
if details.fuels:
    print("Fuel prices:")
    for fuel in details.fuels:
        print(f"  - {fuel.name}: €{fuel.price}")

# Check opening hours
if details.orariapertura:
    print("Opening hours:")
    for hours in details.orariapertura:
        print(f"  - {hours.day}: {hours.opening_time} - {hours.closing_time}")
```

### Brand Information

```python
# Get all brands and their logos
brands = client.registry.brands()
logos = client.registry.brands_logos()

# Create brand-logo mapping
brand_logos = {}
for logo in logos:
    brand_logos[logo.brand] = logo.url

# Display brands with logos
for brand in brands:
    logo_url = brand_logos.get(brand.name, "No logo available")
    print(f"{brand.name}: {logo_url}")
```