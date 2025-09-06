---
layout: default
title: Client
parent: API Reference
nav_order: 1
---

# Client
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

The `Client` class is the main entry point for interacting with the Mimit Fuel API. It provides access to registry and search operations through its properties.

## Constructor

### `Client(base_url=None, timeout=30)`

Creates a new client instance.

**Parameters:**
- `base_url` (str, optional): Custom API base URL. Defaults to the official Mimit API endpoint.
- `timeout` (int, optional): Request timeout in seconds. Defaults to 30.

**Example:**
```python
from mimitfuelpy import Client

# Default configuration
client = Client()

# Custom timeout
client = Client(timeout=60)

# Custom base URL (for testing or proxies)
client = Client(base_url="https://custom-api.example.com")
```

## Properties

### `registry`

Access to registry operations (brands, geographic data, service areas).

**Type:** [`Registry`]({{ site.baseurl }}{% link api/registry.md %})

**Example:**
```python
# Get all brands
brands = client.registry.brands()

# Get regions
regions = client.registry.regions()
```

### `search`

Access to search operations for fuel stations.

**Type:** [`Search`]({{ site.baseurl }}{% link api/search.md %})

**Example:**
```python
from mimitfuelpy.models.search.criteria.search_by_brand_criteria import SearchByBrandCriteria

criteria = SearchByBrandCriteria(province="MI")
results = client.search.byBrand(criteria)
```

## Methods

### `__init__(base_url=None, timeout=30)`

Initializes the client with optional configuration.

**Parameters:**
- `base_url` (str, optional): API base URL
- `timeout` (int, optional): Request timeout in seconds

**Raises:**
- `ValueError`: If timeout is not a positive integer

## Usage Examples

### Basic Usage

```python
from mimitfuelpy import Client
from mimitfuelpy.utils.exceptions import MimitApiError

try:
    client = Client()
    
    # Use registry operations
    brands = client.registry.brands()
    print(f"Found {len(brands)} brands")
    
    # Use search operations
    from mimitfuelpy.models.search.criteria.search_by_brand_criteria import SearchByBrandCriteria
    criteria = SearchByBrandCriteria(province="MI")
    results = client.search.byBrand(criteria)
    print(f"Found {len(results.results)} stations")
    
except MimitApiError as e:
    print(f"API error: {e}")
```

### Custom Configuration

```python
# Configure for production use
client = Client(
    timeout=60  # Longer timeout for slower connections
)

# Configure for testing
test_client = Client(
    base_url="https://test-api.example.com",
    timeout=5  # Shorter timeout for tests
)
```

### Error Handling

```python
from mimitfuelpy import Client
from mimitfuelpy.utils.exceptions import MimitApiError

try:
    client = Client(timeout=30)
    brands = client.registry.brands()
    
except MimitApiError as e:
    print(f"API request failed: {e}")
except ConnectionError as e:
    print(f"Network error: {e}")
except Exception as e:
    print(f"Unexpected error: {e}")
```

## Thread Safety

The `Client` class is thread-safe and can be safely used across multiple threads. However, it's recommended to use a single client instance per application to benefit from connection pooling.

## Best Practices

1. **Reuse client instances** - Create one client and reuse it throughout your application
2. **Set appropriate timeouts** - Adjust timeout based on your network conditions
3. **Handle exceptions** - Always wrap API calls in try-catch blocks
4. **Use context managers** - For resource cleanup in long-running applications

```python
# Good: Reuse client instance
client = Client()

def get_brands():
    return client.registry.brands()

def search_stations(criteria):
    return client.search.byBrand(criteria)

# Bad: Creating new clients repeatedly
def get_brands():
    client = Client()  # Don't do this
    return client.registry.brands()
```