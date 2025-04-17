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
		sshagent(['prod-server-key']) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no ubuntu2@158.160.25.228 "
			sudo apt-get update
			sudo apt-get install ca-certificates curl
			sudo install -m 0755 -d /etc/apt/keyrings
			sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
			sudo chmod a+r /etc/apt/keyrings/docker.asc
			echo \
  			"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  			$(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  			sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
			sudo apt-get update
			sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

                        docker pull cr.yandex/crp1hc0sfitdo1m1vnt4:latest
                        docker stop myapp || true
                        docker rm myapp || true
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