# Staging
build-staging:
	docker-compose -f staging.yml build
start-staging:
	docker-compose -f staging.yml up
stop-staging:
	docker-compose -f staging.yml down
shell-staging:
	docker-compose -f staging.yml run django python manage.py shell_plus
showmigrations-staging:
	docker-compose -f staging.yml run django python manage.py showmigrations

# Local ----------------------------------------------------------------
# Docker
build:
	docker compose -f local.yml build
start:
	docker compose -f local.yml up --remove-orphans
stop:
	docker compose -f local.yml down --remove-orphans
test:
	# make test FILE_PATH=<FilePath>::<ClassName>::<MethodName>
	docker compose -f local.yml run django pytest -s -n0 --no-cov $(FILE_PATH)
test-all:
	docker compose -f local.yml run django pytest
test-cov:
	docker compose -f local.yml run django pytest --cov-report term-missing --disable-warnings --cov=.
superuser:
	docker compose -f local.yml run django python3 manage.py createsuperuser
reset-db:
	docker compose -f local.yml run django python3 manage.py reset_db
shell:
	docker compose -f local.yml run django python manage.py shell_plus
migrations:
	docker compose -f local.yml run django python manage.py makemigrations
migrate:
	# make migrate FILE_PATH=patients
	# make migrate FILE_PATH="patients 0001"
	docker compose -f local.yml run django python manage.py migrate $(FILE_PATH)
migrate-all:
	docker compose -f local.yml run django python manage.py migrate
showmigrations:
	docker compose -f local.yml run django python manage.py showmigrations

startapp:
	docker compose -f local.yml run django python manage.py startapp $(APP_NAME)

# Git
gpd:
	git pull origin develop
gpm:
	git pull origin main

# Format
format:
	pre-commit run --all-files
