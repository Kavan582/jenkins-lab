pipeline {

    agent any



    stages {

        stage('Checkout') {

            steps {

                echo 'Using GitHub repository...'

            }

        }



        stage('Build Docker Image') {

            steps {

                sh 'docker build -t jenkins-lab-app:1.0 .'

            }

        }



        stage('Verify Image') {

            steps {

                sh 'docker images | grep jenkins-lab-app'

            }

        }



        stage('Trivy Scan') {

            steps {

                sh 'trivy image --scanners vuln --severity HIGH,CRITICAL --exit-code 1 jenkins-lab-app:1.0'

            }

        }



        stage('Deploy Container') {

            steps {

                sh '''

                docker rm -f jenkins-lab-app || true

                docker run -d --name jenkins-lab-app -p 8082:80 jenkins-lab-app:1.0

                '''

            }

        }



        stage('Test Application') {

            steps {

                sh 'sleep 3'

                sh 'curl -f http://localhost:8082'

            }

        }

    }

}
