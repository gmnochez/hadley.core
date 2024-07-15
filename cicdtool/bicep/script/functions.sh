#!/bin/bash





read_properties()
{
  file=$1

# AZURE 

  resource_group_name=$(cat $file | hclq get 'locals.resource_group_name' | sed 's/ //g' | sed 's/\"\"//g' | sed 's/\[\]//g' | sed 's/^"\(.*\)"$/\1/' ) 
  if [[ $resource_group_name != "" ]] ; then export RESOURCE_GROUP_NAME=$resource_group_name; fi

  subscription_id=$(cat $file | hclq get 'locals.subscription_id' | sed 's/ //g' | sed 's/\"\"//g' | sed 's/\[\]//g' | sed 's/^"\(.*\)"$/\1/' ) 
  if [[ $subscription_id != "" ]] ; then export ARM_SUBSCRIPTION_ID=$subscription_id; fi

  client_id=$(cat $file | hclq get 'locals.client_id' | sed 's/ //g' | sed 's/\"\"//g' | sed 's/\[\]//g' | sed 's/^"\(.*\)"$/\1/' ) 
  if [[ $client_id != "" ]] ; then export ARM_CLIENT_ID=$client_id; fi

  client_secret=$(cat $file | hclq get 'locals.client_secret' | sed 's/ //g' | sed 's/\"\"//g' | sed 's/\[\]//g' | sed 's/^"\(.*\)"$/\1/' ) 
  if [[ $client_secret != "" ]] ; then export ARM_CLIENT_SECRET=$client_secret; fi

  tenant_id=$(cat $file | hclq get 'locals.tenant_id' | sed 's/ //g' | sed 's/\"\"//g' | sed 's/\[\]//g' | sed 's/^"\(.*\)"$/\1/' ) 
  if [[ $tenant_id != "" ]] ; then export ARM_TENANT_ID=$tenant_id; fi

# AWS
  
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



transformPropertyBicepToHcl()
{
    fileBicep=$1
    fileHcl=$2
    arrayProperty=$3
    sed -i 's|//[^/]*$||' $fileBicep
    sed -i 's|#[^/]*$||' $fileBicep
    sed -i 's|//[^/]*$||' $fileHcl
    sed -i 's|#[^/]*$||' $fileHcl
    tags=$(cat "$fileBicep" | sed -n "/$arrayProperty/,/}/p")

    if [[ -z  $tags ]] ; then
      echo "false"
      return 
    fi 

    sed -i "s|$arrayProperty|hadley_property\n$arrayProperty|g" "$fileHcl"

    sed -i "/$arrayProperty/,/}/d" "$fileHcl"
    

    tags=$(echo "$tags" | sed "s|:|=|g")
    tags=$(echo "$tags" | sed "s|'|\"|g")
    tags=$(echo "$tags" | sed "s|{|[|g")
    tags=$(echo "$tags" | sed "s|}|]|g")
    tags=$(echo "$tags" | sed -r '/^\s*$/d')

    echo "$tags" > temp.txt
    numLineas=$(cat temp.txt | wc -l)
    count=0
    cat temp.txt | while read line || [[ -n $line ]];
    do
        count=$(($count+1))
        key=$(echo $line |awk -F '=' '{print $1}')
        value=$(echo $line |awk -F '=' '{print $2}')
        newLine1="{\n key = "\"$key\""\n value = "$value" \n },"
        newLine2="{\n key = "\"$key\""\n value = "$value" \n }"
            
        if [[ $count > 1 ]]  &&  [[ $count < $(($numLineas-1)) ]] ; then 
            sed -i "s|$line|$newLine1|g"  "./temp.txt"     
        elif [[ $count > 1 ]]  &&  [[ $count < $numLineas ]]  ; then 
            sed -i "s|$line|$newLine2|g"  "./temp.txt"
        fi

        
    done

    extractedParameters=$(cat "./temp.txt" | sed -n "/$arrayProperty/,/]/p")
    extractedParameters=$(printf '%s\n' "$extractedParameters" | sed 's,[\/&],\\&,g;s/$/\\/')
    extractedParameters=${extractedParameters%?}

    sed -i "s|hadley_property|$extractedParameters|g"  "$fileHcl"
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
    echo "true"

}    


transformPropertyHclToBicep()
{
    fileHcl=$1
    fileBicep=$2
    arrayProperty=$3
    sed -i 's|//[^/]*$||' $fileHcl
    sed -i 's|#[^/]*$||' $fileHcl
    sed -i 's|//[^/]*$||' $fileBicep
    sed -i 's|#[^/]*$||' $fileBicep
    tags=$(cat "$fileHcl" | sed -n "/$arrayProperty/,/]/p")

    if [[ -z  $tags ]] ; then
      echo "false"
      return 
    fi 


    sed -i "s/\(.*\)}/hadley_property\n}/g" "$fileBicep"
   
    tags=$(echo "$tags" | sed "s|[|{|g")
    tags=$(echo "$tags" | sed "s|]|}|g")
    tags=$(echo "$tags" | sed -r '/^\s*$/d')


    echo "$tags" > temp.txt
    numLineas=$(cat temp.txt | wc -l)
    count=0

    cat "temp.txt"
    cat "$fileBicep"

    # cat temp.txt | while read line || [[ -n $line ]];
    # do
    #     count=$(($count+1))
    #     key=$(echo $line |awk -F '=' '{print $1}')
    #     value=$(echo $line |awk -F '=' '{print $2}')
    #     newLine1="{\n key = "\"$key\""\n value = "$value" \n },"
    #     newLine2="{\n key = "\"$key\""\n value = "$value" \n }"
            
    #     if [[ $count > 1 ]]  &&  [[ $count < $(($numLineas-1)) ]] ; then 
    #         sed -i "s|$line|$newLine1|g"  "./temp.txt"     
    #     elif [[ $count > 1 ]]  &&  [[ $count < $numLineas ]]  ; then 
    #         sed -i "s|$line|$newLine2|g"  "./temp.txt"
    #     fi

        
    # done

#     extractedParameters=$(cat "./temp.txt" | sed -n "/$arrayProperty/,/]/p")
#     extractedParameters=$(printf '%s\n' "$extractedParameters" | sed 's,[\/&],\\&,g;s/$/\\/')
#     extractedParameters=${extractedParameters%?}

#     sed -i "s|hadley_property|$extractedParameters|g"  "$fileHcl"
#     rm temp.txt


    # tags = [ 
    #           {
    #             key = "enviroment" 
    #             value = "daily"
    #           },
    #           { 
    #             key = "company" 
    #             value = "ktc"
    #           }
    #         ]

    # tags : {
    #     enviroment: 'daily'
    #     company: 'ktc'
    # }

    echo "true"

}    








copyPropertyFileToFile()
{
    sourceFile=$1
    destFile=$2
    arrayProperty=$3
    sed -i 's|//[^/]*$||' $sourceFile
    sed -i 's|#[^/]*$||' $sourceFile
    sed -i 's|//[^/]*$||' $destFile
    sed -i 's|#[^/]*$||' $destFile
    extractedParameters=$(cat "$sourceFile" | sed -n "/$arrayProperty/,/]/p")

    if [[ -z  $extractedParameters ]] ; then
      echo "false"
      return
    fi 

   
    sed -i "s/\(.*\)}/hadley_property\n}/g" "$destFile"

    extractedParameters=$(printf '%s\n' "$extractedParameters" | sed 's,[\/&],\\&,g;s/$/\\/')
    extractedParameters=${extractedParameters%?}

    sed -i "s|hadley_property|$extractedParameters|g"  "$destFile"

    echo "true"

}    

