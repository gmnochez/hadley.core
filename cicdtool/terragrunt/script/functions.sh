#!/bin/bash





read_properties()
{
  file=$1
  subscription_id=$(cat $file | hclq get 'locals.subscription_id' | sed 's/ //g' | sed 's/\"\"//g' | sed 's/\[\]//g' | sed 's/^"\(.*\)"$/\1/' ) 
  if [[ $subscription_id != "" ]] ; then export ARM_SUBSCRIPTION_ID=$subscription_id; fi

  client_id=$(cat $file | hclq get 'locals.client_id' | sed 's/ //g' | sed 's/\"\"//g' | sed 's/\[\]//g' | sed 's/^"\(.*\)"$/\1/' ) 
  if [[ $client_id != "" ]] ; then export ARM_CLIENT_ID=$client_id; fi

  client_secret=$(cat $file | hclq get 'locals.client_secret' | sed 's/ //g' | sed 's/\"\"//g' | sed 's/\[\]//g' | sed 's/^"\(.*\)"$/\1/' ) 
  if [[ $client_secret != "" ]] ; then export ARM_CLIENT_SECRET=$client_secret; fi

  tenant_id=$(cat $file | hclq get 'locals.tenant_id' | sed 's/ //g' | sed 's/\"\"//g' | sed 's/\[\]//g' | sed 's/^"\(.*\)"$/\1/' ) 
  if [[ $tenant_id != "" ]] ; then export ARM_TENANT_ID=$tenant_id; fi

}


importSystemAzureVars()
{
    resourceVar=$1
    enviromentVar=$2
    globalVar=$3

    read_properties $globalVar 
    read_properties $enviromentVar 
    read_properties $resourceVar 
   
    echo $ARM_SUBSCRIPTION_ID
    echo $ARM_CLIENT_ID
    echo $ARM_CLIENT_SECRET
    echo $ARM_TENANT_ID
}    