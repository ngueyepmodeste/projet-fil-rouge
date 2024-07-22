pipeline {
    agent any

    environment {
        ANSIBLE_HOST_KEY_CHECKING = 'false'
    }

    stages {
        stage('Cleanup Workspace') {
            steps {
                // Clean the workspace before checkout
                cleanWs()
            }
        }
        
        stage('Checkout') {
            steps {
                // Checkout your code repository containing the Ansible playbooks and roles
                git branch: 'main', url: 'https://github.com/ngueyepmodeste/projet-fil-rouge.git'
            }
        }

        stage('Deploy Odoo') {
            steps {
                // Execute the Ansible playbook for Odoo
                sh 'ansible-playbook /home/ubuntu/projet-fil-rouge/ansible/deploy_odoo.yml -i /home/ubuntu/projet-fil-rouge/ansible/inventory.yml -l 172.31.80.179'
            }
        }

        stage('Deploy pgAdmin') {
            steps {
                // Execute the Ansible playbook for pgAdmin
                sh 'ansible-playbook /home/ubuntu/projet-fil-rouge/ansible/deploy_odoo.yml -i /home/ubuntu/projet-fil-rouge/ansible/inventory.yml --extra-vars "ansible_ssh_private_key_file=/home/ubuntu/jenkins_key.pem ansible_user=ubuntu" -l 172.31.84.97'
            }
        }

        stage('Deploy Vitrine') {
            steps {
                // Execute the Ansible playbook for Vitrine
                sh 'ansible-playbook /home/ubuntu/projet-fil-rouge/ansible/deploy_odoo.yml -i /home/ubuntu/projet-fil-rouge/ansible/inventory.yml --extra-vars "ansible_ssh_private_key_file=/home/ubuntu/jenkins_key.pem ansible_user=ubuntu" -l 172.31.92.218'
            }
        }
    }

    post {
        always {
            // Cleanup and post actions
            echo 'Pipeline finished.'
        }
    }
}
