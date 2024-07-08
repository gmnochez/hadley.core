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

fileNameImplementation="$sourceBicepDeploy/implementation_$file_name.bicep"
relpathFileNameImplementation="./implementation_$file_name.bicep"

fileBicepToHcl="$sourceBicepDeploy/param_$file_name.hcl"
cp $sourceBicep/$file_name.bicep $fileNameImplementation 
cp $sourceMainBicep/main.bicep "$sourceBicepDeploy/main_$file_name.bicep"
cp $deployDirectory/$file_name.bicep "$sourceBicepDeploy/param_$file_name.bicep"
cp $deployDirectory/$file_name.bicep "$fileBicepToHcl"


sed -i "s|param hadley_definition_param|params :|g" "$sourceBicepDeploy/param_$file_name.bicep"
sed -i "s|param hadley_definition_param|locals|g" "$fileBicepToHcl"
sed -i "s|:|=|g" "$fileBicepToHcl"
sed -i "s|'|\"|g" "$fileBicepToHcl"

extractedParameters="$(cat $sourceBicepDeploy/param_$file_name.bicep)"

extractedParameters=$(printf '%s\n' "$extractedParameters" | sed 's,[\/&],\\&,g;s/$/\\/')
extractedParameters=${extractedParameters%?}


sed -i "s|hadley_resource|$file_name|g" "$sourceBicepDeploy/main_$file_name.bicep"
sed -i "s|hadley_source_bicep|$relpathFileNameImplementation|g" "$sourceBicepDeploy/main_$file_name.bicep"
sed -i "s|hadley_params|$extractedParameters|g" "$sourceBicepDeploy/main_$file_name.bicep"

tags=$(cat "$sourceBicepDeploy/main_$file_name.bicep" | sed -n '/tags/,/}/p')

tags=$(echo "$tags" | sed "s|:|=|g")
tags=$(echo "$tags" | sed "s|'|\"|g")
tags=$(echo "$tags" | sed "s|{|[|g")
tags=$(echo "$tags" | sed "s|}|]|g")
tags=$(echo "$tags" | sed -r '/^\s*$/d')


echo "$tags" > temp.txt

cat temp.txt | while read line || [[ -n $line ]];
do
   
    if [[ $line != *"["* ]]  &&  [[ $line != *"]"* ]] ; then 
        key=$(echo $line |awk -F '=' '{print $1}')
        value=$(echo $line |awk -F '=' '{print $2}')
        newLine="{\n key = "\"$key\""\n value = "$value" \n },"
        sed -i "s|$line|$newLine|g"  "./temp.txt"     
    fi
    if [[ $line == *"]"* ]] ; then 
        line1="*},\n*]*"
        line2="}\n]"
        echo "$line"
        sed -i "s|$line1|$line2|g"  "./temp.txt"
    fi
    
done

cat temp.txt

rm temp.txt


# tags : {
#     enviroment: 'daily'
#     company: 'ktc'
# }

#  tags = [ 
#            {
#              key = "enviroment" 
#              value = "daily"
#            },
#            { 
#              key = "company" 
#              value = "ktc"
#            }
#          ]




importSystemAzureVars $fileBicepToHcl $fullPathEnviroment $fullPathGlobal


# az login \
#     --only-show-errors \
#     --output none \
#     --service-principal \
#     -t $ARM_TENANT_ID \
#     -u $ARM_CLIENT_ID \
#     -p $ARM_CLIENT_SECRET

 
# terraform apply
# az deployment group create
# New-AzResourceGroupDeployment -Confirm


export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1


# if [[ $deploy_action == "create" ]];then 

#     if [[ $resource_action == "plan" ]];then
#         bicep_plan "$sourceBicepDeploy/main_$file_name.bicep"
#     fi

#     if [[ $resource_action == "apply" ]];then
#         bicep_apply "$sourceBicepDeploy/main_$file_name.bicep"
#     fi
# fi





rm -rf "$sourceTerraformDeploy"
