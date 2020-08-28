node {

   def mvnHome
   def artVersion = UUID.randomUUID().toString()
   //def artName = UUID.randomUUID().toString()

   properties([
            parameters([
                    string(name: 'project', defaultValue: 'Default'),
                    string(name: 'releaseName', defaultValue: 'qe release'),
                    string(name: 'releasePipeName', defaultValue: 'pipeline_qe release'),
                    string(name: 'stageName', defaultValue: 'qe stage'),
                    string(name: 'artVersion', defaultValue: UUID.randomUUID().toString()),

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
        cloudBeesFlowTriggerRelease configuration: 'flow-server', parameters: '{"release":{"releaseName":"${releaseName}","stages":[{"stageName":"${stageName}","stageValue":""}],"pipelineName":"${releasePipeName","parameters":[]}}', projectName: "${project}", releaseName: "${releaseName}", startingStage: "${stageName}"

   }
}
