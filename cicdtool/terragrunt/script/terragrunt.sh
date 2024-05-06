#!/bin/bash

resource_action=$1
deploy_action=$2
CICD_ROOT_PATH=$3
FRAMEWORK_PATH=$4
module_framework=$5
main_config=$6
resource_type=$7
resource_api=$8
deploy_path=$9
file_resource=${10}
enviroment_definition=${11}
global_definition=${12}
frameworkFullPath=${13}

source $frameworkFullPath/script/functions.sh
source $frameworkFullPath/script/terragrunt_command.sh

workingDirectory="$CICD_ROOT_PATH/$deploy_path"
fullPathConfigFile="$workingDirectory/terragrunt.hcl"
fullPathMainConfig="$CICD_ROOT_PATH/$main_config"
fullPathEnviroment="$CICD_ROOT_PATH/$enviroment_definition"
fullPathGlobal="$CICD_ROOT_PATH/$global_definition"
fullPathFileResource="$workingDirectory/$file_resource"

sourceTerraform="$CICD_ROOT_PATH/$FRAMEWORK_PATH/$module_framework/$resource_type"    
file_name=$(echo $file_resource |  sed 's/\.hcl//g')
resource_declaration="$resource_api.$file_name"
# deploy_id=$(echo $deploy_path |  sed 's/\//_/g')

sed -i "s|hadley_source_terraform|$sourceTerraform|g" $fullPathConfigFile
sed -i "s|hadley_main_config_terragrunt|$fullPathMainConfig|g" $fullPathConfigFile
sed -i "s|enviroment.hcl|$fullPathEnviroment|g" $fullPathMainConfig
sed -i "s|global.hcl|$fullPathGlobal|g" $fullPathMainConfig
sed -i "s|resource.hcl|$fullPathFileResource|g" $fullPathMainConfig
sed -i "s|key_remote_state|$deploy_path|g" $fullPathMainConfig

mkdir "$sourceTerraform/$deploy_path/$file_name"

cp $sourceTerraform/main.tf "$sourceTerraform/$deploy_path/$file_name/main_$file_name.tf"
cp $sourceTerraform/outputs.tf "$sourceTerraform/$deploy_path/$file_name/outputs_$file_name.tf"
cp $sourceTerraform/variables.tf "$sourceTerraform/$deploy_path/$file_name/variables.tf"


sed -i "s|hadley_resource|$file_name|g" "$sourceTerraform/$deploy_path/$file_name/main_$file_name.tf"
sed -i "s|hadley_resource|$file_name|g" "$sourceTerraform/$deploy_path/$file_name/outputs_$file_name.tf"


echo $workingDirectory
importSystemAzureVars $fullPathFileResource $fullPathEnviroment $fullPathGlobal





if [[ $deploy_action == "import" ]];then
    terragrunt_import $workingDirectory $resource_declaration $fullPathFileResource
fi

if [[ $deploy_action == "create" ]];then 
    terragrunt_validate $workingDirectory

    if [[ $resource_action == "plan" ]];then
        terragrunt_plan $workingDirectory
    fi

    if [[ $resource_action == "apply" ]];then
        terragrunt_apply $workingDirectory
    fi

    if [[ $resource_action == "destroy" ]];then
        terragrunt_destroy $workingDirectory $resource_declaration
    fi    
fi



sed -i "s|$sourceTerraform|hadley_source_terraform|g" $fullPathConfigFile
sed -i "s|$fullPathMainConfig|hadley_main_config_terragrunt|g" $fullPathConfigFile
sed -i "s|$fullPathEnviroment|enviroment.hcl|g" $fullPathMainConfig
sed -i "s|$fullPathGlobal|global.hcl|g" $fullPathMainConfig
sed -i "s|$fullPathFileResource|resource.hcl|g" $fullPathMainConfig
sed -i "s|$deploy_path|key_remote_state|g" $fullPathMainConfig

rm -rf "$sourceTerraform/$deploy_path/$file_name"
