pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = "cr.yandex/crp1hc0sfitdo1m1vnt4"  // Yandex Container Registry
        DOCKER_IMAGE = "my-app"
        DOCKER_TAG = "${env.BUILD_NUMBER}-${env.GIT_COMMIT.substring(0, 7)}"  // Например: 42-abc1234
    }

    stages {
        // Stage 1: Получение кода из Git
        stage('Checkout Git') {
            steps {
                checkout scm
            }
        }

        // Stage 2: Сборка Docker-образа
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}")
                }
            }
        }

        // Stage 3: Загрузка образа в Registry
        stage('Push to Registry') {
            steps {
                script {
                    docker.withRegistry("https://${DOCKER_REGISTRY}", "docker-registry-creds") {
                        docker.image("${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}").push()
                    }
                }
            }
        }

        // Stage 4: Деплой на продакшен-серверы
        stage('Deploy to Production') {
            steps {
                sshagent(['prod-server-ssh-key']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no user@prod-server-1 "
                            docker pull ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}
                            docker stop my-app || true
                            docker rm my-app || true
                            docker run -d --name my-app -p 80:80 ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}
                        "
                    """
                }
            }
        }

        // Stage 5: Очистка старых образов (чтобы не забивать диск)
        stage('Cleanup Old Images') {
            steps {
                sh """
                    docker image prune -a -f --filter 'until=24h'
                    docker system df
                """
            }
        }
    }
}