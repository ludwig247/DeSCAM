
#------------------------------------------------------------------
# Setup mode
#------------------------------------------------------------------
set_mode setup
clear_design
clear_screen

#------------------
# Set path variable
#------------------
  set HOME /import/lab/users/riva/Forked_DeSCAM/DeSCAM/example
  set ROOT_PATH $HOME/RISCV_ISS
  set RTL_PATH $ROOT_PATH/RTL

  set PROP_PATH $RTL_PATH/Properties

#----------------------
# Read RTL files:
#----------------------
read_verilog -golden  -pragma_ignore {}  -version sv2012 $RTL_PATH/globalTypes.sv
read_verilog -golden  -pragma_ignore {}  -version sv2012 $RTL_PATH/ISS_types.sv
read_verilog -golden  -pragma_ignore {}  -version sv2012 $RTL_PATH/ISS.sv

#---------------------
# elaborate and compile
#---------------------
  elaborate -top ISS -verbose
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
read_sva $PROP_PATH/ISS.sva
check -all [get_checks]
   