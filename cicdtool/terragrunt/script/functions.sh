#!/bin/bash





read_properties()
{
  file=$1

# AZURE 

  subscription_id=$(cat $file | hclq get 'locals.subscription_id' | sed 's/ //g' | sed 's/\"\"//g' | sed 's/\[\]//g' | sed 's/^"\(.*\)"$/\1/' ) 
  if [[ $subscription_id != "" ]] ; then export ARM_SUBSCRIPTION_ID=$subscription_id; fi

  client_id=$(cat $file | hclq get 'locals.client_id' | sed 's/ //g' | sed 's/\"\"//g' | sed 's/\[\]//g' | sed 's/^"\(.*\)"$/\1/' ) 
  if [[ $client_id != "" ]] ; then export ARM_CLIENT_ID=$client_id; fi

  client_secret=$(cat $file | hclq get 'locals.client_secret' | sed 's/ //g' | sed 's/\"\"//g' | sed 's/\[\]//g' | sed 's/^"\(.*\)"$/\1/' ) 
  if [[ $client_secret != "" ]] ; then export ARM_CLIENT_SECRET=$client_secret; fi

  tenant_id=$(cat $file | hclq get 'locals.tenant_id' | sed 's/ //g' | sed 's/\"\"//g' | sed 's/\[\]//g' | sed 's/^"\(.*\)"$/\1/' ) 
  if [[ $tenant_id != "" ]] ; then export ARM_TENANT_ID=$tenant_id; fi

# AWS
  echo "read_properties"
  
  aws_account_id=$(cat $file | hclq get 'locals.aws_account_id' | sed 's/ //g' | sed 's/\"\"//g' | sed 's/\[\]//g' | sed 's/^"\(.*\)"$/\1/' ) 
  if [[ $aws_account_id != "" ]] ; then export AWS_ACCOUNT_ID=$aws_account_id; fi
  
  aws_access_key_id=$(cat $file | hclq get 'locals.aws_access_key_id' | sed 's/ //g' | sed 's/\"\"//g' | sed 's/\[\]//g' | sed 's/^"\(.*\)"$/\1/' ) 
  if [[ $aws_access_key_id != "" ]] ; then export AWS_ACCESS_KEY_ID=$aws_access_key_id; fi
  
  aws_secret_access_key=$(cat $file | hclq get 'locals.aws_secret_access_key' | sed 's/ //g' | sed 's/\"\"//g' | sed 's/\[\]//g' | sed 's/^"\(.*\)"$/\1/' ) 
  if [[ $aws_secret_access_key != "" ]] ; then export AWS_SECRET_ACCESS_KEY=$aws_secret_access_key; fi
  




}


importSystemAzureVars()
{
    resourceVar=$1
    enviromentVar=$2
    globalVar=$3

    read_properties $globalVar 
    read_properties $enviromentVar 
    read_properties $resourceVar 
   
}    

