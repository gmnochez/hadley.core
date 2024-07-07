#!/bin/bash

bicep_plan()
{

    workingDirectory=$1

}

bicep_apply()
{

    workingDirectory=$1

}

azure_cli_login()
{
    az login \
    --service-principal \
    -t $ARM_TENANT_ID \
    -u $ARM_CLIENT_ID \
    -p $ARM_CLIENT_SECRET

}


