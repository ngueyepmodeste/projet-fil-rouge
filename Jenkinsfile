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
                    env.ODOO_URL = releaseInfo[0].split(" ")[1]
                    env.PGADMIN_URL = releaseInfo[1].split(" ")[1]
                    env.VERSION = releaseInfo[2].split(" ")[1]
                }
                echo "ODOO_URL: ${env.ODOO_URL}"
                echo "PGADMIN_URL: ${env.PGADMIN_URL}"
                echo "VERSION: ${env.version}"
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
                    def dockerImage = "ic-webapp:${env.version}"

                    sh "docker build --build-arg ODOO_URL=${env.ODOO_URL} --build-arg PGADMIN_URL=${env.PGADMIN_URL} -t ${dockerImage} ."
                }
            }
        }

        stage('Test Docker Image') {
            steps {
                script {
                    // Lancer un container pour tester l'image
                    sh """
                        docker run --name test-ic-webapp -d -p 8080:8080 ic-webapp:${env.VERSION}
                    """
                }
            }
        }

 stage('Deploy to Production') {
            steps {
                ansiblePlaybook(
                    playbook: 'ansible/deploy_odoo.yml',
                    inventory: 'ansible/inventory.yml'
                )
            }
        }
    }

    post {
        always {
            script {
                // Nettoyer les containers et images après le build
                sh """
                    docker rm -f test-ic-webapp || true
                    docker rmi ic-webapp:${env.VERSION} || true
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
