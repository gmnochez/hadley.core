#!/bin/bash

CICD_ROOT_PATH="/data/gitlab-runner/builds/lam-backoffice/devops/terraform-framework"
TF_ADDRESS="https://gde.kapschtraffic.com/api/v4/projects/10856/terraform/state/aks_test"
KTC_PLAN="ktctfapply"
KTC_PLAN_JSON="ktc-plan.json"
KTC_VAR="aks_test.tfvars"



python3 config.py $CICD_ROOT_PATH $TF_ADDRESS $KTC_PLAN $KTC_PLAN_JSON $KTC_VAR