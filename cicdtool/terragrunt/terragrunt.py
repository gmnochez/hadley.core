#!/usr/bin/python
import sys
import os
import shutil
import json
import subprocess


def terragruntImport(CICD_ROOT_PATH, FRAMEWORK_PATH, frameworkFullPath, module_framework, main_config, resource_type, resource_api, deploy_path, file_resource, enviroment_definition, global_definition):
    
    execScript = "sh " + frameworkFullPath + "/script/terragrunt_import.sh "  + CICD_ROOT_PATH + ' ' + FRAMEWORK_PATH + ' ' + module_framework + ' ' + main_config + ' ' + resource_type + ' ' + resource_api + ' ' + deploy_path + ' ' + file_resource + ' ' + enviroment_definition + ' ' + global_definition + ' ' + frameworkFullPath
    process = subprocess.Popen(execScript, shell=True, stdout=subprocess.PIPE)
    out, err = process.communicate()
    print(out.decode())
    print("Exist resource " + format(process.returncode))

def terragruntValidate(CICD_ROOT_PATH, FRAMEWORK_PATH, frameworkFullPath, module_framework, main_config, resource_type, resource_api, deploy_path, file_resource, enviroment_definition, global_definition):
    print('terragruntValidate')
    execScript = "sh " + frameworkFullPath + "/script/terragrunt_validate.sh "  + CICD_ROOT_PATH + ' ' + FRAMEWORK_PATH + ' ' + module_framework + ' ' + main_config + ' ' + resource_type + ' ' + resource_api + ' ' + deploy_path + ' ' + file_resource + ' ' + enviroment_definition + ' ' + global_definition + ' ' + frameworkFullPath
    process = subprocess.Popen(execScript, shell=True, stdout=subprocess.PIPE)
    out, err = process.communicate()
    print(out.decode())
    print("Return code " + format(process.returncode))
   


def terragruntPlan(CICD_ROOT_PATH, FRAMEWORK_PATH, frameworkFullPath, module_framework, main_config, resource_type, resource_api, deploy_path, file_resource, enviroment_definition, global_definition):
    print('terragruntPlan')
    execScript = "sh " + frameworkFullPath + "/script/terragrunt_plan.sh "  + CICD_ROOT_PATH + ' ' + FRAMEWORK_PATH + ' ' + module_framework + ' ' + main_config + ' ' + resource_type + ' ' + resource_api + ' ' + deploy_path + ' ' + file_resource + ' ' + enviroment_definition + ' ' + global_definition + ' ' + frameworkFullPath
    process = subprocess.Popen(execScript, shell=True, stdout=subprocess.PIPE)
    out, err = process.communicate()
    print(out.decode())
    print("Return code " + format(process.returncode))



def terragruntApply(CICD_ROOT_PATH, FRAMEWORK_PATH, frameworkFullPath, module_framework, main_config, resource_type, resource_api, deploy_path, file_resource, enviroment_definition, global_definition):
    print('terragruntApply')
    execScript = "sh " + frameworkFullPath + "/script/terragrunt_apply.sh "  + CICD_ROOT_PATH + ' ' + FRAMEWORK_PATH + ' ' + module_framework + ' ' + main_config + ' ' + resource_type + ' ' + resource_api + ' ' +  deploy_path + ' ' + file_resource + ' ' + enviroment_definition + ' ' + global_definition + ' ' + frameworkFullPath
    process = subprocess.Popen(execScript, shell=True, stdout=subprocess.PIPE)
    out, err = process.communicate()
    print(out.decode())
    print("Return code " + format(process.returncode))


def terragruntDestroy(CICD_ROOT_PATH, FRAMEWORK_PATH, frameworkFullPath, module_framework, main_config, resource_type, resource_api, deploy_path, file_resource, enviroment_definition, global_definition):
    print('terragruntDestroy')
    execScript = "sh " + frameworkFullPath + "/script/terragrunt_destroy.sh "  + CICD_ROOT_PATH + ' ' + FRAMEWORK_PATH + ' ' + module_framework + ' ' + main_config + ' ' + resource_type  + ' ' + resource_api + ' ' + deploy_path + ' ' + file_resource + ' ' + enviroment_definition + ' ' + global_definition + ' ' + frameworkFullPath
    process = subprocess.Popen(execScript, shell=True, stdout=subprocess.PIPE)
    out, err = process.communicate()
    print(out.decode())
    print("Return code " + format(process.returncode))


def checkResourceDefinition(CICD_ROOT_PATH, deploy_path, file_resource):
    fullPathFileResource = CICD_ROOT_PATH  + '/' + deploy_path + '/' + file_resource 
    # print(fullPathFileResource)
    if not os.path.isfile(fullPathFileResource):
        print("File (" + file_resource + ") doesn't exist.")
        exit()
        

def checkDependencies (module_name, resource_type, dependency):
    print('checkDependencies' + '\n')
    # print(module_name + '\n')
    # print(resource_type + '\n')
    # print(dependency + '\n')


def cicdTerragrunt (CICD_ROOT_PATH, FRAMEWORK_PATH, frameworkFullPath, module_framework, main_config, hadley_file):
    # print('cicdTerragrunt \n')
    # print(FRAMEWORK_PATH + '\n')
    # print(frameworkFullPath + '\n')    
    # print(module_framework + '\n')
    # print(main_config + '\n')
    # print(hadley_file + '\n')

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
        for dependencies_in_order in module['dependencies_in_order']:
            # print(dependencies_in_order)
            checkDependencies(module_name, resource_type, dependencies_in_order)
        for resource_definition in module['resource_definition']:
            file_resource = resource_definition['file_resource']
            resource_action = resource_definition['resource_action']
            deploy_action = resource_definition['deploy_action']
            checkResourceDefinition(CICD_ROOT_PATH, deploy_path, file_resource)
            if deploy_action == 'import':
                terragruntImport(CICD_ROOT_PATH, FRAMEWORK_PATH, frameworkFullPath, module_framework, main_config, resource_type, resource_api, deploy_path, file_resource, enviroment_definition, global_definition)
            
            if deploy_action == 'create': 
                terragruntValidate(CICD_ROOT_PATH, FRAMEWORK_PATH, frameworkFullPath, module_framework, main_config, resource_type, resource_api, deploy_path, file_resource, enviroment_definition, global_definition)
      
                if resource_action == 'plan':
                    terragruntPlan(CICD_ROOT_PATH, FRAMEWORK_PATH, frameworkFullPath, module_framework, main_config, resource_type, resource_api, deploy_path, file_resource, enviroment_definition, global_definition)
           
                if resource_action == 'apply':
                    terragruntApply(CICD_ROOT_PATH, FRAMEWORK_PATH, frameworkFullPath, module_framework, main_config, resource_type, resource_api,deploy_path, file_resource, enviroment_definition, global_definition)
           
                if resource_action == 'destroy':
                    terragruntDestroy(CICD_ROOT_PATH, FRAMEWORK_PATH, frameworkFullPath, module_framework, main_config, resource_type, resource_api, deploy_path, file_resource, enviroment_definition, global_definition)
           

    file.close()    






    