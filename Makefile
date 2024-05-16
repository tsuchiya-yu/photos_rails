.PHONY: up app rubocop

build:
	docker compose build
up:
	docker compose up -d
app:
	docker compose exec web bash
rubocop:
	bundle exec rubocop -c .rubocop.yml --require rubocop-airbnb -a
rspec:
	RAILS_ENV=test bundle exec rspec