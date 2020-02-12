//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 4/22/19.
//


#include <PrintStmt.h>
#include <PrintITL/ConditionVisitor.h>
#include <PrintITL/DatapathVisitor.h>
#include "OperationFactory.h"
#include "FindOperations.h"
#include "CreateOperations.h"
#include "ReconstructOperations.h"
#include "ValidOperations.h"
#include "OperationOptimizations/ConditionOptimizer2.h"
#include "OperationOptimizations/AssignmentOptimizer2.h"
#include "OperationOptimizations/OptimizeOperations2.h"
#include "PropertySuite.h"
#include "CreateOperationsSlave.h"
#include "../parser/CommandLineParameter.h"
#include <thread>
#include <CreatePropertySuite.h>

namespace SCAM {
    OperationFactory::OperationFactory(std::map<int, SCAM::CfgNode *> controlFlowMap, SCAM::Module *module) :
            propertySuite(nullptr),
            module(module),
            cfg(std::move(controlFlowMap)) {
        std::cout << "======================" << std::endl;
        std::cout << "Operations generation:" << std::endl;
        std::cout << "----------------------" << std::endl;
        std::cout << "Find Operations:" << std::endl;
        this->findOperations();
        std::cout << "\tFound: " << this->rawOperations.size() << std::endl;
        std::cout << "Create Operations: " << std::endl;
        this->createOperations();
        std::cout << "\tCreated: " << this->operations.size() << std::endl;

        std::cout << "Reconstruct Operations: " << std::endl;
        this->reconstructOperations();
        std::cout << "Valid Operations: " << std::endl;
        this->findValidOperations();
        std::cout << "\tValid: " << this->operations.size() << std::endl;
        this->checkStates();
        auto optimizerOptionsSet = CommandLineParameter::getOptimizeOptionsSet();
        if (optimizerOptionsSet.find("all") == optimizerOptionsSet.end() && optimizerOptionsSet.find("are") == optimizerOptionsSet.end()) {
            std::cout << "Optimizing conditions" << std::endl;
            this->optimizeConditions();
        }
        if (optimizerOptionsSet.find("all") == optimizerOptionsSet.end() && optimizerOptionsSet.find("sim") == optimizerOptionsSet.end()) {
            std::cout << "Optimizing Assignments" << std::endl;
            this->optimizeAssignments();
        }
        std::cout << "Optimization:" << std::endl;
        this->optimizeOperations();
        std::cout << "Generating PropertySuite:" << std::endl;
        std::map<int, State2 *> stateMap;
        for (auto state: this->statesMap) {
            state.second->setName(state.second->getName() + "_" + std::to_string(state.second->getStateId()));
            stateMap.insert(std::make_pair(state.second->getStateId(), state.second));
        }
        this->module->getFSM()->setStateMap(stateMap);
        this->module->setVariableMap(this->varMap);
        this->generatePropertySuite();
    }

    PropertySuite *OperationFactory::getPropertySuite() const {
        return this->propertySuite;
    }

    void OperationFactory::findOperations() {
        SCAM::FindOperations ctest(cfg, this->module);
        this->statesMap = ctest.getStatesMap();
        this->rawOperations = ctest.getOperations();
    }

    void OperationFactory::createOperations() {
        if (this->module->isSlave()) {
            SCAM::CreateOperationsSlave cOperations(this->rawOperations, this->statesMap, this->module);
            this->operations = cOperations.getOperationsList();
            this->statesMap = cOperations.getStatesMap();
        } else {
            SCAM::CreateOperations cOperations(this->rawOperations, this->statesMap, this->module);
            this->operations = cOperations.getOperationsList();
            this->statesMap = cOperations.getStatesMap();
        }
    }

    void OperationFactory::reconstructOperations() {
        SCAM::ReconstructOperations rOperations(this->statesMap, this->module);
        for (auto op : this->operations) {
            rOperations.sortOperation(op);
        }
    }

    void OperationFactory::findValidOperations() {
        std::vector<SCAM::Operation2 *> validOperations;
        for (auto op : this->operations) {
            if (SCAM::ValidOperations::isOperationReachable(op)) {
                validOperations.push_back(op);
            } else {
                /// Remove from stateList operations
                auto state = op->getState();
                state->removeOutgoingOperation(op);

                state = op->getNextState();
                state->removeIncomingOperation(op);
            }
        }
        this->operations = validOperations;
    }

    void OperationFactory::checkStates() {
        for (const auto &state : this->statesMap) {
            if (state.second->isInit()) continue;

            if (state.second->getIncomingOperationsList().empty())
                std::cout << "\t\033[1;33mWarning\033[0m: (" << state.first << ") is unreachable! consider removing it.\n";
        }
    }

    void OperationFactory::optimizeConditions() {
        for (auto operation : operations) {
            ConditionOptimizer2 conditionOptimizer2(operation->getAssumptionsList(), module);
            operation->setAssumptionsList(conditionOptimizer2.getNewConditionList());
        }
    }

    void OperationFactory::optimizeAssignments() {
        for (auto op : operations) {
            AssignmentOptimizer2 assignmentOptimizer2(op->getCommitmentsList(), module);
            op->setCommitmentsList(assignmentOptimizer2.getNewAssignmentsList());
        }
    }

    void OperationFactory::optimizeOperations() {
        SCAM::OptimizeOperations2 oOperations(this->operations, module);
        this->varMap = oOperations.getNewVarMap();
    }

    void OperationFactory::generatePropertySuite() {
        // Generate PropertySuite
        this->propertySuite = new PropertySuite(module->getName());

        //Ports
        SCAM::CreatePropertySuite::addNotifySignals(this->module, this->propertySuite);
        SCAM::CreatePropertySuite::addSyncSignals(this->module, this->propertySuite);
        SCAM::CreatePropertySuite::addDataSignals(this->module, this->propertySuite);

        //Vars
        SCAM::CreatePropertySuite::addVisibleRegisters(this->module, this->propertySuite);

        //States
        SCAM::CreatePropertySuite::addStates(this->module, this->propertySuite);

        //Functions
        SCAM::CreatePropertySuite::addFunctions(this->module, this->propertySuite);

        // RESET PROPERTY
        SCAM::CreatePropertySuite::addReset(this->module, this->propertySuite);

        //OPERATION PROPERTIES
        //SCAM::CreatePropertySuite::addOperations(this->module, this->propertySuite);
        SCAM::CreatePropertySuite::addTrueOperations(this->module, this->propertySuite);

        // WAIT PROPERTIES
        SCAM::CreatePropertySuite::addWait(this->module, this->propertySuite);

    }
}