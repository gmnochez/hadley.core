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
    print("checkResourceDefinition")
    file_name = os.path.splitext(file_resource)[0]
    fullPathFileResource = CICD_ROOT_PATH  + '/' + deploy_path + '/' + file_name + '/' + file_resource 
    # print(fullPathFileResource)
    if not os.path.isfile(fullPathFileResource):
        print("File (" + file_resource + ") doesn't exist.")
        exit()
        

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
            checkResourceDefinition(CICD_ROOT_PATH, deploy_path, file_resource)

            terragruntCommand(resource_action, deploy_action,CICD_ROOT_PATH, FRAMEWORK_PATH, frameworkFullPath, module_framework, main_config, resource_type, resource_api, deploy_path, file_resource, enviroment_definition, global_definition)
                            

    file.close()    






    