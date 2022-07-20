pipeline {
    agent {
        docker {
            image 'maven:3.8.1-adoptopenjdk-11'
            args '-v $HOME/.m2:/root/.m2'
        }
    }
    stages {
        stage('Git') {
            steps {
                git 'https://github.com/amikheev-1303/jenkins_trigger' 
            }
        }
        stage('Build') {
            steps {
                sh 'mvn install'
            }
        }
        stage ('Test') {
            steps {
                archiveArtifacts 'target/*.jar'
            }
        }
    }
}
