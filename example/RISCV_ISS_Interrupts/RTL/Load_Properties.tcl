
#------------------------------------------------------------------
# Setup mode
#------------------------------------------------------------------
set_mode setup
clear_design
clear_screen

#------------------
# Set path variable
#------------------
  set HOME /import/lab/users/riva/DeSCAM/
  set ROOT_PATH $HOME/RISCV_ISS_Interrupts_sv
  set RTL_PATH $ROOT_PATH/PrintSkeleton

  set PROP_PATH $ROOT_PATH/PrintSVA

#----------------------
# Read RTL files:
#----------------------
read_verilog -golden  -pragma_ignore {}  -version sv2012 $RTL_PATH/globalTypes.sv
read_verilog -golden  -pragma_ignore {}  -version sv2012 $RTL_PATH/ISS_Interrupts_types.sv
read_verilog -golden  -pragma_ignore {}  -version sv2012 $RTL_PATH/ISS_Interrupts_1.sv

#---------------------
# elaborate and compile
#---------------------
  elaborate -top ISS_Interrupts -verbose
  compile

#------------------------------------------------------------------
# MV mode
#------------------------------------------------------------------
set_mode mv
set_check_option -verbose
#set_disable_condition -high rst
check_consistency -category init

#--------------------------------
# check properties
#--------------------------------
#Load Properties
read_sva $PROP_PATH/ISS_Interrupts.sva
#check -all [get_checks]
   