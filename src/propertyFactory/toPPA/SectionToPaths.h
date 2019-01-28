//
// Created by tobias on 01.07.16.
//

#ifndef SCAM_SECTIONVISITOR_H
#define SCAM_SECTIONVISITOR_H

#include <StmtAbstractVisitor.h>
#include <Stmt.h>
#include <vector>
#include "Path.h"

namespace SCAM {
    /*!
     * \brief Find all paths within in a section
     *
     *
     * Two things can happen:
     * a) Non-branch node: add current stmt to all exisiting paths
     * b) branch node: duplicate all existing paths, to one half all stmts of the true branch are added
     * to the other half all stmts of the false branch are added(see visit(struct ITE))
     *  Example:
     *  @collecting
     *  if (cnt < 5) {
     *               lcd_value = lcd_value + sensor->read();
     *               sensor->nb_read(lcd_value);
     *               ++cnt;
     *               if(cnt == 5){
     *                   nextstate = printing;
     *               }
     *           }
     *
     *  Resulting paths:
     *  Path #0
     *  Conditions:
     *   cnt == 5
     *   cnt < 5
     *  Stmts:
     *   lcd_value = lcd_value + sensor->read()
     *   sensor->nb_read(lcd_value)
     *   ++cnt
     *   nextstate = printing
     *
     *  Path #1
     *  Conditions:
     *   !cnt == 5
     *   cnt < 5
     *  Stmts:
     *   lcd_value = lcd_value + sensor->read()
     *   sensor->nb_read(lcd_value)
     *   ++cnt
     *
     *  Path #2
     *  Conditions:
     *   !cnt < 5
     *  Stmts:
     *
     */

    class SectionToPaths : public StmtAbstractVisitor {
    public:
        virtual ~SectionToPaths();
        SectionToPaths(const std::map<std::string, std::vector<Stmt *>> &sectionMap);

        const std::map<std::string, std::vector<Path *>> &getNewSectionPathMap() const;

    private:
        std::vector<SCAM::Path*> getPathList();
        SectionToPaths(std::string section, std::vector<Stmt *> stmtList);
        SectionToPaths(){throw std::runtime_error("Constructor not allowed");};

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
        virtual void visit(struct Bitwise &node) override;
        virtual void visit(struct Relational &node) override;
        virtual void visit(struct NBRead &node) override;
        virtual void visit(struct NBWrite &node) override;
        virtual void visit(struct SyncSignal &node) override;
        virtual void visit(struct DataSignalOperand &node) override;
        virtual void visit(struct Cast &node) override;
        virtual void visit(class SCAM::FunctionOperand &node);
        virtual void visit(class CompoundExpr &node);
        virtual void visit(class SCAM::SubSelect &node);
        virtual void visit(class SCAM::ParamOperand &node);
        virtual void visit(class SCAM::Return &node);


        static std::map<SCAM::Stmt*,SCAM::Stmt*> trueMap; //! <condition, if-stmt> Contains an entry for each if
        static std::map<SCAM::Stmt*,SCAM::Stmt*> falseMap; //! <condition, if-stmt> Contains an entry for each if
        void appendStmtToPaths(SCAM::Stmt *stmt); //! Appends the current stmt to each of the paths
        std::vector<SCAM::Path*> pathList;

        std::string section; //! Section the path is in
        std::string nextSection; //! In case of nextstate assignemnt => nextSection = nextstate
        std::map<std::string,std::vector<SCAM::Path*>> sectionPathMap;
        SCAM::Stmt* find_or_add_true(Expr *conditionStmt); //! Either looks up the if-stmt for the condition or creates a new one
        SCAM::Stmt* find_or_add_false(Expr *conditionStmt); //! Either looks up the if-stmt for the condition or creates a new one
    };



}

#endif //SCAM_SECTIONVISITOR_H
