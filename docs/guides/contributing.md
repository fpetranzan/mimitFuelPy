---
layout: default
title: Contributing
parent: Guides
nav_order: 2
permalink: /guides/contributing/
---

# Contributing to mimitfuelpy
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

We welcome contributions to mimitfuelpy! Whether you're fixing bugs, adding features, improving documentation, or reporting issues, your help makes the project better for everyone.

## Ways to Contribute

### 🐛 Report Bugs
Found a bug? Help us fix it by [creating an issue](https://github.com/fpetranzan/mimitFuelPy/issues/new).

### 💡 Suggest Features
Have an idea for a new feature? We'd love to hear it! [Open a feature request](https://github.com/fpetranzan/mimitFuelPy/issues/new).

### 🔧 Submit Code
Ready to contribute code? Great! Follow the development setup guide below.

### 📚 Improve Documentation
Documentation improvements are always welcome, from fixing typos to adding new examples.

### 🌍 Share Examples
Created something cool with mimitfuelpy? Share your examples and use cases!

## Development Setup

### Prerequisites

Before you start, make sure you have:

- **Python 3.7+** installed
- **Git** for version control
- **pip** for package management
- A **GitHub account**

### Fork and Clone

1. **Fork the repository** on GitHub by clicking the "Fork" button
2. **Clone your fork** locally:

```bash
git clone https://github.com/YOUR_USERNAME/mimitFuelPy.git
cd mimitFuelPy
```

3. **Add the upstream remote**:

```bash
git remote add upstream https://github.com/fpetranzan/mimitFuelPy.git
```

### Development Environment

1. **Create a virtual environment**:

```bash
python -m venv venv

# Activate it
# On Windows:
venv\Scripts\activate
# On macOS/Linux:
source venv/bin/activate
```

2. **Install the package in development mode**:

```bash
pip install -e ".[dev]"
```

3. **Install additional development dependencies**:

```bash
pip install pytest pytest-cov black flake8 mypy pre-commit
```

4. **Set up pre-commit hooks** (optional but recommended):

```bash
pre-commit install
```

## Development Workflow

### 1. Create a Feature Branch

```bash
# Update your fork
git fetch upstream
git checkout master
git merge upstream/master

# Create a new branch
git checkout -b feature/your-feature-name
# or
git checkout -b fix/your-bug-fix
```

### 2. Make Your Changes

- Write clean, readable code
- Follow the existing code style
- Add docstrings to new functions and classes
- Include type hints where appropriate

### 3. Write Tests

All new code should include tests:

```bash
# Run the test suite
pytest

# Run tests with coverage
pytest --cov=src/mimitfuelpy --cov-report=html
```

### 4. Code Quality Checks

Before committing, run the quality checks:

```bash
# Format code
black src/ tests/

# Check for style issues
flake8 src/ tests/

# Run type checking
mypy src/mimitfuelpy/
```

### 5. Commit Your Changes

Write clear, descriptive commit messages:

```bash
git add .
git commit -m "feat: add support for new fuel type filtering

- Add FuelTypeFilter enum with new fuel types
- Update SearchCriteria to support fuel type filtering
- Add tests for fuel type filtering functionality
- Update documentation with examples"
```

### 6. Push and Create Pull Request

```bash
git push origin feature/your-feature-name
```

Then create a pull request on GitHub with:
- Clear title describing the change
- Detailed description of what was changed and why
- Link to any related issues
- Screenshots if UI changes are involved

## Code Style Guidelines

### Python Code Style

We follow PEP 8 with these specific guidelines:

```python
# Use clear, descriptive names
def search_stations_by_criteria(criteria: SearchCriteria) -> SearchResult:
    """Search for fuel stations using the provided criteria."""
    pass

# Type hints for all public functions
def get_fuel_prices(station_id: str) -> List[FuelPrice]:
    """Get fuel prices for a specific station."""
    pass

# Docstrings for all public functions and classes
class SearchCriteria:
    """Criteria for searching fuel stations.
    
    Args:
        province: Province code (e.g., "MI" for Milan)
        fuel_type: Type of fuel to filter by
        price_order: Sort order for prices ("asc" or "desc")
    """
    pass
```

### Documentation Style

- Use clear, concise language
- Include code examples for new features
- Update the API reference when adding new methods
- Follow the existing documentation structure

### Testing Guidelines

```python
import pytest
from mimitfuelpy import Client
from mimitfuelpy.models import SearchByBrandCriteria

def test_search_by_brand_basic():
    """Test basic brand search functionality."""
    client = Client()
    criteria = SearchByBrandCriteria(province="MI")
    
    result = client.search.byBrand(criteria)
    
    assert result.success
    assert len(result.results) > 0
    
def test_search_with_invalid_province():
    """Test that invalid province codes are handled properly."""
    client = Client()
    criteria = SearchByBrandCriteria(province="INVALID")
    
    result = client.search.byBrand(criteria)
    
    assert not result.success
    assert result.error is not None
```

## Project Structure

Understanding the project structure helps you know where to make changes:

```
mimitFuelPy/
├── src/mimitfuelpy/           # Main package code
│   ├── __init__.py            # Package initialization
│   ├── client.py              # Main client class
│   ├── models/                # Data models
│   │   ├── enums/             # Enumeration classes
│   │   ├── search/            # Search-related models
│   │   └── registry/          # Registry data models
│   ├── utils/                 # Utility functions
│   │   └── exceptions.py      # Custom exceptions
│   └── api/                   # API interaction layer
├── tests/                     # Test files
├── docs/                      # Documentation source
├── examples/                  # Usage examples
├── pyproject.toml            # Project configuration
└── README.md                 # Project overview
```

## Adding New Features

### 1. API Endpoints

When adding support for new API endpoints:

1. **Add the model classes** in `src/mimitfuelpy/models/`
2. **Update the client** in `src/mimitfuelpy/client.py` or relevant module
3. **Add comprehensive tests** in `tests/`
4. **Update documentation** with usage examples

### 2. Search Criteria

For new search criteria:

1. **Create the criteria class** in `src/mimitfuelpy/models/search/criteria/`
2. **Add validation logic** if needed
3. **Update the search methods** to handle the new criteria
4. **Add tests** covering all validation cases

### 3. Data Models

For new data models:

1. **Define the model** with proper type hints
2. **Add validation** using appropriate libraries
3. **Include serialization/deserialization** methods if needed
4. **Document all fields** with clear descriptions

## Testing

### Running Tests

```bash
# Run all tests
pytest

# Run tests with verbose output
pytest -v

# Run specific test file
pytest tests/test_client.py

# Run tests matching a pattern
pytest -k "test_search"

# Run with coverage
pytest --cov=src/mimitfuelpy
```

### Writing Tests

- Test both success and failure cases
- Mock external API calls when appropriate
- Use descriptive test names
- Include edge cases and boundary conditions

### Test Categories

- **Unit tests**: Test individual functions and methods
- **Integration tests**: Test API interactions
- **End-to-end tests**: Test complete workflows

## Documentation

### Building Documentation Locally

The documentation uses Jekyll and the just-the-docs theme:

```bash
# Install Ruby and Jekyll (see Jekyll docs for your OS)

# Install dependencies
bundle install

# Serve documentation locally
bundle exec jekyll serve

# Open http://localhost:4000/mimitFuelPy in your browser
```

### Documentation Guidelines

- **Keep examples practical** and runnable
- **Update API reference** when adding new methods
- **Include type information** in code examples
- **Test code examples** to ensure they work

## Release Process

Releases are handled by maintainers, but here's the process:

1. **Version bump** in `pyproject.toml`
2. **Update CHANGELOG.md** with new features and fixes
3. **Create git tag** with version number
4. **Build and publish** to PyPI
5. **Create GitHub release** with release notes

## Community Guidelines

### Code of Conduct

- Be respectful and constructive in all interactions
- Welcome newcomers and help them get started
- Focus on the technical merits of contributions
- Provide actionable feedback in reviews

### Getting Help

- **GitHub Issues**: For bugs and feature requests
- **Discussions**: For questions and general discussion
- **Email**: For security issues or private matters

### Recognition

Contributors are recognized in:
- **CONTRIBUTORS.md** file
- **Release notes** for significant contributions
- **Documentation** for major features

## Common Contribution Patterns

### Bug Fix

```bash
# 1. Create issue describing the bug
# 2. Create branch
git checkout -b fix/issue-123-connection-timeout

# 3. Write failing test
# 4. Fix the bug
# 5. Ensure test passes
# 6. Submit PR with "Fixes #123" in description
```

### New Feature

```bash
# 1. Discuss feature in issue or discussion
# 2. Create branch
git checkout -b feature/highway-search

# 3. Implement feature with tests
# 4. Update documentation
# 5. Submit PR with detailed description
```

### Documentation

```bash
# 1. Create branch
git checkout -b docs/improve-api-examples

# 2. Update documentation
# 3. Test documentation builds locally
# 4. Submit PR
```

## Questions?

Don't hesitate to ask questions! You can:

- **Open an issue** for clarification on contributing
- **Start a discussion** for broader topics
- **Comment on existing issues** to offer help

Thank you for contributing to mimitfuelpy! 🚀