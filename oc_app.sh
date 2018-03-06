#!/bin/sh

oc delete all -l app=myapp

oc new-app \
    -l app=myapp \
    -e POSTGRESQL_USER='user' \
    -e POSTGRESQL_PASSWORD='password' \
    -e POSTGRESQL_DATABASE='db' \
    -e POSTGRESQL_ROOT_PASSWORD='root' \
    centos/postgresql-94-centos7 \
    library/rabbitmq \
    python~https://github.com/evandam/django-openshift-test \

oc expose svc/django-openshift-test


