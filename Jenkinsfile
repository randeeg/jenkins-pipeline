pipeline {
    agent any 
    environment {
       DOCKERHUB_CREDS = credentials('jenkins-dockerid')
       // DOCKERHUB_CREDS_USR = 'rgdockerid'
    }
    parameters {
        choice(name: 'DEPLOY_ENV', choices: ['Test', 'Prod'], description: 'Select deployment environment')
            
    }
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
                sh "trivy fs -f table -o trivy-fs-report.html ."
            }
        }
        //post {
        //    always {
        //         junit '/target/build-report/*.xml'
        //     }
        //}

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

        stage(deploy to test environment) {
            when {
                expression { params.DEPLOY_ENV == 'Test' }
            }
            steps {
                sh ('echo $DOCKERHUB_CREDS_PSW | docker login -u $DOCKERHUB_CREDS_USR --password-stdin')
                sh ('docker pull rgdockerid/springboot-maven:Latest')
                sh ('docker tag')
            }
        }
        stage(deploy to Production) {
            when {
                expression { params.DEPLOY_ENV == 'Prod'} 
            }

            steps {
                sh './deploy Prod'    
            }
        }
    }
        
    post {
        always {
            sh 'docker logout'
        }
    }
}