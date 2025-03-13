#!/bin/bash

set -euo pipefail 

# export AWS_PROFILE=staging-patient-app

# aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 916600710645.dkr.ecr.us-west-2.amazonaws.com
cd /home/ec2-user/app/my_awesome_project  

git checkout develop
git pull origin develop

NEW_MIGRATIONS=$(docker-compose -f staging.yml run --rm django python manage.py showmigrations | grep '\[ \]') || true

if [[ -n "$NEW_MIGRATIONS" ]]; then
    echo "New migrations detected, $NEW_MIGRATIONS, stopping containers..."
    docker-compose -f staging.yml stop django celeryworker celerybeat
else
    echo "No new migrations found, skipping container stop."
fi


docker-compose -f staging.yml pull django celeryworker celerybeat
docker-compose -f staging.yml build django celeryworker celerybeat
docker-compose -f staging.yml up -d django celeryworker celerybeat

echo "Deployment complete"

docker system prune -f --volumes
