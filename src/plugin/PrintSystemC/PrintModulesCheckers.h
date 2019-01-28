//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 17.04.18.
//

#ifndef PROJECT_PRINTMODULESCHECKERS_H
#define PROJECT_PRINTMODULESCHECKERS_H

#include "PrintSystemC.h"

    /** \brief
     * This class can function through the CommandlineParameters: "CreateModulesCheckers".
     *
     * CreateModulesCheckers:
     *      Creates C++ projects for each used module in the top model design.
     *      The purpose of these projects is to check the equivalency between the generated modules and the original ones with the help of SCV library.
     *      Each project includes the following files:
     *          - DataTypes_ext: extends the top model's datatypes to allow the SCV generation of random data.
     *              *** NOTE *** User should include the path of their original module.h in this file (DataTypes_ext.h) to allow the DataTypes_ext to find the datatypes structures.
     *          - Module_generated.h: recreates the module's SystemC code from the generated module structure. (The methodology to create this file is inherited from PrintSystemC class)
     *          - Module_checker.h: sc_module that has ports connecting to both original and generated modules.
     *              - creates vectors of random data to be sent to both modules on their input ports.
     *              - stores output data and communication status (NBwrite, NBread) of both modules.
     *              - compares the outputs of both modules and assert their equivalence.
     *          - sc_main.cpp: includes instances of checker, original and generated modules and links them.
     *          - CMakeLists.txt
     *      Each built project runs the equivalency check between the generated module and its corresponding original one for a number of samples specified by variable "Test_cnt" in the "Module_checker.h" file.
     */

    class PrintModulesCheckers : public PrintSystemC {
    public:
        PrintModulesCheckers() = default;

        ~PrintModulesCheckers() = default;

        std::map<std::string, std::string> printModel(Model *node);
    private:
        unsigned int indent = 0;
        unsigned int indentSize = 2;
        std::stringstream ss;

        void visit(SCAM::Module &node);

        void visit(Port &node);

        void visit(Variable &node);

        void visit(FSM &node);

        ////////////////
        std::string Create_CMake(std::string nodeName);
        std::string Text_DataTypesEXT();
        void Text_Checker(SCAM::Module *node);
        void Text_SCMain(SCAM::Module *node);

        void printSpace(unsigned int size);
    };

#endif //PROJECT_PRINTMODULESCHECKERS_H
