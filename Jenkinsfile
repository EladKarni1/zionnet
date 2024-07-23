pipeline {
    agent any
    
    environment {
        KUBE_CONFIG = credentials('kubeconfig')
    }
    
    stages {
        stage('Clone Repository') {
            steps {
                git url: 'https://github.com/EladKarni1/zionnet', branch: 'master'
            }
        }
        
        stage('Setup Docker and Minikube') {
            steps {
                script {
                    docker.image('elad12/minikube-docker:v1').inside {
                        sh '''
                            minikube start --driver=docker
                            kubectl apply -f namespaceapp.yaml
                            kubectl apply -f deploymentapp.yaml
                        '''
                    }
                }
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
    }
}

