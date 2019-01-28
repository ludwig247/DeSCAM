The PrintSystemC Backend folder includes two classes.

======================

PrintSystemC:

    This class can function through the CommandlineParameters: "PrintSystemC".

    This class recreates the Systemc code from the generated model structure.
        - Prints used datatypes in the top model.
        - Prints used modules classes that are used in the top model design.
        - Prints sc_main (model) that links these modules.

======================

CreateModulesCheckers:

    This class can function through the CommandlineParameters: "CreateModulesCheckers".

    Creates C++ projects for each used module in the top model design.
    The purpose of these projects is to check the equivalency between the generated modules and the original ones with the help of SCV library.
    Each project includes the following files:
        - DataTypes_ext: extends the top model's datatypes to allow the SCV generation of random data.
            *** NOTE 1 *** User should include the path of their original module.h in this file to allow the DataTypes_ext to find the datatypes structures.
            *** NOTE 2 *** The original module.h file should use explicit reference to header "Interface.h" if necessary to avoid errors in building the project.
                           for example: (#include "../../Interfaces/Interfaces.h") is accepted,
                                        (#include <Interfaces.h>) is NOT accepted.
            *** NOTE 3 *** ALL created types need to be put in a separate file and not in the original module.h
        - Module_generated.h
        - Module_checker.h: sc_module that has ports connecting to both original and generated modules.
            - creates vectors of random data to be sent to both modules on their input ports.
            - stores output data and communication status (NBwrite, NBread) of both modules.
            - compares the outputs of both modules and assert their equivalence.
        - sc_main.cpp: includes instances of checker, original and generated modules and links them.
        - CMakeLists.txt
    Each built project runs the equivalency check between the generated module and its corresponding original one for a number of samples specified in variable "Test_cnt".
