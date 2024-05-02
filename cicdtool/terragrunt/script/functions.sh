#!/bin/bash


check_Variable()
{
  variable=$1  
  if [ -z $variable ] ;then   
    echo 'subscription_id without value'                    
  else
    echo $variable    
  fi

}



read_properties()
{
  file=$1
  subscription_id=$(cat $file | hclq get 'locals.subscription_id' | sed 's/ //g' | sed 's/\"\"//g' | sed 's/\[\]//g' ) 
  if [ -z $variable ] ; then export ARM_SUBSCRIPTION_ID=$subscription_id; fi

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