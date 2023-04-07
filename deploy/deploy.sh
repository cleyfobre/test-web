#!/bin/bash

# blue up if no blue, green up if blue
HELLO=$(pwd)
logger "pwd?"
logger ${HELLO}

NO_BLUE=$(docker compose -p test-web-blue -f docker-compose.blue.yml ps | grep Up)
if [ -z "$NO_BLUE" ]; then
    logger "blue up"
    docker compose -p test-web-blue -f docker-compose.blue.yml up -d
    logger "blue up2"
    BEFORE_COMPOSE_COLOR="green"
    AFTER_COMPOSE_COLOR="blue"
    logger "blue up3"
else
    logger "green up"
    docker compose -p test-web-green -f docker-compose.green.yml up -d
    logger "green up2"
    BEFORE_COMPOSE_COLOR="blue"
    AFTER_COMPOSE_COLOR="green"
    logger "green up3"
fi

# check if new container is still up after 10s
sleep 10s
IS_UP=$(docker compose -p test-web-${AFTER_COMPOSE_COLOR} -f docker-compose.${AFTER_COMPOSE_COLOR}.yml ps | grep Up)
if [ -n "$IS_UP" ]; then

    # if no nginx, run new nginx container
    NO_NGINX=$(docker ps | grep test-nginx)
    if [ -z "$NO_NGINX" ]; then
        docker image build -t test-nginx:0.0.1 -f Dockerfile_nginx . --build-arg COMPOSE_COLOR="${AFTER_COMPOSE_COLOR}"
        docker run -d -p 80:80 --name test-nginx test-nginx:0.0.1
        logger "nginx started"
    else
        docker cp ./nginx.${AFTER_COMPOSE_COLOR}.conf test-nginx:/etc/nginx/nginx.conf
        docker exec test-nginx nginx -s reload
        logger "nginx reloaded"
    fi

    # previous app down
    docker compose -p test-web-${BEFORE_COMPOSE_COLOR} -f docker-compose.${BEFORE_COMPOSE_COLOR}.yml down
    logger "$BEFORE_COMPOSE_COLOR down"
fi
