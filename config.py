#!/usr/bin/python

import sys
import os
import shutil
import json

CICD_ROOT_PATH = sys.argv[1]
TF_ADDRESS = sys.argv[2]
HDY_PLAN = sys.argv[3]
HDY_PLAN_JSON = sys.argv[4]
HDY_VAR = sys.argv[5]
FRAMEWORK_PATH = '.hadley'








def loadFramework ():
    print('loadFramework')
    existFile = False
    if os.path.isfile(CICD_ROOT_PATH + '/' + 'hadley.json'):
        existFile = True
    else:
        print("File hadley.json doesn't exist.   Please configure the file in you CI/CD tool")
        existFile = True
        exit()

    file = open(CICD_ROOT_PATH + '/' + 'hadley.json')
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

    file = open(CICD_ROOT_PATH + '/' + 'hadley.json')
    data = json.load(file)
    for project in data['project']:
        for config_files in project['config_files']:
            isok_iac_tool = False
            isok_main_config = False            
            isok_hadley_file = False
            iac_tool = config_files['iac_tool']
            main_config = config_files['iac_main_config']            
            hadley_file = config_files['hadley_file']



            if iac_tool == 'terragrunt':
                isok_iac_tool = True

            if os.path.isfile(CICD_ROOT_PATH + '/' + hadley_file):
                isok_hadley_file = True
            else:
                print("Configuration File (" + hadley_file + ") doesn't exist")
                exit()
                

            


            
            for modules_config in config_files['modules']:
                existModule = False
                for modules in project['modules']:
                    if modules_config == modules['name']:
                        existModule = True
                if not existModule:
                    print("Modulo not found in the configuration of the project " + project['name'])
                    exit()

            for modules in project['modules']:
                print('Downloading repository modules \n')
                modPath = CICD_ROOT_PATH + '/' + FRAMEWORK_PATH + '/' + modules['name']
                if os.path.isdir(modPath): 
                    os.system('rm -rf ' + modPath)
                    
                command = 'git clone ' + modules['repository'] + ' ' + CICD_ROOT_PATH + '/' + FRAMEWORK_PATH + '/' + modules['name']
                os.system(command)

            if os.path.isfile(CICD_ROOT_PATH + '/' + main_config):
                isok_main_config = True
            else:
                print("Configuration File (" + main_config + ") doesn't exist")    
                exit()


            if iac_tool == 'terragrunt':
                modulePath = 'cicdtool/terragrunt/terragrunt'
                module = __import__(modulePath) 
                my_class = getattr(modulePath, 'Terragrunt') 
                my_class.cicdTerragrunt(main_config, hadley_file) 
    


                

            

    file.close()








def getCurrentFolder ():
    print ('CICD_ROOT_PATH : ' + CICD_ROOT_PATH + '\n')
    print ('TF_ADDRESS : ' + TF_ADDRESS + '\n')
    print ('KTC_PLAN : ' + HDY_PLAN + '\n')
    print ('KTC_PLAN_JSON : ' + HDY_PLAN_JSON + '\n')
    print ('KTC_VAR : ' + HDY_VAR + '\n')
    print('Current Path : ', os.getcwd())
    
    HDY_VAR_FULLPATH = CICD_ROOT_PATH + '/' + HDY_VAR

    myvars = {}
    with open(HDY_VAR_FULLPATH) as myfile:
        for line in myfile:
            if line.strip() != '':
                name, var = line.partition("=")[::2]
                if var.strip() != '""':
                    myvars[name.strip()] = str(var.strip())
                    os.environ[name.strip()] = str(var.strip())


    # for tfVars in myvars:
        # print(tfVars + ' = ' + myvars[tfVars])
        # print(tfVars + ' = ' + os.environ.get(tfVars, 'Not Set'))
        
        

loadFramework()
parseHadleyFile()
# getCurrentFolder()





