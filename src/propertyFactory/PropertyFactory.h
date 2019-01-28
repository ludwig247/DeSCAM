//
// Created by tobias on 01.07.16.
//

#ifndef SCAM_PROPERTYFACTORY_H
#define SCAM_PROPERTYFACTORY_H

#include <Model.h>
#include <Path.h>
#include <operationGraph/Operation.h>

#include <toPPA/SectionToPaths.h>
#include <toPPA/ConditionOptimizer.h>
#include <toPPA/ValuePropagation.h>
#include <CleanUpPaths.h>
#include <toPPA/DataPathOptimizer.h>
#include <PrintStmt.h>
#include "toPPA/CommToCommNew.h"

namespace SCAM{

/*!
 * \brief Constructs for module of a model the complete set of properties
 *
 *
 * -------------------------------------------------------
 * STEP 1: Find all paths
 * -------------------------------------------------------
 * findPaths() Find every path for each section of the module
 * Path: start state, end state, conditions for branches, stmts
 *
 *  -------------------------------------------------------
 * STEP 2: Analyze paths for communication
 * -------------------------------------------------------
 * addCommuniction(): adds communication information to paths
 *
 * We are considering blocking communication and there can be multiple communications within one path.
 * If this is the case, two things can happen.
 * a) All synchronization signals for each communication port are high -> all communication happens within one cycle
 * -> foreach communication add port_sync == true to conditions
 * b) Not every communication is possible -> need to wait at specific communication point
 * Split up paths at this point
 *
 */

class PropertyFactory {
public:
    //TODO change this to model make "general" start
    PropertyFactory(SCAM::Module *module);
    virtual ~PropertyFactory();

    const std::map<std::string, std::vector<Path *>> &getSectionPathMap() const;

    std::string print();
    std::string printOperations();


private:
    SCAM::Module * module;
    std::map<std::string, std::vector<SCAM::Path *> > sectionPathMap;
    std::map<Operation*, Path * > operationPathMap;

    void createInitSection(SCAM::Module *module); //! Finds or add init section

    void createPaths(); //! Finds all paths for the module

    void addCommunication(); //! Adds communication information to paths

    void createCommToCommPaths(); //! Creates path that start end in a commState

    void valuePropagation(); //! Propagates values true the paths

    void optimizeConditions(); //! Simplifies coniditions

    void optimizeDataPath(); //! Simplifies dataPaths

    std::vector<Operation*> operationList;

    std::map<int, State *> stateMap;

    int getPathCnt();

    void createCommunicationFSM();

};


}
#endif //SCAM_PROPERTYFACTORY_H
