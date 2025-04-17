pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
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
                    sh 'echo y0__xCI3oilqveAAhjB3RMgm4m-0BI1sitH7TbrAx-Ao3vIODQwXTu0Uw|docker login \
  --username oauth \
  --password-stdin \
 cr.yandex'
                    sh 'docker tag myapp cr.yandex/crp1hc0sfitdo1m1vnt4:latest'
                    sh 'docker push cr.yandex/crp1hc0sfitdo1m1vnt4:latest'
                }
            }
        }
        stage('Deploy') {
            steps {
                sh "ssh ubuntu2@158.160.25.228 'docker pull cr.yandex/crp1hc0sfitdo1m1vnt4:latest && docker run -d cr.yandex/crp1hc0sfitdo1m1vnt4:latest'"
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}