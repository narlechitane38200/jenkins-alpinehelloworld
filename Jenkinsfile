pipeline {
    agent none  // Aucun agent global pour le pipeline

    environment {
        IMAGE_NAME = "alpinehelloworld"
        CONTAINER_NAME = "${IMAGE_NAME}"
        PORT = "80"
    }

    stages {
        stage('Build Docker Image') {
            agent { label 'docker-agent' } // Agent capable de builder Docker
            steps {
                echo "Building Docker image..."
                sh """
                docker build -t ${IMAGE_NAME}:latest .
                """
            }
        }

        stage('Run Docker Container') {
            agent { label 'docker-agent' } // Même agent ou un autre capable de docker
            steps {
                echo "Running container..."
                sh """
                # Supprimer le conteneur s'il existe déjà
                docker rm -f ${CONTAINER_NAME} || true
                docker run -d --name ${CONTAINER_NAME} -p ${PORT}:5000 ${IMAGE_NAME}:latest
                """
            }
        }

        stage('Test Container') {
            agent { label 'docker-agent' } // Peut être un agent différent
            steps {
                echo "Testing container with curl..."
                sh """
                sleep 5  # Attendre que le conteneur démarre
                RESPONSE=\$(curl -s http://localhost:${PORT})
                echo "Response: \$RESPONSE"
                if [[ "\$RESPONSE" != *"Hello World"* ]]; then
                    echo "Test failed!"
                    exit 1
                fi
                echo "Test passed!"
                """
            }
        }
    }

    post {
        always {
            agent { label 'docker-agent' } // Netoyage sur un agent capable de docker
            echo "Cleaning up container..."
            sh "docker rm -f ${CONTAINER_NAME} || true"
        }
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed!"
        }
    }
}
