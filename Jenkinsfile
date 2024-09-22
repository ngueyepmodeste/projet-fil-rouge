pipeline {
    agent any  // Utilisation du noeud Jenkins par défaut

    environment {
        ANSIBLE_HOST_KEY_CHECKING = 'false'
        GITHUB_REPO = 'https://github.com/ngueyepmodeste/projet-fil-rouge.git'
        ANSIBLE_PLAYBOOK = 'ansible/deploy_app.yml'
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

        stage('Install Ansible') {
            steps {
                // Vérifie si Ansible est installé, sinon l'installer
                script {
                    def ansibleInstalled = sh(script: 'command -v ansible-playbook', returnStatus: true) == 0
                    if (!ansibleInstalled) {
                        sh '''
                        echo "Ansible n'est pas installé. Installation..."
                        sudo yum install -y epel-release
                        sudo yum install -y ansible
                        '''
                    }
                }
            }
        }

        stage('Deploy Odoo') {
            steps {
                sh "ansible-playbook ${env.ANSIBLE_PLAYBOOK} -i ${env.INVENTORY_FILE} -l 172.31.38.16"
            }
        }

        stage('Deploy pgAdmin') {
            steps {
                sh "ansible-playbook ${env.ANSIBLE_PLAYBOOK} -i ${env.INVENTORY_FILE} --extra-vars 'ansible_ssh_private_key_file=${env.JENKINS_KEY} ansible_user=${env.ANSIBLE_USER}' -l 172.31.44.98"
            }
        }

        stage('Deploy Vitrine') {
            steps {
                sh "ansible-playbook ${env.ANSIBLE_PLAYBOOK} -i ${env.INVENTORY_FILE} --extra-vars 'ansible_ssh_private_key_file=${env.JENKINS_KEY} ansible_user=${env.ANSIBLE_USER}' -l 172.31.37.114"
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished.'
        }
    }
}
