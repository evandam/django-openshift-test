#!/bin/sh

# Create the app in OpenShift
oc new-app https://github.com/evandam/django-openshift-test
oc expose svc django-openshift-test
