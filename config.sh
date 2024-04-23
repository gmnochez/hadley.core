#!/bin/bash

TF_ROOT=$1
TF_ADDRESS=$2
KTC_PLAN=$3
KTC_PLAN_JSON=$4
KTC_VAR=$5


 
apk --no-cache add jq
alias convert_report="jq -r '([.resource_changes[]?.change.actions?]|flatten)|{\"create\":(map(select(.==\"create\"))|length),\"update\":(map(select(.==\"update\"))|length),\"delete\":(map(select(.==\"delete\"))|length)}'"
cd $TF_ROOT
pwd

cp ./$KTC_VAR ./$KTC_VAR.tmp
sed -i 's/[\"\t ]//g' ./$KTC_VAR.tmp
file="./$KTC_VAR.tmp"
while IFS='=' read -r key value
do
    key=$(echo $key)
    if [ -z $key ] ;then   
        echo ''                    
    else
        eval ${key}=\${value} 
    fi
done < "$file" 
rm -rf ./$KTC_VAR.tmp
     




# cp ../../../../modules/vm/variables.tf ../../../../modules/vm/${vm_create_option}/variables.tf
# cp ../../../../modules/vm/providers.tf ../../../../modules/vm/${vm_create_option}/providers.tf
# cp ../../../../modules/vm/variables.tf ./variables.tf
# cp ../../../providers.tf ./providers.tf
# cp ../../../main.tf ./main.tf

#   sed -i "s/module_azure_vm_name/${TF_VARS_VM}/g" ./main.tf
#   sed -i "s:module_url:../../../../modules/vm/${vm_create_option}:g" ./main.tf
#   sed -i "s/provider_alias/${AZURE_PROVIDER_ALIAS}/g" ./main.tf
#   ls    


# - terraform --version
# - echo ${TF_ADDRESS}
# - echo ${TF_VARS_VM}
# - terraform init -reconfigure -backend-config="address=${TF_ADDRESS}" -backend-config="lock_address=${TF_ADDRESS}/lock" -backend-config="unlock_address=${TF_ADDRESS}/lock" -backend-config="username=gitlab-ci-token" -backend-config="password=${CI_JOB_TOKEN}" -backend-config="lock_method=POST" -backend-config="unlock_method=DELETE" -backend-config="retry_wait_min=5"
# - pwd
# # - export TF_LOG=INFO
# - terraform apply -refresh-only -auto-approve




