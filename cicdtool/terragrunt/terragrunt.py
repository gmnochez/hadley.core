#!/usr/bin/python
import sys
import os
import shutil
import json
import subprocess


def terragruntCommand(resource_action, deploy_action, CICD_ROOT_PATH, FRAMEWORK_PATH, frameworkFullPath, module_framework, main_config, resource_type, resource_api, deploy_path, file_resource, enviroment_definition, global_definition):
    execScript = "sh " + frameworkFullPath + "/script/terragrunt.sh " + resource_action + ' ' + deploy_action + ' ' + CICD_ROOT_PATH + ' ' + FRAMEWORK_PATH + ' ' + module_framework + ' ' + main_config + ' ' + resource_type + ' ' + resource_api + ' ' + deploy_path + ' ' + file_resource + ' ' + enviroment_definition + ' ' + global_definition + ' ' + frameworkFullPath
    process = subprocess.Popen(execScript, shell=True, stdout=subprocess.PIPE)
    out, err = process.communicate()
    print(out.decode())
    # print("Exist resource " + format(process.returncode))



def checkResourceDefinition(CICD_ROOT_PATH, deploy_path, file_resource):
    # file_name = os.path.splitext(file_resource)[0]
    str_index = str(file_resource).split('/')
    file_name = str(file_resource).split('/')[len(str_index) - 1]

    fullPathFileResource = CICD_ROOT_PATH  + '/' + deploy_path + '/' + file_resource + '/' + file_name + '.hcl'
    # print(fullPathFileResource)
    if not os.path.isfile(fullPathFileResource):
        print("File (" + fullPathFileResource + ") doesn't exist.")
        return False
    else:
        return True
        

def cicdTerragrunt (CICD_ROOT_PATH, FRAMEWORK_PATH, frameworkFullPath, module_framework, main_config, hadley_file):
    
    existFile = False
    if os.path.isfile(CICD_ROOT_PATH + '/' + hadley_file):
        existFile = True
    else:
        print("File (" + hadley_file + ") doesn't exist.   Please check the config hadley_file in the file hadley.json")
        existFile = False
        exit()

    file = open(CICD_ROOT_PATH + '/' + hadley_file)
    data = json.load(file)
    for module in data['module']:
        module_name = module['module_name']
        resource_type = module['resource_type']
        resource_api = module['resource_api']
        deploy_path = module['deploy_path']
        enviroment_definition = module['enviroment_definition']
        global_definition = module['global_definition']
        
        for resource_definition in module['resource_definition']:
            file_resource = resource_definition['file_resource']
            resource_action = resource_definition['resource_action']
            deploy_action = resource_definition['deploy_action']
            resource_definition_deploy = resource_definition['deploy']
            if resource_definition_deploy != 'true':
                continue


            existCheckFile = checkResourceDefinition(CICD_ROOT_PATH, deploy_path, file_resource)
            
            # if existCheckFile:
            #     terragruntCommand(resource_action, deploy_action,CICD_ROOT_PATH, FRAMEWORK_PATH, frameworkFullPath, module_framework, main_config, resource_type, resource_api, deploy_path, file_resource, enviroment_definition, global_definition)
            # else:
            #     print("Please check the Configuration File ...")                

    file.close()    






    