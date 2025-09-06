---
layout: default
title: Installation
nav_order: 2
---

# Installation
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Requirements

mimitfuelpy requires Python 3.7 or higher. The library has minimal dependencies:

- **Python**: 3.7+
- **requests**: 2.25.0+

## Install from PyPI

The easiest way to install mimitfuelpy is using pip:

```bash
pip install mimitfuelpy
```

### Upgrading

To upgrade to the latest version:

```bash
pip install --upgrade mimitfuelpy
```

### Installing Specific Versions

To install a specific version:

```bash
pip install mimitfuelpy==0.1.0
```

## Install from Source

If you want to install from source or contribute to the project:

### Clone the Repository

```bash
git clone https://github.com/fpetranzan/mimitFuelPy.git
cd mimitFuelPy
```

### Install in Development Mode

For development, install in editable mode:

```bash
pip install -e .
```

This allows you to make changes to the source code and have them reflected immediately.

### Install with Development Dependencies

To install with all development dependencies (testing, linting, etc.):

```bash
pip install -e ".[dev]"
```

## Virtual Environment (Recommended)

It's recommended to use a virtual environment to avoid conflicts with other packages:

### Using venv

```bash
# Create virtual environment
python -m venv mimitfuelpy-env

# Activate on Windows
mimitfuelpy-env\Scripts\activate

# Activate on macOS/Linux
source mimitfuelpy-env/bin/activate

# Install mimitfuelpy
pip install mimitfuelpy
```

### Using conda

```bash
# Create environment
conda create -n mimitfuelpy python=3.9

# Activate environment
conda activate mimitfuelpy

# Install mimitfuelpy
pip install mimitfuelpy
```

## Verification

After installation, verify that mimitfuelpy is working correctly:

```python
import mimitfuelpy
print(mimitfuelpy.__version__)

# Test basic functionality
from mimitfuelpy import Client
client = Client()
brands = client.registry.brands()
print(f"Found {len(brands)} fuel brands")
```

If this runs without errors, you're ready to use mimitfuelpy!

## Troubleshooting

### Common Issues

#### ImportError: No module named 'mimitfuelpy'

Make sure you've installed the package and are using the correct Python environment:

```bash
pip list | grep mimitfuelpy
```

#### Connection Errors

If you encounter connection errors, check:

1. Your internet connection
2. Corporate firewall settings
3. Proxy configuration (if applicable)

#### Version Conflicts

If you have dependency conflicts, try creating a fresh virtual environment:

```bash
python -m venv fresh-env
# Activate the environment
pip install mimitfuelpy
```

### Getting Help

If you encounter issues:

1. Check the [examples]({{ site.baseurl }}{% link examples/index.md %}) for common use cases
2. Review [API documentation]({{ site.baseurl }}{% link api/index.md %})
3. Search [GitHub issues](https://github.com/fpetranzan/mimitFuelPy/issues)
4. Create a new issue with details about your problem