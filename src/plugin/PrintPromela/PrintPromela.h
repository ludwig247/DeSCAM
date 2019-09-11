//
// Created by tobias on 04.01.17.
//

#ifndef PROJECT_PROMELASYNTH_H
#define PROJECT_PROMELASYNTH_H

#include <Model.h>
#include <sstream>

#include "PrintStmtForPromela.h"

namespace SCAM{

class PrintPromela: public AbstractVisitor {
public:
    PrintPromela(Model * model);
    std::string print();
private:
    void visit(class Model &node) override;
    void visit(class Module &node) override;
    void visit(class ModuleInstance &node) override;
    void visit(class Port &node) override;
    void visit(class Channel &node) override;
    void visit(class Interface &node) override;
    void visit(class Variable &node) override;
    void visit(class Function &node) override;
    void visit(class FSM &node) override;
    void visit(class DataType &node) override;
    void visit(class DataSignal &node) override;
    void visit(class Parameter &node) override;


    Model * model;
    ModuleInstance *topInstance;

    std::stringstream ss;
    std::string createCommStmtUnless(State *state);
    std::string createCommStmtHandshake(State *state);
};
}

#endif //PROJECT_PROMELASYNTH_H
