#Note- This file needs to be modified with proper directory paths 
#-----------------------------------------------------------------
# Description: Script to run formal verification of AHB (Advanced High-perfromance Bus)
# Author     : Keerthi Devarajegowda
# Date       : 02/12/2019
# Email      : Keerthikumara.Devarajegowda@infineon.com
# All right reserved @ Infineon Technologies AG, Germany 2019
#-----------------------------------------------------------------

#------------------------------------------------------------------
# Setup mode
#------------------------------------------------------------------
set_mode setup
clear_design
clear_screen

#------------------
# Set path variable
#------------------
  set ROOT_PATH ~/DeSCAM/example/operation-pipeline/
  set RTL_PATH $ROOT_PATH/RTL
#  set MEMMODEL_PATH $ROOT_PATH/source/memory_model
  set PROP_PATH $RTL_PATH/properties_s2qed
#  set SCRIPTS_PATH $ROOT_PATH/scripts

#----------------------
# Read RTL files: 
  # 2.AHB instances
  # 3.S2qed RTL wrapper
#----------------------
  read_vhdl $RTL_PATH/ahb_funct.vhd
  read_vhdl $RTL_PATH/ahb_package.vhd
  read_vhdl $RTL_PATH/ahbTop.vhdl
  read_vhdl $PROP_PATH/s2qed_top.vhd
  read_vhdl $RTL_PATH/ahb_configure.vhd
  read_vhdl $RTL_PATH/mst_agent.vhdl
  read_vhdl $RTL_PATH/slv_agent.vhdl
  read_vhdl $RTL_PATH/ahb_arbiter.vhd
  read_vhdl $RTL_PATH/ahb_components.vhd
  read_vhdl $RTL_PATH/ahb_matrix.vhd

#---------------------
# elaborate and compile
#---------------------
  elaborate -top s2qed_top -verbose
  compile
  set_reset_sequence -high rst
  set_clock_spec -period 2 clk

#------------------------------------------------------------------
# MV mode
#------------------------------------------------------------------
set_mode mv
set_check_option -verbose
#set_disable_condition -high rst
check_consistency -category init
set_itl_flavor vhi

##-------------------------------- 
## Prover settings - works only under Infineon settings
##--------------------------------  
#  source $SCRIPTS_PATH/save_provers_v1.obf
#  source $SCRIPTS_PATH/lsf_oss.tcl
#  par 10

#-------------------------------- 
# check properties 
#--------------------------------  
  #macros and constraints
  read_itl $PROP_PATH/AHB_s2qed.vhi
