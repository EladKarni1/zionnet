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
        stage('Git Clone') {
            steps {
                container('dotnet') {
                    git branch: 'master', url: 'https://github.com/EladKarni1/zionnet'
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                container('docker') {
                    sh 'docker build --no-cache -t elad12/helloworld:latest .'
                }
            }
        }
        stage('Push Docker Image to Docker Hub') {
            steps {
                container('docker') {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials-id', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
                        sh 'echo $DOCKERHUB_PASSWORD | docker login -u $DOCKERHUB_USERNAME --password-stdin'
                        sh 'docker push elad12/helloworld:latest'
                    }
                }
            }
        }
        stage('Deploy Web App') {
            steps {
                container('kubectl') {
                    script {
                        sh 'echo "Kubectl version:" && kubectl version --client'
                        sh 'kubectl apply -f namespaceapp.yaml'
                        sh 'kubectl apply -f deploymentapp.yaml'
                        sh 'kubectl rollout restart deployment/helloworld-app-deployment -n app'
                    }
                }
            }
        }
    }

}

