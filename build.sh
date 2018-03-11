#!/bin/bash -ex

# Create a clean virtual environment
conda create -p "$WORKSPACE/venv" -y python=$PYTHON_VERSION pylint coverage
. activate "$WORKSPACE/venv"
pip install -r requirements.txt

mkdir "$WORKSPACE/reports"

# All the files we want to scan
pyfiles=$(find "$WORKSPACE" -name "*.py" -not -path "$WORKSPACE/venv/*")

# We don't want to fail a build if there are only warnings
if pylint -f parseable $pyfiles > "$WORKSPACE/reports/pylint.report"
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

# Now run Django's test cases (with code coverage)
coverage run --omit="$WORKSPACE/venv/*" $TEST_COMMAND
coverage xml -o "$WORKSPACE/reports/coverage.xml"
