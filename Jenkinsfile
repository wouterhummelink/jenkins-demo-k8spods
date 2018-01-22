def dockerlogin = ""

pipeline {
    agent {
        kubernetes {
            label "php"
            containerTemplate {
                name 'php'
                image 'php:7.2.1-apache'
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
              sh "apt-get update && apt-get install -y git zip unzip"
              sh "curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer"
              sh "cd demoapp && composer install"
            }
        }
        stage("Archive artifacts") {
            steps {
                archive includes: "demoapp/**"
                stash name: "artifacts", includes: "demoapp/**"
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
            label "docker"
          }
          steps {
            container('docker') {
              unstash name: 'artifacts'
              sh "docker build -t ${AWS_REPO}/demoapp:1.0 ."
              sh "${dockerlogin}"
              sh "docker push"
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
