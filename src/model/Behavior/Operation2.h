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
#include "State2.h"
#include <map>

namespace SCAM {

    class Operation2 {
    public:
        Operation2();

        ~Operation2();

        // Getter
        bool IsReset();

        bool IsWait();

        const std::vector<SCAM::Stmt *> &getStatementsList() const;

        const std::vector<Expr *> &getAssumptionsList() const;

        const std::vector<Assignment *> &getCommitmentsList() const;

        SCAM::State2 *getState() const;

        SCAM::State2 *getNextState() const;

        // Setter
        void setStatementsList(std::vector<SCAM::Stmt *> statementsList_arg);

        void setAssumptionsList(std::vector<Expr *> assumptionsList);

        void setCommitmentsList(std::vector<Assignment *> commitmentsList);

        void setState(SCAM::State2 *state_arg);

        void setNextState(SCAM::State2 *nextState);

        void setReset(bool reset);

        void setWait(bool wait);

        void addStatement(SCAM::Stmt *stmt);

        void addAssumption(SCAM::Expr *assumption);

        void addCommitment(SCAM::Assignment *commitment);

        //IDs
        static int getOperations_cnt();

        int getId() const;

        std::string print();

        static int operations_cnt;
    private:
        int id;

        std::vector<SCAM::Stmt *> statementsList;
        std::vector<SCAM::Expr *> assumptionList;
        std::vector<SCAM::Assignment *> commitmentList;

        SCAM::State2 *state;
        SCAM::State2 *nextState;
        bool resetOperation;
        bool waitOperation;
    };
}

#endif //PROJECT_OPERATION2_H
