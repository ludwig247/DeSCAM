//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 3/4/19.
//



#include <regex>
#include <fstream>
#include <functional>
#include "FindOperations.h"


//#define DEBUG_FINDOPERATIONS

SCAM::FindOperations::FindOperations(std::map<int, SCAM::CfgNode *> controlFlowMap, SCAM::Module * module) :
    module(module),
    cfg(std::move(controlFlowMap)),
    new_important_state(false) {

    /// Find the while(true) node to indicate fixed point
    for(auto node:cfg) {
        if(node.second->getStmt()!= nullptr) {
            if (SCAM::NodePeekVisitor::nodePeekWhile(node.second->getStmt()) != nullptr) {
                this->whileNode = node.second;
                break;
            }
        }
    }
    this->checkSanity();
    this->findInitialImportantStates();

    this->processCFG();

    /// Create empty states starting from importantStatements: reset, wait(0), and Blocking communication
    for (auto node : this->importantStates) {
        if(node->getStmt() == nullptr) {
            auto  *state = new SCAM::State2("init");
            state->setInit();
            this->statesMap.insert(std::make_pair("init",state));
        } else {
            //TODO: in the future, the name will represent the line of code
            SCAM::FindCommunication2 findComm;
            node->getStmt()->accept(findComm);
            std::cout << PrintStmt::toString(node->getStmt()) << std::endl;


            std::string stateName = "state";
            if(findComm.hasStateName()) {
                stateName = findComm.getStateName();
            }
            auto *state = new SCAM::State2(stateName);

            if(findComm.isWaitComm()) {
                state->setWait();
                this->statesMap.insert(std::make_pair(node->getName(), state));
            } else {
                state->setCommunicationStmt(findComm.getCommStmt());
                this->statesMap.insert(std::make_pair(node->getName(), state));
            }
        }
    }


#ifdef DEBUG_FINDOPERATIONS
    std::cout << "\n***********Important states (Final) ***********\n\n";
    for(auto node: this->importantStates){
        std::cout << node->printShort() << std::endl;
    }
    std::cout << "\n*********** Final Operations Paths ***********\n\n";
    for(auto operationPath: this->operations){
        std::cout << "Path: \n";
        for (auto pathNode: operationPath)
            std::cout << pathNode->printShort();
//            std::cout << "ID[" << pathNode->getId() << "] - ";
        std::cout << "\n";
    }
//    throw std::runtime_error(" YOOOOOO ");
#endif
}

void SCAM::FindOperations::checkSanity() {
    bool foundSlaves = false;
    bool foundBlocking = false;

    for (auto port : module->getPorts()) {
        if (port.second->getInterface()->isBlocking())
            foundBlocking = true;
        else if (port.second->getInterface()->isSlaveIn() ) {
            foundSlaves = true;
            this->slaveInOrder.insert(std::make_pair(port.second,false));
        } else if (port.second->getInterface()->isSlaveOut() ) {
            foundSlaves = true;
            this->slaveOutOrder.insert(std::make_pair(port.second,false));
        }
    }

    if(foundBlocking && foundSlaves) {
        throw std::runtime_error("Module " + this->module->getName() + ": not permitted combination of Blocking and Slave communications");
    }
    this->slaveModule = foundSlaves;
}

void SCAM::FindOperations::findInitialImportantStates() {
    /** @brief: initial coloring
     *  @details: Initial coloring only includes wait(0) and blocking communication statements
     */

    /// add root node because we need this to create the reset operation
    this->importantStates.push_back(cfg[0]);

    for(auto node:cfg){
        if(node.second->getStmt() != nullptr){
            SCAM::FindCommunication2 findComm;
            node.second->getStmt()->accept(findComm);
            /// Initial coloring only includes wait(0) and blocking communication statements
            if (findComm.isBlockingInterface()) {
                this->importantStates.push_back(node.second);
                this->new_important_state = true;
            }
            if (findComm.isWaitComm()) {
                this->importantStates.push_back(node.second);
                this->new_important_state = true;
            }
        }
    }
}

void SCAM::FindOperations::processCFG() {
    /// do the processing before checking for new_important_state because we might start from a cfg without blocking comm
    do {
        //reset all
        this->new_important_state = false;
        this->operations.clear();
        FindStateOperations findStateOperations(cfg,importantStates,module,whileNode);

        bool spurious;
        for(auto node: this->importantStates) {
            FindStateBacktrack b(node, whileNode);
            spurious = findStateOperations.findOperations(node);//will affect this->spuriousPath
            if (spurious) {
                if(this->slaveModule)
                    this->processSpuriousSlave(findStateOperations.getSpurious());//will affect this->new_important_state or throw an error
                else
                    this->processSpurious(findStateOperations.getSpurious());//will affect this->new_important_state or throw an error
                break;/// because we have to re-span the cfg and find all operations again
            }

            /// Deciding what stateOperations are reachable given the backtrack of the state
            for (const auto& operationPath : findStateOperations.getStateOperations()) {
                for(const auto& backtrack : b.getStateBacktracks()) {
#ifdef DEBUG_FINDOPERATIONS
                    std::cout << "-----------************* Assumption Statements -----------*************\n";
                    for (auto stmt : backtrack)
                        std::cout << PrintStmt::toString(stmt) << "\n";
                    std::cout << "\n";
                    std::cout << "-----------************* Finished Path -----------*************\n";
                    for (auto pathNode: operationPath)
                        std::cout << pathNode->printShort();
                    std::cout << "\n";
#endif
                    if (SCAM::ValidOperations::isPathReachable(backtrack, operationPath, module)) {
                        this->operations.push_back(operationPath);
                        break;//No need to check other backtracks
                    }
                }
            }
        }
        /// No need to do it when a new_important_state is already added from processing the spurious path
        if(!this->new_important_state) {
            if(this->slaveModule) {
                this->checkForSlaves();// might affect this->new_important_state
                    this->checkForMasters();// might affect this->new_important_state
                    if (this->new_important_state)
                        throw std::runtime_error("Invalid Coloring: masters can't be colored in a slave module!\n");
            } else
                this->checkForMasters();// might affect this->new_important_state
        }
    } while(this->new_important_state);
}

bool portNameCompare(SCAM::CfgNode* & obj, const std::string& name) {
    SCAM::FindCommunication2 findComm;
    obj->getStmt()->accept(findComm);
    return (findComm.getPort()->getName() == name);
//    return (SCAM::NodePeekVisitor::nodePeekPortOperand(obj->getStmt())->getOperandName() == name);//FIXME: nodePeekPortOperand is not correct
}

//#define DEBUG_PROCESSSPURIOUS
void SCAM::FindOperations::processSpurious(std::vector<SCAM::CfgNode *> spuriousPath) {
    /**
     * The statement to be colored will be the one representing the last of the different master ports in use.
     * To make this happen we store possibleCandidates in reverse order (i.e. starting from the end of the path) and choose the first one to color.
     *
     * exp.: importantState -- -- m_1->write  --  m_2->write  --  m_3->write  -- -- loopback
     *                                                              (color)
     *
     * For special cases when a master port is used more than once along the path then we need to consider the first appearance for coloring not the last
     * exp.: m_1->write  --  m_2->write  --  m_4->write  --  m_2->write  --  m_3->write  --  m_1->write  --  m_3->write
     *                                                                                                        (added)
     *                                                                                         (added)
     *                                                                    (appear later!)
     *                                                                        (added)                         (remove)
     *                                                         (added)
     *                                        (added)
     *                    (appear later!)
     *                        (added)                         (remove)        (remove)         (remove)
     *                                        (color)
     *
     * Traverse path in reverse
     *      if(master) {
     *          if same port appears "later" in path then
     *              if port used in the importantState (in the beginning of the path)
     *                  remove: from possibleCandidates.begin() --to--> possibleCandidates.appearance (excluded)
     *              else
     *                  remove: from possibleCandidates.begin() --to--> possibleCandidates.appearance (included)
     *
     *          possibleCandidates.push_back(master)
     *      }
     *
     * if(!possibleCandidates.empty()){
     *      importantStates.insert((*possibleCandidates.begin()));
     *      return;
     * }
     *
     * if reach here then there are no statements to add
     * throw error
     */
#ifdef DEBUG_PROCESSSPURIOUS
    std::cout << "\n********FindOperations::processSpurious\n";
    for(auto node : spuriousPath)
        std::cout << node->printShort();
#endif
    std::vector<SCAM::CfgNode *> pathMasters;
    for (auto it = spuriousPath.begin(); it != spuriousPath.end(); it++) {
        if ((*it)->getStmt() != nullptr) {
            SCAM::FindCommunication2 findComm;
            (*it)->getStmt()->accept(findComm);
            if (findComm.isCommunication() && findComm.isMaster()) {
                /// read after write
                if (findComm.isRead()) {
                    for (auto mas = pathMasters.rbegin(); mas != pathMasters.rend(); mas++) {
                        if (NodePeekVisitor::nodePeekWrite((*mas)->getStmt()) != nullptr) {
                            /// color master_write
#ifdef DEBUG_PROCESSSPURIOUS
                            std::cout << "\t\t\twant to color: " << (*mas)->getId() << " ------- read after write\n";
#endif
                            if(std::find(this->importantStates.begin(),this->importantStates.end(),*mas) == this->importantStates.end()) {
                                this->importantStates.push_back(*mas);
                                this->new_important_state = true;
#ifdef DEBUG_PROCESSSPURIOUS
                                std::cout << "\t\t\tcolor: " << (*mas)->getId() << " ------- read after write\n";
#endif
                            }
                            return;
                        }
                    }
                }

                /// already passed this port?
                std::string portName = findComm.getPort()->getName();
                auto master_it = std::find_if(pathMasters.begin(), pathMasters.end(), std::bind(portNameCompare, std::placeholders::_1, portName));
                if (master_it != pathMasters.end()) {
                    /// if repeated port is same as starting node in path (i.e. already an important state) then color second always
                    if (*master_it == *spuriousPath.begin()) {
#ifdef DEBUG_PROCESSSPURIOUS
                        std::cout << "\t\t\twant to color: " << (*it)->getId() << " ------- spuriousPath.begin()\n";
#endif
                        if(std::find(this->importantStates.begin(),this->importantStates.end(),*it) == this->importantStates.end()) {
                            this->importantStates.push_back(*it);
                            this->new_important_state = true;
#ifdef DEBUG_PROCESSSPURIOUS
                            std::cout << "\t\t\tcolor: " << (*it)->getId() << " ------- spuriousPath.begin()\n";
#endif
                        }
                        return;
                    }

                    /// intermediate ports can appear ONLY once
                    if (findComm.isRead()) {
                        /// color second
#ifdef DEBUG_PROCESSSPURIOUS
                        std::cout << "\t\t\twant to color: " << (*it)->getId() << " ------- color second\n";
#endif
                        if(std::find(this->importantStates.begin(),this->importantStates.end(),*it) == this->importantStates.end()) {
                            this->importantStates.push_back(*it);
                            this->new_important_state = true;
#ifdef DEBUG_PROCESSSPURIOUS
                            std::cout << "\t\t\tcolor: " << (*it)->getId() << " ------- color second\n";
#endif
                        }
                        return;
                    } else {
                        /// color first
#ifdef DEBUG_PROCESSSPURIOUS
                        std::cout << "\t\t\twant to color: " << (*master_it)->getId() << " ------- color first\n";
#endif
                        if(std::find(this->importantStates.begin(),this->importantStates.end(),*master_it) == this->importantStates.end()) {
                            this->importantStates.push_back(*master_it);
                            this->new_important_state = true;
#ifdef DEBUG_PROCESSSPURIOUS
                            std::cout << "\t\t\tcolor: " << (*master_it)->getId() << " ------- color first\n";
#endif
                        }
                        return;
                    }
                }

#ifdef DEBUG_PROCESSSPURIOUS
                std::cout << "\t\t\tpush_back: " << (*it)->getId() << "\n";
#endif
                pathMasters.push_back((*it));
            }
        }
    }
    if (!pathMasters.empty()) {
#ifdef DEBUG_PROCESSSPURIOUS
        std::cout << "\t\t\twant to color: " << pathMasters.back()->getId() << " ------- !pathMasters.empty()\n";
#endif
        if(std::find(this->importantStates.begin(),this->importantStates.end(),pathMasters.back()) == this->importantStates.end()) {
            this->importantStates.push_back(pathMasters.back());
            this->new_important_state = true;
#ifdef DEBUG_PROCESSSPURIOUS
            std::cout << "\t\t\tcolor: " << pathMasters.back()->getId() << " ------- !pathMasters.empty()\n";
#endif
        }
        return;
    }

    /// No new coloring occurred so throw an error
    std::ofstream fileStream;
    fileStream.open(this->module->getName() + "_Spurious.dot");
    fileStream << printCFG_Spurious(spuriousPath);
    fileStream.close();
    for (auto node: spuriousPath)
        std::cout << node->printShort();
    throw std::runtime_error("Invalid Path: A Path without any important statement\n"
                             "\t\t\tCheck bin/" + this->module->getName() + "_Spurious.dot for more details");
}

void SCAM::FindOperations::processSpuriousSlave(const std::vector<SCAM::CfgNode *>& spuriousPath) {
    printCFG_Spurious(spuriousPath);
}

void SCAM::FindOperations::checkForMasters() {
    /**
     * Through ever path in operation, store all passed masterComm along the path.
     * If same port is used in more than one statement and it's not the important statement at the end of the path then
     * consider this masterComm statement an important state and redo the operations finding.
     *
     *
     *          b_1  -   m_2->read  -   m_3->write  -   m_2->read  -   b_1
     *                                                     (c)
     *
     *          b_1  -   m_2->write  -   m_3->read  -   m_2->write  -   b_1
     *                      (c)
     *
     *          b_1  -   m_2->write  -   m_3->read  -   m_2->write  -   m_3->read  -   b_1
     *                      (c)                                            (c)
     *
     *          b_1  -   m_1->read  -   m_2->write  -   m_3->read  -   m_4->write  -   b_1  ...... for combinational cases
     *                                     (c)
     */
    for(auto path:this->operations) {
        /// have to store the pathMasters in std::vector<SCAM::CfgNode *> in order to add one to importantStates if needed
        std::vector<SCAM::CfgNode *> pathMasters;
        /// Excluding the important states at both ends of path
        for (auto it = (path.begin()+1); it != (path.end()-1); it++) {
            if ((*it)->getStmt() != nullptr) {
                SCAM::FindCommunication2 findComm;
                (*it)->getStmt()->accept(findComm);
                if (findComm.isCommunication() && findComm.isMaster()) {
                    /// read after write
                    if(findComm.isRead()) {
                        for (auto mas = pathMasters.rbegin(); mas != pathMasters.rend(); mas++) {
                            if (NodePeekVisitor::nodePeekWrite((*mas)->getStmt()) != nullptr ) {
                                /// color master_write
                                this->importantStates.push_back(*mas);
                                this->new_important_state = true;
                                return;
                            }
                        }
                    }
                    /// already passed this port?
                    std::string portName = findComm.getPort()->getName();
                    auto master_it = std::find_if(pathMasters.begin(), pathMasters.end(), std::bind(portNameCompare, std::placeholders::_1, portName));
                    if (master_it != pathMasters.end()) {
                        if(findComm.isRead()) {
                            /// color second
                            this->importantStates.push_back(*it);
                            this->new_important_state = true;
                            return;
                        } else {
                            /// color first
                            this->importantStates.push_back(*master_it);
                            this->new_important_state = true;
                            return;
                        }
                    }
                    pathMasters.push_back((*it));
                }
            }
        }
    }

}

void SCAM::FindOperations::checkForSlaves() {
    bool resetProperty;
    for(const auto& path:this->operations) {
        resetProperty = false;
        if(path.front()->getStmt() == nullptr)
            resetProperty = true;
        /// have to store the pathSlaves in std::vector<SCAM::CfgNode *> in order to add one to importantStates if needed
        std::vector<SCAM::CfgNode *> pathSlaves;
        for (auto & it : path) {
            if (it->getStmt() != nullptr) {
                SCAM::FindCommunication2 findComm;
                it->getStmt()->accept(findComm);
                if (findComm.isCommunication() && findComm.isSlave()) {
                    pathSlaves.push_back(it);

                    /// reset path allows only slave_writes to be in it
                    if (findComm.getPort()->getInterface()->isSlaveIn() && resetProperty) {
                        std::cout << "\n\n------------- Invalid Slaves Order: reset property should not have any slave communications in it\n";
                        printCFG_Spurious(path);
                    }
                }

            }
        }

        if ((path.front()->getStmt() != nullptr) && !checkSlavesOrder(pathSlaves))
            printCFG_Spurious(path);
    }
}

bool SCAM::FindOperations::checkSlavesOrder(const std::vector<SCAM::CfgNode *>& pathSlaves) {
    /// reset slave ports status
    for(auto &port : this->slaveInOrder)
        port.second = false;
    for(auto &port : this->slaveOutOrder)
        port.second = false;

    int slaveInSize = this->slaveInOrder.size();
    int slaveOutSize = this->slaveOutOrder.size();

    /// traverse the path and flip the status of slave ports in their maps
    int countIns = 0;
    int countOuts = 0;
    SCAM::FindCommunication2 findComm;
    for (auto node : pathSlaves) {
        node->getStmt()->accept(findComm);
        auto it_in = this->slaveInOrder.find(findComm.getPort());
        if (it_in != this->slaveInOrder.end()) {
            countIns++;
            this->slaveInOrder[(*it_in).first] = !this->slaveInOrder[(*it_in).first];
        }

        auto it_out = this->slaveOutOrder.find(findComm.getPort());
        if (it_out != this->slaveOutOrder.end()) {
            countOuts++;
            this->slaveOutOrder[(*it_out).first] = !this->slaveOutOrder[(*it_out).first];
        }

        if( (countIns < slaveInSize) && (countOuts > 0) ) {
            std::cout << "\n\n------------- Invalid Slaves Order: passing an output port before all input ports!\n";
            return false;
        }
        if (countIns > slaveInSize) {
            std::cout << "\n\n------------- Invalid Slaves Order: passing an input port more than once!\n";
            return false;
        }
        if (countOuts > slaveOutSize) {
            std::cout << "\n\n------------- Invalid Slaves Order: passing an output port more than once!\n";
            return false;
        }
    }

    if( (countIns != slaveInSize) || (countOuts != slaveOutSize)) {
        std::cout << "\n\n------------- Invalid Slaves Order: missing slave ports in the path!\n";
        return false;
    }

    /// check that the path included every available slave port by checking the status of the SlavePortMap. because counting the number of slaves passed is not enough
    for ( auto port : this->slaveInOrder) {
        if (!port.second) {
            std::cout << "\n\n------------- Invalid Slaves Order: missing slave port from the path!\n";
            return false;
        }
    }
    for ( auto port : this->slaveOutOrder) {
        if (!port.second) {
            std::cout << "\n\n------------- Invalid Slaves Order: missing slave port from the path!\n";
            return false;
        }
    }

    return true;
}

const std::map<std::string, SCAM::State2 *> &SCAM::FindOperations::getStatesMap() const {
    return this->statesMap;
}

const std::vector<std::vector<SCAM::CfgNode *> > &SCAM::FindOperations::getOperations() const{
    return this->operations;
}

std::string SCAM::FindOperations::printCFG_Spurious(std::vector<SCAM::CfgNode *> spuriousPath) {
    std::stringstream ss;
    ss << "digraph Spurious {  graph [rankdir=TD];  " << std::endl;

    // Node and Name
    for (auto node : cfg) {
        ss << node.second->getName() << "[ label = \"";
        if(node.second->getStmt() == nullptr)
            ss << "------";
        else
            ss << PrintStmtForDotSpurious::toString(node.second->getStmt());
        ss << "\"];\n";
    }

    ss << std::endl;

    // Connections
    for (auto node : cfg) {
        for (auto succ : node.second->getSuccessorList()) {
            ss << node.second->getName() << " -> " << succ->getName();
            if(node.second->getSuccessorList().size() > 1) {
                if(succ->getId() == node.second->getId() + 1)
                    ss << "[label = \"yes\"]";
                else
                    ss << "[label = \"no\"]";
            }
            ss << ";\n";
        }
    }

    ss << std::endl;

    // Highlight States
    int groupCount = 0;
    for (auto state : importantStates) {
        ss << "subgraph cluster_" << groupCount << " {\n";
        ss << "\tstyle=filled; color=slategray;\n";
        ss << "\t" << state->getName() << ";\n";
        ss << "}\n";
        groupCount++;
    }


    // Highlight Spurious
    auto node = spuriousPath.begin();
    int connectionNum = 1;
    while (node != spuriousPath.end() - 1) {
        ss << (*node)->getName() << " -> " << (*(node+1))->getName();
        ss << "[label = \"" << connectionNum++ << "\", color=red, penwidth=3.0];\n";
        node++;
    }

    ss << "}" << std::endl;

    std::ofstream fileStream;
    fileStream.open(this->module->getName() + "_Spurious.dot");
    fileStream << ss.str();
    fileStream.close();
    for (auto sNode: spuriousPath)
        std::cout << sNode->printShort();
    throw std::runtime_error("Invalid Path: Check bin/" + this->module->getName() + "_Spurious.dot for more details");
}
