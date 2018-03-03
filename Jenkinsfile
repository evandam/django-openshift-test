pipeline {
    agent 'python'

    stages {
        stage('Test') {
            python manage.py test
        }
        stage('Deploy') {
            echo "Deploying somewhere...
        }
    }
}
