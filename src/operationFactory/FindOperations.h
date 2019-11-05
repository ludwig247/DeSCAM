//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 3/4/19.
//

#ifndef PROJECT_COLORREALCFG_H
#define PROJECT_COLORREALCFG_H

#include <map>
#include "Behavior/CfgNode.h"
#include "Model.h"
#include "Behavior/State2.h"
#include "Behavior/CfgNode.h"
#include "ValidOperations.h"
#include <OperationMiscellaneous/FindStateBacktrack.h>
#include <OperationMiscellaneous/FindStateOperations.h>
#include <OperationMiscellaneous/PrintStmtForDotSpurious.h>
#include <OperationMiscellaneous/FindCommunication2.h>
#include <NodePeekVisitor.h>


namespace SCAM{

    /**
     * \brief: This class encapsulate the entire process of analyzing the module's CFG and generating the operational properties.
     *
     * \input:
     *          - SCAM::Module * module;
     *          - std::map<int, SCAM::CfgNode *> cfg;
     * \output:
     *          - std::vector<std::vector<SCAM::CfgNode *> > operations;
     *          - std::map<std::string, SCAM::State2 *> statesMap;
     *
     * Steps:
     *      1- Check sanity:
     *          Find out if the module has slave and blocking communications and blocking at the same time.
     *      2- Find initial states:
     *          Initial coloring only includes root node, wait(0, NS) and blocking communication statements.
     *      3- Process the CFG:
     *          For every important state:
     *              - Find all possible back tracks from the state leading to the "while(true)"
     *              - Find all paths starting from the state and leading to other states
     *                  - Process if path finding leads to a fixed loop (i.e. spurious path)
     *                      - For slave modules: throw an error
     *                      - For others: attempt secondary coloring for master communication
     *              - Decide what paths are reachable given the possible backtracks of the state
     *              - For all valid paths, check communications order
     *                  - For slave modules: check the order of slave inputs then outputs
     *                  - For all modules: check the order of master communications
     */

    class FindOperations {
    public:
        explicit FindOperations(std::map<int, SCAM::CfgNode *> controlFlowMap, SCAM::Module * module);

        virtual ~FindOperations() = default;

        const std::map<std::string, SCAM::State2 *> &getStatesMap() const;
        const std::vector<std::vector<SCAM::CfgNode *> >& getOperations() const;

    private:
        std::map<int, SCAM::CfgNode *> cfg;
        SCAM::CfgNode * whileNode;
        std::vector<SCAM::CfgNode *> importantStates;
        std::vector<std::vector<SCAM::CfgNode *> > operations;
        std::map<std::string, SCAM::State2 *> statesMap;
        SCAM::Module * module;
        std::map<SCAM::Port *, bool> slaveInOrder;
        std::map<SCAM::Port *, bool> slaveOutOrder;

        bool new_important_state;
        bool slaveModule;
        void checkSanity();
        void findInitialImportantStates();
        void processCFG();
        void processSpurious(std::vector<SCAM::CfgNode *> spuriousPath);
        void processSpuriousSlave(const std::vector<SCAM::CfgNode *>& spuriousPath);
        std::string printCFG_Spurious(std::vector<SCAM::CfgNode *> spuriousPath);
        void checkForMasters();
        void checkForSlaves();
        bool checkSlavesOrder(const std::vector<SCAM::CfgNode *>& pathSlaves);
    };

}


#endif //PROJECT_COLORREALCFG_H
