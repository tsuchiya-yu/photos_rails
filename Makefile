.PHONY: up app

build:
	docker compose build
up:
	docker compose up -d
app:
	docker compose exec web bash
