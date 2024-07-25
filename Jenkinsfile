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
              - name: docker
                image: docker:20.10.7
                command:
                - cat
                tty: true
                volumeMounts:
                - mountPath: /var/run/docker.sock
                  name: docker-socket
                - mountPath: /home/jenkins/agent
                  name: workspace-volume
              volumes:
              - name: docker-socket
                hostPath:
                  path: /var/run/docker.sock
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
        stage('Build Docker Image') {
            steps {
                container('docker') {
                    sh 'docker build -t elad12/helloworld:latest .'
                }
            }
        }
        stage('Push Docker Image to Docker Hub') {
            steps {
                container('docker') {
                    withCredentials([string(credentialsId: 'dockerhub-credentials-id', variable: 'DOCKER_HUB_PASSWORD')]) {
                        sh 'echo $DOCKER_HUB_PASSWORD | docker login -u elad12 --password-stdin'
                        sh 'docker push elad12/helloworld:latest'
                    }
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

