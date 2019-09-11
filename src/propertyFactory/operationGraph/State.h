//
// Created by ludwig on 25.10.16.
//

#ifndef SCAM_PROP_STATE_H
#define SCAM_PROP_STATE_H

#include <Port.h>
#include <Stmts/Communication.h>
#include <assert.h>
#include <set>

namespace SCAM {

    /**
     * \brief: Represents a communication state
     */
    class Operation;

    class State {
    public:
        State(std::string section); //! Pointer so section
        State(const State &); //! Copy constructor
        State(std::string section, int stateId, Communication *commStmt); //! Communication is read
        State(std::string section, int stateId, Communication *commStmt, Expr *writeValue); //! Communication is write
        virtual ~State();

        void addOutgoingOperation(Operation *operation);

        void addIncomingOperation(Operation *operation);


        void removeIncomingOperation(Operation *operation);

        void removeOutgoingOperation(Operation *operation);

        //GETTER
        const std::string &getSection() const;

        const std::vector<Operation *> &getIncomingOperationList() const;

        const std::vector<Operation *> &getOutgoingOperationList() const;

        std::string getName() const; //! Returns the name : section_stateID;

        Port *getCommPort() const;

        Expr *getWriteValue() const;

        Communication *getCommStmt() const;

        void addCommStmt(Communication *commStmt);

        const std::set<Communication *> &getCommStmtSet() const;

        int getStateId() const;

        bool isInit() const; //! Returns true if state is init state
        bool isRead() const;

        bool isWrite() const;

        //Print
        std::string print() const;

        std::string printOutgoingOperations() const;

    private:
        std::string section; //! Section the communication State belongs to
        int stateId; //! Unique ID of the state
        Expr *writeValue;
        Communication *commStmt;    //! Stmt that is communication in this state
        std::set<Communication *> commStmtSet;
        std::vector<Operation *> outgoingOperationList;
        std::vector<Operation *> incomingOperationList;


    };
}

#endif //SCAM_STATE_H
