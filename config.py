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


def cicdTerrafom ():
    print('cicdTerrafom')





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
        command = 'git clone ' + repository + ' ' + CICD_ROOT_PATH + '/.framework'
        if name == 'hadley.core':
            if not os.path.isdir(CICD_ROOT_PATH + '/.framework' + 'hadley.core'): 
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
            isok_file = False
            
            if config_files['iac_tool'] == 'terraform':
                isok_iac_tool = True
                
            
            if os.path.isfile(CICD_ROOT_PATH + '/' + config_files['file']):
                isok_file = True
            else:
                print("Configuration File doesn't exist")
            
            if not isok_iac_tool or not isok_file:
                print('Check the properties iac_tool and file in the section config_file of the project with name ' + project['name'])
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
                if os.path.isdir(CICD_ROOT_PATH + '/.framework/' + modules['name']): 
                    shutil.rmtree(CICD_ROOT_PATH + '/.framework/' + modules['name'])
               
                command = 'git clone ' + modules['repository'] +  CICD_ROOT_PATH + '/.framework'
                os.system(command)

            cicdTerrafom()

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





