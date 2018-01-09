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
              sh "go version"
              git url: "https://github.com/kubernetes-incubator/cri-tools.git"
              sh "make"
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
