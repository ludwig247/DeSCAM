#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Oct 12 16:36:46 2018

@author: Paulius Morkunas
"""
import re
import os

import argparse
parser = argparse.ArgumentParser(description='OneSpin log analyzer.')

parser.add_argument('-i', dest='inputDir', metavar='dir', default="", help='directory with OneSpin log files', required=True)
args = parser.parse_args()

import sys
if not os.path.exists(args.inputDir):
    sys.exit("Error: \"" + args.inputDir + "\" directory does not exist.")


class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

print("\n##################### Checking OneSpin *.log files #####################")

problemFoundFlag = False;
# create list of all file names in results directory
fileList = os.listdir(args.inputDir)
for file in fileList:
    if file.endswith(".log"):
        with open(args.inputDir + "/" + file) as inFile:
            failedPropertyList = list();
            failedWitnessList = list();
            vacuousPropertyList = list();
            for i, line in enumerate(inFile):
                failedProperty = re.search('-R- Property \'(.*)\' (?:fails from reset|fails within [0-9]* cycles from reset) \(.*\)', line)
                if failedProperty:
                    if failedProperty.group(1) not in failedPropertyList:
                        problemFoundFlag = True
                        failedPropertyList.append(failedProperty.group(1))
                
                failedWitness = re.search('-R- Witness computation for \'(.*)\' failed \(no witness exists\) \(.*\)', line)
                if failedWitness:
                    if failedWitness.group(1) not in failedWitnessList:
                        problemFoundFlag = True
                        failedWitnessList.append(failedWitness.group(1))
    
                vacuousProperty = re.search('-R- Property \'(.*)\' (?:is vacuous) \(.*\)', line)
                if vacuousProperty:
                    if vacuousProperty.group(1) not in vacuousPropertyList:
                        problemFoundFlag = True
                        vacuousPropertyList.append(vacuousProperty.group(1))
    
            if len(failedPropertyList) > 0:
                print(bcolors.FAIL + "\nList of failed properties for " + file + ":" + bcolors.ENDC)
                for entry in failedPropertyList:
                    print("\t" + entry)
            if len(failedWitnessList) > 0:
                print(bcolors.WARNING + "\nList of failed witnesses for " + file + ":" + bcolors.ENDC)
                for entry in failedWitnessList:
                    print("\t" + entry)
            if len(vacuousPropertyList) > 0:
                print(bcolors.WARNING + "\nList of vacuous properties for " + file + ":" + bcolors.ENDC)
                for entry in vacuousPropertyList:
                    print("\t" + entry)

if not problemFoundFlag:
    print(bcolors.OKGREEN + "\nNo problems found\n" + bcolors.ENDC)
else:
    print("\n")
