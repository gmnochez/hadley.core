#!/usr/bin/python

import sys
import os
import shutil
import json

CICD_ROOT_PATH = sys.argv[1]
FRAMEWORK_PATH = '.hadley'



def setSysPath(path):
    _path = os.path.abspath(path)
    if _path not in sys.path:
        sys.path.append(_path)


def loadHclq ():
    command = 'curl -sSLo install.sh https://install.hclq.sh && ./install.sh && rm -rf install.sh'
    os.system(command)


def loadFramework ():
    existFile = False
    if os.path.isfile(CICD_ROOT_PATH + '/' + 'hadley.json'):
        existFile = True
    else:
        print("File hadley.json doesn't exist.   Please configure the file in you CI/CD tool")
        existFile = False
        exit()

    file_config = open(CICD_ROOT_PATH + '/' + 'hadley.json')
    hadley_config = json.load(file_config)

    for hd_config in hadley_config['hadley_config']:
        hadley_config_name = hd_config['name']
        hadley_config_file_path = hd_config['config_file_path']
        
        file = open(CICD_ROOT_PATH + '/' + hadley_config_file_path)
        data = json.load(file)
        for framework in data['framework']:
            name = framework['name']
            repository = framework['repository']
            command = 'git clone ' + repository + ' ' + CICD_ROOT_PATH + '/' + FRAMEWORK_PATH
            if name == 'hadley.core':
                if not os.path.isdir(CICD_ROOT_PATH + '/' + FRAMEWORK_PATH + '/hadley.core'): 
                    os.system(command)
            else:
                os.system(command)


    file.close()


def parseHadleyFile ():
    

    existFile = False
    if os.path.isfile(CICD_ROOT_PATH + '/' + 'hadley.json'):
        existFile = True
    else:
        print("File hadley.json doesn't exist.   Please configure the file in you CI/CD tool")
        existFile = True
        exit()

    file_config = open(CICD_ROOT_PATH + '/' + 'hadley.json')
    hadley_config = json.load(file_config)
    existDeploy = False
    for hd_config in hadley_config['hadley_config']:
        hadley_config_name = hd_config['name']
        hadley_config_deploy = hd_config['deploy']
        if hadley_config_deploy != 'true':
            continue

        hadley_config_file_path = hd_config['config_file_path']
        
        file = open(CICD_ROOT_PATH + '/' + hadley_config_file_path)
        data = json.load(file)

        existDeploy = True

        for framework in data['framework']:
            frameworkName = framework['name']

        for project in data['project']:
            arrayFrameworks = [] 
            for config_files in project['config_files']:
                isok_iac_tool = False
                isok_main_config = False            
                isok_hadley_file = False
                iac_tool = config_files['iac_tool']
                main_config = config_files['iac_main_config']            
                hadley_file = config_files['hadley_file']
                config_files_deploy = config_files['deploy']
                if config_files_deploy != 'true':
                    continue


                if iac_tool == 'terragrunt':
                    isok_iac_tool = True

                if os.path.isfile(CICD_ROOT_PATH + '/' + hadley_file):
                    isok_hadley_file = True
                else:
                    print("Configuration hadley_file (" + hadley_file + ") doesn't exist")
                    exit()
                    

                existModule = False
                module = config_files['module']
                for modules in project['modules']:
                    if module == modules['name']:
                        existModule = True
                if not existModule:
                    print("Modulo not found in the configuration of the project " + project['name'])
                    exit()

                        
                for modules in project['modules']:                
                    modPath = CICD_ROOT_PATH + '/' + FRAMEWORK_PATH + '/' + modules['name']                                   
                    if arrayFrameworks.count(modPath) == 0: 
                        if os.path.isdir(modPath): 
                            os.system('rm -rf ' + modPath)
                        
                        print('Downloading repository modules ...')
                        command = 'git clone ' + modules['repository'] + ' ' + CICD_ROOT_PATH + '/' + FRAMEWORK_PATH + '/' + modules['name']
                        os.system(command)
                        arrayFrameworks.append(modPath)
                        break

                
                if main_config != "false":
                    if os.path.isfile(CICD_ROOT_PATH + '/' + main_config):
                        isok_main_config = True
                    else:
                        print("Configuration iac_main_config (" + main_config + ") doesn't exist")    
                        exit()

                frameworkPath = CICD_ROOT_PATH + '/' + FRAMEWORK_PATH + '/' + frameworkName                    
                if iac_tool == 'terragrunt':
                    frameworkFullPath = frameworkPath + '/cicdtool/terragrunt'
                    setSysPath(frameworkFullPath)
                    import terragrunt as ter 
                    ter.cicdTerragrunt(CICD_ROOT_PATH,FRAMEWORK_PATH,frameworkFullPath,module,main_config, hadley_file) 
    
                if iac_tool == 'bicep':
                    frameworkFullPath = frameworkPath + '/cicdtool/bicep'
                    setSysPath(frameworkFullPath)
                    import bicep as bcp 
                    bcp.cicdBicep(CICD_ROOT_PATH,FRAMEWORK_PATH,frameworkFullPath,module,main_config, hadley_file) 
    
                


    if existDeploy:
        file.close()
    else:
        print('Nothing set for deploy, check the file hadley.json')    

    file_config.close()



        
        
# loadHclq()
loadFramework()
parseHadleyFile()





