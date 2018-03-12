# django-openshift-test
Testing building and deploying an application through Jenkins and OpenShift

[Cobertura](https://wiki.jenkins.io/display/JENKINS/Cobertura+Plugin) and [Warnings](https://wiki.jenkins.io/display/JENKINS/Warnings+Plugin) plugins are used to publish the reports. These must be installed on your Jenkins instance.

[evandam/jenkins-slave-miniconda](https://github.com/evandam/jenkins-slave-miniconda) is used to provision build agents and run `conda` in them. Visit that repo for install instructions.

# Environment Variables
Projects in Jenkins should be parameterized, with two variables:
- `PYTHON_VERSION` is used to set the version of Python to build and test with. It is installed via Anaconda and should typically be something like `2.7`, `3.5`, `3.6`, etc.
- `TEST_COMMAND` is the command used to run tests. For Django apps, it might be `manage.py test`, but other cases might include `nosetests`, `nose2`, `test.py`, etc.

# Pipeline Project
A `Jenkinsfile` is included that does the following:
1. Build a virtual environment and install dependencies.
2. Run Pylint on all `.py` files in the repository.
3. Run tests as defined in `$TEST_COMMAND`.
4. Publish pylint and code coverage reports.

Simply create a new Jenkins pipeline project and point to this repo for it to run!

# TODO
- Build and deploy to an Openshift project/application
