#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Oct 12 16:36:46 2018

@author: Paulius Morkunas
"""

import argparse
parser = argparse.ArgumentParser(description='TCL script generator.')

import os
parser.add_argument('-c', dest='cmdList', metavar='cmd', nargs = '+', default="", help='list of commands that need to be in the script')
parser.add_argument('-o', dest='outputDir', default=(os.getcwd() + "/generated"), metavar='dir', help='output directory for the generated script')
args = parser.parse_args()

if not os.path.exists(args.outputDir):
    os.makedirs(args.outputDir)

outputScript = open(args.outputDir + "/generated_script.tcl","w+")

for cmd in args.cmdList:
    outputScript.write(cmd + "\n")
    
outputScript.close()
