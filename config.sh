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
     




cp ../../../../modules/vm/variables.tf ../../../../modules/vm/${vm_create_option}/variables.tf
cp ../../../../modules/vm/providers.tf ../../../../modules/vm/${vm_create_option}/providers.tf
cp ../../../../modules/vm/variables.tf ./variables.tf
cp ../../../providers.tf ./providers.tf
cp ../../../main.tf ./main.tf





