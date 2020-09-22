//
// Created by tobias on 17.07.18.
//

#ifndef PROJECT_FUNCTION_H
#define PROJECT_FUNCTION_H

#include <Parameter.h>
#include <Stmts/Stmt.h>
#include <Stmts/Return.h>
#include "AbstractNode.h"
#include "DataType.h"
#include <Behavior/CfgNode.h>

namespace DESCAM {
    class Function : public AbstractNode {
    public:
        Function(std::string name, DataType *returnType, const std::map<std::string, Parameter *> &paramMap, LocationInfo = LocationInfo());

        Function(Function *function);

        virtual ~Function();

        //Getter
        DataType *getReturnType() const;

        const std::map<std::string, Parameter *> &getParamMap() const;

        const std::vector<Stmt *> &getStmtList() const;

        void setStmtList(const std::vector<Stmt *> &stmtList);


        const std::vector<std::pair<Return *, std::vector<Expr *>>> &getReturnValueConditionList() const;

        void setReturnValueConditionList(const std::vector<std::pair<Return *, std::vector<Expr *>>> &returnValueConditionList);

        virtual void accept(AbstractVisitor &visitor);

        const std::map<int, DESCAM::CfgNode *> &getCfg() const;

        void setCfg(const std::map<int, DESCAM::CfgNode *> &cfg);

    private:
        std::vector<std::pair<DESCAM::Return *, std::vector<DESCAM::Expr *> > > returnValueConditionList; //! Stores the return value for each possible sequence of inputs
        DataType *returnType;
        std::vector<Stmt *> stmtList;
        std::map<std::string, Parameter *> paramMap;

        std::map<int, DESCAM::CfgNode *> cfg;


    };
}


#endif //PROJECT_FUNCTION_H
