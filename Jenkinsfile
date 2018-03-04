pipeline {
    agent {
        kubernetes { label 'python' }
    }

    stages {
        stage('Build') {
            steps {
                echo "Building..."
                sh 'pip install -r requirements.txt'
            }
        }
        stage('Test') {
            steps {
                echo "Testing..."
                sh 'manage.py test'
            }
        }
    }
}
