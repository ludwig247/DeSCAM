//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 17.04.18.
//

#ifndef PROJECT_PRINTSYSTEMC_H
#define PROJECT_PRINTSYSTEMC_H

#include <PluginFactory.h>
#include <sstream>
#include "Model.h"
#include "PrintStmtForSystemC.h"

    /** \brief
     * This class can function through the CommandlineParameters: "PrintSystemC".
     *
     * This class recreates the Systemc code from the generated model structure.
     * Prints on the console the created Systemc code for the passed model
     *          - Prints used datatypes in the top model.
     *          - Prints used modules classes that are used in the top model design.
     *          - Prints sc_main (model) that links these modules.
     *
     */

    class PrintSystemC : public PluginFactory, public AbstractVisitor {
    public:
        PrintSystemC() = default;

        ~PrintSystemC() = default;

        std::map<std::string, std::string> printModel(Model *node);
    private:
        void visit(Model &node);
        void visit(SCAM::Module &node);
        void visit(ModuleInstance &node);
        void visit(Port &node);
        void visit(DataSignal &node); //not used
        void visit(Channel &node);
        void visit(Interface &node); //not used
        void visit(Variable &node);
        void visit(FSM &node);
        void visit(DataType &node);
        void visit(Function &node);
        void visit(Parameter &node);

        unsigned int indent = 0;
        unsigned int indentSize = 2;
        ////////////////
        std::string Text_CMake();
        void Text_DataTypes();
        void printSpace(unsigned int size);

        std::stringstream ss;
    };


#endif //PROJECT_PRINTSYSTEMC_H
