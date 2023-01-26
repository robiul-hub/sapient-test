pipelinr{

    agent server-name

    tools {
        maven 'maven-3.0'
    }

    environment{
        registry = AWS-ECR-registry-Repo-URL/ECR-Repo-Name
    }

    stages{
        stage('Chekout SCM'){
            steps{
                checkoutcheckout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'hithub-repo-url']]])
            }
        }

        stage('Build maven'){
            steps{
                sh 'mvn clean package'
            }
        }

        statge('Build Docker Image'){
            steps{
                scripts{
                    dockerImage = docker.build registry + ":$BUILD_NUMBER"
                }
            }
        }

        stage('ECR Upload'){
            steps{
                environment{
                    AWS_ACCESS_KEY_ID=credentials('secret_key_id')
                    AWS_SECRET_ACCESS_KEY=credentials('secret_access_key')
                }
                scripts{
                    sh 'aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin acct_id.dkr.ecr.us-east-2.amazonaws.com'
                    sh 'docker push AWS-ECR-registry-Repo-URL/ECR-Repo-Name'
                }
            }
        }
    }
}