pipeline {

    agent any

    environment {
        APP_NAME    = 'jenkins-lab-app'
        DOCKER_REPO = 'kavan145/jenkins-lab-app'
        APP_PORT    = '8082'
    }



    stages {



        stage('Checkout') {

            steps {

                echo 'Using GitHub repository...'

            }

        }
 post {
        success {
            echo 'Pipeline completed successfully!'
        }

        failure {
            echo 'Pipeline failed! Check the console output.'
        }

        always {
            echo 'Pipeline execution finished.'


        stage('Environment Variables') {

            steps {

                sh '''

                    echo "Job Name      : $JOB_NAME"

                    echo "Build Number : $BUILD_NUMBER"

                    echo "Workspace    : $WORKSPACE"

                    echo "Build URL    : $BUILD_URL"

                '''

            }

        }



        stage('Build Docker Image') {

            steps {

                sh 'docker build -t jenkins-lab-app:${BUILD_NUMBER} .'

            }

        }



        stage('Verify Image') {

            steps {

                sh 'docker images jenkins-lab-app:${BUILD_NUMBER}'

            }

        }



        stage('Trivy Scan') {

            steps {

                sh '''

                    trivy image \

                    --scanners vuln \

                    --severity HIGH,CRITICAL \

                    --exit-code 1 \

                    jenkins-lab-app:${BUILD_NUMBER}

                '''

            }

        }



        stage('Push to Docker Hub') {

            steps {

                withCredentials([usernamePassword(

                    credentialsId: 'dockerhub-creds',

                    usernameVariable: 'DOCKER_USER',

                    passwordVariable: 'DOCKER_TOKEN'

                )]) {

                    sh '''

                        echo "$DOCKER_TOKEN" | docker login \

                        -u "$DOCKER_USER" \

                        --password-stdin



                        docker tag \

                        jenkins-lab-app:${BUILD_NUMBER} \

                        $DOCKER_USER/jenkins-lab-app:${BUILD_NUMBER}



                        docker push \

                        $DOCKER_USER/jenkins-lab-app:${BUILD_NUMBER}

                    '''

                }

            }

        }



        stage('Deploy Container') {

            steps {

                sh '''

                    docker rm -f jenkins-lab-app || true



                    docker run -d \

                    --name jenkins-lab-app \

                    -p 8082:80 \

                    jenkins-lab-app:${BUILD_NUMBER}

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
