pipeline {
    agent {
        docker {
            image 'ansible/ansible:latest' // Utiliser l'image Ansible officielle
            args '-u root'
        }
    }

    environment {
        ANSIBLE_HOST_KEY_CHECKING = 'false'
        GITHUB_REPO = 'https://github.com/ngueyepmodeste/projet-fil-rouge.git'
        ANSIBLE_PLAYBOOK = 'ansible/deploy_odoo.yml'
        INVENTORY_FILE = 'ansible/inventory.yml'
        JENKINS_KEY = '/home/ubuntu/jenkins_key.pem'
        ANSIBLE_USER = 'ubuntu'
    }

    stages {
        stage('Cleanup Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout') {
            steps {
                git branch: 'main', url: env.GITHUB_REPO
            }
        }

        stage('Deploy Odoo') {
            steps {
                ansiblePlaybook credentialsId: 'dev-server', 
                    disableHostKeyChecking: true, 
                    extras: "-i ${env.INVENTORY_FILE} -l 172.31.38.16", 
                    installation: 'ansible', 
                    playbook: env.ANSIBLE_PLAYBOOK
            }
        }

        stage('Deploy pgAdmin') {
            steps {
                ansiblePlaybook credentialsId: 'dev-server', 
                    disableHostKeyChecking: true, 
                    extras: "--extra-vars 'ansible_ssh_private_key_file=${env.JENKINS_KEY} ansible_user=${env.ANSIBLE_USER}' -i ${env.INVENTORY_FILE} -l 172.31.44.98", 
                    installation: 'ansible', 
                    playbook: env.ANSIBLE_PLAYBOOK
            }
        }

        stage('Deploy Vitrine') {
            steps {
                ansiblePlaybook credentialsId: 'dev-server', 
                    disableHostKeyChecking: true, 
                    extras: "--extra-vars 'ansible_ssh_private_key_file=${env.JENKINS_KEY} ansible_user=${env.ANSIBLE_USER}' -i ${env.INVENTORY_FILE} -l 172.31.37.114", 
                    installation: 'ansible', 
                    playbook: env.ANSIBLE_PLAYBOOK
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished.'
        }
    }
}
