# Directory: Test Framework

## Setup
The folder ESL containts the implementation and the build-system:
1) Create a Core.h file, with a class Core containing your processor . 
2) Within Core.h specify these ports for accessing the memory:
    * blocking_out<CUtoME_IF> COtoME_port;
    * blocking_in<MEtoCU_IF> MEtoCO_port;
    * *Make sure you use the same names*
    * Name your registers file readRegfile
3) Add your Core.h to the Core_Test.h and uncomment all other cores

4) Enableing LOGTOFILE property in the CMakeLists.txt ensures that the 
output is forwarded to a logfile (see comments in CMakeLists)

## Running

1) Compile the riscv_regression_test with debug flag and make sure the binary is in SCAM/bin
2) Adjust your path in run_all_tests and then run it










 

