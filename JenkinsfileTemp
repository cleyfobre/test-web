pipeline {
    environment {
        TARGET_HOST = "ubuntu@172.31.5.156"
        DOCKERHUB_CREDENTIALS = credentials('cleyfobre')
    }
    agent any
    stages {
        stage('========== Clone Source ==========') {
            steps {
                checkout scm
            }
        }
        stage('========== Build ==========') {
            steps {
                script {
                    docker.build 'cleyfobre/demo2:$BUILD_NUMBER'
                    docker.build 'cleyfobre/demo2:latest'
                }
            }
        }
        stage('========== Test ==========') {
            steps {
                echo "Testing"
            }
        }
        stage('========== Login ==========') {
            steps{
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin' // docker hub 로그인
            }
        }
        stage('========== Deploy to Docker Hub ==========') {
            steps {
                script {
                    sh 'docker push cleyfobre/demo2:$BUILD_NUMBER'
                    sh 'docker push cleyfobre/demo2:latest'
                }
            }
        }
        stage('========== Remove Images ==========') {
            steps {
                sh 'docker rmi cleyfobre/demo2:$BUILD_NUMBER'
                sh 'docker rmi cleyfobre/demo2:latest'
            }
        }
        stage('========== Work for test-web instance ==========') {
            steps {
                sh 'ls'
                sshagent (credentials: ['test-web-ssh']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ${TARGET_HOST} '
                        pwd
                        '
                    """
                }
                sh 'whoami'
            }

        }
    }

}
