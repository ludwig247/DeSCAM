//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 17.04.18.
//

#ifndef PROJECT_PRINTTEMPLATE_H
#define PROJECT_PRINTTEMPLATE_H

#include <PluginFactory.h>
#include "Model.h"

class PrintTemplate : public PluginFactory, public AbstractVisitor {

public:
    PrintTemplate() = default;

    ~PrintTemplate() = default;

    std::map<std::string, std::string> printModel(Model *node);

private:
    void visit(Model &node) {};

    void visit(Module &node) {};

    void visit(Port &node) {};

    void visit(Variable &node) {};

    void visit(Function &node) {};

    void visit(Parameter &node) {};

    void visit(FSM &node) {};

    void visit(DataType &node) {};

    void visit(ModuleInstance &node) {};

    void visit(Channel &node) {};

    void visit(DataSignal &node) {};

    void visit(Interface &node) {};

};
#endif //PROJECT_PRINTTEMPLATE_H
