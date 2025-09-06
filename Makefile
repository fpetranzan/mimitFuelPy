# Makefile for mimitfuelpy project

.PHONY: help install install-dev test test-unit test-integration test-performance test-coverage clean lint format type-check build upload docs

# Default target
help:
	@echo "Available commands:"
	@echo "  install         Install package in production mode"
	@echo "  install-dev     Install package in development mode with all dependencies"
	@echo "  test            Run all tests"
	@echo "  test-unit       Run only unit tests"
	@echo "  test-integration Run only integration tests"
	@echo "  test-performance Run performance tests"
	@echo "  test-coverage   Run tests with coverage report"
	@echo "  lint            Run code linting"
	@echo "  format          Format code with black and isort"
	@echo "  type-check      Run type checking with mypy"
	@echo "  clean           Clean temporary files and build artifacts"
	@echo "  build           Build package for distribution"
	@echo "  upload          Upload package to PyPI"
	@echo "  docs            Generate documentation"

# Installation commands
install:
	pip install -e .

install-dev:
	pip install -e .[dev,test]

# Testing commands
test:
	pytest

test-unit:
	pytest tests/unit/ -v

test-integration:
	pytest tests/integration/ -v -m integration

test-performance:
	pytest tests/test_performance.py -v -m slow

test-coverage:
	pytest --cov=src/mimitfuelpy --cov-report=html --cov-report=term-missing

test-quick:
	pytest tests/unit/ --tb=short -q

# Code quality commands
lint:
	@echo "Running flake8..."
	flake8 src tests
	@echo "Running pylint..."
	pylint src/mimitfuelpy

format:
	@echo "Running black..."
	black src tests
	@echo "Running isort..."
	isort src tests

type-check:
	mypy src/mimitfuelpy

# Development commands
clean:
	@echo "Cleaning temporary files..."
	find . -type f -name "*.pyc" -delete
	find . -type d -name "__pycache__" -delete
	find . -type d -name "*.egg-info" -exec rm -rf {} +
	rm -rf build/
	rm -rf dist/
	rm -rf htmlcov/
	rm -rf .coverage
	rm -rf coverage.xml
	rm -rf .pytest_cache/
	rm -rf .mypy_cache/

# Build and distribution
build: clean
	python -m build

upload-test: build
	python -m twine upload --repository testpypi dist/*

upload: build
	python -m twine upload dist/*

# Documentation
docs:
	@echo "Documentation generation not yet implemented"

# Development workflow shortcuts
check: lint type-check test-unit
	@echo "All checks passed!"

ci: lint type-check test
	@echo "CI pipeline completed!"

# Git hooks setup
install-hooks:
	pre-commit install

# Virtual environment setup
venv:
	python -m venv venv
	@echo "Virtual environment created. Activate with:"
	@echo "  source venv/bin/activate  # Linux/macOS"
	@echo "  venv\\Scripts\\activate     # Windows"

# Package info
info:
	@echo "Package: mimitfuelpy"
	@echo "Version: $(shell python -c 'from src.mimitfuelpy import __version__; print(__version__)')"
	@echo "Python: $(shell python --version)"
	@echo "Pytest: $(shell pytest --version)"

# Security scan
security:
	safety check
	bandit -r src/

# Performance profiling
profile:
	python -m cProfile -o profile.stats -m pytest tests/test_performance.py
	python -c "import pstats; p=pstats.Stats('profile.stats'); p.sort_stats('cumulative'); p.print_stats(20)"

# Dependency management  
deps-update:
	pip-compile requirements.in
	pip-compile requirements-dev.in

deps-sync:
	pip-sync requirements.txt requirements-dev.txt