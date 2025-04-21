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
                    sh 'docker tag myapp cr.yandex/crp0oph9869e43c5738o'
                    sh 'docker push cr.yandex/crp0oph9869e43c5738o'
                }
            }
        }
	stage('Install Docker') {
            steps {
                script {
                    sh '''
                        ssh ubuntu3@158.160.78.213 "
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
                        ssh ubuntu3@158.160.78.213 "
			curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash
			exec -l $SHELL
			yc config set token y0__xCI3oilqveAAhjB3RMgm4m-0BI1sitH7TbrAx-Ao3vIODQwXTU0Uw
			yc config set cloud-id b1g5b020anchqspg6qul
			yc config set folder-id b1g29785h55ampa74ipj
			yc config set compute-default-zone ru-central1-b
			IAM_TOKEN=$(yc iam create-token)
			echo $IAM_TOKEN | sudo docker login --username iam --password-stdin cr.yandex
			sudo docker pull cr.yandex/crp0oph9869e43c5738o
                        docker run -d --name myapp cr.yandex/crp0oph9869e43c5738o
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
