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

parser.add_argument('-ilog', dest='inputLog', metavar='*.log', default="", help='OneSpin log *.log', required=True)
parser.add_argument('-irtl', dest='inputRTL', metavar='*.vhd', default="", help='RTL implementation *.vhd', required=True)
parser.add_argument('-o', dest='outputDir', metavar='path', default="", help='Output directory for refined RTL', required=True)
args = parser.parse_args()

import sys

if not os.path.isfile(args.inputLog):
    sys.exit('Error: \'' + args.inputLog + '\' file does not exist.')
if not os.path.isfile(args.inputRTL):
    sys.exit('Error: \'' + args.inputRTL + '\' file does not exist.')
if not os.path.exists(args.outputDir):
    sys.exit('Error: \'' + args.outputDir + '\' directory does not exist.')

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
file = args.inputLog
if file.endswith(".log"):
    with open(file) as inFile:
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


outputRefined = open(args.outputDir + '/outputRefined.vhd','w+')

if not problemFoundFlag:
    print(bcolors.OKGREEN + "\nNo problems found\n" + bcolors.ENDC)
else:
    print("\n")



if problemFoundFlag:
    if failedPropertyList:
        print(bcolors.FAIL + "\nError: can't refine RTL, failed property found.\n" + bcolors.ENDC)
    else:
        file = args.inputRTL
        skipLines = 0;
        with open(file) as inFile2:
            inFile = inFile2.readlines()
            for i, line in enumerate(inFile):
                if skipLines > 0:
                    skipLines = skipLines - 1
                else:
                    if re.search('\s*type .*_operation_t is \(.*\);\s*', line, re.IGNORECASE):
                        modifiedLine = line
                        for operation in failedWitnessList:
                            matchedLine = re.search('(\s*type .*_operation_t is \(.*)(op_' + operation + ',+ +)(.*\);\s*)', modifiedLine, re.IGNORECASE)
                            if (matchedLine):
                                modifiedLine = matchedLine.group(1) + matchedLine.group(3)
                        outputRefined.write(modifiedLine)
                        print (modifiedLine)
                    elif len(inFile) > i+1 and re.search('\s*active_operation <= ', inFile[i+1], re.IGNORECASE):
                        for operation in failedWitnessList:
                            if re.search('\s*active_operation <= op_' + operation + ';\s*', inFile[i+1], re.IGNORECASE):
                                print (inFile[i+1])
#                                if re.search('\s*elsif ', line, re.IGNORECASE):
#                                    
#                                    skipLines = 2
#                                else:
#                                    skipLines = 1
                                skipLines = 1
                                break
                        if skipLines == 0:
                            outputRefined.write(line)
                    elif re.search('\s*when op_.* =>\s*', line, re.IGNORECASE):
                        for operation in failedWitnessList:
                            if re.search('\s*when op_' + operation + ' =>\s*', line, re.IGNORECASE):
                                print (line)
                                skipLines = 0
                                subline = inFile[i + skipLines + 1]
                                while not (re.search('\s*when op_.* =>\s*', subline, re.IGNORECASE) or re.search('\s*end case;\s*', subline, re.IGNORECASE)):
                                    skipLines = skipLines + 1
                                    subline = inFile[i+skipLines + 1]
                                break
                        if skipLines == 0:
                            outputRefined.write(line)
                    else:
                        #print (line)
                        outputRefined.write(line)


outputRefined.close()
