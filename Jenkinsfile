pipeline {
    agent {
        kubernetes {
            label "mypod"
            containerTemplate {
            name 'golang'
            image 'golang:1.9.2'
            ttyEnabled true
            command 'cat'
      }
        }
    }
    stages {
        stage("Build") {
            steps {
                withEnv(["GOROOT=/var/lib/jenkins/tools/org.jenkinsci.plugins.golang.GolangInstallation/Go_1.9.2",
                         "PATH+GO=/var/lib/jenkins/tools/org.jenkinsci.plugins.golang.GolangInstallation/Go_1.9.2/bin"]) {
                    sh "go version"
                    git url: "https://github.com/kubernetes-incubator/cri-tools.git"
                    sh "make"
                }
            }
        }
        stage("Archive artifacts") {
            steps {
                sh "ls"
                archive includes: "_output/bin/*"
            }
        }
    }
}
