//
// Created by Dino Mehmedagić on 18.03.20.
//

#include <PluginFactory.h>
#include <AbstractVisitor.h>

#ifndef DESCAM_ESTIMATEPOWER_H
#define DESCAM_ESTIMATEPOWER_H

#endif //DESCAM_ESTIMATEPOWER_H


class EstimatePower : public PluginFactory, public AbstractVisitor {
public:
    EstimatePower() = default;
    ~EstimatePower() = default;

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

    void visit(Timepoint &node);
};