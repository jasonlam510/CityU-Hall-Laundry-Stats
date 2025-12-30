# Initialize environment file from example
.PHONY: init-env
init-env:
	@if [ ! -f .env.example ]; then \
		echo "Error: .env.example file not found"; \
		exit 1; \
	fi
	@if [ -f .env ]; then \
		echo "Warning: .env already exists. Skipping copy."; \
		echo "To overwrite, delete .env first and run 'make init-env' again."; \
	else \
		cp .env.example .env; \
		echo ".env file created from .env.example"; \
	fi

# Start Docker containers
.PHONY: start
start:
	@echo "Starting Docker containers..."
	docker compose up -d

# Import workflows into n8n
.PHONY: import-workflows
import-workflows:
	@echo "Importing workflows into n8n..."
	@docker compose exec -T n8n sh -c "mkdir -p /workflows && chown -R node:node /workflows"
	@for workflow in n8n/workflows/*.json; do \
		if [ -f "$$workflow" ]; then \
			filename=$$(basename "$$workflow"); \
			echo "Importing: $$filename"; \
			docker compose exec -T n8n n8n import:workflow --input="/workflows/$$filename" || echo "Warning: Failed to import $$filename"; \
		fi; \
	done

# Import credentials into n8n
.PHONY: import-credentials
import-credentials:
	@echo "Importing credentials into n8n..."
	@docker compose exec -T n8n sh -c "mkdir -p /credentials && chown -R node:node /credentials"
	@docker compose exec -T n8n n8n import:credentials --separate --input="/credentials"
	
# Initialize n8n: import credentials then workflows
.PHONY: init-n8n
init-n8n: import-credentials import-workflows

# Export workflows from n8n (separate files)
.PHONY: export-workflows
export-workflows:
	@echo "Exporting all workflows from n8n..."
	@mkdir -p n8n/workflows
	@docker compose exec -T n8n sh -c "mkdir -p /workflows && chown -R node:node /workflows"
	docker compose exec -T n8n n8n export:workflow --all --separate --output "/workflows"
	@echo "Workflows exported to n8n/workflows/"

# Export credentials from n8n (separate files)
.PHONY: export-credentials
export-credentials:
	@echo "Exporting all credentials from n8n..."
	@mkdir -p n8n/credentials
	@docker compose exec -T n8n sh -c "mkdir -p /credentials && chown -R node:node /credentials"
	docker compose exec -T n8n n8n export:credentials --all --separate --output "/credentials"
	@echo "Credentials exported to n8n/credentials/"

# Export all from n8n
.PHONY: export-n8n
export-n8n: export-credentials export-workflows

# Clear Docker containers and volumes
.PHONY: clear-env
clear-env:
	@echo "Stopping and removing containers and volumes..."
	docker compose down -v

