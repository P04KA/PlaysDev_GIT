pipeline {
    agent any

    environment {
        REGISTRY = "cr.yandex/crp0oph9869e43c5738o"
        DOCKER_IMAGE = "${REGISTRY}:${env.BUILD_NUMBER}"
        DEPLOY_HOST = "ubuntu3@158.160.78.213"
        OAUTH_TOKEN = "y0__xCI3oilqveAAhjB3RMgm4m-0BI1sitH7TbrAx-Ao3vIODQwXTu0Uw"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Push') {
            steps {
                script {
                    sh """
                        echo ${OAUTH_TOKEN} | docker login --username oauth --password-stdin cr.yandex
                        docker push ${DOCKER_IMAGE}
                    """

                    sh """
                        docker tag ${DOCKER_IMAGE} ${REGISTRY}:latest
                        docker push ${REGISTRY}:latest
                    """
                }
            }
        }

        stage('Prepare Deployment Server') {
            steps {
                script {
                    sshagent(['jenkins-ssh-key']) {
                        sh """
                            ssh -o StrictHostKeyChecking=no ${DEPLOY_HOST} '
                                # Установка Docker если отсутствует
                                if ! command -v docker &>/dev/null; then
                                    sudo apt-get update -qq &&
                                    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common &&
                                    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - &&
                                    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" &&
                                    sudo apt-get update -qq &&
                                    sudo apt-get install -y docker-ce
                                fi

                                if ! command -v yc &>/dev/null; then
                                    curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash
                                    exec -l $SHELL
                                fi
                            '
                        """
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    sshagent(['jenkins-ssh-key']) {
                        sh """
                            ssh -o StrictHostKeyChecking=no ${DEPLOY_HOST} '
                                # Настройка YC CLI
                                yc config set token ${OAUTH_TOKEN}
                                yc config set cloud-id b1g5b020anchqspg6qul
                                yc config set folder-id b1g29785h55ampa74ipj
                                yc config set compute-default-zone ru-central1-b

                                # Авторизация в registry
                                IAM_TOKEN=$(yc iam create-token)
                                echo $IAM_TOKEN | sudo docker login --username iam --password-stdin cr.yandex

                                # Остановка и удаление старого контейнера
                                sudo docker stop myapp || true
                                sudo docker rm myapp || true

                                # Запуск нового контейнера
                                sudo docker run -d --name myapp ${DOCKER_IMAGE}
                            '
                        """
                    }
                }
            }
        }
    }
}