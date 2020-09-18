//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 4/25/19.
//

#ifndef PROJECT_STATE2_H
#define PROJECT_STATE2_H

#include <string>
#include <Port.h>
#include <Stmts/Communication.h>

namespace DESCAM {

    class Operation;

    class State {
    public:
        State() = delete;
        explicit State(std::string name);

        ~State() = default;

        //GETTERS
        int getStateId() const;

        std::string getName() const;

        bool isInit() const;

        bool isWait() const;

        DESCAM::Port *getCommunicationPort() const;

        const std::vector<DESCAM::Operation *> &getOutgoingOperationsList() const;

        const std::vector<DESCAM::Operation *> &getIncomingOperationsList() const;


        //SETTERS
        void setName(std::string name);

        void setInit();

        void setWait();

        void setCommunicationStmt(DESCAM::Communication *commStmt);

        //ADDERS
        void addIncomingOperation(DESCAM::Operation *incomingOperation);

        void addOutgoingOperation(DESCAM::Operation *outgoingOperation);

        //REMOVE
        void removeIncomingOperation(DESCAM::Operation *incomingOperation);

        void removeOutgoingOperation(DESCAM::Operation *outgoingOperation);

        //WAIT STATE

        //Print
        std::string print() const;

        static int state_cnt;
    private:
        int stateId;
        std::string name;
        bool init;
        bool wait;
        DESCAM::Communication *commStmt;    //! Stmt that is communication in this state
        std::vector<DESCAM::Operation *> incomingOperationsList;
        std::vector<DESCAM::Operation *> outgoingOperationsList;
        std::vector<std::vector<DESCAM::Stmt *> > incomingFreezeSignals;
        std::vector<std::vector<DESCAM::Stmt *> > outgoingAssignSignals;
    };

}

#endif //PROJECT_STATE2_H
