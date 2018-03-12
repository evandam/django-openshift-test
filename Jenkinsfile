pipeline {
    agent { 
        label 'jenkins-slave-miniconda'
    }

    environment {
        VENV="$WORKSPACE/VENV"
        REPORTS="$WORKSPACE/reports"
    }

    stages {
        stage('Build') {
            steps {
                sh 'conda create -p "$VENV" -q -y python=$PYTHON_VERSION pylint coverage'
                sh '"$VENV/bin/pip" install -q -r requirements.txt'
                sh 'mkdir "$REPORTS"'
            }
        }
        stage('Lint') {
            steps {
                sh '''#!/bin/bash
                    pyfiles=$(find "$WORKSPACE" -name "*.py" -not -path "$VENV/*")
                    if "$VENV/bin/pylint" -f parseable $pyfiles > "$REPORTS/pylint.report"
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
                sh '"$VENV/bin/coverage" run --omit "$VENV/*" $TEST_COMMAND || true'
                sh '"$VENV/bin/coverage" xml -o "$REPORTS/coverage.xml"'
            }
        }
        stage('Publish') {
            steps {
                step([
                    $class: 'WarningsPublisher',
                    parserConfigurations: [
                        [parserName: 'PyLint', pattern: '$REPORTS/pylint.report']
                    ],
                ])
                step([
                    $class: 'CoberturaPublisher',
                    coberturaReportFile: '$REPORTS/coverage.xml'
                ])
            }
        }
    }
}