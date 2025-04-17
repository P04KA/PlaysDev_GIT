pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/P04KA/PlaysDev_GIT.git'
            }
        }
        stage('Build') {
            steps {
                sh 'docker build -t myapp .'
            }
        }
        stage('Push') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: '123', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "echo y0__xCI3oilqveAAhjB3RMgm4m-0BI1sitH7TbrAx-Ao3vIODQwXTu0Uw|docker login \
  --username oauth \
  --password-stdin \
 cr.yandex"
                        sh "docker tag myapp cr.yandex/b1g29785h55ampa74ipj:latest"
                        sh "docker push cr.yandex/b1g29785h55ampa74ipj:latest"
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                sh "ssh ubuntu@51.250.106.240 'docker pull cr.yandex/b1g29785h55ampa74ipj:latest && docker run -d cr.yandex/b1g29785h55ampa74ipj:latest'"
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}