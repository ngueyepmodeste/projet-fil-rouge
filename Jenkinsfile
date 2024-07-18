pipeline {
    agent any

    environment {
        // Variables d'environnement
        ODOO_URL = ''
        PGADMIN_URL = ''
        VERSION = ''
    }

    stages {
        stage('Preparation') {
            steps {
                script {
                    // Lire les valeurs du fichier releases.txt
                    def releaseInfo = readFile('releases.txt').trim().split("\n")
                    ODOO_URL = releaseInfo[0].split(" ")[0]
                    PGADMIN_URL = releaseInfo[1].split(" ")[0]
                    VERSION = releaseInfo[2].split(" ")[0]
                }
                echo "ODOO_URL: ${ODOO_URL}"
                echo "PGADMIN_URL: ${PGADMIN_URL}"
                echo "VERSION: ${VERSION}"
            }
        }

        stage('Checkout') {
            steps {
                // Récupérer le code depuis le dépôt GitHub
                git url: 'https://github.com/ngueyepmodeste/projet-fil-rouge.git', branch: 'main'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Construire l'image Docker avec les variables d'environnement
                    sh """
                        docker build --build-arg ODOO_URL=${ODOO_URL} --build-arg PGADMIN_URL=${PGADMIN_URL} -t ic-webapp:${VERSION} .
                    """
                }
            }
        }

        stage('Test Docker Image') {
            steps {
                script {
                    // Lancer un container pour tester l'image
                    sh """
                        docker run --name test-ic-webapp -d -p 8080:8080 ic-webapp:${VERSION}
                    """
                }
            }
        }
        
        stage('Push Docker Image') {
            steps {
                script {
                    // Pousser l'image Docker sur Docker Hub
                    withCredentials([string(credentialsId: 'docker-hub-credentials', variable: 'DOCKER_HUB_PASSWORD')]) {
                        sh """
                            echo $DOCKER_HUB_PASSWORD | docker login -u 'your-docker-hub-username' --password-stdin
                            docker push ic-webapp:${VERSION}
                        """
                    }
                }
            }
        }

        stage('Deploy to Production') {
            steps {
                script {
                    // Déployer l'application en production avec Ansible
                    sh """
                        ansible-playbook -i inventory deploy.yml --extra-vars "version=${VERSION} odoo_url=${ODOO_URL} pgadmin_url=${PGADMIN_URL}"
                    """
                }
            }
        }
    }

    post {
        always {
            script {
                // Nettoyer les containers et images après le build
                sh """
                    docker rm -f test-ic-webapp || true
                    docker rmi ic-webapp:${VERSION} || true
                """
            }
        }
        success {
            echo 'Pipeline terminé avec succès.'
        }
        failure {
            echo 'Pipeline échoué.'
        }
    }
}
