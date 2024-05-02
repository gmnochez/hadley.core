#!/bin/bash


read_properties()
{
  file=$1
  cat $file | hclq get 'locals.subscription_id'  



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