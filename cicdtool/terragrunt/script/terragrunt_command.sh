#!/bin/bash


terragrunt_validate()
{

    workingDirectory=$1

    terragrunt run-all validate \
        --terragrunt-working-dir $workingDirectory \
        --terragrunt-include-external-dependencies \
        --terragrunt-non-interactive


}


terragrunt_reconfigure()
{

    workingDirectory=$1

    terragrunt init -reconfigure  \
        --terragrunt-working-dir $workingDirectory \
        --terragrunt-include-external-dependencies \
        --terragrunt-non-interactive


}




terragrunt_plan()
{

    workingDirectory=$1
    terragrunt run-all plan \
        --terragrunt-working-dir $workingDirectory \
        --terragrunt-include-external-dependencies \
        --terragrunt-non-interactive

}

terragrunt_destroy()
{

    workingDirectory=$1
    resource_declaration=$2

    existResource=0
    terragrunt --terragrunt-working-dir $workingDirectory state list
    for initialList in $(terragrunt --terragrunt-working-dir $workingDirectory state list) 
    do

        if [[ $initialList == $resource_declaration ]]; then
            existResource=1
            # echo Resource $initialList  exist !!
        fi
    done

    if [[ $existResource == 1 ]]; then
        
        terragrunt run-all destroy \
            --terragrunt-working-dir $workingDirectory \
            --terragrunt-ignore-external-dependencies \
            --terragrunt-non-interactive

    else
        echo "Resource doesn't exist.   Nothing to destroy !!"
    fi



}


terragrunt_destroy_plan()
{
    workingDirectory=$1
    terragrunt run-all plan \
        --terragrunt-working-dir $workingDirectory \
        --terragrunt-include-external-dependencies \
        --terragrunt-non-interactive \
        -destroy

}




terragrunt_import()
{

    workingDirectory=$1
    resource_declaration=$2
    fullPathFileResource=$3

    existResource=0
    terragrunt --terragrunt-working-dir $workingDirectory state list
    for initialList in $(terragrunt --terragrunt-working-dir $workingDirectory state list) 
    do

        if [[ $initialList == $resource_declaration ]]; then
            existResource=1
            # echo $initialList state already exist !!

        fi
    done

    if [[ $existResource == 0 ]]; then   
        resource_id=$(cat $fullPathFileResource | hclq get 'locals.resource_id' | sed 's/ //g' | sed 's/\"\"//g' | sed 's/\[\]//g' | sed 's/^"\(.*\)"$/\1/' ) 
        terragrunt import \
            --terragrunt-working-dir $workingDirectory \
            --terragrunt-include-external-dependencies \
            --terragrunt-non-interactive $resource_declaration $resource_id
            
        existResource=1

    fi



}


terragrunt_apply()
{

    workingDirectory=$1

    terragrunt run-all apply \
        --terragrunt-working-dir $workingDirectory \
        --terragrunt-include-external-dependencies \
        --terragrunt-non-interactive

}








