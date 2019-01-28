//
// Created by ludwig on 25.10.16.
//

#ifndef SCAM_OPERATION_H
#define SCAM_OPERATION_H


#include <Stmts/Stmt.h>
#include <Stmts/Assignment.h>
#include "State.h"

namespace SCAM{
    class Operation {
    public:
        Operation(SCAM::State * state, SCAM::State * nextstate);
        Operation(const Operation & op, SCAM::State * state, SCAM::State * nextState);
        virtual ~Operation();

        //ADD
        void addAssumption(Expr* stmt);
        void addCommitment(Stmt* stmt);

        //GETTER
        State *getState() const;
        State *getNextState() const;

        int getOp_id() const;

        const std::vector<Expr *> &getAssumptionList() const;
        const std::vector<Assignment *> &getCommitmentList() const;

        void setCommitmentList(const std::vector<Assignment *> &commitmentList);

        void setAssumptionList(const std::vector<Expr *> &assumptionList);

        bool isWait() const;

        //SETTER
        void setWait(bool wait);

        //PRINT
        std::string print() const;

    private:
        State * state;
        State * nextstate;
        std::vector<Expr*> assumptionList;
        std::vector<Assignment*> commitmentList;
        bool wait;
        int op_id;
        static int op_cnt;
    };
}




#endif //SCAM_OPERATION_H
