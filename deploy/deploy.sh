#!/bin/bash

# Blue 를 기준으로 현재 떠있는 컨테이너를 체크한다.
NO_BLUE=$(docker-compose -p test-web-blue -f docker-compose.blue.yml ps | grep Up)

# 컨테이너 스위칭
if [ -z "$NO_BLUE" ]; then
    echo "blue up"
    docker-compose -p test-web-blue -f docker-compose.blue.yml up -d
    BEFORE_COMPOSE_COLOR="green"
    AFTER_COMPOSE_COLOR="blue"
else
    echo "green up"
    docker-compose -p test-web-green -f docker-compose.green.yml up -d
    BEFORE_COMPOSE_COLOR="blue"
    AFTER_COMPOSE_COLOR="green"
fi

sleep 10

# check new container is up
IS_UP=$(docker-compose -p test-web-${AFTER_COMPOSE_COLOR} -f docker-compose.${AFTER_COMPOSE_COLOR}.yml ps | grep Up)
if [ -n "$IS_UP" ]; then

    # if no nginx, run new nginx container
    NO_NGINX=$(docker ps | grep test-nginx)
    if [ -z "$NO_NGINX" ]; then
        docker image build -t test-nginx:0.0.1 -f Dockerfile_nginx . --build-arg COMPOSE_COLOR="${AFTER_COMPOSE_COLOR}"
        docker run -d -p 80:80 --name test-nginx test-nginx:0.0.1
        echo "nginx started"
    else
        docker cp ./nginx.${AFTER_COMPOSE_COLOR}.conf test-nginx:/etc/nginx/nginx.conf
        docker exec test-nginx nginx -s reload
        echo "nginx reloaded"
    fi

    # 이전 컨테이너 종료
    docker-compose -p test-web-${BEFORE_COMPOSE_COLOR} -f docker-compose.${BEFORE_COMPOSE_COLOR}.yml down
    echo "$BEFORE_COMPOSE_COLOR down"
fi
