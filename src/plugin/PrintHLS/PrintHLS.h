//
// Created by johannes on 28.07.19.
//

#ifndef SCAM_PRINTHLS_H
#define SCAM_PRINTHLS_H

#include <memory>

#include <PluginFactory.h>

#include "Model.h"
#include "PrintSynthesisScripts.h"
#include "OptimizeForHLS.h"

class PrintHLS : public PluginFactory, public AbstractVisitor {
public:
    PrintHLS();
    ~PrintHLS() override = default;

    std::map<std::string, std::string> printModel(Model *node) override ;

private:
    std::stringstream ss;

    PropertySuite *propertySuite;
    SCAM::Module *currentModule;

    std::unique_ptr<PrintSynthesisScripts> synthesisScript;
    std::unique_ptr<OptimizeForHLS> utils;

    void dataTypes();
    void functions();
    void operations();

    void functionParameters();
    void assumptions(AbstractProperty *successorProperty);

    void visit(Model &node) override {};
    void visit(SCAM::Module &node) override {} ;
    void visit(ModuleInstance &node) override {};
    void visit(Port &node) override  {};
    void visit(DataSignal &node) override {};
    void visit(Channel &node)  override {};
    void visit(Interface &node)  override {}
    void visit(Variable &node) override {};
    void visit(FSM &node) override {};
    void visit(DataType &node) override ;
    void visit(Function &node) override ;
    void visit(Parameter &node) override {};
};

#endif //SCAM_PRINTHLS_H
