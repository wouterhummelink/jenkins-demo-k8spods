def dockerlogin = ""

pipeline {
    agent {
        kubernetes {
            label "golang"
            containerTemplate {
                name 'golang'
                image 'golang:1.9.2'
                ttyEnabled true
                command 'cat'
            }
        }
      }
    }
    options {
      buildDiscarder(logRotator(numToKeepStr: '5', artifactNumToKeepStr: '2'))
    }
    stages {
        stage("Build") {
            steps {
              sh "go version"
              git url: "https://github.com/kubernetes-incubator/cri-tools.git"
              sh "make"
            }
        }
        stage("Archive artifacts") {
            steps {
                sh "mkdir ${WORKSPACE}/_output && cp -r /go/bin ${WORKSPACE}/_output"
                archive includes: "_output/bin/*"
                stash name: "artifacts", includes: "_output/bin/*"
            }
        }
        stage("Aquire aws docker login") {
          steps {
            script {
              dockerlogin = sh "aws ecr login"
            }
          }
        }
        stage("Create Docker image")
          agent {
            kubernetes {
              containerTemplate {
                label "docker"
                containerTemplate {
                  name "docker"
                  image "docker:stable"
                }
              }
            }
          }
          steps {
            unstash name: 'artifacts'
            sh "docker build -t ${AWS_REPO}/demoapp:1.0 ."
            sh "${dockerlogin}"
            sh "docker push"
          }
          stage("Deploy app to kubernetes") {
            steps {
              // sh "kubectl apply -f demoapp-deployment.yaml"
            }
          }
        }
        stage("Deploy app to kubernetes") {
          steps {
            // sh "kubectl apply -f demoapp-deployment.yaml"
          }
        }
    }
}
