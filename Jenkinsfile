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
                echo "VERSION: ${env.VERSION}"
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
                    def dockerImage = "ic-webapp:${env.VERSION}"

                    sh "docker build --build-arg ODOO_URL=${env.ODOO_URL} --build-arg PGADMIN_URL=${env.PGADMIN_URL} -t ${dockerImage} ."
                }
            }
        }

        stage('Deploy to Production') {
            steps {
                script {
                    // Déployer l'application en production avec Ansible
                    sh """
                        ansible-playbook -i ./ansible/inventory.yml  ./ansible/deploy_odoo.yml --extra-vars "version=${env.VERSION} odoo_url=${env.ODOO_URL} pgadmin_url=${env.PGADMIN_URL}"
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
