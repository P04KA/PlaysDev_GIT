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
	stage('Install Docker on Target Server') {
            steps {
                script {
                    sh '''
                        ssh ubuntu2@158.160.25.228 "
                        if ! command -v docker &> /dev/null; then
                            sudo apt-get update &&
                            sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common &&
                            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - &&
                            sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" &&
                            sudo apt-get update &&
                            sudo apt-get install -y docker-ce
                        fi
                        "
                    '''
                }
            }
        }
        stage('Deploy') {
            steps {
		script {
                    sh '''
                        ssh ubuntu2@158.160.25.228 "
			yc config list
                        docker pull cr.yandex/crp1hc0sfitdo1m1vnt4:latest
                        docker run -d --name myapp cr.yandex/crp1hc0sfitdo1m1vnt4:latest
                    "
                    '''
            }
	  }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}