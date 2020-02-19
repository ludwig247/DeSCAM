//
// Created by M.I.Alkoudsi on 28.05.19.
//

#ifndef SCAM_PROPAGATECONSTANTVALUE_H
#define SCAM_PROPAGATECONSTANTVALUE_H

#include <StmtAbstractVisitor.h>
#include <Stmt.h>
#include "Behavior/CfgNode.h"
#include <ModelGlobal.h>
#include <vector>
#include <map>
#include "DetectCounterVariable.h"
#include <PrintStmt.h>
#include <cassert>
#include "ExprVisitor.h"

namespace SCAM {

/**
 *  \brief check assignments of a specific variable through each path of all possible paths in the CFG
 *  \author:mi-alkoudsi
 *  \inputs:
 *    - std::map<int, std::vector<SCAM::CfgNode *>> allPathsToNodeMap;
 *    - SCAM::Variable *var;
 *    - int stmtId;
 *  \outputs:
 *    - SCAM::Expr *propagatedValue;
 *    - int numLastAssignments;
 *    - std::map<int, SCAM::Expr *> lastAssignmentsMap;
 *  \details: On each Path, only the last assignment to the variable kept.
 *  if there was no read to the variable on any of the paths =>
 *  the result is map containing all last assignments, and if and only if they are all equal then propagation is valid
 *  Note: if the assignment contains another variable which is assigned before the statement to which we want to propagate, propagation is not valid.
 */

    class PropagateConstantValue : public SCAM::StmtAbstractVisitor {
    public:

        PropagateConstantValue(const std::map<int, std::vector<SCAM::CfgNode *>> &allPathsToNodeMap,
                               SCAM::Variable *var,int stmtId);

        SCAM::Expr *getPropagatedValue() const;

        int getNumLastAssignments() const;

        const std::map<int, SCAM::Expr *> &getLastAssignmentsMap() const;

    private:
        SCAM::Variable *variable;
        SCAM::Expr *propagatedValue;
        int stmtId;
        int currentNodeId{};
        int lastAssignmentId{};
        bool lastAssignmentAlreadyStored;
        int numLastAssignments;
        bool isVarRead;                                                                  // true when the last assignment of a specific path to the variable at hands is a read
        bool wasRhsVarOp{};                                                              // true when the right handside of an assignment is a variable operand
        std::map<std::string,std::set<int>> rhsVariableAssignmentsIds;                   // used when wasRhsVarOp is true to keep track of assignments to the rhs variable
        std::map<std::string, SCAM::Expr *> variableValueMap;                            // Contains the current pointer to the value/s of a variable
        std::map<int, SCAM::Expr *> LastAssignmentMap;                                   // Contains last assignments for a variable at a path n
        std::map<int, std::vector<SCAM::CfgNode *>> allPathsToNodeMap;                   // Contains all the paths of the blockCFG

        //returns the last assignment value to the variable in check, null ptr in case of no assignment on the path or if the last assignment is read
        SCAM::Expr *lastVariableValueInPath(const std::vector<SCAM::CfgNode *> &path);

        //if varName found in variableValueMap, change the value to expr, otherwise add them
        void addOrSubstituteVariableValue(const std::string& varName, SCAM::Expr *expr);

        void checkIfRhsOfAssignmentIsAVarOp(SCAM::Expr *rhs);

        //visitors
        void visit(struct VariableOperand &node) override {};

        void visit(struct IntegerValue &node) override {};

        void visit(struct UnsignedValue &node) override {};

        void visit(struct BoolValue &node) override {};

        void visit(struct EnumValue &node) override {};

        void visit(struct CompoundValue &node) override {};

        void visit(class PortOperand &node) override {};

        void visit(class Assignment &node) override;

        void visit(struct UnaryExpr &node) override {};

        void visit(struct While &node) override {};

        void visit(struct If &node) override {};

        void visit(struct Read &node) override;

        void visit(struct Write &node) override;

        void visit(struct SectionOperand &node) override {};

        void visit(class SectionValue &node) override {};

        void visit(struct ITE &node) override;

        void visit(struct Arithmetic &node) override {};

        void visit(struct Logical &node) override {};

        void visit(struct Relational &node) override {};

        void visit(struct Bitwise &node) override {};

        void visit(struct SyncSignal &node) override {};

        void visit(struct DataSignalOperand &node) override {};

        void visit(struct Cast &node) override {};

        void visit(struct SCAM::FunctionOperand &node) override {};

        void visit(struct ArrayOperand &node) override {};

        void visit(class CompoundExpr &node) override {};

        void visit(class ArrayExpr &node) override {};

        void visit(class ParamOperand &node) override {};

        void visit(class Return &node) override;

        void visit(class Notify &node) override {};

        void visit(class Wait &node) override {};

        void visit(class Peek &node) override {};

        void visit(class TimePointOperand &node) override {};

        void visit(class CompareOperator &node) override;

    };
}

#endif //SCAM_PROPAGATECONSTANTVALUE_H
