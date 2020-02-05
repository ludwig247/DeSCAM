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
        //SCAM::CreatePropertySuite::addWait(this->module, this->propertySuite);

    }

    std::string convertDataType(std::string dataTypeName) {
        if (dataTypeName == "bool") {
            return "boolean";
        } else if (dataTypeName == "int") {
            return "signed";
        } else {
            return dataTypeName;
        }
    }

    void OperationFactory::printPropertySuite() {
        throw std::runtime_error("Don't use anymore");
//        std::stringstream ss;
//        std::string t_end;
//
//        ss << "-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --" << std::endl;
//        for (auto sync: this->propertySuite->getSyncSignals()) {
//            ss << "macro " << sync->getName() << " : " << convertDataType(sync->getDataType()->getName())
//               << " := end macro;" << std::endl;
//        }
//        for (auto notify: this->propertySuite->getNotifySignals()) {
//            ss << "macro " << notify->getName() << " : " << convertDataType(notify->getDataType()->getName())
//               << " := end macro;" << std::endl;
//        }
//        ss << std::endl << std::endl;
//
//        ss << "-- DP SIGNALS --" << std::endl;
//        for (auto dp: this->propertySuite->getDpSignals()) {
//            ss << "macro " << dp->getName();
//            if (dp->isCompoundType()) {
//                ss << "_" + dp->getSubVarName();
//            }
//            ss << " : " << convertDataType(dp->getDataType()->getName()) << " := end macro;" << std::endl;
//        }
//        ss << std::endl << std::endl;
//
//        ss << "-- CONSTRAINTS --" << std::endl;
//        // Reset constraint is print out extra because of the quotation marks ('0')
//        ss << "constraint no_reset := rst = '0'; end constraint;" << std::endl;
//        for (auto co: this->propertySuite->getConstraints()) {
//            if (co->getName() != "no_reset") {
//                ss << "constraint " << co->getName() << " : " << co->getExpression()
//                   << "; end constraint;" << std::endl;
//            }
//        }
//        ss << std::endl << std::endl;
//
//        ss << "-- VISIBLE REGISTERS --" << std::endl;
//        for (auto vr: this->propertySuite->getVisibleRegisters()) {
//            if (!vr->isArrayType()) {
//                ss << "macro " << vr->getName();
//                if (vr->isCompoundType()) {
//                    ss << "_" + vr->getSubVarName();
//                }
//                ss << " : " << convertDataType(vr->getDataType()->getName()) << " := end macro;" << std::endl;
//            }
//        }
//        ss << std::endl << std::endl;
//
//        ss << "-- STATES --" << std::endl;
//        for (auto st: this->propertySuite->getStates()) {
//            ss << "macro " << st->getName() << " : " << convertDataType(st->getDataType()->getName());
//            ss << " := " << st->getExpression() << " end macro;" << std::endl;
//        }
//        ss << std::endl << std::endl;
//
//        ss << "-- OPERATIONS --" << std::endl;
//
//        // Reset property
//        ss << "property " << this->propertySuite->getResetProperty()->getName() << " is\n";
//        ss << "assume:\n";
//        ss << "\t reset_sequence;\n";
//        ss << "prove:\n";
//        //ss << "\t at t: " << this->propertySuite->getResetProperty()->getNextState()->getName() << ";\n";
//        for (auto commitment : this->propertySuite->getResetProperty()->getCommitmentList()) {
//            if (commitment->isAt()) {
//                ss << "\t at ";
//                ss << commitment->getTiming().at(0);
//                ss << ": ";
//            } else if (commitment->isDuring()) {
//                ss << "\t during[";
//                ss << commitment->getTiming().at(0);
//                ss << ", ";
//                ss << commitment->getTiming().at(1);
//                ss << "]: ";
//            }
//            ss << commitment->getStatement();
//        }
//        ss << "end property;\n";
//        ss << std::endl << std::endl;
//
//        // Operation properties
//        for (auto op : this->propertySuite->getProperties()) {
//            ss << "property " << op->getName() << " is\n";
//
//            unsigned long constraintSize = op->getConstraints().size();
//            ss << "dependencies: ";
//            for (auto co : op->getConstraints()) {
//                ss << co->getName();
//                if (constraintSize > 1) {
//                    ss << ",";
//                } else {
//                    ss << ";\n";
//                }
//                constraintSize--;
//            }
//
//            unsigned long timePointSize = op->getTimePoints().size();
//            ss << "for timepoints:\n";
//            for (auto tp : op->getTimePoints()) {
//                ss << "\t" << tp.first->getName() << " = " << tp.second;
//                if (timePointSize > 1) {
//                    ss << ",\n";
//                } else {
//                    ss << ";\n";
//                }
//                timePointSize--;
//            }
//
//            unsigned long freezeVarSize = op->getFreezeSignals().size();
//            if (freezeVarSize > 0) {
//                ss << "freeze:\n";
//                for (auto freeze : op->getFreezeSignals()) {
//
//                    ss << "\t";
//                    if (freeze.first->isArrayType()) {
//                        ss << freeze.first->getParent()->getName() << "_" << freeze.first->getVariable()->getName()
//                           << "_at_" << freeze.second;
//                        ss << " = ";
//                        ss << freeze.first->getParent()->getName() << "(" << freeze.first->getVariable()->getName()
//                           << ")@t";
//                    } else {
//                        ss << freeze.first << "_at_" << freeze.second;
//                        ss << " = ";
//                        ss << freeze.first << "@" << freeze.second;
//                    }
//
//                    if (freezeVarSize > 1) {
//                        ss << ",\n";
//                    } else {
//                        ss << ";\n";
//                    }
//                    freezeVarSize--;
//                }
//            }
//            ss << "assume:\n";
//            for (auto assumption : this->propertySuite->getResetProperty()->getAssumptionList()) {
//                if (assumption->isAt()) {
//                    ss << "\t at ";
//                    ss << assumption->getTiming().at(0);
//                    ss << ": ";
//                } else if (assumption->isDuring()) {
//                    ss << "\t during[";
//                    ss << assumption->getTiming().at(0);
//                    ss << ", ";
//                    ss << assumption->getTiming().at(1);
//                    ss << "]: ";
//                }
//                ss << assumption->getStatement();
//            }
//
//
//            ss << "prove:\n";
//            for (auto commitment : this->propertySuite->getResetProperty()->getCommitmentList()) {
//                if (commitment->isAt()) {
//                    ss << "\t at ";
//                    ss << commitment->getTiming().at(0);
//                    ss << ": ";
//                } else if (commitment->isDuring()) {
//                    ss << "\t during[";
//                    ss << commitment->getTiming().at(0);
//                    ss << ", ";
//                    ss << commitment->getTiming().at(1);
//                    ss << "]: ";
//                }
//                ss << commitment->getStatement();
//            }
//            ss << "end property;\n";
//            ss << "\n\n";
//        }
    }
}