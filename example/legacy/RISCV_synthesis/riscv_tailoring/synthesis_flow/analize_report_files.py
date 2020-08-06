#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Oct 12 16:36:46 2018

@author: Paulius Morkunas
"""
import re
import os

import argparse
parser = argparse.ArgumentParser(description='Design Compiler report analyzer.')

parser.add_argument('-i', dest='inputDir', metavar='dir', default="", help='directory with Design Compiler report files', required=True)
parser.add_argument('-o', dest='outputDir', default=(os.getcwd() + "/reports"), metavar='dir', help='output directory for report files')
args = parser.parse_args()

import sys
if not os.path.exists(args.inputDir):
    sys.exit("Error: \"" + args.inputDir + "\" directory does not exist.")

if not os.path.exists(args.outputDir):
    os.makedirs(args.outputDir)



class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

print("\n##################### Checking Design Compiler *.rep files #####################")

problemFoundFlag = False;
# create list of all file names in results directory
fileList = os.listdir(args.inputDir)

import csv

from collections import defaultdict
nonameyet = defaultdict(list)

reportList = list()
programList = list()
compileTypeList = list()
for file in fileList:
    fileNameFields = re.search('^(timing|power|area|cell)_([^_]+)_([^_]+)_?([^_]*).rep$', file)
    if fileNameFields:
        reportList.append(fileNameFields.group(0))
        if fileNameFields.group(2) not in programList:
            programList.append(fileNameFields.group(2))
        if fileNameFields.group(3) not in compileTypeList:
            compileTypeList.append(fileNameFields.group(3))

# fullriscv is a special case used as a reference in data analysis, therefore is moved to the first place
#if "fullriscv" in programList:
#    index = programList.index("fullriscv")
#    programList[0], programList[index] = programList[index], programList[0]

import time
timestr = time.strftime("%Y_%m_%d_%H_%M_%S")

outputPower = open(args.outputDir + "/report_" + timestr + ".csv","w+")
filewriter = csv.writer(outputPower, delimiter=',', quotechar='|', quoting=csv.QUOTE_MINIMAL)


parameters = [
        'TPtot',
        'TPreg',
        'TPcmb',
        'TPclk',
        'IPtot',
        'IPreg',
        'IPcmb',
        'IPclk',
        'SPtot',
        'SPreg',
        'SPcmb',
        'SPclk',
        'LPtot',
        'LPreg',
        'LPcmb',
        'LPclk',
        'TA',
        'CA',
        'NCA',
        'BIA',
        ]

cellNameDict = {
        'TPtot': 'Total Power [mW] (tot)',
        'TPreg': 'Total Power [mW] (reg)',
        'TPcmb': 'Total Power [mW] (comb)',
        'TPclk': 'Total Power [mW] (clk)',
        
        'IPtot': 'Internal Power [mW] (tot)',
        'IPreg': 'Internal Power [mW] (reg)',
        'IPcmb': 'Internal Power [mW] (comb)',
        'IPclk': 'Internal Power [mW] (clk)',
        
        'SPtot': 'Switching Power [mW] (tot)',
        'SPreg': 'Switching Power [mW] (reg)',
        'SPcmb': 'Switching Power [mW] (comb)',
        'SPclk': 'Switching Power [mW] (clk)',
        
        'LPtot': 'Leakage Power [mW] (tot)',
        'LPreg': 'Leakage Power [mW] (reg)',
        'LPcmb': 'Leakage Power [mW] (comb)',
        'LPclk': 'Leakage Power [mW] (clk)',
        
        'TA': 'Total Area',
        'CA': 'Comb. Area',
        'NCA': 'Noncomb. Area',
        'BIA': 'Buf./Inv. Area',
        }


titleRow = list()
titleRow.append('CompType->')
maxWordsNum = 0
for field in parameters:
    for compileType in compileTypeList:
        titleRow.append(compileType)
        words = field.split()
        if len(words) > maxWordsNum:
            maxWordsNum = len(words)
filewriter.writerow(titleRow)

titleRow.clear()
for row in range(0, maxWordsNum):
    for index, field in enumerate(['BespName'] + parameters):
        words = (field + ":").split()
        if len(words) > row:
            word = words[row]
        else:
            word = ""
        for compileType in compileTypeList:
            titleRow.append(word)
            if index == 0:
                break
    filewriter.writerow(titleRow)
    titleRow.clear()


infoRow = [None for dummy in range(len(parameters) * len(compileTypeList) + 1)]

for program in programList:
    for file in reportList:
        fileNameFields = re.search('^(timing|power|area|cell)_' + program + '_([^_]+).rep$', file)
        if fileNameFields:
            infoRow[0] = program
            if fileNameFields.group(1) == 'power':
                with open(args.inputDir + "/" + file) as inFile:
                    for line in inFile:
                        matchedLine = re.search('Total\s+(\d+.?\d+(?:(?:e-|e\+)\d+)?)\s(\w\w?)\s+(\d+.?\d+(?:(?:e-|e\+)\d+)?)\s(\w\w?)\s+(\d+.?\d+(?:(?:e-|e\+)\d+)?)\s(\w\w?)\s+(\d+.?\d+(?:(?:e-|e\+)\d+)?)\s(\w\w?)', line)
                        if matchedLine:
                            index = 1 + parameters.index('IPtot') * len(compileTypeList) + compileTypeList.index(fileNameFields.group(2))
                            infoRow[index] = matchedLine.group(1)
                            index = 1 + parameters.index('SPtot') * len(compileTypeList) + compileTypeList.index(fileNameFields.group(2))
                            infoRow[index] = matchedLine.group(3)
                            index = 1 + parameters.index('LPtot') * len(compileTypeList) + compileTypeList.index(fileNameFields.group(2))
                            infoRow[index] = matchedLine.group(5)
                            index = 1 + parameters.index('TPtot') * len(compileTypeList) + compileTypeList.index(fileNameFields.group(2))
                            infoRow[index] = matchedLine.group(7)
                        matchedLine = re.search('clock_network\s+(\d+.?\d+(?:(?:e-|e\+)\d+)?)\s+(\d+.?\d+(?:(?:e-|e\+)\d+)?)\s+(\d+.?\d+(?:(?:e-|e\+)\d+)?)\s+(\d+.?\d+(?:(?:e-|e\+)\d+)?)\s+\(\s+(\d+\.\d+)%\)', line)
                        if matchedLine:
                            index = 1 + parameters.index('IPclk') * len(compileTypeList) + compileTypeList.index(fileNameFields.group(2))
                            infoRow[index] = matchedLine.group(1)
                            index = 1 + parameters.index('SPclk') * len(compileTypeList) + compileTypeList.index(fileNameFields.group(2))
                            infoRow[index] = matchedLine.group(2)
                            index = 1 + parameters.index('LPclk') * len(compileTypeList) + compileTypeList.index(fileNameFields.group(2))
                            infoRow[index] = matchedLine.group(3)
                            index = 1 + parameters.index('TPclk') * len(compileTypeList) + compileTypeList.index(fileNameFields.group(2))
                            infoRow[index] = matchedLine.group(4)
                            #index = 1 + parameters.index('Total Power [%](clk)') * len(compileTypeList) + compileTypeList.index(fileNameFields.group(2))
                            #infoRow[index] = matchedLine.group(5)
                        matchedLine = re.search('register\s+(\d+.?\d+(?:(?:e-|e\+)\d+)?)\s+(\d+.?\d+(?:(?:e-|e\+)\d+)?)\s+(\d+.?\d+(?:(?:e-|e\+)\d+)?)\s+(\d+.?\d+(?:(?:e-|e\+)\d+)?)\s+\(\s+(\d+\.\d+)%\)', line)
                        if matchedLine:
                            index = 1 + parameters.index('IPreg') * len(compileTypeList) + compileTypeList.index(fileNameFields.group(2))
                            infoRow[index] = matchedLine.group(1)
                            index = 1 + parameters.index('SPreg') * len(compileTypeList) + compileTypeList.index(fileNameFields.group(2))
                            infoRow[index] = matchedLine.group(2)
                            index = 1 + parameters.index('LPreg') * len(compileTypeList) + compileTypeList.index(fileNameFields.group(2))
                            infoRow[index] = matchedLine.group(3)
                            index = 1 + parameters.index('TPreg') * len(compileTypeList) + compileTypeList.index(fileNameFields.group(2))
                            infoRow[index] = matchedLine.group(4)
                            #index = 1 + parameters.index('Total Power [%](reg)') * len(compileTypeList) + compileTypeList.index(fileNameFields.group(2))
                            #infoRow[index] = matchedLine.group(5)
                        matchedLine = re.search('combinational\s+(\d+.?\d+(?:(?:e-|e\+)\d+)?)\s+(\d+.?\d+(?:(?:e-|e\+)\d+)?)\s+(\d+.?\d+(?:(?:e-|e\+)\d+)?)\s+(\d+.?\d+(?:(?:e-|e\+)\d+)?)\s+\(\s+(\d+\.\d+)%\)', line)
                        if matchedLine:
                            index = 1 + parameters.index('IPcmb') * len(compileTypeList) + compileTypeList.index(fileNameFields.group(2))
                            infoRow[index] = matchedLine.group(1)
                            index = 1 + parameters.index('SPcmb') * len(compileTypeList) + compileTypeList.index(fileNameFields.group(2))
                            infoRow[index] = matchedLine.group(2)
                            index = 1 + parameters.index('LPcmb') * len(compileTypeList) + compileTypeList.index(fileNameFields.group(2))
                            infoRow[index] = matchedLine.group(3)
                            index = 1 + parameters.index('TPcmb') * len(compileTypeList) + compileTypeList.index(fileNameFields.group(2))
                            infoRow[index] = matchedLine.group(4)
                            #index = 1 + parameters.index('Total Power [%](comb)') * len(compileTypeList) + compileTypeList.index(fileNameFields.group(2))
                            #infoRow[index] = matchedLine.group(5)
                            
            if fileNameFields.group(1) == 'area':
                with open(args.inputDir + "/" + file) as inFile:
                    for line in inFile:
                        matchedLine = re.search('Combinational area:\s+(\d+.?\d+(?:(?:e-|e\+)\d+)?)', line)
                        if matchedLine:
                            index = 1 + parameters.index('CA') * len(compileTypeList) + compileTypeList.index(fileNameFields.group(2))
                            infoRow[index] = matchedLine.group(1)
                        matchedLine = re.search('Buf/Inv area:\s+(\d+.?\d+(?:(?:e-|e\+)\d+)?)', line)
                        if matchedLine:
                            index = 1 + parameters.index('BIA') * len(compileTypeList) + compileTypeList.index(fileNameFields.group(2))
                            infoRow[index] = matchedLine.group(1)
                        matchedLine = re.search('Noncombinational area:\s+(\d+.?\d+(?:(?:e-|e\+)\d+)?)', line)
                        if matchedLine:
                            index = 1 + parameters.index('NCA') * len(compileTypeList) + compileTypeList.index(fileNameFields.group(2))
                            infoRow[index] = matchedLine.group(1)
                        matchedLine = re.search('Total cell area:\s+(\d+.?\d+(?:(?:e-|e\+)\d+)?)', line)
                        if matchedLine:
                            index = 1 + parameters.index('TA') * len(compileTypeList) + compileTypeList.index(fileNameFields.group(2))
                            infoRow[index] = matchedLine.group(1)
    filewriter.writerow(infoRow)
    infoRow = [None for dummy in range(len(parameters) * len(compileTypeList) + 1)]

for program in programList:
    for file in reportList:
        fileNameFields = re.search('^(power|area|cell)_' + program + '_(basic)_([^_]*).rep$', file)
        if fileNameFields:
            if fileNameFields.group(3) in programList:
                infoRow[0] = program + "_" + fileNameFields.group(3)
            if fileNameFields.group(1) == 'power':
                with open(args.inputDir + "/" + file) as inFile:
                    for line in inFile:
                        matchedLine = re.search('Total\s+(\d+.?\d+(?:(?:e-|e\+)\d+)?)\s(\w\w?)\s+(\d+.?\d+(?:(?:e-|e\+)\d+)?)\s(\w\w?)\s+(\d+.?\d+(?:(?:e-|e\+)\d+)?)\s(\w\w?)\s+(\d+.?\d+(?:(?:e-|e\+)\d+)?)\s(\w\w?)', line)
                        if matchedLine:
                            index = 1 + parameters.index('IPtot') * len(compileTypeList) + compileTypeList.index(fileNameFields.group(2))
                            infoRow[index] = matchedLine.group(1)
                            index = 1 + parameters.index('SPtot') * len(compileTypeList) + compileTypeList.index(fileNameFields.group(2))
                            infoRow[index] = matchedLine.group(3)
                            index = 1 + parameters.index('LPtot') * len(compileTypeList) + compileTypeList.index(fileNameFields.group(2))
                            infoRow[index] = matchedLine.group(5)
                            index = 1 + parameters.index('TPtot') * len(compileTypeList) + compileTypeList.index(fileNameFields.group(2))
                            infoRow[index] = matchedLine.group(7)
                        matchedLine = re.search('clock_network\s+(\d+.?\d+(?:(?:e-|e\+)\d+)?)\s+(\d+.?\d+(?:(?:e-|e\+)\d+)?)\s+(\d+.?\d+(?:(?:e-|e\+)\d+)?)\s+(\d+.?\d+(?:(?:e-|e\+)\d+)?)\s+\(\s+(\d+\.\d+)%\)', line)
                        if matchedLine:
                            index = 1 + parameters.index('IPclk') * len(compileTypeList) + compileTypeList.index(fileNameFields.group(2))
                            infoRow[index] = matchedLine.group(1)
                            index = 1 + parameters.index('SPclk') * len(compileTypeList) + compileTypeList.index(fileNameFields.group(2))
                            infoRow[index] = matchedLine.group(2)
                            index = 1 + parameters.index('LPclk') * len(compileTypeList) + compileTypeList.index(fileNameFields.group(2))
                            infoRow[index] = matchedLine.group(3)
                            index = 1 + parameters.index('TPclk') * len(compileTypeList) + compileTypeList.index(fileNameFields.group(2))
                            infoRow[index] = matchedLine.group(4)
                            #index = 1 + parameters.index('Total Power [%](clk)') * len(compileTypeList) + compileTypeList.index(fileNameFields.group(2))
                            #infoRow[index] = matchedLine.group(5)
                        matchedLine = re.search('register\s+(\d+.?\d+(?:(?:e-|e\+)\d+)?)\s+(\d+.?\d+(?:(?:e-|e\+)\d+)?)\s+(\d+.?\d+(?:(?:e-|e\+)\d+)?)\s+(\d+.?\d+(?:(?:e-|e\+)\d+)?)\s+\(\s+(\d+\.\d+)%\)', line)
                        if matchedLine:
                            index = 1 + parameters.index('IPreg') * len(compileTypeList) + compileTypeList.index(fileNameFields.group(2))
                            infoRow[index] = matchedLine.group(1)
                            index = 1 + parameters.index('SPreg') * len(compileTypeList) + compileTypeList.index(fileNameFields.group(2))
                            infoRow[index] = matchedLine.group(2)
                            index = 1 + parameters.index('LPreg') * len(compileTypeList) + compileTypeList.index(fileNameFields.group(2))
                            infoRow[index] = matchedLine.group(3)
                            index = 1 + parameters.index('TPreg') * len(compileTypeList) + compileTypeList.index(fileNameFields.group(2))
                            infoRow[index] = matchedLine.group(4)
                            #index = 1 + parameters.index('Total Power [%](reg)') * len(compileTypeList) + compileTypeList.index(fileNameFields.group(2))
                            #infoRow[index] = matchedLine.group(5)
                        matchedLine = re.search('combinational\s+(\d+.?\d+(?:(?:e-|e\+)\d+)?)\s+(\d+.?\d+(?:(?:e-|e\+)\d+)?)\s+(\d+.?\d+(?:(?:e-|e\+)\d+)?)\s+(\d+.?\d+(?:(?:e-|e\+)\d+)?)\s+\(\s+(\d+\.\d+)%\)', line)
                        if matchedLine:
                            index = 1 + parameters.index('IPcmb') * len(compileTypeList) + compileTypeList.index(fileNameFields.group(2))
                            infoRow[index] = matchedLine.group(1)
                            index = 1 + parameters.index('SPcmb') * len(compileTypeList) + compileTypeList.index(fileNameFields.group(2))
                            infoRow[index] = matchedLine.group(2)
                            index = 1 + parameters.index('LPcmb') * len(compileTypeList) + compileTypeList.index(fileNameFields.group(2))
                            infoRow[index] = matchedLine.group(3)
                            index = 1 + parameters.index('TPcmb') * len(compileTypeList) + compileTypeList.index(fileNameFields.group(2))
                            infoRow[index] = matchedLine.group(4)
                            #index = 1 + parameters.index('Total Power [%](comb)') * len(compileTypeList) + compileTypeList.index(fileNameFields.group(2))
                            #infoRow[index] = matchedLine.group(5)
                    filewriter.writerow(infoRow)
                    infoRow = [None for dummy in range(len(parameters) * len(compileTypeList) + 1)]

    

outputPower.close()
