pipeline {
    agent {
        docker { image 'python' }
    }

    stages {
        stage('Test') {
            sh manage.py test
        }
        stage('Deploy') {
            echo "Deploying somewhere..."
        }
    }
}
