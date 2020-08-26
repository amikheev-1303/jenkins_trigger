node {
   def mvnHome
   def artVersion = UUID.randomUUID().toString()
   //def artName = UUID.randomUUID().toString()
   properties([
            parameters([
                    string(name: 'project', defaultValue: 'Default'),
                    string(name: 'releaseName', defaultValue: 'qe release'),
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
       archiveArtifacts 'test1.txt'
   }
    stage('Publish'){
        cloudBeesFlowPublishArtifact artifactName: "com.demo:test1", artifactVersion: "${artVersion} - 1 -SNAPSHOT", configuration: 'flow-server', filePath: 'test1.txt', repositoryName: 'default'
   }
   stage('Test') {
       junit 'target/surefire-reports/*.xml'
   }   
   stage('Pipeline') {
       cloudBeesFlowAssociateBuildToRelease configuration: 'flow-server', flowRuntimeId: '', projectName: "${project}", releaseName: "${releaseName}"
   }
}
