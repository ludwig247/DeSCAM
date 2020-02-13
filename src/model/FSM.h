//
// Created by ludwig on 20.11.15.
//

#ifndef SCAM_STATE_H
#define SCAM_STATE_H

#include <Stmts/Stmt.h>
#include "AbstractNode.h"
#include "Variable.h"
#include "Behavior/Operation.h"


namespace SCAM {
    /*!
     * \brief Class contains the finite state machine of a module
     */
    class Path;

    class FSM : public AbstractNode {
    public:
        FSM(Module *module);

        virtual ~FSM();

        //SectionMap
        void setSectionMap(std::map<std::string, std::vector<SCAM::Stmt *>> sectionMap);

        const std::map<std::string, std::vector<SCAM::Stmt *>> &getSectionMap();

        //Sections
        Variable *getSectionVariable() const; //TODO delete
        Variable *getNextSectionVariable() const; //TODO delte
        void setSections(DataType *sectionType, std::string initialSection); //TODO: delete
        std::string getInitialSection(); //TODO: delete
        std::vector<std::string> getSectionList(); //TODO: delte
        //Module
        Module *getModule() const; //TODO: delete

        //OperationPathMap
        const std::map<Operation *, Path *> &getOperationPathMap() const; //TODO delete ?
        void setOperationPathMap(const std::map<Operation *, Path *> &operationPathMap); //TODO delete?

        //StateMap
        const std::map<int, State *> &getStateMap() const;
        void setStateMap(const std::map<int, State *> &stateMap);

        //Accept
        virtual void accept(AbstractVisitor &visitor);

    private:
        FSM();

        Module *module;
        Variable *sectionVariable; //! Section that is currently executed
        Variable *nextSectionVariable; //! Section that is executed next

        std::map<std::string, std::vector<SCAM::Stmt *>> sectionMap; //!Sections: a section exists for each state of the FSM with the stmts within the section
        std::map<int, State *> stateMap; //! Stores a map of the abstract states and the connecting operations
        std::map<Operation *, Path *> operationPathMap;
    };
}


#endif //SCAM_STATE_H
