pipeline {
    agent any

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
                sh "/usr/bin/ansible-playbook ${env.ANSIBLE_PLAYBOOK} -i ${env.INVENTORY_FILE} -l 172.31.38.16"
            }
        }

        stage('Deploy pgAdmin') {
            steps {
                sh "/usr/bin/ansible-playbook ${env.ANSIBLE_PLAYBOOK} -i ${env.INVENTORY_FILE} --extra-vars 'ansible_ssh_private_key_file=${env.JENKINS_KEY} ansible_user=${env.ANSIBLE_USER}' -l 172.31.44.98"
            }
        }

        stage('Deploy Vitrine') {
            steps {
                sh "/usr/bin/ansible-playbook ${env.ANSIBLE_PLAYBOOK} -i ${env.INVENTORY_FILE} --extra-vars 'ansible_ssh_private_key_file=${env.JENKINS_KEY} ansible_user=${env.ANSIBLE_USER}' -l 172.31.37.114"
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished.'
        }
    }
}
