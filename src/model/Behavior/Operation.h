//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 4/10/19.
//

#ifndef PROJECT_OPERATION2_H
#define PROJECT_OPERATION2_H

#include <vector>
#include <Stmt.h>
#include <string>
#include <sstream>
#include "Expr.h"
#include "State.h"
#include <map>

namespace DESCAM {

    class Operation {
    public:
        Operation();

        ~Operation();

        Operation& operator=(const Operation &operation) = default;

        // Getter
        bool IsReset();

        bool IsWait() const;

        const std::vector<DESCAM::Stmt *> &getStatementsList() const;

        const std::vector<Expr *> &getAssumptionsList() const;

        const std::vector<Assignment *> & getCommitmentsList() const;

        const std::vector<DESCAM::Assignment *> &getCommitmentList() const;

        DESCAM::State *getState() const;

        DESCAM::State *getNextState() const;

        // Setter
        void setStatementsList(std::vector<DESCAM::Stmt *> statementsList_arg);

        void setAssumptionsList(std::vector<Expr *> assumptionsList);

        void setCommitmentsList(std::vector<Assignment *> commitmentsList);

        void setState(DESCAM::State *state_arg);

        void setNextState(DESCAM::State *nextState);

        void setReset(bool reset);

        void setWait(bool wait);

        void addStatement(DESCAM::Stmt *stmt);

        void addAssumption(DESCAM::Expr *assumption);

        void addCommitment(DESCAM::Assignment *commitment);

        int getId() const;

        std::string print();

        static int operations_cnt;
    private:
        int id;

        std::vector<DESCAM::Stmt *> statementsList;
        std::vector<DESCAM::Expr *> assumptionList;
        std::vector<DESCAM::Assignment *> commitmentList;

        DESCAM::State *state;
        DESCAM::State *nextState;
        bool resetOperation;
        bool waitOperation;
    };
}

#endif //PROJECT_OPERATION2_H
