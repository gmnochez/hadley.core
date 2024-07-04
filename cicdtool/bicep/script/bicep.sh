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

echo "bicep.sh"

echo "resource_action=$resource_action"
echo "deploy_action=$deploy_action"
echo "CICD_ROOT_PATH=$CICD_ROOT_PATH"
echo "FRAMEWORK_PATH=$FRAMEWORK_PATH"
echo "module_framework=$module_framework"
echo "main_config=$main_config"
echo "resource_type=$resource_type"
echo "resource_api=$resource_api"
echo "deploy_path=$deploy_path"
echo "file_resource=$file_resource"
echo "enviroment_definition=$enviroment_definition"
echo "global_definition=$global_definition"
echo "frameworkFullPath=$frameworkFullPath"



# source $frameworkFullPath/script/functions.sh
# source $frameworkFullPath/script/bicep_command.sh

# workingDirectory="$CICD_ROOT_PATH/$deploy_path"


# fullPathMainConfig="$CICD_ROOT_PATH/$main_config"
# fullPathEnviroment="$CICD_ROOT_PATH/$enviroment_definition"
# fullPathGlobal="$CICD_ROOT_PATH/$global_definition"
 
# file_name=$(echo $file_resource |  sed 's#.*/##')
# fullPathFileResource="$workingDirectory/$file_resource/$file_name.hcl"

# export deployDirectory="$workingDirectory/$file_name"



# fullPathConfigFile="$workingDirectory/$file_resource/terragrunt.hcl"

# sourceTerraform="$CICD_ROOT_PATH/$FRAMEWORK_PATH/$module_framework/$resource_type"  
# sourceTerraformDeploy=$sourceTerraform/$deploy_path/$file_resource
# resource_declaration="$resource_api.$file_name"
# # deploy_id=$(echo $deploy_path |  sed 's/\//_/g')

# key_remote_state="$deploy_path/$file_resource/$file_name.tfstate"


# sed -i "s|hadley_source_terraform|$sourceTerraformDeploy|g" $fullPathConfigFile
# sed -i "s|hadley_main_config_terragrunt|$fullPathMainConfig|g" $fullPathConfigFile
# sed -i "s|enviroment.hcl|$fullPathEnviroment|g" $fullPathMainConfig
# sed -i "s|global.hcl|$fullPathGlobal|g" $fullPathMainConfig
# sed -i "s|resource.hcl|$fullPathFileResource|g" $fullPathMainConfig
# sed -i "s|key_remote_state|$key_remote_state|g" $fullPathMainConfig

# mkdir -p "$sourceTerraformDeploy"

# cp $sourceTerraform/main.tf "$sourceTerraformDeploy/main_$file_name.tf"
# cp $sourceTerraform/outputs.tf "$sourceTerraformDeploy/outputs_$file_name.tf"
# cp $sourceTerraform/variables.tf "$sourceTerraformDeploy/variables.tf"


# sed -i "s|hadley_resource|$file_name|g" "$sourceTerraformDeploy/main_$file_name.tf"
# sed -i "s|hadley_resource|$file_name|g" "$sourceTerraformDeploy/outputs_$file_name.tf"


# # echo $workingDirectory
# importSystemAzureVars $fullPathFileResource $fullPathEnviroment $fullPathGlobal

# az login \
# --service-principal \
# -t <Tenant-ID> \
# -u <Client-ID> \
# -p <Client-secret>



# deployDirectory="$workingDirectory/$file_resource"


# if [[ $deploy_action == "import" ]];then
#     terragrunt_import $deployDirectory $resource_declaration $fullPathFileResource
# fi

# if [[ $deploy_action == "create" ]];then 
    
#     if [[ $resource_action == "reconfigure" ]];then
#         terragrunt_reconfigure $deployDirectory
#     fi

#     terragrunt_validate $deployDirectory

#     if [[ $resource_action == "plan" ]];then
#         terragrunt_plan $deployDirectory
#     fi

#     if [[ $resource_action == "apply" ]];then
#         terragrunt_apply $deployDirectory
#     fi

#     if [[ $resource_action == "destroy" ]];then
#         terragrunt_destroy $deployDirectory $resource_declaration
#     fi    

#     if [[ $resource_action == "destroy_plan" ]];then
#         terragrunt_destroy_plan $deployDirectory $resource_declaration
#     fi  

# fi



# sed -i "s|$sourceTerraformDeploy|hadley_source_terraform|g" $fullPathConfigFile
# sed -i "s|$fullPathMainConfig|hadley_main_config_terragrunt|g" $fullPathConfigFile
# sed -i "s|$fullPathEnviroment|enviroment.hcl|g" $fullPathMainConfig
# sed -i "s|$fullPathGlobal|global.hcl|g" $fullPathMainConfig
# sed -i "s|$fullPathFileResource|resource.hcl|g" $fullPathMainConfig
# sed -i "s|$key_remote_state|key_remote_state|g" $fullPathMainConfig

# rm -rf "$sourceTerraformDeploy"
