//
// Created by tobias on 01.07.16.
//




#include "PropertyFactory.h"
#include "toPPA/OnlyBlockingComm.h"
#include "../optimizePPA/OptimizeMaster.h"
#include "../optimizePPA/OptimizeSlave.h"
#include "../optimizePPA/OptimizeOperations.h"
#include "toPPA/CreateInitSection.h"
//#include "OptimizeOperations.h"


SCAM::PropertyFactory::PropertyFactory(SCAM::Module *module) :
        module(module) {
    //Can't analyze model with  an empty section
    for (auto section: module->getFSM()->getSectionMap()) {
        if (section.second.empty()) throw std::runtime_error(module->getName() + ": Section " + section.first + " empty!");
    }

    this->createInitSection(this->module); //TODO: move to the place where the sectionMap is added to the model

    this->createPaths();
    std::cout << "" << std::endl;
    std::cout << "======================" << std::endl;
    std::cout << "PPA generation:" << std::endl;
    std::cout << "----------------------" << std::endl;
    std::cout << "Create Paths:"  << this->getPathCnt() << std::endl;

    this->addCommunication();
    std::cout << "Add communication: " << this->getPathCnt() << std::endl;
    this->sectionPathMap = CleanUpPaths::deleteDuplicatedPaths(this->sectionPathMap);
    this->createCommToCommPaths();
    std::cout << "Comm to Comm: " << this->getPathCnt() << std::endl;


    this->sectionPathMap = CleanUpPaths::deleteDuplicatedPaths(this->sectionPathMap);

    this->valuePropagation();
    std::cout << "Value Propagation:"  << this->getPathCnt() << std::endl;
    this->sectionPathMap = CleanUpPaths::deleteDuplicatedPaths(this->sectionPathMap);
    this->sectionPathMap = CleanUpPaths::deleteUnreachablePaths(this->sectionPathMap);
    //std::cout << print() << std::endl;
    std::cout << "Clean-up: " << this->getPathCnt() <<  std::endl;

    this->optimizeConditions();
    std::cout << "Optimized conditions" << std::endl;
    this->optimizeDataPath();
    std::cout << "Optimized datapath" << std::endl;

    std::cout << "Optimization: " << this->getPathCnt() << std::endl;
    this->createCommunicationFSM();
    //std::cout << print() << std::endl;

}

SCAM::PropertyFactory::~PropertyFactory() {
    Path::resetPathCnt();
}


/** \brief Creates the InitSection
 *
 * The init section is implicitly defined through
 * the initialValues of the variables and the initialValue of the sectionVariable
 * Init section may not be used by the user -> Throw error in this case
 */
void SCAM::PropertyFactory::createInitSection(SCAM::Module *module) {
    //Does init section already exist?
    if (module->getFSM()->getSectionMap().find("init") != this->module->getFSM()->getSectionMap().end()) {
        throw std::runtime_error("@INIT: is a reserverd section name, may not be used by the user");
    }

    //Add new SectionPathMap to FSM
    std::map<std::string, std::vector<SCAM::Stmt *>> newSectionPathMap = module->getFSM()->getSectionMap();
    std::vector<SCAM::Stmt *> initList = CreateInitSection::createInitSection(*module);
    newSectionPathMap.insert(std::make_pair("init", initList));
    module->getFSM()->setSectionMap(newSectionPathMap);
}

/** \brief Splits the non sequential sections into sequential paths
 *
 *  For each branch in a section there will be two paths
 */
void SCAM::PropertyFactory::createPaths() {
    SectionToPaths sectionToPaths(module->getFSM()->getSectionMap());
    this->sectionPathMap = sectionToPaths.getNewSectionPathMap();
}

/** \brief Enforce only 1 communication point in a sequential path
 *
 *  Unitl now, sections are only translated to paths.
 *  Paths can contain multiple communication statements.
 *  A transition in the PPA starts with a communication state and ends with a communication state.
 *  In order to compute the datapath between two communication states we need a path from one communication state to another.
 *  Hence all paths are split up at a communication point.
 *  All stmts before a communication belong to the previous path.
 *  This step might be merged with createPaths, bAlteut would make debugging more complicated since flattening the paths is a recursive Method.
 *
 *  Another benefit is that it is possible to create paths that allow multiple communications within 1 step.
 *  For now, only 1 communication per path is allowed
 */
void SCAM::PropertyFactory::addCommunication() {
    //Traverse paths contain communictions and split them according a specific policy
    //SingleCommunication singleCommunication(this->sectionPathMap);
    //SingleCommV2 singleCommunication(this->sectionPathMap);
    OnlyBlockingComm onlyBlockingComm(this->sectionPathMap);

    //Update the sectionPathMap
    this->sectionPathMap = onlyBlockingComm.getNewSectionPathMap();

    //Each communication stmt will represent a state in the PPA
    this->stateMap = onlyBlockingComm.getStateMap();

}

/** \brief Create paths that start and end in a communication
 *
 * Until now creation of paths was limited to section.
 * If a paths end at a section without a communication it's nextstate will just be section.
 * In order to have a valid PPA a path starts and ends with a communication.
 *
 */
void SCAM::PropertyFactory::createCommToCommPaths() {

    CommToCommNew commToComm(this->sectionPathMap, module);
    this->sectionPathMap = commToComm.getNewSectionPathMap();

}

//
//! Optimizes the paths regarding assignments and constants
void SCAM::PropertyFactory::valuePropagation() {
    ValuePropagation valuePropagation(this->sectionPathMap, module);
    this->sectionPathMap = valuePropagation.getNewSectionPathMap();
}

/** \brief Simpliefies conditions using Z3 SMT Solver
 *
 * Expression will be simplified: e.G:
 * cnt < 10 && cnt == 3 && x == cnt
 * is simplified to:
 * cnt == 3 && x == 3
 * which is way easier to read and understand
 */
void SCAM::PropertyFactory::optimizeConditions() {

    this->sectionPathMap = ConditionOptimizer::optimize(this->sectionPathMap, module);

}

/** \brief Simpliefies the datapath expr using Z3 SMT Solver
 *
 * Expression will be simplified: e.G:
 * x = ((x+3)+2)+1
 * is simplified to:
 * x = x + 6
 * which is way easier to read and understand
 */
void SCAM::PropertyFactory::optimizeDataPath() {
    this->sectionPathMap = DataPathOptimizer::optimize(this->sectionPathMap, module);

}

/** \brief Creates the communication FSM from the paths
 *
 * Each path already contains its starting state and end state
 * Here the Operations are created by transforming the information from the paths.
 * They already contain all information.
 * The datastructure is a more efficient representation of the statemachine.
 * The communication FSM is also stored in the FSM of the module
 *
 */
void SCAM::PropertyFactory::createCommunicationFSM() {
    for (auto section: sectionPathMap) {
        for (auto path: section.second) {
            //From state -> to state
            Operation *op;
            int from = -1;
            if (path->getSection() != "init") from = std::stoi(path->getSubState());
            int to = std::stoi(path->getSubNext());
            op = new Operation(stateMap.at(from), stateMap.at(to));
            //Assumptions
            for (auto assumption: path->getConditionList()) {
                op->addAssumption(assumption);
            }
            for (auto commCond: path->getCommunicationConditionList()) {
                op->addAssumption(commCond);
            }
            //Commitment
            for (auto commitment: path->getDataPathList()) {
                op->addCommitment(commitment);
            }
            //Additional info: state a wait-state?
            op->setWait(path->isWait());
            this->operationPathMap.insert(std::make_pair(op, path));
            this->operationList.push_back(op);
        }
    }

    this->module->getFSM()->setStateMap(this->stateMap);
    this->module->getFSM()->setOperationPathMap(this->operationPathMap);

}


std::string SCAM::PropertyFactory::print() {
    std::stringstream ss;
    //Number of total paths:
    int cnt = 0;
    ss << "Module: " << module->getName() << " \n";
    for (auto section: this->sectionPathMap) {
        for (auto path: section.second) {
            ss << path->print() << "\n";
            ss << "";
            cnt++;
        }
    }
    ss << "\n ++++++++#Paths: " << cnt << "\n";
    return ss.str();
}

std::string SCAM::PropertyFactory::printOperations() {
    std::stringstream ss;
    for (auto &&state : this->stateMap) {
        for (auto op: state.second->getOutgoingOperationList()) {
            ss << op->print();
            ss << "\n";
        }
    }
    return ss.str();
}

const std::map<std::string, std::vector<SCAM::Path *>> &SCAM::PropertyFactory::getSectionPathMap() const {
    return sectionPathMap;
}

int SCAM::PropertyFactory::getPathCnt() {
    int cnt = 0;
    for(auto section: sectionPathMap){
        for(auto path: section.second){
            cnt++;
        }
    }
    return cnt;
}

