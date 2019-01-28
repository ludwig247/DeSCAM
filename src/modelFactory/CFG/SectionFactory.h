//
// Created by ludwig on 21.01.16.
//

#ifndef SCAM_FLATTENMODEL_H
#define SCAM_FLATTENMODEL_H

#include <FSM.h>
#include <iostream>
#include <Module.h>
#include "FindEndNode.h"
#include "FlattenIf.h"
#include "FlattenWhile.h"

namespace  SCAM{

/** \brief Creates the FSM for the module from a control Flow
 *
 *  Tasks:
 *  - Dected states or add default states init&run
 *  - Analyze behavior within the states
 *
 *  -> Result is stored in flattenMap
 *
 */
class SectionFactory {

public:
    SectionFactory(SCAM::Module *module, const std::map<int, CFGNode *> &controlFlowMap, bool expliciteStates);
    void print();
    const std::map<std::string, std::vector<Stmt *>> & getSectionPathMap();

private:
    void findFlattenModel(); //! creates the flattenModel for each section
    void findSections(); //! Fills the sectionMap with all sections
    void findStartEndMap(); //! Fills the startEndMap with all start and endpoints for every branch
    void initList(); //! Create list for initial section
    SCAM::Module * module;
    std::map<int, CFGNode *> controlFlowMap;
    std::map<SCAM::CFGNode *, SCAM::CFGNode *> startEndMap; //! <startNode,endNode> everthing that is contained within an if block
    std::map<std::string,std::vector<SCAM::Stmt*>> sectionPathMap; //! Contains an entry for each section with all stmts that are within a section
    std::map<std::string,SCAM::CFGNode *> sectionMap; //! Contains the startnode for every section of the module
    bool explicteState; //! True if module has explicite section
    std::map<SCAM::CFGNode*,std::set<int>> pathNodeMap;
};

}

#endif //SCAM_FLATTENMODEL_H
