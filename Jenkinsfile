pipeline {
    agent {
        docker { image 'python' }
    }

    stages {
        stage('Test') {
            steps {
                sh 'manage.py test'
            }
        }
    }
}
