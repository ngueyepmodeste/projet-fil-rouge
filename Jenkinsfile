pipeline {
    agent any

    environment {
        ODOO_URL = ""
        PGADMIN_URL = ""
        VERSION = ""
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Load Environment Variables') {
            steps {
                script {
                    def props = readProperties file: 'releases.txt'
                    env.ODOO_URL = props.ODOO_URL
                    env.PGADMIN_URL = props.PGADMIN_URL
                    env.VERSION = props.VERSION
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                docker build --build-arg ODOO_URL=${ODOO_URL} --build-arg PGADMIN_URL=${PGADMIN_URL} -t ic-webapp:${VERSION} .
                '''
            }
        }

        stage('Test Docker Image') {
            steps {
                sh '''
                docker run --rm -e ODOO_URL=${ODOO_URL} -e PGADMIN_URL=${PGADMIN_URL} --name test-ic-webapp ic-webapp:${VERSION} 
                '''
            }
        }


        stage('Deploy to Production') {
            steps {
                ansiblePlaybook(
                    playbook: '../roles/deploy_odoo.yml',
                    inventory: '../roles/inventory.yml'
                )
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
