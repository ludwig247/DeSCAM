//
// Created by M.I.Alkoudsi on 08.06.19.
//

#ifndef SCAM_LIVENESSANALYSIS_H
#define SCAM_LIVENESSANALYSIS_H

#include<map>
#include "Behavior/CfgNode.h"
#include"ModelGlobal.h"
#include "PrintStmt.h"

namespace SCAM {
    /***
     * \brief: looks for dead assignments to variables and removes them from the control flow graph
     * \author: mi-alkoudsi
     * \inputs:
     *       - std::map<int, CfgNode *> CFG;
     *       - std::set<std::string> variablesThatHaveReadSet;
     * \outputs:
     *      - std::map<int, CfgNode *> optimizedCFG;
     * \details: Every statement is given input and output information for each variable in it, which are represented by a boolean flag.
     *  after initializing all flags with false, the CFG is repeatedly reversely traversed until the following rules are met:
     *  1.if there is a use of a var, then toggle its in info to true at the stmt that uses it
     *  2.if in info of any succ stmt = true  , current stmt out info = true
     *  3.set in info of every variable not used in current stmt to the output of it
     */
    class LivenessAnalysis : public StmtAbstractVisitor {
    public:
        LivenessAnalysis() = delete;

        LivenessAnalysis(std::map<int, CfgNode *> CFG,
                         const std::map<std::string, Variable *> &ModuleVariables);

        ~LivenessAnalysis() = default;

        void initLA(const std::map<std::string, Variable *> &ModuleVariables);

        const std::map<int, CfgNode *> &getCFG() const;

    private:
        bool deadNodeDetected;
        int currentNodeID;
        std::map<int, std::set<std::string>> variablesInStmtMap;
        std::map<int, CfgNode *> CFG;
        std::map<std::string, Variable *> moduleVariablesMap;
        std::map<std::string, std::map<int, std::pair<bool, bool>>> stmtInfoMap;  //contains propagated liveness analysis information for each stmt input and output
        std::map<std::string, std::set<int>> allAssignments;                      //stores for each variable in what nodes it is assigned
        std::vector<bool> toggledToTrueNodeVector;                                // true when a variable use detected/propagated at/to currentNode
        int numToTrueToggles;                                                     // if it doesn't change between runs,terminate algorithm
        std::set<int> deadAssignmentSet;
        std::map<int, Variable *> assignmentsToCompoundsVarsMap;

        void removeDeadStatementAndReplaceItInPredecessorsAndSuccessors(int nodeId);

        //visitors
        void visit(struct VariableOperand &node) override;

        void visit(struct IntegerValue &node) override {};

        void visit(struct UnsignedValue &node) override {};

        void visit(struct BoolValue &node) override {};

        void visit(struct EnumValue &node) override {};

        void visit(struct CompoundValue &node) override {};

        void visit(class PortOperand &node) override {};

        void visit(class Assignment &node) override;

        void visit(struct UnaryExpr &node) override;

        void visit(struct While &node) override {};

        void visit(struct If &node) override;

        void visit(struct Read &node) override;

        void visit(struct Write &node) override;

        void visit(struct SectionOperand &node) override {};

        void visit(class SectionValue &node) override {};

        void visit(struct ITE &node) override {};

        void visit(struct Arithmetic &node) override;

        void visit(struct Logical &node) override;

        void visit(struct Relational &node) override;

        void visit(struct Bitwise &node) override;

        void visit(struct SyncSignal &node) override {};

        void visit(struct DataSignalOperand &node) override {};

        void visit(struct Cast &node) override;

        void visit(struct FunctionOperand &node) override;

        void visit(struct ArrayOperand &node) override;

        void visit(class CompoundExpr &node) override;

        void visit(class ArrayExpr &node) override;

        void visit(class ParamOperand &node) override {};

        void visit(class Return &node) override {};

        void visit(class Notify &node) override {};

        void visit(class Wait &node) override {};

        void visit(class Peek &node) override {};

        void visit(class TimePointOperand &node) override {};

        void visit(class Ternary &node) override;
    };
}

#endif //SCAM_LIVENESSANALYSIS_H