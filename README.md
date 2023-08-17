# 젠킨스 아이템 구성

## gradlew build
```
chmod +x gradlew
./gradlew clean build
```

## docker 이미지 빌드, 푸시 그리고 제거
```
docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD docker.io
docker build -t cleyfobre/test-web:0.0.1 .
docker push cleyfobre/test-web:0.0.1
docker rmi cleyfobre/test-web:0.0.1
```

## 서버 ssh 접속 및 스크립트 실행
```
sudo sh /home/ubuntu/setting.sh
sudo docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD docker.io
sudo docker pull cleyfobre/test-web:0.0.1
sudo sh /home/ubuntu/deploy.sh
```