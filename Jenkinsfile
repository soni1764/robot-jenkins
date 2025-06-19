pipeline {
    agent any

    environment {
        IMAGE_NAME = 'robot-runner'
        CONTAINER_NAME = 'my-robot-container'
        RESULTS_DIR = "results"
        ABS_RESULTS_DIR = "${env.WORKSPACE}\\results"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'test_jenkin_with_docker', url: 'https://github.com/soni1764/robot-jenkins'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat "docker build -t %IMAGE_NAME% ."
            }
        }

        stage('Clean & Create Results Directory') {
            steps {
                bat '''
                    if exist %RESULTS_DIR% rmdir /s /q %RESULTS_DIR%
                    mkdir %RESULTS_DIR%
                '''
            }
        }

        stage('Run Robot Tests in Docker') {
            steps {
                script {
                    def dockerResultsPath = ABS_RESULTS_DIR.replace('\\', '/').replace('C:', '/c')

                    bat """
                        docker rm -f %CONTAINER_NAME% || echo Container not found
                        docker run --rm --name %CONTAINER_NAME% ^
                            -v "${dockerResultsPath}:/testing/results" ^
                            %IMAGE_NAME% robot --outputdir results tests/
                    """
                }
            }
        }


        stage('Publish Robot Framework Report') {
            steps {
                robot outputPath: 'results'
            }
        }
    }

    post {
        always {
            echo 'Cleaning up any leftovers...'
            bat 'docker rm -f %CONTAINER_NAME% || exit 0'
        }
        success {
            echo '✅ Robot Framework test execution completed!'
        }
        failure {
            echo '❌ Test run failed. Check logs and reports.'
        }
    }
}
