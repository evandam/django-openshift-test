pipeline {
    agent { label 'jenkins-slave-miniconda' }

    environment {
        VENV_BIN="$WORKSPACE/venv/bin"
    }

    stages {
        stage('Build') {
            steps {
                sh 'conda create -p "$WORKSPACE/venv" -y python=$PYTHON_VERSION pylint coverage'
                sh '"$VENV_BIN/pip" install -r requirements.txt'
            }
        }
        stage('Lint') {
            steps {
                sh 'mkdir "$WORKSPACE/reports"'
                sh '''#!/bin/bash -e
                    pyfiles=$(find "$WORKSPACE" -name "*.py" -not -path "$WORKSPACE/venv/*")
                    if "$VENV_BIN/pylint" -f parseable $pyfiles > "$WORKSPACE/reports/pylint.report"
                    then
                        echo "No errors in pylint!"
                    else
                        # Pylint exit codes are bit-encoded. We need to do some fun bitwise ANDs.
                        exitcode=$?
                        if [ $(( $exitcode & 3 )) -ne 0 ]
                        then
                            echo "Error detected by pylint!"
                            exit $exitcode
                        elif [ $exitcode -eq 32 ]
                        then
                            echo "Pylint usage error!"
                            exit $exitcode
                        else
                            echo "Warnings detected in pylint, but not failing the build."
                        fi
                    fi
                '''
            }
        }
        stage('Test') {
            steps {
                sh '"$VENV_BIN/coverage" run --omit "$WORKSPACE/venv/*" $TEST_COMMAND || true'
                sh '"$VENV_BIN/coverage" xml -o "$WORKSPACE/reports/coverage.xml"'
            }
        }
        stage('Publish') {
            steps {
                step([
                    $class: 'WarningsPublisher',
                    parserConfigurations: [
                        [parserName: 'PyLint', pattern: 'reports/pylint.report']
                    ],
                ])
                step([
                    $class: 'CoberturaPublisher',
                    coberturaReportFile: 'reports/coverage.xml'
                ])
            }
        }
    }
}