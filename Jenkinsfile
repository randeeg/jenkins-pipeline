pipeline {
    agent any 
    environment {
       DOCKERHUB_CREDS = credentials('jenkins-dockerid')
       // DOCKERHUB_CREDS_USR = 'rgdockerid'
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

        stage('Vulnerability Scan') {
            steps {
                sh "trivy fs --scanners vuln,config,secret --severity HIGH,CRITICAL --format table -o trivy-fs-report.html ."
            }
        }
        post {
            always {
                 junit '/target/build-report/*.xml'
             }
        }

        stage('Build Docker Image') {
            steps {
                sh ('docker build -t rgdockerid/springboot-maven:$BUILD_NUMBER .')
            }
        }

        stage('Login to Container Registry') {
            steps {
                sh ('echo $DOCKERHUB_CREDS_PSW | docker login -u $DOCKERHUB_CREDS_USR --password-stdin')    
            }
        }

        stage('Push Image to Registry') {
            steps {
                sh 'docker push rgdockerid/springboot-maven:$BUILD_NUMBER'
            }
        }


    }
        
    post {
        always {
            sh 'docker logout'
        }
    }
}