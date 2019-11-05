//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 4/25/19.
//

#ifndef PROJECT_STATE2_H
#define PROJECT_STATE2_H

#include <string>
#include <Port.h>
#include <Stmts/Communication.h>

namespace SCAM {

    class Operation2;

    class State2 {
    public:
        State2();

        explicit State2(std::string name);

        ~State2() = default;

        //GETTERS
        int getStateId() const;

        std::string getName() const;

        bool isInit() const;

        bool isWait() const;

        SCAM::Port *getCommunicationPort() const;

        const std::vector<SCAM::Operation2 *> &getOutgoingOperationsList() const;

        const std::vector<SCAM::Operation2 *> &getIncomingOperationsList() const;


        //SETTERS
        void setName(std::string name);

        void setInit();

        void setWait();

        void setCommunicationStmt(SCAM::Communication *commStmt);

        //ADDERS
        void addIncomingOperation(SCAM::Operation2 *incomingOperation);

        void addOutgoingOperation(SCAM::Operation2 *outgoingOperation);

        //REMOVE
        void removeIncomingOperation(SCAM::Operation2 *incomingOperation);

        void removeOutgoingOperation(SCAM::Operation2 *outgoingOperation);

        //WAIT STATE

        //Print
        std::string print() const;

        static int state_cnt;
    private:
        int stateId;
        std::string name;
        bool init;
        bool wait;
        SCAM::Communication *commStmt;    //! Stmt that is communication in this state
        std::vector<SCAM::Operation2 *> incomingOperationsList;
        std::vector<SCAM::Operation2 *> outgoingOperationsList;
        std::vector<std::vector<SCAM::Stmt *> > incomingFreezeSignals;
        std::vector<std::vector<SCAM::Stmt *> > outgoingAssignSignals;
    };

}

#endif //PROJECT_STATE2_H
