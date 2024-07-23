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

