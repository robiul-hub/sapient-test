pipeline{

    agent server-name

    tools {
        maven 'maven-3.0'
        jdk "OracleJDK8"
    }

    environment{
        SNAP_REPO = 'sapient-snapshot'
		RELEASE_REPO = 'sapient-release'
		CENTRAL_REPO = 'sapient-maven-central'
		NEXUS_GRP_REPO = 'sapient-maven-group'
        NEXUS_LOGIN = 'nexuslogin'
        SONARSERVER = 'sonarserver'
        SONARSCANNER = 'sonarscanner'
        registryCredential = 'ecr:us-west-1:awscreds'
        appRegistry = 'user_name/image_name'
        registry = "AWS-ECR-registry-Repo-URL/ECR-Repo-Name"
    }

    stages{
        // Checkout GitHub Repository
        stage('Chekout SCM'){
            steps{
                checkoutcheckout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'hithub-repo-url']]])
            }
        }

        // Building the code using Maven
        stage('maven Build '){
            steps{
                sh 'mvn -B clean package -f sapient-test/pom.xml -DskipTests'
            }
        }
        
        //Unit test of the code
        stage('Test'){
            steps {
                // Test config file to run in this step. Below is an example
                sh 'mvn -B test -f sapient-test/pom.xml'
            }

        }
        
        // Code analysis with SAST tool SonarQube
        stage('Sonar Analysis') {
            environment {
                scannerHome = tool "${SONARSCANNER}"
            }
            steps {
               withSonarQubeEnv("${SONARSERVER}") {
                   sh "mvn sonar:sonar -f sapient-test/pom.xml"
              }
            }
        }

        // To set pipeline as STABLE/UNSTABLE based on Quality Gate status running previous SonarQube analysis
        stage("Quality Gate") {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    // true = set pipeline to UNSTABLE, false = don't
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        
        // Upload the build artifact to central repository. Below is an example of Nexus
        stage("UploadArtifact"){
            steps{
                nexusArtifactUploader(
                  nexusVersion: 'nexus3',
                  protocol: 'http',
                  nexusUrl: "nexuus.com",
                  groupId: 'Dev',
                  version: "${env.BUILD_ID}-${env.BUILD_TIMESTAMP}",
                  repository: "${RELEASE_REPO}",
                  credentialsId: "${NEXUS_LOGIN}",
                  artifacts: [
                    [artifactId: 'sapient-test',
                     file: 'target/PharmaStore.war',
                     type: 'war']
                  ]
                )
            }
        }
        
        // Building docker image using Dockerfile
        statge('Build App Image'){
            steps{
                scripts{
                    dockerImage = docker.build( appRegistry + ":$BUILD_NUMBER")
                }
            }
        }

        // Upload Docker image do Registry. Below example is for AWS ECR
        stage('Upload App Image') {
          steps{
            script {
              docker.withRegistry( registry, registryCredential ) {
                dockerImage.push("$BUILD_NUMBER")
                dockerImage.push('latest')
              }
            }
          }
        }
        
    }
}