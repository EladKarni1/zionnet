pipeline {
    agent any
    
    environment {
        KUBE_CONFIG = credentials('kubeconfig')
    }
    
    stages {
        stage('Install Docker') {
            steps {
                script {
                    sh '''
                        sudo apt-get update
                        sudo apt-get install -y docker.io
                    '''
                }
            }
        }
        
        stage('Install Minikube') {
            steps {
                script {
                    sh '''
                        curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
                        chmod +x minikube
                        mv minikube /usr/local/bin/
                    '''
                }
            }
        }
        
        stage('Start Minikube') {
            steps {
                script {
                    sh '''
                        minikube start --driver=docker
                    '''
                }
            }
        }
        
        stage('Clone Repository') {
            steps {
                git url: 'https://github.com/EladKarni1/zionnet', branch: 'master'
            }
        }
        
        stage('Get Minikube IP') {
            steps {
                script {
                    MINIKUBE_IP = sh(script: 'minikube ip', returnStdout: true).trim()
                    echo "Minikube IP is: ${MINIKUBE_IP}"
                }
            }
        }
        
        stage('Apply Kubernetes Configurations') {
            steps {
                script {
                    withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                        sh 'kubectl apply -f namespaceapp.yaml'
                        sh 'kubectl apply -f deploymentapp.yaml'
                    }
                }
            }
        }
    }
}
