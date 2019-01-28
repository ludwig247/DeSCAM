//
// Created by joakim on 11/8/16.
//

#ifndef SCAM_PRINTAML_H
#define SCAM_PRINTAML_H

#include <PluginFactory.h>
#include <sstream>
#include "Model.h"
#include "PrintStmt.h"

    class PrintAML : public PluginFactory, public AbstractVisitor {
    public:
        PrintAML() = default;
        ~PrintAML() = default;

         std::map<std::string, std::string> printModel(Model *node);
    private:
        void visit(Model& node);
        void visit(SCAM::Module& node);
        void visit(ModuleInstance& node); //not used
        void visit(Port& node);
        void visit(DataSignal &node);
        void visit(Channel& node); //not used
        void visit(Interface& node); //not used
        void visit(Variable& node);
        void visit(FSM& node);
        void visit(DataType &node);
        void visit(Function &node);
        void visit(Parameter &node);

        unsigned int indent = 0;
        unsigned int indentSize = 2;
        void printSpace(unsigned int size);

        std::stringstream ss;
    };

#endif //SCAM_PRINTAML_H


