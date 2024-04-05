pipeline {
    agent any 
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerIDSecret')
    }
    stages {
        stage('SCM Checkout') {
            steps {
                checkout scmGit(
                    branches: [[name: '*/main']],
                    extensions:[],
                    userRemoteConfigs: [[url: 'https://github.com/randeeg/jenkins-pipeline']] ) 
                }
        }

        stage('Build Application') {
            steps {
                sh 'mvn -B clean package'
            }
        }

        stage('Test Build package') {
            steps {
                sh 'mvn test'
            }
        }
        // post(
        //     always {
        //         junit '**/target/build-report/*.xml'
        //     }
        // )

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t springboot-maven:$BUILD_NUMBER .'
            }
        }

        stage('login to Image Registry') {
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | \
                    docker login -u $DOCKERHUB_CREDENTIALS_USR credentials --password-stdin' 
            }
        }

        stage('Push Image to Registry') {
            steps {
                sh 'docker push springboot-maven:$BUILD_NUMBER'
            }
        }
    }
    post {
        always {
            sh 'docker logout'
        }
    }
}
