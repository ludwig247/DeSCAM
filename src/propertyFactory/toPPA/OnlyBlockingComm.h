//
// Created by ludwig on 25.04.17.
//

#ifndef PROJECT_ONLYBLOCKINGCOMM_H
#define PROJECT_ONLYBLOCKINGCOMM_H


#include <vector>
#include <map>
#include "FindCommunication.h"
#include "Path.h"
#include "State.h"
#include <State.h>
#include <sstream>
#include "ExprVisitor.h"
#include <PrintStmt.h>
#include <assert.h>
#include "SectionToPaths.h"
#include "ReplaceStmt.h"

namespace SCAM {

    class OnlyBlockingComm {
/*!
 * \brief Creates paths that only contain one communication point
 *
 */
    public:
        OnlyBlockingComm(const std::map<std::string, std::vector<SCAM::Path *>> &sectionPathMap);

        virtual ~OnlyBlockingComm();

        //!Prints the new created paths
        std::string print() const;

        //! Returns the paths ordered by section
        std::map<std::string, std::vector<SCAM::Path *> > getNewSectionPathMap();

        const std::map<int, State *> &getStateMap() const;


    private:

        int find_or_add_communication(SCAM::Stmt *, std::string nextstate, std::string section); //! Returns the unique id for the communication
        void addWait();
        void addNB();
        void splitPathAtCommPoint();

        std::map<std::string, std::vector<SCAM::Path *> > sectionPathMap; //! Contains the original paths ordered by sections
        std::map<std::string, std::vector<SCAM::Path *> > sectionNewPathMap; //! Contains the paths ordered by sections
        std::map<std::pair<SCAM::Stmt *, std::string>, int> communicationMap; //! Contains an unique id for each communication point


        std::map<int, State *> stateMap;
    };
};


#endif //PROJECT_ONLYBLOCKINGCOMM_H
