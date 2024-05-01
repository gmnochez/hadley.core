#!/bin/bash

CICD_ROOT_PATH=$1
FRAMEWORK_PATH=$2
module_framework=$3
main_config=$4
resource_type=$5
deploy_path=$6
file_resource=$7
enviroment_definition=$8
global_definition=$9

workingDirectory="$CICD_ROOT_PATH/$deploy_path"
fullPathConfigFile="$workingDirectory/terragrunt.hcl"
fullPathMainConfig="$CICD_ROOT_PATH/$main_config"
fullPathEnviroment="$CICD_ROOT_PATH/$enviroment_definition"
fullPathGlobal="$CICD_ROOT_PATH/$global_definition"

sourceTerraform="$CICD_ROOT_PATH/$FRAMEWORK_PATH/$module_framework/$resource_type"    



sed -i "s/hadley_source_terraform/$sourceTerraform/g" $fullPathConfigFile
sed -i "s/hadley_main_config_terragrunt/$fullPathMainConfig/g" $fullPathConfigFile
sed -i "s/enviroment.hcl/$fullPathEnviroment/g" $fullPathMainConfig
sed -i "s/global.hcl/$fullPathGlobal/g" $fullPathMainConfig



existResource=false
terragrunt --terragrunt-working-dir $workingDirectory state list
for initialList in $(terragrunt --terragrunt-working-dir $workingDirectory state list) 
do
    if [[ $initialList == "azurerm_resource_group.default" ]]; then
        existResource=true
        echo $initialList state already exist !!
    else

        terragrunt import \
        --terragrunt-working-dir $workingDirectory \
        --terragrunt-include-external-dependencies \
        --terragrunt-non-interactive azurerm_resource_group.default azurerm_resource_group.default.default_resource_group_id
        existResource=true
    fi
done

echo $existResource