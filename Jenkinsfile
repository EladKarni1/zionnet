pipeline {
    agent {
        docker {
            image 'elad12/minikube-docker:v1'
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
    
    environment {
        KUBE_CONFIG = credentials('kubeconfig')
    }
    
    stages {
        stage('Clone Repository') {
            steps {
                git url: 'https://github.com/EladKarni1/zionnet', branch: 'master'
            }
        }
        
        stage('Start Minikube') {
            steps {
                script {
                    sh 'minikube start --driver=docker'
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
