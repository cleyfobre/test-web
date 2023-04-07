#!/bin/bash

# blue up if no blue, green up if blue
if docker ps | grep -q test-web-blue; then
  echo "green up"
  docker compose -p test-web-green -f docker-compose.green.yml up -d
  BEFORE_COMPOSE_COLOR="blue"
  AFTER_COMPOSE_COLOR="green"
else
  echo "blue up"
  docker compose -p test-web-blue -f docker-compose.blue.yml up -d
  BEFORE_COMPOSE_COLOR="green"
  AFTER_COMPOSE_COLOR="blue"
fi


# check if new container is still up after 10s
sleep 10s
if docker ps | grep -q test-web-${AFTER_COMPOSE_COLOR}; then
  # if no nginx, run new nginx container
  if docker ps | grep -q test-nginx; then
    docker cp ./nginx.${AFTER_COMPOSE_COLOR}.conf test-nginx:/etc/nginx/nginx.conf
    docker exec test-nginx nginx -s reload
    echo "nginx reloaded"
  else
    docker image build -t test-nginx:0.0.1 -f Dockerfile_nginx . --build-arg COMPOSE_COLOR="${AFTER_COMPOSE_COLOR}"
    docker run -d -p 80:80 --name test-nginx test-nginx:0.0.1
    echo "nginx started"
  fi

  # previous app down
  docker compose -p test-web-${BEFORE_COMPOSE_COLOR} -f docker-compose.${BEFORE_COMPOSE_COLOR}.yml down
  echo "$BEFORE_COMPOSE_COLOR down"
fi
