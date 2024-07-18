pipeline {
    agent any
    environment {
        ODOO_URL = ''
        PGADMIN_URL = ''
        VERSION = ''
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
                script {
                    def props = readProperties(file: 'releases.txt')
                    env.ODOO_URL = props['ODOO_URL']
                    env.PGADMIN_URL = props['PGADMIN_URL']
                    env.VERSION = props['Version']
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    if (!env.VERSION) {
                        error "Version not defined. Check releases.txt file."
                    }
                    def image = docker.build("ic-webapp:${env.VERSION}", "--build-arg ODOO_URL=${env.ODOO_URL} --build-arg PGADMIN_URL=${env.PGADMIN_URL} .")
                }
            }
        }
        stage('Test Docker Image') {
            steps {
                script {
                    def image = docker.image("ic-webapp:${env.VERSION}")
                    image.inside {
                        sh 'python test_script.py'
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    sh 'ansible-playbook -i inventory deploy.yml'
                }
            }
        }
    }
}
