//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 17.04.18.
//

#ifndef PROJECT_Completeness_H
#define PROJECT_Completeness_H

#include <PluginFactory.h>
#include "Model.h"

class PrintCompleteness : public PluginFactory, public AbstractVisitor {

public:
    PrintCompleteness() = default;

    ~PrintCompleteness() = default;

    std::map<std::string, std::string> printModel(Model *node);

  std::map<std::string, bool> getOptionMap() override {
    return CommandLineParameter::getOptionMap("PrintCompleteness");
  }
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

    void visit(TimeExpr &node) {};

};

#endif //PROJECT_PrintEPPA_H
