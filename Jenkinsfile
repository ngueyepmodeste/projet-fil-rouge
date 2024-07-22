pipeline {
    agent any

    environment {
        ANSIBLE_HOST_KEY_CHECKING = 'false'
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout your code repository containing the Ansible playbooks and roles
                git 'https://github.com/ngueyepmodeste/projet-fil-rouge.git'
            }
        }
        
        
        stage('Deploy Odoo') {
            steps {
                // Execute the Ansible playbook for Odoo
                ansiblePlaybook(
                    playbook: 'deploy_odoo.yml',
                    inventory: 'inventory.yml',
                    limit: '172.31.80.179'
                )
            }
        }

        stage('Deploy pgAdmin') {
            steps {
                // Execute the Ansible playbook for pgAdmin
                ansiblePlaybook(
                    playbook: 'deploy_odoo.yml',
                    inventory: 'inventory.yml',
                    extraVars: [
                        ansible_ssh_private_key_file: '/home/ubuntu/jenkins_key.pem',
                        ansible_user: 'ubuntu'
                    ],
                    limit: '172.31.84.97'
                )
            }
        }

        stage('Deploy Vitrine') {
            steps {
                // Execute the Ansible playbook for Vitrine
                ansiblePlaybook(
                    playbook: 'deploy_odoo.yml',
                    inventory: 'inventory.yml',
                    extraVars: [
                        ansible_ssh_private_key_file: '/home/ubuntu/jenkins_key.pem',
                        ansible_user: 'ubuntu'
                    ],
                    limit: '172.31.92.218'
                )
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
