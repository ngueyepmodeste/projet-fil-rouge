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

        stage('Install Ansible') { // Nouveau stage pour installer Ansible
            steps {
                sh '''
                    # Installer Ansible si nécessaire
                    if ! command -v ansible-playbook &> /dev/null; then
                        echo "Ansible n'est pas installé. Installation..."
                        sudo apt-get update
                        sudo apt-get install -y ansible
                    else
                        echo "Ansible est déjà installé."
                    fi
                '''
            }
        }

        stage('Checkout') {
            steps {
                git branch: 'main', url: env.GITHUB_REPO
            }
        }

        stage('Deploy Odoo') {
            steps {
                sh "ansible-playbook ${env.ANSIBLE_PLAYBOOK} -i ${env.INVENTORY_FILE} -l 172.31.46.53"
            }
        }

        stage('Deploy pgAdmin') {
            steps {
                sh "ansible-playbook ${env.ANSIBLE_PLAYBOOK} -i ${env.INVENTORY_FILE} --extra-vars 'ansible_ssh_private_key_file=${env.JENKINS_KEY} ansible_user=${env.ANSIBLE_USER}' -l 172.31.36.253"
            }
        }

        stage('Deploy Vitrine') {
            steps {
                sh "ansible-playbook ${env.ANSIBLE_PLAYBOOK} -i ${env.INVENTORY_FILE} --extra-vars 'ansible_ssh_private_key_file=${env.JENKINS_KEY} ansible_user=${env.ANSIBLE_USER}' -l 172.31.42.221"
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished.'
        }
    }
}
