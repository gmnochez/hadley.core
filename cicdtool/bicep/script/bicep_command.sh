#!/bin/bash

bicep_plan()
{

    templateFile=$1

    az deployment group what-if \
        --resource-group $RESOURCE_GROUP_NAME \
        --subscription $ARM_SUBSCRIPTION_ID \
        --template-file $templateFile 

}

bicep_apply()
{

    templateFile=$1

    az deployment group create \
        --resource-group $RESOURCE_GROUP_NAME \
        --subscription $ARM_SUBSCRIPTION_ID \
        --template-file $templateFile 

}



