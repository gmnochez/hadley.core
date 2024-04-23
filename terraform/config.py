#!/usr/bin/python

import sys
import os


CICD_ROOT_PATH = sys.argv[1]
TF_ADDRESS = sys.argv[2]
KTC_PLAN = sys.argv[3]
KTC_PLAN_JSON = sys.argv[4]
KTC_VAR = sys.argv[5]



def getCurrentFolder ():
    print ('CICD_ROOT_PATH : ' + CICD_ROOT_PATH + '\n')
    print ('TF_ADDRESS : ' + TF_ADDRESS + '\n')
    print ('KTC_PLAN : ' + KTC_PLAN + '\n')
    print ('KTC_VAR : ' + KTC_VAR + '\n')
    print('Current Path : ', os.getcwd())

getCurrentFolder()





