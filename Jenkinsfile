pipeline {
    agent any
    
    environment {
        KUBE_CONFIG = credentials('kubeconfig') // Make sure you have a Jenkins credential with id 'kubeconfig'
    }
    
    stages {
        stage('Clone Repository') {
            steps {
                // Clone the Git repository
                git url: 'https://github.com/your-username/your-repo.git', branch: 'main'
            }
        }
        
        stage('Get Minikube IP') {
            steps {
                script {
                    // Retrieve Minikube IP
                    MINIKUBE_IP = sh(script: 'minikube ip', returnStdout: true).trim()
                    echo "Minikube IP is: ${MINIKUBE_IP}"
                }
            }
        }
        
        stage('Apply Kubernetes Configurations') {
            steps {
                script {
                    // Use the kubectl command to apply the namespace and deployment YAML files
                    withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                        sh 'kubectl apply -f namespaceapp.yaml'
                        sh 'kubectl apply -f deploymentapp.yaml'
                    }
                }
            }
        }
    }
}
