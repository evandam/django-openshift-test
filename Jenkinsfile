pipeline {
    agent { 
        label 'jenkins-slave-miniconda'
    }

    stages {
        stage('Build') {
            steps {
                sh 'conda create -p venv -q -y python=$PYTHON_VERSION pylint coverage'
                sh 'venv/bin/pip install -q -r requirements.txt'
                sh 'mkdir reports'
            }
        }
        stage('Pylint') {
            steps {
                sh '''#!/bin/bash
                    pyfiles=$(find . -name "*.py" -not -path "./venv/*")
                    if venv/bin/pylint -f parseable $pyfiles > "reports/pylint.report"
                    then
                        echo "No errors in pylint!"
                    else
                        # Pylint exit codes are bit-encoded. Bits 1 and 2 indicate errors.
                        status=$?
                        if [ $(( $status & 3 )) -ne 0 ]
                        then
                            echo "Error detected by pylint!"
                            exit $status
                        elif [ $status -eq 32 ]
                        then
                            echo "Pylint usage error!"
                            exit $status
                        else
                            echo "Warnings detected in pylint, but not failing the build."
                        fi
                    fi
                '''
            }
        }
        stage('Test') {
            steps {
                sh 'venv/bin/coverage run --omit "venv/*" $TEST_COMMAND'
            }
        }
        stage('Publish') {
            steps {
                zip zipFile: 'app.zip', archive: true
            }
        }
    }
    post {
        always {
            step([
                $class: 'WarningsPublisher',
                parserConfigurations: [
                    [parserName: 'PyLint', pattern: 'reports/pylint.report']
                ],
            ])
            
            sh 'venv/bin/coverage xml -o "reports/coverage.xml"'
            step([
                $class: 'CoberturaPublisher',
                coberturaReportFile: 'reports/coverage.xml'
            ])

            deleteDir()
        }
    }
}
