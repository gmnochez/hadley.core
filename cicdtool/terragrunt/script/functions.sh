#!/bin/bash


read_properties()
{
  file=$1
  cat $file | hclq get 'locals.subscription_id'
  subscription_id=$(cat $file | hclq get 'locals.subscription_id') 
  echo $subscription_id | sed 's/ //g' | sed 's/\"\"//g' | sed 's/\[\]//g'  
#   echo subscription_id $subscription_id
  

 
}


importSystemAzureVars()
{
    resourceVar=$1
    enviromentVar=$2
    globalVar=$3

    read_properties $resourceVar 
    read_properties $enviromentVar 
    read_properties $globalVar 





}    