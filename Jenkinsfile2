pipeline {
    agent any
    tools {
        maven 'Maven'
    }

    stages {
        stage('Hello') {
            steps {
                git 'https://github.com/amikheev-1303/jenkins_trigger.git'
                sh 'mvn install'
            }
        }
        stage('Test') {
            steps {
                archiveArtifacts 'target/*.jar'
                junit 'target/surefire-reports/*.xml'
            }
        }
        stage('Publish') {
            steps {
                cloudBeesFlowCallRestApi body: '', configuration: 'flow-forrester', envVarNameForResult: '', httpMethod: 'DELETE', urlPath: '/artifacts/com.demo:helloworld'
                cloudBeesFlowPublishArtifact artifactName: 'com.demo:helloworld', artifactVersion: '1.0-SNAPSHOT', configuration: 'flow-forrester', filePath: 'target/helloworld-1.0-SNAPSHOT.jar', repositoryName: 'default'
            }
        }
        stage('Results') {
            steps {
                cloudBeesFlowRunPipeline addParam: '{"pipeline":{"pipelineName":"Deploy Pipeline","parameters":[]}}', configuration: 'flow-forrester', pipelineName: 'Test Pipeline', projectName: 'Test'
            }
        }
    }
}
