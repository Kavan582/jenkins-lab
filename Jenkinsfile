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



        stage('Environment Variables') {

            steps {

                sh '''

                    echo "Job Name      : $JOB_NAME"

                    echo "Build Number : $BUILD_NUMBER"

                    echo "Workspace    : $WORKSPACE"

                    echo "Build URL    : $BUILD_URL"



                    echo "App Name     : $APP_NAME"

                    echo "Docker Repo  : $DOCKER_REPO"

                    echo "App Port     : $APP_PORT"

                '''

            }

        }



        stage('When Condition Test') {

            when {

                expression {

                    return env.JOB_NAME == 'my-first-pipeline-jenkins'

                }

            }



            steps {

                echo 'WHEN condition is TRUE. This stage is executing.'

            }

        }



        stage('Build Docker Image') {

            steps {

                sh 'docker build -t ${APP_NAME}:${BUILD_NUMBER} .'

            }

        }



        stage('Verify Image') {

            steps {

                sh 'docker images ${APP_NAME}:${BUILD_NUMBER}'

            }

        }



        stage('Parallel Checks') {

            parallel {



                stage('Docker Image Check') {

                    steps {

                        sh 'docker images ${APP_NAME}:${BUILD_NUMBER}'

                    }

                }



                stage('Environment Check') {

                    steps {

                        sh '''

                            echo "Application: $APP_NAME"

                            echo "Docker Repo: $DOCKER_REPO"

                            echo "Port: $APP_PORT"

                        '''

                    }

                }

            }

        }



        stage('Trivy Scan') {

            steps {

                sh 'trivy image --scanners vuln --severity HIGH,CRITICAL --exit-code 1 ${APP_NAME}:${BUILD_NUMBER}'

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

                        echo "$DOCKER_TOKEN" | docker login -u "$DOCKER_USER" --password-stdin



                        docker tag ${APP_NAME}:${BUILD_NUMBER} ${DOCKER_REPO}:${BUILD_NUMBER}



                        docker push ${DOCKER_REPO}:${BUILD_NUMBER}

                    '''

                }

            }

        }


        stage('Production Approval') {
        steps {
             input message: 'Deploy this build to production?',
              ok: 'Proceed'
    }
}
        stage('Deploy Container') {

            steps {

                sh '''

                    docker rm -f ${APP_NAME} || true



                    docker run -d \

                        --name ${APP_NAME} \

                        -p ${APP_PORT}:80 \

                        ${APP_NAME}:${BUILD_NUMBER}

                '''

            }

        }



        stage('Test Application') {

            steps {

                sh '''

                    sleep 3

                    curl -f http://localhost:${APP_PORT}

                '''

            }

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

        }

    }

}
