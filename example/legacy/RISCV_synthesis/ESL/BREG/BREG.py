#!/usr/bin/env python3
# -*- coding: utf-8 -*-
'''
Created on Fri Oct 12 16:36:46 2018

@author: Paulius Morkunas
'''

def OPCODE_FIELD(encodedInstrBin):
    return int(encodedInstrBin[25:32], 2)

def FUNCT3_FIELD(encodedInstrBin):
    return int(encodedInstrBin[17:20], 2)

def FUNCT7_FIELD(encodedInstrBin):
    return int(encodedInstrBin[0:7], 2)

def RS1_FIELD(encodedInstrBin):
    return int(encodedInstrBin[12:17], 2)
    
def RS2_FIELD(encodedInstrBin):
    return int(encodedInstrBin[7:12], 2)

def RD_FIELD(encodedInstrBin):
    return int(encodedInstrBin[20:25], 2)

OPCODE_U1  = int('0x37', 16) #0110111
OPCODE_U2  = int('0x17', 16) #0010111
OPCODE_J   = int('0x6F', 16) #1101111
OPCODE_I_J = int('0x67', 16) #1100111
OPCODE_B   = int('0x63', 16) #1100011
OPCODE_I_L = int('0x03', 16) #0000011
OPCODE_S   = int('0x23', 16) #0100011
OPCODE_I_I = int('0x13', 16) #0010011
OPCODE_R   = int('0x33', 16) #0110011
OPCODE_I_M = int('0x0F', 16) #0001111
OPCODE_I_S = int('0x73', 16) #1110011

usedRegisters = set()
usedInstrTypes = set()

instructionFieldInfo = [
        [OPCODE_U1,  '---', '----', 'INSTR_LUI',        '---', '---', 'RD'],
        [OPCODE_U2,  '---', '----', 'INSTR_AUIPC',      '---', '---', 'RD'],
        [OPCODE_J,   '---', '----', 'INSTR_JAL',        '---', '---', 'RD'],
        [OPCODE_I_J, '---', '----', 'INSTR_JALR',       'RS1', '---', 'RD'],
        [OPCODE_B,   '0x0', '----', 'INSTR_BEQ',        'RS1', 'RS2', '--'],
        [OPCODE_B,   '0x1', '----', 'INSTR_BNE',        'RS1', 'RS2', '--'],
        [OPCODE_B,   '0x4', '----', 'INSTR_BLT',        'RS1', 'RS2', '--'],
        [OPCODE_B,   '0x5', '----', 'INSTR_BGE',        'RS1', 'RS2', '--'],
        [OPCODE_B,   '0x6', '----', 'INSTR_BLTU',       'RS1', 'RS2', '--'],
        [OPCODE_B,   '0x7', '----', 'INSTR_BGEU',       'RS1', 'RS2', '--'], 
        [OPCODE_I_L, '0x0', '----', 'INSTR_LB',         'RS1', '---', 'RD'],
        [OPCODE_I_L, '0x1', '----', 'INSTR_LH',         'RS1', '---', 'RD'],
        [OPCODE_I_L, '0x2', '----', 'INSTR_LW',         'RS1', '---', 'RD'],
        [OPCODE_I_L, '0x4', '----', 'INSTR_LBU',        'RS1', '---', 'RD'],
        [OPCODE_I_L, '0x5', '----', 'INSTR_LHU',        'RS1', '---', 'RD'],
        [OPCODE_S,   '0x0', '----', 'INSTR_SB',         'RS1', 'RS2', '--'],
        [OPCODE_S,   '0x1', '----', 'INSTR_SH',         'RS1', 'RS2', '--'],
        [OPCODE_S,   '0x2', '----', 'INSTR_SW',         'RS1', 'RS2', '--'],
        [OPCODE_I_I, '0x0', '----', 'INSTR_ADDI',       'RS1', '---', 'RD'],
        [OPCODE_I_I, '0x2', '----', 'INSTR_SLTI',       'RS1', '---', 'RD'],
        [OPCODE_I_I, '0x3', '----', 'INSTR_SLTIU',      'RS1', '---', 'RD'],
        [OPCODE_I_I, '0x4', '----', 'INSTR_XORI',       'RS1', '---', 'RD'],
        [OPCODE_I_I, '0x6', '----', 'INSTR_ORI',        'RS1', '---', 'RD'],
        [OPCODE_I_I, '0x7', '----', 'INSTR_ANDI',       'RS1', '---', 'RD'],
        [OPCODE_I_I, '0x1', '----', 'INSTR_SLLI',       'RS1', '---', 'RD'],
        [OPCODE_I_I, '0x5', '0x00', 'INSTR_SRLI',       'RS1', '---', 'RD'],
        [OPCODE_I_I, '0x5', '0x20', 'INSTR_SRAI',       'RS1', '---', 'RD'],
        [OPCODE_R,   '0x0', '0x00', 'INSTR_ADD',        'RS1', 'RS2', 'RD'],
        [OPCODE_R,   '0x0', '0x20', 'INSTR_SUB',        'RS1', 'RS2', 'RD'],
        [OPCODE_R,   '0x1', '----', 'INSTR_SLL',        'RS1', 'RS2', 'RD'],
        [OPCODE_R,   '0x2', '----', 'INSTR_SLT',        'RS1', 'RS2', 'RD'],
        [OPCODE_R,   '0x3', '----', 'INSTR_SLTU',       'RS1', 'RS2', 'RD'],
        [OPCODE_R,   '0x4', '----', 'INSTR_XOR',        'RS1', 'RS2', 'RD'],
        [OPCODE_R,   '0x5', '0x00', 'INSTR_SRL',        'RS1', 'RS2', 'RD'],
        [OPCODE_R,   '0x5', '0x20', 'INSTR_SRA',        'RS1', 'RS2', 'RD'],
        [OPCODE_R,   '0x6', '----', 'INSTR_OR',         'RS1', 'RS2', 'RD'],
        [OPCODE_R,   '0x7', '----', 'INSTR_AND',        'RS1', 'RS2', 'RD'],
        [OPCODE_R,   '0x1', '----', 'INSTR_SLL',        'RS1', 'RS2', 'RD'],
        [OPCODE_R,   '0x2', '----', 'INSTR_SLT',        'RS1', 'RS2', 'RD'],
        # Multicore memory mamagement instructions
        [OPCODE_I_M, '0x0', '----', 'INSTR_FENCE',      '---', '---', '--'],
        [OPCODE_I_M, '0x1', '----', 'INSTR_FENCE.I',    '---', '---', '--'],
        # Environment Call and Breakpoint (Privileged Instructions)
        [OPCODE_I_S, '0x0', '0x00', 'INSTR_ECALL',      '---', '0x0', '--'],
        [OPCODE_I_S, '0x0', '0x00', 'INSTR_EBREAK',     '---', '0x1', '--'],
        # Trap-Return Instructions (Privileged Instructions)
        [OPCODE_I_S, '0x0', '0x00', 'INSTR_URET',       '---', '0x2', '--'],
        [OPCODE_I_S, '0x0', '0x08', 'INSTR_SRET',       '---', '0x2', '--'],
        [OPCODE_I_S, '0x0', '0x18', 'INSTR_MRET',       '---', '0x2', '--'],
        # Interrupt-Management Instructions (Privileged Instructions)
        [OPCODE_I_S, '0x0', '0x08', 'INSTR_WFI',        '---', '0x5', '--'],
        # Memory-Management Instructions (Privileged Instructions)
        # NOTE: Source registers RS2 RS1 for SFENCE.VMA instruction are ommited because this instruction is not supported at this stage
        [OPCODE_I_S, '0x0', '0x09', 'INSTR_SFENCE.VMA', '---', '---', '--'],
        # Status register instructions
        [OPCODE_I_S, '0x1', '----', 'INSTR_CSRRW',      'RS1', '---', 'RD'],
        [OPCODE_I_S, '0x2', '----', 'INSTR_CSRRS',      'RS1', '---', 'RD'],
        [OPCODE_I_S, '0x3', '----', 'INSTR_CSRRC',      'RS1', '---', 'RD'],
        [OPCODE_I_S, '0x5', '----', 'INSTR_CSRRWI',     '---', '---', 'RD'],
        [OPCODE_I_S, '0x6', '----', 'INSTR_CSRRSI',     '---', '---', 'RD'],
        [OPCODE_I_S, '0x7', '----', 'INSTR_CSRRCI',     '---', '---', 'RD']]

import sys
def parseInstruction(encodedInstrBin):
    for index, info in enumerate(instructionFieldInfo):
        if info[0] == OPCODE_FIELD(encodedInstrBin):
            if info[1][:2] != '0x' or FUNCT3_FIELD(encodedInstrBin) == int(info[1], 16):
                if info[2][:2] != '0x' or FUNCT7_FIELD(encodedInstrBin) == int(info[2], 16):
                    if info[5][:2] != '0x' or RS2_FIELD(encodedInstrBin) == int(info[5], 16):
                        usedInstrTypes.add(info[3])
                        if info[4] == 'RS1':
                            usedRegisters.add(RS1_FIELD(encodedInstrBin))
                        if info[5] == 'RS2':
                            usedRegisters.add(RS2_FIELD(encodedInstrBin))
                        if info[6] == 'RD':
                            usedRegisters.add(RD_FIELD(encodedInstrBin))
                        return
    print('WARNING: unsupported instruction type encountered (address: 0x' + matchString.group(1) + ')')


import argparse
import os

parser = argparse.ArgumentParser(description='Bespoke RISC-V ESL generator.')
parser.add_argument('-f', dest='asmFile', default='', metavar='path', help='path to RISC-V assembly file (*.asm)')
parser.add_argument('-o', dest='outputDir', default=(os.getcwd() + '/generated'), metavar='dir', help='Output directory for generated files')
parser.add_argument('-i', dest='interfacesInclude', default='', metavar='path', help='CPU_Interfaces.h include path')
parser.add_argument('-w', dest='werbose', default=False, action='store_true', help='Report used resources')
parser.add_argument('-r', dest='reorder', default=False, action='store_true', help='Enable reordering (in functions move most complex condition to else branch)')
parser.add_argument('-m', dest='modulesDir', default=(os.getcwd() + '/modules/'), metavar='dir', help='Directory containing ESL modules and snippets')
parser.add_argument('-nocsr', dest='nocsr', default=False, action='store_true', help='Do not include CSR functionality in full riscv generation')
parser.add_argument('-nosyscall', dest='nosyscall', default=False, action='store_true', help='Do not include system call functionality in full riscv generation')

args = parser.parse_args()

if args.asmFile != '':
    if not os.path.isfile(args.asmFile):
        sys.exit('Error: \'' + args.asmFile + '\' assembly file does not exist.')

if not os.path.isdir(args.modulesDir):
    sys.exit('Error: \'' + args.modulesDir + '\' directory does not exist, specify correct module directory.')

if not os.path.exists(args.outputDir):
    os.makedirs(args.outputDir)

print('###################### Bespoke RISC-V generation started #######################')

import re

if args.asmFile != '':
    programMemoryRegionFlag = False
    with open(args.asmFile) as asmFile:
        for line in asmFile:
            if programMemoryRegionFlag == False and re.search(r'^(?:Disassembly of section .)(?:text).*:\s$', line):
               programMemoryRegionFlag = True
            elif programMemoryRegionFlag == True:
                if re.search(r'^(?:Disassembly of section .)(?!text).*:\s$', line):
                    programMemoryRegionFlag = False
                else:
                    matchString = re.search(r'^(?:[\ \t]*([0-9a-fA-F]+):[\ \t]+([0-9a-fA-F]{8})[\ \t]+)([a-zA-Z \.]{1,5})(?:[\ \t]+)?(.*)?\s?$', line)
                    if matchString:
                        encodedInstrBin = bin(int(matchString.group(2), 16))[2:].zfill(32)
                        parseInstruction(encodedInstrBin)
else:
    print('INFO: No assembly program was specified, generating full RISC-V ESL description.')
    usedInstrTypes = [field[3] for field in instructionFieldInfo]
    usedRegisters = [i for i in range(32)]

if args.nocsr:
    for instr in usedInstrTypes[:]:
        if instr[:10] == 'INSTR_CSRR':
            usedInstrTypes.remove(instr)

if args.nosyscall:
    for instr in usedInstrTypes[:]:
        if instr in ['INSTR_ECALL', 'INSTR_URET', 'INSTR_SRET', 'INSTR_MRET', 'INSTR_WFI', 'INSTR_SFENCE.VMA']:
            usedInstrTypes.remove(instr)

usedInstrTypes = list(usedInstrTypes)
usedRegisters = list(usedRegisters)

# End of assembly parser
############################################################################################
# Beginning of RISC-V generator

#TODO: doesnt handle empty files

# Contains information about all supported instructions
instructionInfoDict = {
        'INSTR_LUI':    ['ENC_U',   'ALU_COPY1', '-'],
        'INSTR_AUIPC':  ['ENC_U',   'ALU_ADD',   '-'],
        'INSTR_JAL':    ['ENC_J',   '-',         '-'],
        'INSTR_JALR':   ['ENC_I_J', '-',         '-'],
        'INSTR_BEQ':    ['ENC_B',   'ALU_SUB',   '-'],
        'INSTR_BNE':    ['ENC_B',   'ALU_SUB',   '-'],
        'INSTR_BLT':    ['ENC_B',   'ALU_SLT',   '-'],
        'INSTR_BGE':    ['ENC_B',   'ALU_SLT',   '-'],
        'INSTR_BLTU':   ['ENC_B',   'ALU_SLTU',  '-'],
        'INSTR_BGEU':   ['ENC_B',   'ALU_SLTU',  '-'],
        'INSTR_LB':     ['ENC_I_L', 'ALU_ADD',   'MT_B'],
        'INSTR_LH':     ['ENC_I_L', 'ALU_ADD',   'MT_H'],
        'INSTR_LW':     ['ENC_I_L', 'ALU_ADD',   'MT_W'],
        'INSTR_LBU':    ['ENC_I_L', 'ALU_ADD',   'MT_BU'],
        'INSTR_LHU':    ['ENC_I_L', 'ALU_ADD',   'MT_HU'],
        'INSTR_SB':     ['ENC_S',   'ALU_ADD',   'MT_B'],
        'INSTR_SH':     ['ENC_S',   'ALU_ADD',   'MT_H'],
        'INSTR_SW':     ['ENC_S',   'ALU_ADD',   'MT_W'],
        'INSTR_ADDI':   ['ENC_I_I', 'ALU_ADD',   '-'],
        'INSTR_SLTI':   ['ENC_I_I', 'ALU_SLT',   '-'],
        'INSTR_SLTIU':  ['ENC_I_I', 'ALU_SLTU',  '-'],
        'INSTR_XORI':   ['ENC_I_I', 'ALU_XOR',   '-'],
        'INSTR_ORI':    ['ENC_I_I', 'ALU_OR',    '-'],
        'INSTR_ANDI':   ['ENC_I_I', 'ALU_AND',   '-'],
        'INSTR_SLLI':   ['ENC_I_I', 'ALU_SLL',   '-'],
        'INSTR_SRLI':   ['ENC_I_I', 'ALU_SRL',   '-'],
        'INSTR_SRAI':   ['ENC_I_I', 'ALU_SRA',   '-'],
        'INSTR_ADD':    ['ENC_R',   'ALU_ADD',   '-'],
        'INSTR_SUB':    ['ENC_R',   'ALU_SUB',   '-'],
        'INSTR_SLL':    ['ENC_R',   'ALU_SLL',   '-'],
        'INSTR_SLT':    ['ENC_R',   'ALU_SLT',   '-'],
        'INSTR_SLTU':   ['ENC_R',   'ALU_SLTU',  '-'],
        'INSTR_XOR':    ['ENC_R',   'ALU_XOR',   '-'],
        'INSTR_SRL':    ['ENC_R',   'ALU_SRL',   '-'],
        'INSTR_SRA':    ['ENC_R',   'ALU_SRA',   '-'],
        'INSTR_OR':     ['ENC_R',   'ALU_OR',    '-'],
        'INSTR_AND':    ['ENC_R',   'ALU_AND',   '-'],
        'INSTR_ECALL':  ['ENC_I_S', '-',         '-'],
        'INSTR_MRET':   ['ENC_I_S', '-',         '-'],
        'INSTR_CSRRW':  ['ENC_I_S', '-',         '-'],
        'INSTR_CSRRS':  ['ENC_I_S', '-',         '-'],
        'INSTR_CSRRC':  ['ENC_I_S', '-',         '-'],
        'INSTR_CSRRWI': ['ENC_I_S', '-',         '-'],
        'INSTR_CSRRSI': ['ENC_I_S', '-',         '-'],
        'INSTR_CSRRCI': ['ENC_I_S', '-',         '-']}


from collections import defaultdict
encToInstrDict = defaultdict(list)

moduleList = list()

for instr in instructionInfoDict:
    encToInstrDict[instructionInfoDict[instr][0]].append(instr)


# Order and remove unsupported instructions
usedEncTypes = list()
for instr in usedInstrTypes:
    if instr not in instructionInfoDict:
        if instr != 'INSTR_EBREAK':
            print('WARNING: Instruction ' + instr[6:] + ' is not supported and therefore will act as NOP.')
        else:
            print('WARNING: Instruction ' + instr[6:] + ' is used to stop ESL simulation, otherwise acts as NOP.')
        # ENC_X encryption is needed to allow ignoring of unsupported instructions
        if 'ENC_X' not in usedEncTypes:
            usedEncTypes.append('ENC_X')
usedInstrTypes = [instr for instr in instructionInfoDict if instr in usedInstrTypes]

# Determine used encryption types
for instr in usedInstrTypes:
    enc = instructionInfoDict[instr][0]
    if enc not in usedEncTypes:
         usedEncTypes.append(enc)
    del enc
    
# Determine used ALU types
usedAluFuncTypes = list()
for instr in instructionInfoDict:
    if instr in usedInstrTypes:
        func = instructionInfoDict[instr][1]
        if func != '-' and func not in usedAluFuncTypes:
             usedAluFuncTypes.append(func)
        del func

# Determine used memory mask types
usedMemoryMaskTypes = list()
for instr in instructionInfoDict:
    if instr in usedInstrTypes:
        mask = instructionInfoDict[instr][2]
        if mask != '-' and mask not in usedMemoryMaskTypes:
             usedMemoryMaskTypes.append(mask)
        del mask

from collections import defaultdict
usedEncInstrTypes = defaultdict(list)
for instr in usedInstrTypes:
    for enc in usedEncTypes:
        if instr in encToInstrDict[enc]:
            usedEncInstrTypes[enc].append(instr)
            break


instructionConditionDict = {
        'INSTR_SLL':    'FUNCT3_FIELD(encodedInstr) == 0x1',
        'INSTR_SLT':    'FUNCT3_FIELD(encodedInstr) == 0x2',
        'INSTR_SLTU':   'FUNCT3_FIELD(encodedInstr) == 0x3',
        'INSTR_XOR':    'FUNCT3_FIELD(encodedInstr) == 0x4',
        'INSTR_OR':     'FUNCT3_FIELD(encodedInstr) == 0x6',
        'INSTR_AND':    'FUNCT3_FIELD(encodedInstr) == 0x7',
        'INSTR_ADDI':   'FUNCT3_FIELD(encodedInstr) == 0x0',
        'INSTR_SLLI':   'FUNCT3_FIELD(encodedInstr) == 0x1',
        'INSTR_SLTI':   'FUNCT3_FIELD(encodedInstr) == 0x2',
        'INSTR_SLTIU':  'FUNCT3_FIELD(encodedInstr) == 0x3',
        'INSTR_XORI':   'FUNCT3_FIELD(encodedInstr) == 0x4',
        'INSTR_ORI':    'FUNCT3_FIELD(encodedInstr) == 0x6',
        'INSTR_ANDI':   'FUNCT3_FIELD(encodedInstr) == 0x7',
        'INSTR_LB':     'FUNCT3_FIELD(encodedInstr) == 0x0',
        'INSTR_LH':     'FUNCT3_FIELD(encodedInstr) == 0x1',
        'INSTR_LW':     'FUNCT3_FIELD(encodedInstr) == 0x2',
        'INSTR_LBU':    'FUNCT3_FIELD(encodedInstr) == 0x4',
        'INSTR_LHU':    'FUNCT3_FIELD(encodedInstr) == 0x5',
        'INSTR_SB':     'FUNCT3_FIELD(encodedInstr) == 0x0',
        'INSTR_SH':     'FUNCT3_FIELD(encodedInstr) == 0x1',
        'INSTR_SW':     'FUNCT3_FIELD(encodedInstr) == 0x2',
        'INSTR_BEQ':    'FUNCT3_FIELD(encodedInstr) == 0x0',
        'INSTR_BNE':    'FUNCT3_FIELD(encodedInstr) == 0x1',
        'INSTR_BLT':    'FUNCT3_FIELD(encodedInstr) == 0x4',
        'INSTR_BGE':    'FUNCT3_FIELD(encodedInstr) == 0x5',
        'INSTR_BLTU':   'FUNCT3_FIELD(encodedInstr) == 0x6',
        'INSTR_BGEU':   'FUNCT3_FIELD(encodedInstr) == 0x7',
        'INSTR_ADD':    'FUNCT3_FIELD(encodedInstr) == 0x0 && FUNCT7_FIELD(encodedInstr) == 0x00',
        'INSTR_SUB':    'FUNCT3_FIELD(encodedInstr) == 0x0 && FUNCT7_FIELD(encodedInstr) == 0x20',
        'INSTR_SRL':    'FUNCT3_FIELD(encodedInstr) == 0x5 && FUNCT7_FIELD(encodedInstr) == 0x00',
        'INSTR_SRA':    'FUNCT3_FIELD(encodedInstr) == 0x5 && FUNCT7_FIELD(encodedInstr) == 0x20',
        'INSTR_SRLI':   'FUNCT3_FIELD(encodedInstr) == 0x5 && FUNCT7_FIELD(encodedInstr) == 0x00',
        'INSTR_SRAI':   'FUNCT3_FIELD(encodedInstr) == 0x5 && FUNCT7_FIELD(encodedInstr) == 0x20',
        'INSTR_LUI':    'OPCODE_FIELD(encodedInstr) == OPCODE_U1',
        'INSTR_AUIPC':  'OPCODE_FIELD(encodedInstr) == OPCODE_U2',
        'INSTR_ECALL':  'FUNCT3_FIELD(encodedInstr) == 0x0 && FUNCT7_FIELD(encodedInstr) == 0x00 && RS2_FIELD(encodedInstr) == 0x0',
        'INSTR_MRET':   'FUNCT3_FIELD(encodedInstr) == 0x0 && FUNCT7_FIELD(encodedInstr) == 0x18 && RS2_FIELD(encodedInstr) == 0x2',
        'INSTR_CSRRW':  'FUNCT3_FIELD(encodedInstr) == 0x1',
        'INSTR_CSRRS':  'FUNCT3_FIELD(encodedInstr) == 0x2',
        'INSTR_CSRRC':  'FUNCT3_FIELD(encodedInstr) == 0x3',
        'INSTR_CSRRWI': 'FUNCT3_FIELD(encodedInstr) == 0x5',
        'INSTR_CSRRSI': 'FUNCT3_FIELD(encodedInstr) == 0x6',
        'INSTR_CSRRCI': 'FUNCT3_FIELD(encodedInstr) == 0x7'}



encryptionConditionDict = {
        'ENC_R':   'OPCODE_FIELD(encodedInstr) == OPCODE_R',
        'ENC_I_I': 'OPCODE_FIELD(encodedInstr) == OPCODE_I_I',
        'ENC_I_L': 'OPCODE_FIELD(encodedInstr) == OPCODE_I_L',
        'ENC_I_J': 'OPCODE_FIELD(encodedInstr) == OPCODE_I_J',
        'ENC_S':   'OPCODE_FIELD(encodedInstr) == OPCODE_S',
        'ENC_B':   'OPCODE_FIELD(encodedInstr) == OPCODE_B',
        'ENC_J':   'OPCODE_FIELD(encodedInstr) == OPCODE_J',
        'ENC_I_S': 'OPCODE_FIELD(encodedInstr) == OPCODE_I_S',
        'ENC_U':   'OPCODE_FIELD(encodedInstr) == OPCODE_U1 || OPCODE_FIELD(encodedInstr) == OPCODE_U2',
        'ENC_X':   ''}# must be in else branch


memoryMaskConditionDict = defaultdict(list)
for instr in instructionInfoDict:
    if instructionInfoDict[instr][2] != '-':
        memoryMaskConditionDict[instructionInfoDict[instr][2]].append(instr)

aluFuncConditionDict = defaultdict(list)
for instr in instructionInfoDict:
    if instructionInfoDict[instr][1] != '-':
        aluFuncConditionDict[instructionInfoDict[instr][1]].append(instr)

if args.werbose:
    print('\nUsed encryption types:')
    for entry in usedEncTypes:
        print(entry)
    print('\nUsed instructions types:')
    for entry in usedInstrTypes:
        print(entry)
    print('\nUsed registers:')
    for entry in usedRegisters:
        print(entry)
    print('\nUsed ALU functions:')
    for entry in usedAluFuncTypes:
        print(entry)
    print('\nUsed memory masks:')
    for entry in usedMemoryMaskTypes:
        print(entry)

csrUsedFlag = False
for instr in usedInstrTypes:
    if instr[:10] == 'INSTR_CSRR':
        csrUsedFlag = True


if "INSTR_ECALL" in usedInstrTypes or "INSTR_MRET" in usedInstrTypes:
    syscallUsedFlag = True
else:
    syscallUsedFlag = False

####################################################################################################################################
moduleList.append("ISA.h")
outputISA = open(args.outputDir + '/ISA.h','w+')

# Print file include guard ====================================================
outputISA.write('\
#ifndef RISCV_ISA_H_\n\
#define RISCV_ISA_H_\n\n')

# Print includes ==============================================================
outputISA.write('\
#include "systemc.h"\n\
#include "Interfaces.h"\n\
#include "CPU_Interfaces.h"\n\n')

# Print defines ===============================================================
outputISA.write('\
#define OPCODE_U1  0x37 //0110111\n\
#define OPCODE_U2  0x17 //0010111\n\
#define OPCODE_J   0x6F //1101111\n\
#define OPCODE_I_J 0x67 //1100111\n\
#define OPCODE_B   0x63 //1100011\n\
#define OPCODE_I_L 0x03 //0000011\n\
#define OPCODE_S   0x23 //0100011\n\
#define OPCODE_I_I 0x13 //0010011\n\
#define OPCODE_R   0x33 //0110011\n\
#define OPCODE_I_S 0x73 //1110011\n\
\n\
#define OPCODE_FIELD(x) ((x) & 0x7F)\n\
#define FUNCT3_FIELD(x) (((x) >> 12) & 0x07)\n\
#define FUNCT7_FIELD(x) (((x) >> 25) & 0x7F)\n\
#define RS1_FIELD(x)    (((x) >> 15) & 0x1F)\n\
#define RS2_FIELD(x)    (((x) >> 20) & 0x1F)\n\
#define RD_FIELD(x)     (((x) >> 7) & 0x1F)\n\
#define SIGN_FIELD(x)   (((x) >> 31) & 0x1)\n\
\n\
#define IMM_U_FIELD(x)      ((x) & static_cast<unsigned int>(0xFFFFF000))\n\
#define POS_IMM_I_FIELD(x)  ((x) >> 20)\n\
#define POS_IMM_S_FIELD(x)  ((((x) >> 20) & 0xFE0) | (((x) >> 7) & 0x1F))\n\
#define POS_IMM_B_FIELD(x)  ((((x) << 4) & 0x800) | (((x) >> 20) & 0x7E0) | (((x) >> 7) & 0x1E))\n\
#define POS_IMM_J_FIELD(x)  (((x) & 0xFF000) | (((x) >> 9) & 0x800) | (((x) >> 20) & 0x7FE))\n\
#define NEG_IMM_I_FIELD(x)  (static_cast<unsigned int>(0xFFFFF000) | POS_IMM_I_FIELD(x))\n\
#define NEG_IMM_S_FIELD(x)  (static_cast<unsigned int>(0xFFFFF000) | POS_IMM_S_FIELD(x))\n\
#define NEG_IMM_B_FIELD(x)  (static_cast<unsigned int>(0xFFFFF000) | POS_IMM_B_FIELD(x))\n\
#define NEG_IMM_J_FIELD(x)  (static_cast<unsigned int>(0xFFF00000) | POS_IMM_J_FIELD(x))\n\
\n')

if csrUsedFlag:
    outputISA.write('\
#define MCSR_MSTATUS 0x300\n\
#define MCSR_MIE     0x304\n\
#define MCSR_MTVEC   0x305\n\
#define MCSR_MEPC    0x341\n\
#define MCSR_MCAUSE  0x342\n\
#define MCSR_MIP     0x344\n\
\n\
#define MSTATUS_MIE(x)  ((x) & 0x00000008)\n\
#define MTRAP_ML12I(x)  ((x) & 0x00001000)\n\
#define MTRAP_MEI(x)    ((x) & 0x00000800)\n\
#define MTRAP_MSI(x)    ((x) & 0x00000008)\n\
#define MTRAP_MTI(x)    ((x) & 0x00000080)\n\n')

# Print enumerators ===========================================================
# TODO move enummerator inside module next to sections enum?
outputISA.write('enum EncType {\n')
for enc in usedEncTypes:
    outputISA.write('\t' + enc + ',\n')
outputISA.write('};\n\n')

outputISA.write('enum InstrType {\n')
for instr in usedInstrTypes:
    if instr in instructionConditionDict:
        outputISA.write('\t' + instr + ',\n')
    else:
        outputISA.write('\t//' + instr + ',\n')
outputISA.write('};\n\n')

outputISA.write('enum ALUfuncType {\n')
for func in usedAluFuncTypes:
    outputISA.write('\t' + func + ',\n')
outputISA.write('};\n\n')

outputISA.write('\
class ISA : public sc_module {\n\
public:\n\
\tSC_HAS_PROCESS(ISA);\n\
\tISA(sc_module_name name) :\n\
\t\t\tfromMemoryPort("fromMemoryPort"),\n\
\t\t\ttoMemoryPort("toMemoryPort"),\n\
\t\t\ttoRegsPort("toRegsPort"),\n\
\t\t\tfromRegsPort("fromRegsPort"),\n')
if csrUsedFlag:
    outputISA.write('\
\t\t\tmip_isa_Port("mipPort"),\n')
if syscallUsedFlag:
    outputISA.write('\
\t\t\tisa_syscall_Port("isa_syscall_Port"),\n\
\t\t\tsyscall_isa_Port("syscall_isa_Port"),\n\
\t\t\tsysRES(true),\n')
outputISA.write('\
\t\t\tsection(fetch),\n\
\t\t\tnextsection(fetch),\n\
\t\t\tpcReg(0) {\n\
\t\tSC_THREAD(run);\n\
\t}\n\
\t// ports for communication with memory/decoder\n\
\tblocking_out<CUtoME_IF> toMemoryPort;\n\
\tblocking_in<MEtoCU_IF> fromMemoryPort;\n\
\t// ports for communication with register file\n\
\tmaster_in<RegfileType> fromRegsPort;\n\
\tmaster_out<RegfileWriteType> toRegsPort;\n\
\t// data for communication with memory\n\
\tCUtoME_IF toMemoryData;\n\
\tMEtoCU_IF fromMemoryData;\n\
\t// data for communication with register file\n\
\tRegfileWriteType toRegsData;\n\
\tRegfileType fromRegsData;\n')
if csrUsedFlag:
    outputISA.write('\
\t// port for communication with mip module\n\
\tmaster_in<unsigned int> mip_isa_Port;\n')
if syscallUsedFlag:
    outputISA.write('\
\t// ports for communication with syscallHandler\n\
\tblocking_out<bool> isa_syscall_Port;\n\
\tblocking_in<bool> syscall_isa_Port;\n')
outputISA.write('\
\t// ISA sections\n\
\tenum Sections {\n\
\t\tfetch,  // fetch next instruction from memory\n\
\t\texecute // decode the fetched instruction and do all the manipulations till writing back to the register file\n\
\t};\n\
\tSections section, nextsection;\n\
\t// Other control signals:\n\
\tunsigned int encodedInstr;\n\
\tunsigned int pcReg;\n')
if len(usedAluFuncTypes) >= 1:
    outputISA.write('\
\tunsigned int aluOp1;\n\
\tunsigned int aluOp2;\n\
\tunsigned int aluResult;\n')
    
if syscallUsedFlag:
    outputISA.write('\
\t// data for communication with syscallHandler\n\
\tbool sysRES;\n')
    
if csrUsedFlag:
    outputISA.write('\
\tunsigned int mstatus;\n\
\tunsigned int mie;\n\
\tunsigned int mtvec;\n\
\tunsigned int mepc;\n\
\tunsigned int mcause;\n\
\tunsigned int mip;\n\n')

# Print functions =============================================================
outputISA.write('\
\tvoid run();\n\
\t//Decoding functions\n\
\tEncType getEncType(unsigned int encodedInstr) const;\n\
\tInstrType getInstrType(unsigned int encodedInstr) const;\n')

if len(usedEncTypes) >= 2 or (len(usedEncTypes) >= 1 and 'ENC_R' not in usedEncTypes):
    outputISA.write('\tunsigned int getImmediate(unsigned int encodedInstr) const;\n')

if len(usedMemoryMaskTypes) >= 1:
    outputISA.write('\tME_MaskType getMemoryMask(InstrType instr) const;\n')

if len(usedAluFuncTypes) >= 1:
    outputISA.write('\
\tALUfuncType getALUfunc(InstrType instr) const;\n\
\tunsigned int getALUresult(ALUfuncType aluFunction, unsigned int operand1, unsigned int operand2) const;\n')

if 'ENC_B' in usedEncTypes:
    outputISA.write('\tunsigned int getBranchResult(unsigned int encodedInstr, unsigned int aluResult, unsigned int pcReg) const;\n')

if len(usedRegisters) >= 1:
    outputISA.write('\tunsigned int readRegfile(unsigned int src, RegfileType fromRegsData) const;\n')

if csrUsedFlag:
    outputISA.write('\tunsigned int getCSR(unsigned int mstatus, unsigned int mie, unsigned int mtvec, unsigned int mepc, unsigned int mip, unsigned int mcause, unsigned int encodedInstr) const;\n')
    outputISA.write('\tunsigned int getCSRresult(InstrType instr, unsigned int rs1, unsigned int csr) const;\n') 
    outputISA.write('\tunsigned int updateMCAUSE(unsigned int mstatus, unsigned int mie, unsigned int mip, unsigned int mcause) const;\n')
    outputISA.write('\tunsigned int updateMSTATUS(unsigned int mstatus, unsigned int mie, unsigned int mip, unsigned int mcause) const;\n')
    outputISA.write('\tunsigned int updateMEPC(unsigned int mstatus, unsigned int mie, unsigned int mip, unsigned int mcause, unsigned int mepc, unsigned int pcReg) const;\n')
    outputISA.write('\tunsigned int updatePC(unsigned int mstatus, unsigned int mie, unsigned int mip, unsigned int mcause, unsigned int mtvec, unsigned int pcReg) const;\n')


outputISA.write('\
};\n\
void ISA::run() {\n\
#pragma clang diagnostic push\n\
#pragma clang diagnostic ignored "-Wmissing-noreturn"\n\
\twhile (true) {\n\
\t\tif (section == Sections::fetch) {\n\
\t\t\ttoMemoryData.req = ME_RD;\n\
\t\t\ttoMemoryData.mask = MT_W;\n\
\t\t\ttoMemoryData.addrIn = pcReg;\n\
\t\t\ttoMemoryData.dataIn = 0;\n\
\t\t\ttoMemoryPort->write(toMemoryData);\n\
\t\t\tfromMemoryPort->read(fromMemoryData);\n\
\t\t\tencodedInstr = fromMemoryData.loadedData;\n\
#ifdef SC_SIMULATE\n\
\t\t\t/// Terminating instruction EBREAK\n\
\t\t\tif (fromMemoryData.loadedData == 0x100073) {\n\
\t\t\t\tstd::cout << "Terminating instruction (EBREAK)" << std::endl;\n\
\t\t\t\tsc_stop();\n\
\t\t\t\twait(SC_ZERO_TIME);\n\
\t\t\t}\n\
#endif\n\
\t\t\tnextsection = Sections::execute;\n\
\t\t} else if (section == Sections::execute) {\n')

firstEncType = ''
lastEncType = 'ENC_X'
for index, enc in enumerate(usedEncTypes):
    if enc != 'ENC_X' and firstEncType == '':
        firstEncType = enc
    if 'ENC_X' not in usedEncTypes and index == len(usedEncTypes)-1:
        lastEncType = enc

if 'ENC_U' in usedEncTypes:
    if lastEncType != 'ENC_U':
        if firstEncType == 'ENC_U':
            outputISA.write('\t\t\tif (')
        else:
            outputISA.write(' else if (')
        outputISA.write('getEncType(encodedInstr) == ENC_U) {\n')
    else:
        outputISA.write(' else {\n')
    outputISA.write('\
\t\t\t\taluOp1 = getImmediate(encodedInstr);\n\
\t\t\t\taluOp2 = pcReg;\n\
\t\t\t\taluResult = getALUresult(getALUfunc(getInstrType(encodedInstr)), aluOp1, aluOp2);\n\
\t\t\t\ttoRegsData.dst = RD_FIELD(encodedInstr);\n\
\t\t\t\ttoRegsData.dstData = aluResult;\n\
\t\t\t\ttoRegsPort->write(toRegsData);\n\
\t\t\t\tpcReg = pcReg + 4;\n\
\t\t\t}')

if 'ENC_J' in usedEncTypes:
    if lastEncType != 'ENC_J':
        if firstEncType == 'ENC_J':
            outputISA.write('\t\t\tif (')
        else:
            outputISA.write(' else if (')
        outputISA.write('getEncType(encodedInstr) == ENC_J) {\n')
    else:
        outputISA.write(' else {\n')
    outputISA.write('\
\t\t\t\ttoRegsData.dst = RD_FIELD(encodedInstr);\n\
\t\t\t\ttoRegsData.dstData = pcReg + 4;\n\
\t\t\t\ttoRegsPort->write(toRegsData);\n\
\t\t\t\tpcReg = pcReg + getImmediate(encodedInstr);\n\
\t\t\t}')

if 'ENC_I_J' in usedEncTypes:
    if lastEncType != 'ENC_I_J':
        if firstEncType == 'ENC_I_J':
            outputISA.write('\t\t\tif (')
        else:
            outputISA.write(' else if (')
        outputISA.write('getEncType(encodedInstr) == ENC_I_J) {\n')
    else:
        outputISA.write(' else {\n')
    outputISA.write('\
\t\t\t\tfromRegsPort->read(fromRegsData);\n\
\t\t\t\ttoRegsData.dst = RD_FIELD(encodedInstr);\n\
\t\t\t\ttoRegsData.dstData = pcReg + 4;\n\
\t\t\t\ttoRegsPort->write(toRegsData);\n\
\t\t\t\tpcReg = readRegfile(RS1_FIELD(encodedInstr), fromRegsData) + getImmediate(encodedInstr);\n\
\t\t\t}')

if 'ENC_B' in usedEncTypes:
    if lastEncType != 'ENC_B':
        if firstEncType == 'ENC_B':
            outputISA.write('\t\t\tif (')
        else:
            outputISA.write(' else if (')
        outputISA.write('getEncType(encodedInstr) == ENC_B) {\n')
    else:
        outputISA.write(' else {\n')
    outputISA.write('\
\t\t\t\tfromRegsPort->read(fromRegsData);\n\
\t\t\t\taluOp1 = readRegfile(RS1_FIELD(encodedInstr), fromRegsData);\n\
\t\t\t\taluOp2 = readRegfile(RS2_FIELD(encodedInstr), fromRegsData);\n\
\t\t\t\taluResult = getALUresult(getALUfunc(getInstrType(encodedInstr)), aluOp1, aluOp2);\n\
\t\t\t\tpcReg = getBranchResult(encodedInstr, aluResult, pcReg);\n\
\t\t\t}')

if 'ENC_I_L' in usedEncTypes:
    if lastEncType != 'ENC_I_L':
        if firstEncType == 'ENC_I_L':
            outputISA.write('\t\t\tif (')
        else:
            outputISA.write(' else if (')
        outputISA.write('getEncType(encodedInstr) == ENC_I_L) {\n')
    else:
        outputISA.write(' else {\n')
    outputISA.write('\
\t\t\t\tfromRegsPort->read(fromRegsData);\n\
\t\t\t\taluOp1 = readRegfile(RS1_FIELD(encodedInstr), fromRegsData);\n\
\t\t\t\taluOp2 = getImmediate(encodedInstr);\n\
\t\t\t\taluResult = getALUresult(ALU_ADD, aluOp1, aluOp2);\n\
\t\t\t\ttoMemoryData.req = ME_RD;\n\
\t\t\t\ttoMemoryData.mask = getMemoryMask(getInstrType(encodedInstr));\n\
\t\t\t\ttoMemoryData.addrIn = aluResult;\n\
\t\t\t\ttoMemoryData.dataIn = 0;\n\
\t\t\t\ttoRegsData.dst = RD_FIELD(encodedInstr);\n\
\t\t\t\ttoMemoryPort->write(toMemoryData);\n\
\t\t\t\tfromMemoryPort->read(fromMemoryData);\n\
\t\t\t\ttoRegsData.dstData = fromMemoryData.loadedData;\n\
\t\t\t\ttoRegsPort->write(toRegsData);\n\
\t\t\t\tpcReg = pcReg + 4;\n\
\t\t\t}')

if 'ENC_S' in usedEncTypes:
    if lastEncType != 'ENC_S':
        if firstEncType == 'ENC_S':
            outputISA.write('\t\t\tif (')
        else:
            outputISA.write(' else if (')
        outputISA.write('getEncType(encodedInstr) == ENC_S) {\n')
    else:
        outputISA.write(' else {\n')
    outputISA.write('\
\t\t\t\tfromRegsPort->read(fromRegsData);\n\
\t\t\t\taluOp1 = readRegfile(RS1_FIELD(encodedInstr), fromRegsData);\n\
\t\t\t\taluOp2 = getImmediate(encodedInstr);\n\
\t\t\t\taluResult = getALUresult(ALU_ADD, aluOp1, aluOp2);\n\
\t\t\t\ttoMemoryData.req = ME_WR;\n\
\t\t\t\ttoMemoryData.mask = getMemoryMask(getInstrType(encodedInstr));\n\
\t\t\t\ttoMemoryData.addrIn = aluResult;\n\
\t\t\t\ttoMemoryData.dataIn = readRegfile(RS2_FIELD(encodedInstr), fromRegsData);\n\
\t\t\t\ttoMemoryPort->write(toMemoryData);\n\
\t\t\t\tpcReg = pcReg + 4;\n\
\t\t\t}')
    
if 'ENC_I_I' in usedEncTypes:
    if lastEncType != 'ENC_I_I':
        if firstEncType == 'ENC_I_I':
            outputISA.write('\t\t\tif (')
        else:
            outputISA.write(' else if (')
        outputISA.write('getEncType(encodedInstr) == ENC_I_I) {\n')
    else:
        outputISA.write(' else {\n')
    outputISA.write('\
\t\t\t\tfromRegsPort->read(fromRegsData);\n\
\t\t\t\taluOp1 = readRegfile(RS1_FIELD(encodedInstr), fromRegsData);\n\
\t\t\t\taluOp2 = getImmediate(encodedInstr);\n\
\t\t\t\taluResult = getALUresult(getALUfunc(getInstrType(encodedInstr)), aluOp1, aluOp2);\n\
\t\t\t\ttoRegsData.dst = RD_FIELD(encodedInstr);\n\
\t\t\t\ttoRegsData.dstData = aluResult;\n\
\t\t\t\ttoRegsPort->write(toRegsData);\n\
\t\t\t\tpcReg = pcReg + 4;\n\
\t\t\t}')

if 'ENC_R' in usedEncTypes:
    if lastEncType != 'ENC_R':
        if firstEncType == 'ENC_R':
            outputISA.write('\t\t\tif (')
        else:
            outputISA.write(' else if (')
        outputISA.write('getEncType(encodedInstr) == ENC_R) {\n')
    else:
        outputISA.write(' else {\n')
    outputISA.write('\
\t\t\t\tfromRegsPort->read(fromRegsData);\n\
\t\t\t\taluOp1 = readRegfile(RS1_FIELD(encodedInstr), fromRegsData);\n\
\t\t\t\taluOp2 = readRegfile(RS2_FIELD(encodedInstr), fromRegsData);\n\
\t\t\t\taluResult = getALUresult(getALUfunc(getInstrType(encodedInstr)), aluOp1, aluOp2);\n\
\t\t\t\ttoRegsData.dst = RD_FIELD(encodedInstr);\n\
\t\t\t\ttoRegsData.dstData = aluResult;\n\
\t\t\t\ttoRegsPort->write(toRegsData);\n\
\t\t\t\tpcReg = pcReg + 4;\n\
\t\t\t}')

if 'ENC_I_S' in usedEncTypes:
    if lastEncType != 'ENC_I_S':
        if firstEncType == 'ENC_I_S':
            outputISA.write('\t\t\tif (')
        else:
            outputISA.write(' else if (')
        outputISA.write('getEncType(encodedInstr) == ENC_I_S) {\n\t\t\t\t')
    else:
        outputISA.write(' else {\n\t\t\t\t')
    if 'INSTR_ECALL' in usedInstrTypes:
        outputISA.write('\
if (getInstrType(encodedInstr) == INSTR_ECALL) {\n\
\t\t\t\t\tisa_syscall_Port->write(true);\n\
\t\t\t\t\t// wait for syscall to finish processing the ecall\n\
\t\t\t\t\tsyscall_isa_Port->read(sysRES);\n\
#ifdef SC_SIMULATE\n\
\t\t\t\t\tif(!sysRES) {\n\
\t\t\t\t\t\tstd::cout << "ECALL exit" << std::endl;\n\
\t\t\t\t\t\tsc_stop();\n\
\t\t\t\t\t\twait(SC_ZERO_TIME);\n\
\t\t\t\t\t}\n\
#endif\n\
\t\t\t\t\tpcReg = pcReg + 4;\n\
\t\t\t\t} else ')

    if 'INSTR_MRET' in usedInstrTypes:
        outputISA.write('\
if (getInstrType(encodedInstr) == INSTR_MRET) {\n\
\t\t\t\t\tmstatus = mstatus | 0x00000008; // set MIE\n\
\t\t\t\t\tmcause = 0;\n\
\t\t\t\t\tpcReg = mepc;\n\
\t\t\t\t} else ')

    if csrUsedFlag:
        csrImmInstr = list()
        csrRegInstr = list()
        for instr in usedInstrTypes:
            if re.search('^INSTR_CSRR\wI$', instr):
                csrImmInstr.append(instr)
            elif re.search('^INSTR_CSRR\w$', instr):
                csrRegInstr.append(instr)
        outputISA.write('if (')
        first = True
        for instr in usedInstrTypes:
            if instr[:10] == 'INSTR_CSRR':
                if first == True:
                    first = False
                    outputISA.write('getInstrType(encodedInstr) == ' + instr)
                else:
                    outputISA.write(' ||\n\t\t\t\t\t\t   getInstrType(encodedInstr) == ' + instr)
        outputISA.write(') {\n')
        if len(csrImmInstr) > 0 and len(csrRegInstr) > 0:
            outputISA.write('\t\t\t\t\tif (')
            first = True
            for instr in csrImmInstr:
                if first == True:
                    first = False
                    outputISA.write('getInstrType(encodedInstr) == ' + instr)
                else:
                    outputISA.write(' ||\n\t\t\t\t\t\tgetInstrType(encodedInstr) == ' + instr)
            outputISA.write(') {\n\
\t\t\t\t\t\taluOp1 = RS1_FIELD(encodedInstr);\n\
\t\t\t\t\t} else {\n\
\t\t\t\t\t\tfromRegsPort->read(fromRegsData);\n\
\t\t\t\t\t\taluOp1 = readRegfile(RS1_FIELD(encodedInstr), fromRegsData);\n\
\t\t\t\t\t}\n')
        elif len(csrImmInstr) > 0:
            outputISA.write('\
\t\t\t\t\taluOp1 = RS1_FIELD(encodedInstr);\n')
        elif len(csrRegInstr) > 0:
            outputISA.write('\
\t\t\t\t\tfromRegsPort->read(fromRegsData);\n\
\t\t\t\t\taluOp1 = readRegfile(RS1_FIELD(encodedInstr), fromRegsData);\n')
        outputISA.write('\
\t\t\t\t\taluOp2 = getCSR(mstatus, mie, mtvec, mepc, mcause, mip, encodedInstr);\n\
\t\t\t\t\taluResult = getCSRresult(getInstrType(encodedInstr), aluOp1, aluOp2);\n\
\t\t\t\t\tif (getImmediate(encodedInstr) == MCSR_MSTATUS) {\n\
\t\t\t\t\t\tmstatus = aluResult;\n\
\t\t\t\t\t} else if (getImmediate(encodedInstr) == MCSR_MIE) {\n\
\t\t\t\t\t\tmie = aluResult;\n\
\t\t\t\t\t} else if (getImmediate(encodedInstr) == MCSR_MTVEC) {\n\
\t\t\t\t\t\tmtvec = aluResult;\n\
\t\t\t\t\t} else if (getImmediate(encodedInstr) == MCSR_MEPC) {\n\
\t\t\t\t\t\tmepc = aluResult;\n\
\t\t\t\t\t} else if (getImmediate(encodedInstr) == MCSR_MCAUSE) {\n\
\t\t\t\t\t\tmcause = aluResult;\n\
\t\t\t\t\t}\n\
\t\t\t\t\ttoRegsData.dst = RD_FIELD(encodedInstr);\n\
\t\t\t\t\ttoRegsData.dstData = aluOp2;\n\
\t\t\t\t\ttoRegsPort->write(toRegsData);\n\
\t\t\t\t\tpcReg = pcReg + 4;\n')
        del csrImmInstr, csrRegInstr
        outputISA.write('\t\t\t\t} else ')
    outputISA.write('{\n\
\t\t\t\t\tpcReg = pcReg + 4;\n\
\t\t\t\t}')
    outputISA.write('\n\t\t\t}')

if 'ENC_X' in usedEncTypes:
    if lastEncType == 'ENC_X':
        outputISA.write(' else {\n')
    outputISA.write('\
\t\t\t\tpcReg = pcReg + 4;\n\
\t\t\t}')


if csrUsedFlag:
    outputISA.write('\n\
\t\t\tmip_isa_Port->read(mip);\n\
\t\t\tmcause = updateMCAUSE(mstatus, mie, mip, mcause);\n\
\t\t\tmepc = updateMEPC(mstatus, mie, mip, mcause, mepc, pcReg);\n\
\t\t\tpcReg = updatePC(mstatus, mie, mip, mcause, mtvec, pcReg);\n\
\t\t\tmstatus = updateMSTATUS(mstatus, mie, mip, mcause);\n')

outputISA.write('\n\
\t\t\tnextsection = Sections::fetch;\n\
\t\t}\n\
\t\tsection = nextsection;\n\
\t}\n\
#pragma clang diagnostic pop\n\
}\n\n')



usedEncTypesReordered = [enc for enc in encryptionConditionDict if enc in usedEncTypes]

outputISA.write('EncType ISA::getEncType(unsigned int encodedInstr) const {\n')
if len(usedEncTypesReordered) >= 2:
    for index, enc in enumerate(usedEncTypesReordered):
        if index != len(usedEncTypesReordered)-1:
            if index == 0:
                outputISA.write('\tif (')
            else:
                outputISA.write(' else if (')
            outputISA.write(encryptionConditionDict[enc] + ') {\n')
        else:
            outputISA.write(' else {\n')
        outputISA.write('\t\treturn ' + enc + ';\n\t}')
else:
    outputISA.write('\treturn ' + usedEncTypesReordered[0] + ';') 
outputISA.write('\n}\n\n')



usedInstrTypesReordered = [instr for instr in instructionConditionDict if instr in usedInstrTypes]

usedEncInstrTypesReordered = defaultdict(list)
for instr in instructionConditionDict:
    if instr in usedInstrTypes:
        for enc in usedEncTypesReordered:
            if instr in encToInstrDict[enc]:
                usedEncInstrTypesReordered[enc].append(instr)
                break

outputISA.write('InstrType ISA::getInstrType(unsigned int encodedInstr) const {\n')
if len(usedEncInstrTypesReordered) >= 2:
    for index, enc in enumerate(usedEncInstrTypesReordered):
        if index != len(usedEncInstrTypesReordered)-1:
            if index == 0:
                outputISA.write('\tif (')
            else:
                outputISA.write(' else if (')
            outputISA.write(encryptionConditionDict[enc] + ') {\n')
        else:
            outputISA.write(' else {\n')
        if len(usedEncInstrTypesReordered[enc]) >= 2:
            for index, instr in enumerate(usedEncInstrTypesReordered[enc]):
                if index != len(usedEncInstrTypesReordered[enc])-1:
                    if index == 0:
                        outputISA.write('\t\tif (')
                    else:
                        outputISA.write(' else if (')
                    outputISA.write(instructionConditionDict[instr] + ') {\n')
                else:
                    outputISA.write(' else {\n')
                outputISA.write('\t\t\treturn ' + instr + ';\n\t\t}')
        else:
            outputISA.write('\t\treturn ' + usedEncInstrTypesReordered[enc][0] + ';')
        outputISA.write('\n\t}')
else:
    instrList = [instr for instr in usedEncInstrTypesReordered.values()][0]
    if len(instrList) >= 2:
        for index, instr in enumerate(instrList):
            if index != len(instrList)-1:
                if index == 0:
                    outputISA.write('\tif (')
                else:
                    outputISA.write(' else if (')
                outputISA.write(instructionConditionDict[instr] + ') {\n')
            else:
                outputISA.write(' else {\n')
            outputISA.write('\t\treturn ' + instr + ';\n\t}')
    else:
        outputISA.write('\treturn ' + instrList[0] + ';')
outputISA.write('\n}\n\n')
del usedInstrTypesReordered, usedEncInstrTypesReordered


encryptionToImmediateDict = {
        'ENC_U': '\
$indent$return IMM_U_FIELD(encodedInstr);',\
        'ENC_S': '\
$indent$if (SIGN_FIELD(encodedInstr) == 0) {\n\
$indent$\treturn POS_IMM_S_FIELD(encodedInstr);\n\
$indent$} else {\n\
$indent$\treturn NEG_IMM_S_FIELD(encodedInstr);\n\
$indent$}',\
        'ENC_B': '\
$indent$if (SIGN_FIELD(encodedInstr) == 0) {\n\
$indent$\treturn POS_IMM_B_FIELD(encodedInstr);\n\
$indent$} else {\n\
$indent$\treturn NEG_IMM_B_FIELD(encodedInstr);\n\
$indent$}',\
        'ENC_J': '\
$indent$if (SIGN_FIELD(encodedInstr) == 0) {\n\
$indent$\treturn POS_IMM_J_FIELD(encodedInstr);\n\
$indent$} else {\n\
$indent$\treturn NEG_IMM_J_FIELD(encodedInstr);\n\
$indent$}',\
        'ENC_I_*': '\
$indent$if (SIGN_FIELD(encodedInstr) == 0) {\n\
$indent$\treturn POS_IMM_I_FIELD(encodedInstr);\n\
$indent$} else {\n\
$indent$\treturn NEG_IMM_I_FIELD(encodedInstr);\n\
$indent$}'}

#NOTE: ENC_I_* should always fall in else branch because it does not have defined conditions for it in encryptionConditionDict
usedImmediateEncTypes = list()
for enc in encryptionToImmediateDict:
    if enc in usedEncInstrTypes:
        usedImmediateEncTypes.append(enc)
    if enc[0:6] == 'ENC_I_':
        usedImmediateEncTypes.append('ENC_I_*')

if len(usedImmediateEncTypes) >= 1:
    outputISA.write('unsigned int ISA::getImmediate(unsigned int encodedInstr) const {\n')
    if len(usedImmediateEncTypes) >= 2:
        for index, enc in enumerate(usedImmediateEncTypes):
            if index != len(usedImmediateEncTypes)-1:
                if index == 0:
                    outputISA.write('\tif (')
                else: 
                    outputISA.write(' else if (')
                outputISA.write(encryptionConditionDict[enc])
                outputISA.write(') {\n')
            else:
                outputISA.write(' else {\n')
            outputISA.write(encryptionToImmediateDict[enc].replace('$indent$', '\t\t') + '\n\t}')
    else:
        outputISA.write(encryptionToImmediateDict[usedImmediateEncTypes[0]].replace('$indent$', '\t')) 
    outputISA.write('\n}\n\n')
del usedImmediateEncTypes

# Function structure: multiple conditions to result
# make sure that the most complex condition is moved to the else branch by reordering the list
if args.reorder:
    if len(usedAluFuncTypes) >= 2:
        elseCase = ('none', 0)
        for entry in usedAluFuncTypes:
            matchCounter = 0
            for instr in aluFuncConditionDict[entry]:
                if instr in usedInstrTypes:
                    matchCounter += 1
            if matchCounter > elseCase[1]:
                elseCase = (entry, matchCounter)
        usedAluFuncTypes.remove(elseCase[0])
        usedAluFuncTypes.append(elseCase[0])
        del matchCounter, elseCase
    
if len(usedAluFuncTypes) >= 1:
    outputISA.write('ALUfuncType ISA::getALUfunc(InstrType instr) const {\n')
    if len(usedAluFuncTypes) >= 2:
        for index, entry in enumerate(usedAluFuncTypes):
            if index != len(usedAluFuncTypes)-1:
                if index == 0:
                    outputISA.write('\tif (')
                else: 
                    outputISA.write(' else if (')
                first = True
                for instr in aluFuncConditionDict[entry]:
                    if instr in usedInstrTypes:
                        if first == True:
                            first = False
                            outputISA.write('instr == ' + instr)
                        else:
                            outputISA.write(' || instr == ' + instr)
                outputISA.write(') {\n')
            else:
                outputISA.write(' else {\n')
            outputISA.write('\t\treturn ' + entry + ';\n\t}')
    else:
        outputISA.write('\treturn ' + usedAluFuncTypes[0] + ';') 
    outputISA.write('\n}\n\n')


# Function structure: multiple conditions to result
# make sure that the most complex condition is moved to the else branch by reordering the list
if args.reorder:
    if len(usedMemoryMaskTypes) >= 2:
        elseCase = ('none', 0)
        for entry in usedMemoryMaskTypes:
            matchCounter = 0
            for instr in memoryMaskConditionDict[entry]:
                if instr in usedInstrTypes:
                    matchCounter += 1
            if matchCounter > elseCase[1]:
                elseCase = (entry, matchCounter)
        usedMemoryMaskTypes.remove(elseCase[0])
        usedMemoryMaskTypes.append(elseCase[0])
        del matchCounter, elseCase

if len(usedMemoryMaskTypes) >= 1:
    outputISA.write('ME_MaskType ISA::getMemoryMask(InstrType instr) const {\n')
    if len(usedMemoryMaskTypes) >= 2:
        for index, entry in enumerate(usedMemoryMaskTypes):
            if index != len(usedMemoryMaskTypes)-1:
                if index == 0:
                    outputISA.write('\tif (')
                else: 
                    outputISA.write(' else if (')
                first = True
                for instr in memoryMaskConditionDict[entry]:
                    if instr in usedInstrTypes:
                        if first == True:
                            first = False
                            outputISA.write('instr == ' + instr)
                        else:
                            outputISA.write(' || instr == ' + instr)
                outputISA.write(') {\n')
            else:
                outputISA.write(' else {\n')
            outputISA.write('\t\treturn ' + entry + ';\n\t}')
    else:
        outputISA.write('\treturn ' + usedMemoryMaskTypes[0] + ';') 
    outputISA.write('\n}\n\n')


aluFuncToResultDict = {
        'ALU_ADD': '$indent$return operand1 + operand2;',
        'ALU_SUB': '$indent$return operand1 - operand2;',
        'ALU_AND': '$indent$return operand1 & operand2;',
        'ALU_OR': '$indent$return operand1 | operand2;',
        'ALU_XOR': '$indent$return operand1 ^ operand2;',
        'ALU_SLT': '\
$indent$if (static_cast<int>(operand1) < static_cast<int>(operand2)) {\n\
$indent$\treturn 1;\n\
$indent$} else {\n\
$indent$\treturn 0;\n\
$indent$}',
        'ALU_SLTU': '\
$indent$if (operand1 < operand2) {\n\
$indent$\treturn 1;\n\
$indent$} else {\n\
$indent$\treturn 0;\n\
$indent$}',
        'ALU_SLL': '$indent$return operand1 << (operand2 & 0x1F);',
        'ALU_SRA': '$indent$return static_cast<unsigned int>(static_cast<int>(operand1) >> static_cast<int>(operand2 & 0x1F));',
        'ALU_SRL': '$indent$return operand1 >> (operand2 & 0x1F);',
        'ALU_COPY1': '$indent$return operand1;'}

if len(usedAluFuncTypes) >= 1:
    outputISA.write('unsigned int ISA::getALUresult(ALUfuncType aluFunction, unsigned int operand1, unsigned int operand2) const {\n')
    if len(usedAluFuncTypes) >= 2:
        for index, func in enumerate(usedAluFuncTypes):
            if index != len(usedAluFuncTypes)-1:
                if index == 0:
                    outputISA.write('\tif (')
                else:
                    outputISA.write(' else if (')
                outputISA.write('aluFunction == ' + func + ') {\n')
            else:
                outputISA.write(' else {\n')
            outputISA.write(aluFuncToResultDict[func].replace('$indent$', '\t\t') + '\n\t}')
    else:
        outputISA.write(aluFuncToResultDict[usedAluFuncTypes[0]].replace('$indent$', '\t')) 
    outputISA.write('\n}\n\n')

if len(usedRegisters) >= 1:
    outputISA.write('unsigned int ISA::readRegfile(unsigned int src, RegfileType fromRegsData) const {\n')
    if len(usedRegisters) >= 2:
        for index, reg in enumerate(usedRegisters):
            if index != len(usedRegisters)-1:
                if index == 0:
                    outputISA.write('\tif (')
                else:
                    outputISA.write(' else if (')
                outputISA.write('src == ' + str(reg) + ') {\n')
            else:
                outputISA.write(' else {\n')
            if reg == 0:
                outputISA.write('\t\treturn 0;\n\t}')
            else:
                outputISA.write('\t\treturn fromRegsData.reg_file_' + str(reg).zfill(2) + ';\n\t}')
    else:
        if reg == 0:
            outputISA.write('\treturn 0;\n\t}')
        else:
            outputISA.write('\treturn fromRegsData.reg_file_' + str(reg).zfill(2) + ';\n\t}')
    outputISA.write('\n}\n\n')

# Print getBranchResult function
branchConditionDict = {
        'ret1': [['INSTR_BEQ', 'INSTR_BGE', 'INSTR_BGEU'], 'aluResult == 0'],
        'ret2': [['INSTR_BLT', 'INSTR_BLTU'], 'aluResult == 1'],
        'ret3': [['INSTR_BNE'], 'aluResult != 0']}

usedBranchResultTypes = list()
for ret in branchConditionDict:
    for instr in branchConditionDict[ret][0]:
        if instr in usedInstrTypes:
            if ret not in usedBranchResultTypes:
                usedBranchResultTypes.append(ret)

if 'ENC_B' in usedEncTypes:
    outputISA.write('\
unsigned int ISA::getBranchResult(unsigned int encodedInstr, unsigned int aluResult, unsigned int pcReg) const {\n')
    for index, entry in enumerate(usedBranchResultTypes):
        if index == 0:
            outputISA.write('\tif ((')
        else: 
            outputISA.write(' else if ((')
        first = True
        for instr in branchConditionDict[entry][0]:
            if instr in usedInstrTypes:
                if first == True:
                    first = False
                    outputISA.write('getInstrType(encodedInstr) == ' + instr)
                else:
                    outputISA.write(' || getInstrType(encodedInstr) == ' + instr)
        outputISA.write(') && ' + branchConditionDict[entry][1] + ') {\n')
        outputISA.write('\t\treturn pcReg + getImmediate(encodedInstr);\n\t}')

    outputISA.write(' else {\n\
\t\treturn pcReg + 4;\n\
\t}\n\
}\n\n')

# Print CSR functions
if csrUsedFlag:
    outputISA.write('unsigned int ISA::getCSR(unsigned int mstatus, unsigned int mie, unsigned int mtvec, unsigned int mepc, unsigned int mcause, unsigned int mip, unsigned int encodedInstr) const {\n\
\tif (POS_IMM_I_FIELD(encodedInstr) == MCSR_MSTATUS) {\n\
\t\treturn mstatus;\n\
\t} else if (POS_IMM_I_FIELD(encodedInstr) == MCSR_MIE) {\n\
\t\treturn mie;\n\
\t} else if (POS_IMM_I_FIELD(encodedInstr) == MCSR_MTVEC) {\n\
\t\treturn mtvec;\n\
\t} else if (POS_IMM_I_FIELD(encodedInstr) == MCSR_MEPC) {\n\
\t\treturn mepc;\n\
\t} else if (POS_IMM_I_FIELD(encodedInstr) == MCSR_MCAUSE) {\n\
\t\treturn mcause;\n\
\t} else { //MCSR_MIP\n\
\t\treturn mip;\n\
\t}\n\
}\n\n')

# Print getCSRresult function
# Function structure: multiple conditions to result
csrResultToInstrDict = {
        'rs1': ['INSTR_CSRRW', 'INSTR_CSRRWI'],
        'csr | rs1': ['INSTR_CSRRS', 'INSTR_CSRRSI'],
        'csr & ((-rs1) - 1)': ['INSTR_CSRRC', 'INSTR_CSRRCI']}

usedCsrResultTypes = list()
for result in csrResultToInstrDict:
    for instr in csrResultToInstrDict[result]:
        if instr in usedInstrTypes:
            if result not in usedCsrResultTypes:
                usedCsrResultTypes.append(result)

# make sure that the most complex condition is moved to the else branch by reordering the list
if args.reorder:
    if len(usedCsrResultTypes) >= 2:
        elseCase = ('none', 0)
        for entry in usedCsrResultTypes:
            matchCounter = 0
            for instr in csrResultToInstrDict[entry]:
                if instr in usedInstrTypes:
                    matchCounter += 1
            if matchCounter > elseCase[1]:
                elseCase = (entry, matchCounter)
        usedCsrResultTypes.remove(elseCase[0])
        usedCsrResultTypes.append(elseCase[0])
        del matchCounter, elseCase

if csrUsedFlag:
    outputISA.write('unsigned int ISA::getCSRresult(InstrType instr, unsigned int rs1, unsigned int csr) const {\n')
    if len(usedCsrResultTypes) >= 2:
        for index, entry in enumerate(usedCsrResultTypes):
            if index != len(usedCsrResultTypes)-1:
                if index == 0:
                    outputISA.write('\tif (')
                else: 
                    outputISA.write(' else if (')
                first = True
                for instr in csrResultToInstrDict[entry]:
                    if instr in usedInstrTypes:
                        if first == True:
                            first = False
                            outputISA.write('instr == ' + instr)
                        else:
                            outputISA.write(' || instr == ' + instr)
                outputISA.write(') {\n')
            else:
                outputISA.write(' else {\n')
            outputISA.write('\t\treturn ' + entry + ';\n\t}')
    else:
        outputISA.write('\treturn ' + usedCsrResultTypes[0] + ';') 
    outputISA.write('\n}\n\n')

# Print updateMCAUSE function
if csrUsedFlag:
    outputISA.write('\
unsigned int ISA::updateMCAUSE(unsigned int mstatus, unsigned int mie, unsigned int mip, unsigned int mcause) const {\n\
\tif (MSTATUS_MIE(mstatus) != 0) {\n\
\t\tif ((MTRAP_MEI(mie) != 0) && (MTRAP_MEI(mip) != 0)) {\n\
\t\t\treturn static_cast<unsigned int>(0x8000000B);\n\
\t\t} else if ((MTRAP_MSI(mie) != 0) && (MTRAP_MSI(mip) != 0)) {\n\
\t\t\treturn static_cast<unsigned int>(0x80000003);\n\
\t\t} else if ((MTRAP_MTI(mie) != 0) && (MTRAP_MTI(mip) != 0)) {\n\
\t\t\treturn static_cast<unsigned int>(0x80000007);\n\
\t\t} else { //(mcause != 0) {\n\
\t\t\treturn mcause;\n\
\t\t}\n\
\t} else {\n\
\t\treturn mcause;\n\
\t}\n\
}\n\n')

# Print updateMSTATUS function
if csrUsedFlag:
    outputISA.write('\
unsigned int ISA::updateMSTATUS(unsigned int mstatus, unsigned int mie, unsigned int mip, unsigned int mcause) const {\n\
\tif (MSTATUS_MIE(mstatus) != 0) {\n\
\t\tif ((MTRAP_MEI(mie) != 0) && (MTRAP_MEI(mip) != 0)) {\n\
\t\t\treturn mstatus & static_cast<unsigned int>(0xFFFFFFF7); // Setting MPIE(7) and Clearing MIE(3)\n\
\t\t} else if ((MTRAP_MSI(mie) != 0) && (MTRAP_MSI(mip) != 0)) {\n\
\t\t\treturn mstatus & static_cast<unsigned int>(0xFFFFFFF7);\n\
\t\t} else if ((MTRAP_MTI(mie) != 0) && (MTRAP_MTI(mip) != 0)) {\n\
\t\t\treturn mstatus & static_cast<unsigned int>(0xFFFFFFF7);\n\
\t\t} else if (mcause != 0) {\n\
\t\t\treturn mstatus & static_cast<unsigned int>(0xFFFFFFF7);\n\
\t\t} else {\n\
\t\t\treturn mstatus;\n\
\t\t}\n\
\t} else {\n\
\t\treturn mstatus;\n\
\t}\n\
}\n\n')

# Print updateMEPC function
if csrUsedFlag:
    outputISA.write('\
unsigned int ISA::updateMEPC(unsigned int mstatus, unsigned int mie, unsigned int mip, unsigned int mcause, unsigned int mepc, unsigned int pcReg) const {\n\
\tif (MSTATUS_MIE(mstatus) != 0) {\n\
\t\tif ((MTRAP_MEI(mie) != 0) && (MTRAP_MEI(mip) != 0)) {\n\
\t\t\treturn pcReg; // store the return from interrupt address\n\
\t\t} else if ((MTRAP_MSI(mie) != 0) && (MTRAP_MSI(mip) != 0)) {\n\
\t\t\treturn pcReg; // store the return from interrupt address\n\
\t\t} else if ((MTRAP_MTI(mie) != 0) && (MTRAP_MTI(mip) != 0)) {\n\
\t\t\treturn pcReg; // store the return from interrupt address\n\
\t\t} else { //(mcause != 0) { // exceptions\n\
\t\t\treturn mepc;\n\
\t\t}\n\
\t} else {\n\
\t\treturn mepc;\n\
\t}\n\
}\n\n')

# Print updatePC function
if csrUsedFlag:
    outputISA.write('\
unsigned int ISA::updatePC(unsigned int mstatus, unsigned int mie, unsigned int mip, unsigned int mcause, unsigned int mtvec, unsigned int pcReg) const {\n\
\tif (MSTATUS_MIE(mstatus) != 0) {\n\
\t\tif ((MTRAP_MEI(mie) != 0) && (MTRAP_MEI(mip) != 0)) {\n\
\t\t\treturn mtvec;\n\
\t\t} else if ((MTRAP_MSI(mie) != 0) && (MTRAP_MSI(mip) != 0)) {\n\
\t\t\treturn mtvec;\n\
\t\t} else if ((MTRAP_MTI(mie) != 0) && (MTRAP_MTI(mip) != 0)) {\n\
\t\t\treturn mtvec;\n\
\t\t} else if (mcause != 0) { // exceptions\n\
\t\t\treturn mtvec;\n\
\t\t} else {\n\
\t\t\treturn pcReg;\n\
\t\t}\n\
\t} else {\n\
\t\treturn pcReg;\n\
\t}\n\
}\n\n')


outputISA.write('#endif //RISCV_ISA_H_\n')
outputISA.close()

#########################################################################################
moduleList.append("CPU_Interfaces.h")
outputCpuInterfaces = open(args.outputDir + '/CPU_Interfaces.h','w+')
outputCpuInterfaces.write('\
#ifndef RISCV_CPU_INTERFACES_H\n\
#define RISCV_CPU_INTERFACES_H\n\
\n\
#include "' + args.interfacesInclude +'Memory_Interfaces.h"\n\
\n\
struct RegfileWriteType {\n\
    unsigned int dst;\n\
    unsigned int dstData;\n\
};\n')

if syscallUsedFlag:
    outputCpuInterfaces.write('\
// register file output interface\n\
struct RegfileSyscallType {\n')
    for reg in [10, 11, 12, 17]:
        if reg in usedRegisters:
            outputCpuInterfaces.write('\tunsigned int reg_file_' + str(reg).zfill(2) + ';\n')
    outputCpuInterfaces.write('};')

outputCpuInterfaces.write('struct RegfileType {\n')
for reg in usedRegisters:
    if reg != 0:
        outputCpuInterfaces.write('\tunsigned int reg_file_' + str(reg).zfill(2) + ';\n')
outputCpuInterfaces.write('};\n\n#endif // RISCV_CPU_INTERFACES_H')
outputCpuInterfaces.close()

###########################################################################################
moduleList.append("Regs.h")
outputRegs = open(args.outputDir + '/Regs.h','w+')
outputRegs.write('\
#ifndef RISCV_REGS_H_\n\
#define RISCV_REGS_H_\n\
\n\
#include "systemc.h"\n\
#include <iomanip>\n\
#include "Interfaces.h"\n\
#include "CPU_Interfaces.h"\n\
\n\
class Regs : public sc_module {\n\
public:\n\
    SC_HAS_PROCESS(Regs);\n\
    Regs(sc_module_name name) :\n\
            toRegsPort("toRegsPort"),\n\
            fromRegsPort("fromRegsPort"),\n')
if syscallUsedFlag:
    outputRegs.write('\
            syscall_reg_Port("syscall_reg_Port"),\n\
            reg_syscall_Port("reg_syscall_Port"),\n')
outputRegs.write('\
            reg_file_01(0),\n\
            reg_file_02(0),\n\
            reg_file_03(0),\n\
            reg_file_04(0),\n\
            reg_file_05(0),\n\
            reg_file_06(0),\n\
            reg_file_07(0),\n\
            reg_file_08(0),\n\
            reg_file_09(0),\n\
            reg_file_10(0),\n\
            reg_file_11(0),\n\
            reg_file_12(0),\n\
            reg_file_13(0),\n\
            reg_file_14(0),\n\
            reg_file_15(0),\n\
            reg_file_16(0),\n\
            reg_file_17(0),\n\
            reg_file_18(0),\n\
            reg_file_19(0),\n\
            reg_file_20(0),\n\
            reg_file_21(0),\n\
            reg_file_22(0),\n\
            reg_file_23(0),\n\
            reg_file_24(0),\n\
            reg_file_25(0),\n\
            reg_file_26(0),\n\
            reg_file_27(0),\n\
            reg_file_28(0),\n\
            reg_file_29(0),\n\
            reg_file_30(0),\n\
            reg_file_31(0),\n\
            req(false)\n\
    {\n\
        SC_THREAD(run);\n\
    }\n\
\n\
    slave_in<RegfileWriteType> toRegsPort;\n\
    slave_out<RegfileType> fromRegsPort;\n\
    RegfileWriteType regfileWrite;\n\
    RegfileType regfile;\n')
if syscallUsedFlag:
    outputRegs.write('\
    // Ports for communication with syscallHandler\n\
    slave_in<RegfileWriteType> syscall_reg_Port;\n\
    slave_out<RegfileSyscallType> reg_syscall_Port;\n\
    RegfileWriteType regfileSyscallWrite;\n\
    RegfileSyscallType regfileSyscall; // RegisterFile{10,11,12,17}\n')
outputRegs.write('\
\n\
    unsigned int reg_file_01 = 0;\n\
    unsigned int reg_file_02 = 0;\n\
    unsigned int reg_file_03 = 0;\n\
    unsigned int reg_file_04 = 0;\n\
    unsigned int reg_file_05 = 0;\n\
    unsigned int reg_file_06 = 0;\n\
    unsigned int reg_file_07 = 0;\n\
    unsigned int reg_file_08 = 0;\n\
    unsigned int reg_file_09 = 0;\n\
    unsigned int reg_file_10 = 0;\n\
    unsigned int reg_file_11 = 0;\n\
    unsigned int reg_file_12 = 0;\n\
    unsigned int reg_file_13 = 0;\n\
    unsigned int reg_file_14 = 0;\n\
    unsigned int reg_file_15 = 0;\n\
    unsigned int reg_file_16 = 0;\n\
    unsigned int reg_file_17 = 0;\n\
    unsigned int reg_file_18 = 0;\n\
    unsigned int reg_file_19 = 0;\n\
    unsigned int reg_file_20 = 0;\n\
    unsigned int reg_file_21 = 0;\n\
    unsigned int reg_file_22 = 0;\n\
    unsigned int reg_file_23 = 0;\n\
    unsigned int reg_file_24 = 0;\n\
    unsigned int reg_file_25 = 0;\n\
    unsigned int reg_file_26 = 0;\n\
    unsigned int reg_file_27 = 0;\n\
    unsigned int reg_file_28 = 0;\n\
    unsigned int reg_file_29 = 0;\n\
    unsigned int reg_file_30 = 0;\n\
    unsigned int reg_file_31 = 0;\n\
    bool req;\n\
    void run();\n\
};\n\
\n\
void Regs::run() {\n\
#pragma clang diagnostic push\n\
#pragma clang diagnostic ignored "-Wmissing-noreturn"\n\
    while (true) {\n')

for reg in usedRegisters:
    if reg != 0:
        outputRegs.write('\t\tregfile.reg_file_' + str(reg).zfill(2) + ' = reg_file_' + str(reg).zfill(2) + ';\n')
if syscallUsedFlag:
    for reg in [10, 11, 12, 17]:
        if reg in usedRegisters:
            outputRegs.write('\t\tregfileSyscall.reg_file_' + str(reg).zfill(2) + ' = reg_file_' + str(reg).zfill(2) + ';\n')

if syscallUsedFlag:
    outputRegs.write('\
\t\treg_syscall_Port->nb_write(regfileSyscall);\n')
outputRegs.write('\
\t\tfromRegsPort->nb_write(regfile);\n\
\t\treq = toRegsPort->nb_read(regfileWrite);\n\
\t\tif (req) {\n')

if len(usedRegisters) >= 2:
    for index, reg in enumerate(usedRegisters):
        if index != len(usedRegisters)-1:
            if index == 0:
                outputRegs.write('\t\t\tif (')
            else:
                outputRegs.write(' else if (')
            outputRegs.write('regfileWrite.dst == ' + str(reg) + ') {\n')
        else:
            outputRegs.write(' else {\n')
        if reg != 0:
            outputRegs.write('\t\t\t\treg_file_' + str(reg).zfill(2) + ' = regfileWrite.dstData;\n\t\t\t}')
        else:
            outputRegs.write('\t\t\t\t// Do nothing\n\t\t\t}')
else:
    if reg != 0:
        outputRegs.write('\t\t\treg_file_' + str(reg).zfill(2) + ' = regfileWrite.dstData;\n\t\t\t\t}')
outputRegs.write('\n\t\t}\n')
                
if syscallUsedFlag and 10 in usedRegisters:
    outputRegs.write('\
        req = syscall_reg_Port->nb_read(regfileSyscallWrite); // read request from syscall\n\
        if (req) {\n\
            reg_file_10 = regfileSyscallWrite.dstData;\n\
        }\n')
outputRegs.write('\t}\n')
outputRegs.write('}\n\n#endif  // RISCV_REGS_H_')
    
    
outputRegs.close()

###############################################################################
# Copy files that do not need to be modified
from shutil import copyfile

if args.interfacesInclude == '':
    copyfile(args.modulesDir + '/Memory_Interfaces.h', args.outputDir + '/Memory_Interfaces.h')

if csrUsedFlag and syscallUsedFlag:
    copyfile(args.modulesDir + '/core_full.h', args.outputDir + '/Core.h')
    copyfile(args.modulesDir + '/mip.h', args.outputDir + '/mip.h')
    copyfile(args.modulesDir + '/PLIC.h', args.outputDir + '/PLIC.h')
    copyfile(args.modulesDir + '/CLINT.h', args.outputDir + '/CLINT.h')
    copyfile(args.modulesDir + '/bus_full.h', args.outputDir + '/Bus.h')
    copyfile(args.modulesDir + '/SYScallHandler.h', args.outputDir + '/SYScallHandler.h')
elif csrUsedFlag:
    copyfile(args.modulesDir + '/core_csr.h', args.outputDir + '/Core.h')
    copyfile(args.modulesDir + '/mip.h', args.outputDir + '/mip.h')
    copyfile(args.modulesDir + '/PLIC.h', args.outputDir + '/PLIC.h')
    copyfile(args.modulesDir + '/CLINT.h', args.outputDir + '/CLINT.h')
    copyfile(args.modulesDir + '/bus_csr.h', args.outputDir + '/Bus.h')
elif syscallUsedFlag:
    copyfile(args.modulesDir + '/core_syscall.h', args.outputDir + '/Core.h')
    copyfile(args.modulesDir + '/bus_syscall.h', args.outputDir + '/Bus.h')
    copyfile(args.modulesDir + '/SYScallHandler.h', args.outputDir + '/SYScallHandler.h')
else:
    copyfile(args.modulesDir + '/core_mini.h', args.outputDir + '/Core.h')

print('###################### Bespoke RISC-V generation finished ######################')

#########################################################################################
# Adds all SystemC-PPA compatible modules to modules.h for use with SCAM
outputModules = open(args.outputDir + '/modules.h','w+')
for module in moduleList:
    outputModules.write('#include "' + module + '"\n')
outputModules.close()

###########################################################################################
