node {
   def mvnHome
   def artVersion = UUID.randomUUID().toString()
   //def artName = UUID.randomUUID().toString()
   properties([
            parameters([
                    string(name: 'project', defaultValue: 'Default'),
                    string(name: 'releaseName', defaultValue: 'qe release'),
                    string(name: 'flowRunId', defaultValue: 'e9bb5a24-e926-11ea-a1b3-42010a000038'),
                    string(name: 'artVersion', defaultValue: "$artVersion"),

            ])
    ])
   stage('Build') {
      cleanWs()
      git 'https://github.com/amikheev-1303/jenkins_trigger.git'
      mvnHome = tool 'mvn'
      withEnv(["MVN_HOME=$mvnHome"]) {
          sh '"$MVN_HOME/bin/mvn" install'
      }
   }
   stage('Archive') {
       archiveArtifacts 'test2.txt'
   }
    stage('Publish'){
        cloudBeesFlowPublishArtifact artifactName: "com.demo:test2", artifactVersion: "${artVersion} - 2 -SNAPSHOT", configuration: 'flow-server', filePath: 'test2.txt', repositoryName: 'default'
   }
   stage('Test') {
       junit 'target/surefire-reports/*.xml'
   }   
   stage('Pipeline') {
       cloudBeesFlowAssociateBuildToRelease configuration: 'flow-server', flowRuntimeId: "${flowRunId}", projectName: "${project}", releaseName: "${releaseName}"
       //cloudBeesFlowAssociateBuildToRelease configuration: 'flow-server', flowRuntimeId: 'f8e2a167-a747-11ea-821f-42010a000012', projectName: 'Default', releaseName: 'qe release'
   }
}