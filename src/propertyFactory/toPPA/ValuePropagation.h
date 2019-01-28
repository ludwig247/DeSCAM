//
// Created by tobias on 22.07.16.
//

#ifndef SCAM_PATHOPTIMIZER_H
#define SCAM_PATHOPTIMIZER_H

#include "Path.h"
#include <StmtAbstractVisitor.h>
#include <Stmt.h>
namespace SCAM{

/**
 * \brief Propagates assignments through the stmtlist
 *
 * Look through all stmts of a path in case of an assigment
 * Propagate to all further usages of this variable
 * E.g.:
 * AML
 * [...]
 * cnt = cnt + 3
 * if(cnt < 10
 * [...]
 *
 * In path change condition from
 * cnt < 10
 * to
 * (cnt+3) < 10
 * Because the path always assumes the value of cnt at the beginning
 * -------------------------------------------------------
 * STEP 1: Create a variableMap
 * -------------------------------------------------------
 * For each variable that is assigned a new value
 *  -------------------------------------------------------
 * STEP 2: Redirect pointer
 * -------------------------------------------------------
 * Every time a variable is used it is checked whether this variable has a previous
 * assignment. If there is a new assignment vor a variable it is stored in the variableValue map.
 */


class ValuePropagation: public SCAM::StmtAbstractVisitor {
public:

    ValuePropagation(const std::map<std::string, std::vector<SCAM::Path *> > &sectionPathMap, SCAM::Module *module);
    ValuePropagation(const std::map<std::string, std::vector<SCAM::Path *> > &sectionPathMap, SCAM::Function * function);
    ValuePropagation(SCAM::Module *module);

    virtual void visit(struct VariableOperand &node) override;
    virtual void visit(struct IntegerValue &node) override;
    virtual void visit(struct UnsignedValue &node) override;
    virtual void visit(struct BoolValue &node) override;
    virtual void visit(struct EnumValue &node) override;
    virtual void visit(struct CompoundValue &node) override;
    virtual void visit(class PortOperand &node) override;
    virtual void visit(class Assignment &node) override;
    virtual void visit(struct UnaryExpr &node) override;
    virtual void visit(struct While &node) override;
    virtual void visit(struct If &node) override;
    virtual void visit(struct Read &node) override;
    virtual void visit(struct Write &node) override;
    virtual void visit(struct SectionOperand &node) override;
    virtual void visit(class SectionValue &node) override;
    virtual void visit(struct ITE &node) override;
    virtual void visit(struct Arithmetic &node) override;
    virtual void visit(struct Logical &node) override;
    virtual void visit(struct Relational &node) override;
    virtual void visit(struct Bitwise &node) override;
    virtual void visit(struct NBRead &node) override;
    virtual void visit(struct NBWrite &node) override;
    virtual void visit(struct SyncSignal &node) override;
    virtual void visit(struct DataSignalOperand &node) override;
    virtual void visit(struct Cast &node) override;
    virtual void visit(struct SCAM::FunctionOperand &node);
    virtual void visit(struct SubSelect &node);
    virtual void visit(class CompoundExpr &node);
    virtual void visit(class ParamOperand &node);
    virtual void visit(class Return &node);

    std::map <std::string, std::vector<Path *>> getNewSectionPathMap();


    void propagatePath(Path* path);

private:


    SCAM::Expr  *find_or_add_variable(std::string varName, SCAM::Expr * expr);
    std::map<std::string, std::vector<Path *>> sectionPathMap;
    SCAM::Path* path;
    SCAM::Expr * newExpr;

    bool isStateVar;

    SCAM::Module * module;
    std::map<std::string,SCAM::Expr*> variableValueMap; //! Contains the current pointer to the value of a variable

    std::map<std::string,SCAM::Expr*> variableMap; //! Contains an entry for each variable_name,Variable*

    void reset();

    Return *returnValue;//! If a path leads to a return, var stores the propagated return value
};
}

#endif //SCAM_PATHOPTIMIZER_H
