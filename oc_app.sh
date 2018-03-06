#!/bin/sh

# Clean the old app
oc delete all -l app=myapp

# Create the new app (with postgres and rabbitmq)
oc new-app \
    -l app=myapp \
    -e POSTGRESQL_USER='user' \
    -e POSTGRESQL_PASSWORD='password' \
    -e POSTGRESQL_DATABASE='db' \
    -e POSTGRESQL_ROOT_PASSWORD='root' \
    centos/postgresql-94-centos7 \
    library/rabbitmq \
    python~https://github.com/evandam/django-openshift-test \

# Make sure we run our tests every build
oc set build-hook bc/django-openshift-test --script "./manage.py test"

# Open up the port to the web app
oc expose svc/django-openshift-test


