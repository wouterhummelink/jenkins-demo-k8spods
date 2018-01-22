def dockerlogin = ""
def repourl = ""

pipeline {
    agent { label "master" }
    options {
      buildDiscarder(logRotator(numToKeepStr: '5', artifactNumToKeepStr: '2'))
    }
    stages {
        stage("Build") {
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
            steps {
                sh "apt-get update && apt-get install -y git zip unzip"
                sh "curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer"
                sh "cd demoapp && composer install"
                stash name: "artifacts", includes: "demoapp/**"
            }
        }
        stage("Aquire aws docker login") {
            steps {
                script {
                    sh "aws configure set default.region eu-central-1"
                    dockerlogin = sh script: "aws ecr get-login", returnStdout: true
                    if(!fileExists('ecr_repo_url')) {
                        sh "aws s3 cp s3://ord-demo-keystore/ecr_repo_url ecr_repo_url"
                    }
                    repourl = readFile('ecr_repo_url')
                }
            }  
        }
        stage("Create Docker image") {
            agent {
                label "docker"
            }
            environment {
                AWS_REPO = "${repourl}"
            }
            steps {
                container('docker') {
                    unstash name: 'artifacts'
                    sh "docker build -t ${env.AWS_REPO}/demoapp:1.0 ."
                    sh "${dockerlogin}"
                    sh "docker push ${env.AWS_REPO}/demoapp:1.0"
                    sh "tar czf demoapp-1.0.tar.gz demoapp/"
                    archive includes: "demoapp-1.0.tar.gz"
                }
            }
        }
        stage("Deploy app to kubernetes") {
            agent {
                label "master"
            }
            environment {
                DOCKER_LOGIN = credentials("docker-login")
                PATH = "${env.PATH}:/usr/local/bin"
                AWS_REPO = "${repourl}"
            }
            steps {
                echo "Deploy not implemented yet"
                script {
                    if(fileExists("demoapp-deployment-1.yaml")) {
                        sh "rm demoapp-deployment-1.yaml"
                    }
                    def deployment = readYaml file: "demoapp-deployment.yaml"
                    deployment.spec.template.spec.containers[0].image = "docker.io/${env.DOCKER_LOGIN_USR}/demoapp:1.0"
                    writeYaml file: 'demoapp-deployment-1.yaml', data: deployment
                    sh "kubectl apply -f demoapp-deployment-1.yaml"
                    sh "kubectl apply -f demoapp-svc.yaml"
                }
            }
        }
    }
}
