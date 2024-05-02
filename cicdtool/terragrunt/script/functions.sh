#!/bin/bash





read_properties()
{
  file=$1
  subscription_id=$(cat $file | hclq get 'locals.subscription_id' | sed 's/ //g' | sed 's/\"\"//g' | sed 's/\[\]//g' ) 
  echo $subscription_id
  if [ -n $subscription_id ] ; then export ARM_SUBSCRIPTION_ID=$subscription_id; fi

}


importSystemAzureVars()
{
    resourceVar=$1
    enviromentVar=$2
    globalVar=$3

    read_properties $resourceVar 
    read_properties $enviromentVar 
    read_properties $globalVar 

    echo $ARM_SUBSCRIPTION_ID



}    