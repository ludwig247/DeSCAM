//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 4/22/19.
//

#ifndef PROJECT_OPERATIONFACTORY_H
#define PROJECT_OPERATIONFACTORY_H

#include <map>
#include <Module.h>
#include "Behavior/CfgNode.h"
#include "Behavior/State.h"
#include "Behavior/Operation.h"

namespace DESCAM {

    /**
     * \brief: This class encapsulate the entire process of analyzing the module's CFG and generating the operational properties.
     *
     * \input:
     *          - DESCAM::Module * module;
     *          - std::map<int, DESCAM::CfgNode *> cfg;
     * \output:
     *          - PropertySuite * propertySuite;
     *
     * Steps:
     *      1- Find important states in the graph and color them, and find CFG paths between them :
     *          - For Slave modules:
     *              - Coloring includes wait statements.
     *          - For other modules:
     *              - Initial coloring includes blocking communication and wait statements.
     *              - Secondary coloring includes master communications
     *      2- Create operations:
     *          Create operations given all combinations of communications synchs
     *      3- Reconstruct operations:
     *          Propagates assignments through the statements list and sort them into assumptions and commitments
     *      4- Find valid operations:
     *          Check if operation's assumption list has contradictions and making the operation unreachable
     *      5- Optimize conditions:
     *          Get rid of redundant assumptions
     *      6- Optimize Assignments:
     *      7- Optimize operations:
     *          Getting rid of redundant variables; variables not getting any commitments through any operation
     *      8- Generate property suite:
     *          restructure operations into starting and ending states, freezing variables and notify signals ...
     *
     */
    class OperationFactory {
    public:
        OperationFactory(std::map<int, DESCAM::CfgNode *> controlFlowMap, DESCAM::Module * module);
        ~OperationFactory() = default;

    private:
        DESCAM::Module * module;
        std::map<int, DESCAM::CfgNode *> cfg;
        std::vector<std::vector<DESCAM::CfgNode *> > rawOperations;
        std::map<std::string, DESCAM::State *> statesMap;
        std::vector<DESCAM::Operation*> operations;
        std::map<std::string, Variable*> varMap;

        void findOperations();
        void createOperations();
        void reconstructOperations();
        void findValidOperations();
        void checkStates();
        void optimizeConditions();
        void optimizeAssignments();
        void optimizeTernary();
        void optimizeOperations();



        static void simplifyTernary(const std::vector<Expr *>& assumptionList, Expr *expr);
    };

}

#endif //PROJECT_OPERATIONFACTORY_H
