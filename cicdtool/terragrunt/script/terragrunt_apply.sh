#!/bin/bash

CICD_ROOT_PATH=$1
FRAMEWORK_PATH=$2
module_framework=$3
main_config=$4
resource_type=$5
resource_api=$6
deploy_path=$7
file_resource=$8
enviroment_definition=$9
global_definition=${10}
frameworkFullPath=${11}

source $frameworkFullPath/script/functions.sh

workingDirectory="$CICD_ROOT_PATH/$deploy_path"
fullPathConfigFile="$workingDirectory/terragrunt.hcl"
fullPathMainConfig="$CICD_ROOT_PATH/$main_config"
fullPathEnviroment="$CICD_ROOT_PATH/$enviroment_definition"
fullPathGlobal="$CICD_ROOT_PATH/$global_definition"
fullPathFileResource="$workingDirectory/$file_resource"
sourceTerraform="$CICD_ROOT_PATH/$FRAMEWORK_PATH/$module_framework/$resource_type"    
file_name=$(echo $file_resource |  sed 's/\.hcl//g')
$resource_declaration="$resource_api/$file_name"

sed -i "s|hadley_source_terraform|$sourceTerraform|g" $fullPathConfigFile
sed -i "s|hadley_main_config_terragrunt|$fullPathMainConfig|g" $fullPathConfigFile
sed -i "s|enviroment.hcl|$fullPathEnviroment|g" $fullPathMainConfig
sed -i "s|global.hcl|$fullPathGlobal|g" $fullPathMainConfig
sed -i "s|resource.hcl|$fullPathFileResource|g" $fullPathMainConfig
sed -i "s|key_remote_state|$deploy_path|g" $fullPathMainConfig
sed -i "s|hadley_resource|$file_name|g" $sourceTerraform/main.tf
sed -i "s|hadley_resource|$file_name|g" $sourceTerraform/outputs.tf

echo $workingDirectory
importSystemAzureVars $fullPathFileResource $fullPathEnviroment $fullPathGlobal


terragrunt run-all apply \
    --terragrunt-working-dir $workingDirectory \
    --terragrunt-include-external-dependencies \
    --terragrunt-non-interactive



sed -i "s|$sourceTerraform|hadley_source_terraform|g" $fullPathConfigFile
sed -i "s|$fullPathMainConfig|hadley_main_config_terragrunt|g" $fullPathConfigFile
sed -i "s|$fullPathEnviroment|enviroment.hcl|g" $fullPathMainConfig
sed -i "s|$fullPathGlobal|global.hcl|g" $fullPathMainConfig
sed -i "s|$fullPathFileResource|resource.hcl|g" $fullPathMainConfig
sed -i "s|$deploy_path|key_remote_state|g" $fullPathMainConfig
sed -i "s|$file_name|hadley_resource|g" $sourceTerraform/main.tf
sed -i "s|$file_name|hadley_resource|g" $sourceTerraform/outputs.tf
