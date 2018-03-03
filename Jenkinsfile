pipeline {
    agent 'any'

    stages {
        stage('Build') {
            echo "Building..."
            sh 'pip install -r requirements.txt'
        }
        stage('Test') {
            steps {
                echo "Testing..."
                sh 'manage.py test'
            }
        }
    }
}
