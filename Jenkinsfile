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
                sh 'ls -R ansible/roles/odoo_role/vars/'
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
                script {
                    def fileExists = fileExists 'ansible/roles/odoo_role/vars/main.yml'
                    if (!fileExists) {
                        error "Le fichier ansible/roles/odoo_role/vars/main.yml n'existe pas."
                    } else {
                        echo "Le fichier ansible/roles/odoo_role/vars/main.yml existe."
                    }
                }
                sh "ansible-playbook ${env.ANSIBLE_PLAYBOOK} -i ${env.INVENTORY_FILE} -l 172.31.46.53 -e @ansible/roles/odoo_role/vars/main.yml"
            }
        }

        stage('Deploy pgAdmin') {
            steps {
                script {
                    def fileExists = fileExists 'ansible/roles/pgadmin_role/vars/main.yml'
                    if (!fileExists) {
                        error "Le fichier ansible/roles/pgadmin_role/vars/main.yml n'existe pas."
                    } else {
                        echo "Le fichier ansible/roles/pgadmin_role/vars/main.yml existe."
                    }
                }
                sh "ansible-playbook ${env.ANSIBLE_PLAYBOOK} -i ${env.INVENTORY_FILE} --extra-vars 'ansible_ssh_private_key_file=${env.JENKINS_KEY} ansible_user=${env.ANSIBLE_USER}' -l 172.31.36.253 -e @ansible/roles/pgadmin_role/vars/main.yml"
            }
        }

        stage('Deploy Vitrine') {
            steps {
                script {
                    def fileExists = fileExists 'ansible/roles/vitrine_roles/vars/main.yml'
                    if (!fileExists) {
                        error "Le fichier ansible/roles/vitrine_roles/vars/main.yml n'existe pas."
                    } else {
                        echo "Le fichier ansible/roles/vitrine_roles/vars/main.yml existe."
                    }
                }
                sh "ansible-playbook ${env.ANSIBLE_PLAYBOOK} -i ${env.INVENTORY_FILE} --extra-vars 'ansible_ssh_private_key_file=${env.JENKINS_KEY} ansible_user=${env.ANSIBLE_USER}' -l 172.31.42.221 -e @ansible/roles/vitrine_roles/vars/main.yml"
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished.'
        }
    }
}
