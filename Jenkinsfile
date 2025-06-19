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
                git branch: 'master', url: 'https://github.com/soni1764/robot-jenkins'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat "docker build -t %IMAGE_NAME% ."
            }
        }

        stage('Create Results Directory') {
            steps {
                bat "mkdir %RESULTS_DIR%"
            }
        }

        stage('Run Robot Tests in Docker') {
            steps {
                script {
                    def dockerResultsPath = ABS_RESULTS_DIR.replace('\\', '/').replace('C:', '/c')

                    bat """
                    docker run --rm --name %CONTAINER_NAME% ^
                        -v "${dockerResultsPath}:/testing/results" ^
                        %IMAGE_NAME% robot --outputdir results --xunit results/xunit.xml tests/
                    """
                }
            }
        }

        stage('Publish Test Results') {
            steps {
                junit 'results/xunit.xml'
                publishHTML([
                    reportName: 'Robot Report',
                    reportDir: 'results',
                    reportFiles: 'report.html',
                    keepAll: true,
                    alwaysLinkToLastBuild: true
                ])
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
