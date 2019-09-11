//
// Created by anna on 27.06.18.
//

#ifndef PROJECT_PRINTLTL_H
#define PROJECT_PRINTLTL_H

#include <Model.h>
#include <sstream>

namespace SCAM{
    class PrintLTL: public AbstractVisitor {

    public:
        PrintLTL(SCAM::Model *model);
        std::string print();

        void optimizeCommunicationFSM();

    private:
        void visit(class Model &node) override;
        void visit(class Module &node) override;
        void visit(class ModuleInstance &node) override;
        void visit(class Port &node) override;
        void visit(class Channel &node) override;
        void visit(class Interface &node) override;
        void visit(class Variable &node) override;
        void visit(class FSM &node) override;
        void visit(class DataType &node) override;
        void visit(class DataSignal &node) override;
        void visit(class Function &node) override;
        void visit(class Parameter &node) override;

        std::string createCommStmt(SCAM::State *state);

        Model * model;
        ModuleInstance *topInstance;

        std::stringstream ss;

        ModuleInstance *currentInstance;
        Module *currentModule;

        std::map<int, State *> stateMap;
        std::map<std::string ,SCAM::Variable*> stateVarMap;

        int getOpCnt(std::map<int, State *> stateMap);
    };
}

#endif //PROJECT_PRINTLTL_H
