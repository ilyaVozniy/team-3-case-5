# Usage: `make <target>` (run `make help` to list targets).

NOTEBOOK_PATHS := .

.DEFAULT_GOAL := help
.PHONY: help install lint format clean

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-14s\033[0m %s\n", $$1, $$2}'

install: ## Install dev dependencies (Poetry)
	poetry install --with dev --no-root

lint: ## Check notebook code and import order with Ruff
	poetry run nbqa ruff $(NOTEBOOK_PATHS)

format: ## Apply Ruff fixes and format notebooks with Black
	poetry run nbqa ruff $(NOTEBOOK_PATHS) --fix
	poetry run nbqa black $(NOTEBOOK_PATHS)

clean: ## Remove Python and lint caches
	poetry run python -c "import shutil; [shutil.rmtree(p, ignore_errors=True) for p in ('.pytest_cache', '.ruff_cache', '.coverage', 'htmlcov')]; [shutil.rmtree(p, ignore_errors=True) for p in __import__('pathlib').Path('.').rglob('__pycache__')]"
