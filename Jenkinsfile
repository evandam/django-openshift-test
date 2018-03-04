pipeline {
    agent {
        docker { image 'python' }
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
