#!/bin/sh

oc delete all -l app=myapp

oc new-app \
    -l app=myapp \
    -e MYSQL_USER='user' \
    -e MYSQL_PASSWORD='password' \
    -e MYSQL_DATABASE='db' \
    -e MYSQL_ROOT_PASSWORD='root' \
    library/mysql \
    library/rabbitmq \
    python~https://github.com/evandam/django-openshift-test \

oc expose svc/django-openshift-test


