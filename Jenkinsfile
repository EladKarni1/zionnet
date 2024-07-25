pipeline {
    agent {
        kubernetes {
            yaml """
            apiVersion: v1
            kind: Pod
            spec:
              serviceAccountName: jenkins
              containers:
              - name: dotnet
                image: mcr.microsoft.com/dotnet/sdk:7.0
                command:
                - cat
                tty: true
              - name: kubectl
                image: lachlanevenson/k8s-kubectl:v1.20.0
                command:
                - cat
                tty: true
                volumeMounts:
                - mountPath: /home/jenkins/agent
                  name: workspace-volume
              volumes:
              - name: workspace-volume
                emptyDir: {}
            """
        }
    }
    stages {
        stage('Checkout') {
            steps {
                container('dotnet') {
                    git branch: 'master', url: 'https://github.com/EladKarni1/zionnet'
                }
            }
        }
        stage('Build') {
            steps {
                container('dotnet') {
                    sh 'dotnet build'
                }
            }
        }
        stage('Apply Kubernetes Configurations') {
            steps {
                container('kubectl') {
                    script {
                        sh 'echo "Kubectl version:" && kubectl version --client'
                        sh 'kubectl apply -f namespaceapp.yaml'
                        sh 'kubectl apply -f deploymentapp.yaml'
                    }
                }
            }
        }
    }
    post {
        always {
            echo 'This will always run'
        }
        success {
            echo 'This will run only if the pipeline succeeds'
        }
        failure {
            echo 'This will run only if the pipeline fails'
        }
        cleanup {
            echo 'This will run after the pipeline completes, regardless of the result'
        }
    }
}
