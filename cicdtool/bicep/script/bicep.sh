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



source $frameworkFullPath/bicep/script/functions.sh
source $frameworkFullPath/bicep/script/bicep_command.sh

workingDirectory="$CICD_ROOT_PATH/$deploy_path"


# fullPathMainConfig="$CICD_ROOT_PATH/$main_config"
fullPathEnviroment="$CICD_ROOT_PATH/$enviroment_definition"
fullPathGlobal="$CICD_ROOT_PATH/$global_definition"
 
file_name=$(echo $file_resource |  sed 's#.*/##')
fullPathFileResource="$workingDirectory/$file_resource/$file_name.bicep"

export deployDirectory="$workingDirectory/$file_name"



# fullPathConfigFile="$workingDirectory/$file_resource/terragrunt.hcl"

sourceBicep="$CICD_ROOT_PATH/$FRAMEWORK_PATH/$module_framework/$resource_type"  
sourceMainBicep="$CICD_ROOT_PATH/$FRAMEWORK_PATH/$module_framework/azurerm"  
sourceBicepDeploy=$sourceBicep/$deploy_path/$file_resource
resource_declaration="$resource_api.$file_name"


# key_remote_state="$deploy_path/$file_resource/$file_name.tfstate"

deployDirectory="$workingDirectory/$file_resource"

mkdir -p "$sourceBicepDeploy"

fileNameImplementation="$sourceBicepDeploy/implamentation_$file_name.bicep"
cp $sourceBicep/$file_name.bicep $fileNameImplementation 
cp $sourceMainBicep/main.bicep "$sourceBicepDeploy/main_$file_name.bicep"
cp $deployDirectory/$file_name.bicep "$sourceBicepDeploy/param_$file_name.bicep"

sed -i "s|param hadley_definition_param|params|g" "$sourceBicepDeploy/param_$file_name.bicep"
extractedParameters=$(cat "$sourceBicepDeploy/param_$file_name.bicep" | sed 's/ //g' | sed 's/\"\"//g' | sed 's/\[\]//g' | sed 's/^"\(.*\)"$/\1/')
echo $extractedParameters

sed -i "s|hadley_resource|$file_name|g" "$sourceBicepDeploy/main_$file_name.bicep"
sed -i "s|hadley_source_bicep|$fileNameImplementation|g" "$sourceBicepDeploy/main_$file_name.bicep"
sed -i "s|hadley_params|$extractedParameters|g" "$sourceBicepDeploy/main_$file_name.bicep"

cat "$sourceBicepDeploy/main_$file_name.bicep"



# # echo $workingDirectory
# importSystemAzureVars $fullPathFileResource $fullPathEnviroment $fullPathGlobal

# az login \
# --service-principal \
# -t <Tenant-ID> \
# -u <Client-ID> \
# -p <Client-secret>



# az deployment group create \
#   --resource-group testgroup \
#   --subscription sub \
#   --template-file <path-to-bicep> \

# terraform plan	
# az deployment group what-if
# New-AzResourceGroupDeployment -Whatif

 
# terraform apply
# az deployment group create
# New-AzResourceGroupDeployment -Confirm








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
