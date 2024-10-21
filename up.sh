#!/bin/bash

# Read the value of COMPOSE_PROJECT_NAME from the .env file at the top level if defined
if [ -f ../.env ]; then
  COMPOSE_PROJECT_NAME=$(grep -E '^COMPOSE_PROJECT_NAME=' ../.env | cut -d '=' -f2 | xargs)
  if [ -n "$COMPOSE_PROJECT_NAME" ]; then
    export COMPOSE_PROJECT_NAME
  fi
fi

# If COMPOSE_PROJECT_NAME is not defined, use the name of the folder one level above
COMPOSE_PROJECT_NAME=${COMPOSE_PROJECT_NAME:-$(basename "$(dirname "$(pwd)")")}

docker-compose up -d && docker exec -it "${COMPOSE_PROJECT_NAME}-php-apache" /bin/bash