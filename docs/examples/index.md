---
layout: default
title: Examples
nav_order: 5
has_children: true
permalink: /examples/
---

# Examples

Real-world examples and code snippets to help you get the most out of mimitfuelpy.

## Basic Examples

- **[Basic Usage]({{ site.baseurl }}{% link examples/basic-usage.md %})** - Simple examples to get started
- **[Search Examples]({{ site.baseurl }}{% link examples/search-examples.md %})** - Various ways to search for fuel stations
- **[Geographic Data]({{ site.baseurl }}{% link examples/geographic-data.md %})** - Working with regions, provinces, and towns

## Advanced Examples

- **[Error Handling]({{ site.baseurl }}{% link examples/error-handling.md %})** - Robust error handling patterns
- **[Data Processing]({{ site.baseurl }}{% link examples/data-processing.md %})** - Processing and analyzing fuel data
- **[Async Usage]({{ site.baseurl }}{% link examples/async-usage.md %})** - Using mimitfuelpy in async applications

## Use Cases

- **[Price Comparison]({{ site.baseurl }}{% link examples/price-comparison.md %})** - Find the cheapest fuel stations
- **[Route Planning]({{ site.baseurl }}{% link examples/route-planning.md %})** - Find stations along a route
- **[Data Analysis]({{ site.baseurl }}{% link examples/data-analysis.md %})** - Analyzing fuel price trends

## Running the Examples

All examples are standalone Python scripts that you can run directly:

```bash
# Clone the repository
git clone https://github.com/fpetranzan/mimitFuelPy.git
cd mimitFuelPy

# Install the library
pip install -e .

# Run examples
python examples/basic_usage.py
```

## Contributing Examples

We welcome contributions of new examples! Please see our [Contributing Guide]({{ site.baseurl }}{% link guides/contributing.md %}) for details on how to submit new examples.