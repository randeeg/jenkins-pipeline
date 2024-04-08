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
                sh 'mvn clean install'
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
                sh 'docker build -t rgdockerid/springboot-maven:$BUILD_NUMBER .'
            }
        }

        stage('login and push to container registry') {
            steps {
                withCredentials ([usernamePassword(credentialsID: 'jenkins-dockerid', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
                  sh 'docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}'
                  sh 'docker push rgdockerid/spring:maven:$BUILD_NUMBER'  
                }
            }
        }

     }  
    
    post {
        always {
            sh 'docker logout'
        }
    }
}