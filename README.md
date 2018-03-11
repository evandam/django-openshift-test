# django-openshift-test
Testing building and deploying an application through Jenkins and OpenShift

# Jenkins
[Cobertura](https://wiki.jenkins.io/display/JENKINS/Cobertura+Plugin) and [Warnings](https://wiki.jenkins.io/display/JENKINS/Warnings+Plugin) plugins are used to publish the reports. These must be installed on your Jenkins instance.

[evandam/jenkins-slave-miniconda](https://github.com/evandam/jenkins-slave-miniconda) is used, since I am personally running Jenkins through Openshift. This is a custom Jenkins slave that is loaded with [Miniconda](https://conda.io/miniconda.html). It can be deployed to Openshift with the following, assuming you have a project named `ci`:
```bash
$ oc project ci
$ oc new-app https://github.com/evandam/jenkins-slave-miniconda -l role=jenkins-slave
```
Restart your Jenkins instance for Openshift to recognize the new template.

## Freestyle Project
### General
- This project is parameterized
  - `PYTHON_VERSION`: Default value `3.6`, `2.7`, etc.
  - `TEST_COMMAND`: Default value `manage.py test`, `nosetest`, `nose2`, etc.
- Restrict where this project can be run
  - `jenkins-slave-miniconda` if using Openshift as mentioned above. Can be any agent with `conda` available.

### Source Code Management
- Git: `https://github.com/evandam/django-openshift-test`

### Build
- Execute shell: `./build.sh`
- TODO: Build + Deploy Openshift project

### Post-build Actions
- Scan for compiler warnings
  - Scan workspace files
    - File pattern: `reports/pylint.report`
    - Parser: PyLint
- Publish Cobertura Coverage Report
  - Cobertura xml report pattern: `reports/coverage.xml`
  
