//
// Created by lanrez on 8/30/20.
//

#include "InstrumentPower.h"
#include <sstream>
#include <string>
#include <PrintStmt.h>

#define DEBUG 0

std::map<std::string, std::string> InstrumentPower::printModel(Model *node) {

    std::map<std::string, Module *> moduleMap = node->getModules();
    for (auto module : moduleMap) {
        portMap = module.second->getPorts();
        std::cout << "Module " << module.first << std::endl;
        findStateStmt(module.second->getFSM());
        registerOperations(*module.second->getFSM());
#if DEBUG == 1
        debug(*module.second);
        pluginOutput.insert(std::make_pair(module.first + "_instrumented.h", ""));
        return pluginOutput;
#endif
        pluginOutput.insert(std::make_pair(module.first + "_instrumented.h", writeFile(module)));
    }

    return pluginOutput;
}

void InstrumentPower::registerOperations(FSM &node) {
    for (auto state : node.getStateMap())  {
        for (auto operation : state.second->getOutgoingOperationsList())  {
            if (operation->getNextState() != operation->getState())
                operationsCounter++;
            operationsCounted.insert(std::pair <Operation *, bool> (operation, false));
        }
    }
}





std::string InstrumentPower::writeFile(std::pair <std::string, Module*> module ) {
    std::stringstream ss;
    std::ifstream inFile;
    inFile.open(module.first + ".h");
    if (!inFile) throw(std::runtime_error("Unable to open file."));
    bool insideProcess = false;
    std::string line;
    std::string functionName = "";
    std::size_t startPosition;
    std::size_t length;
    std::size_t endPosition;
    unsigned int bracketCounter = 0;
    unsigned int bracketTarget = 0;
    unsigned int lineCounter = 0;
    unsigned int processPosition;
    while (std::getline(inFile, line))  {
        if (line.find("{") != std::string::npos)
            bracketCounter++;
        if (line.find("}") != std::string::npos)
            bracketCounter--;
        if (insideProcess && bracketCounter < bracketTarget)  {
            insideProcess = false;
            for (auto process_line : processBody)
                ss << (process_line + "\n");
        }
        if (insideProcess)
            processBody.push_back(line);
        if (line.find("SC_HAS_PROCESS(") != std::string::npos)  {
            ss << ("unsigned int originState;\n");
        }
        startPosition = line.find("SC_THREAD(");
        if (startPosition != std::string::npos) {
            startPosition += 10;
            length = line.find(")") - startPosition;
            functionName = line.substr(startPosition, length);
            std::cout << "Function name: " << functionName << std::endl;
        }
        if (!insideProcess)
            ss << (line + "\n");
        startPosition = line.find("void ");
        if (startPosition != std::string::npos) {
            startPosition = line.find(functionName);
            if (startPosition != std::string::npos) {
                startPosition = line.find(";");
                if (startPosition == std::string::npos) {
                    insideProcess = true;
                    bracketTarget = bracketCounter;
                    processPosition = lineCounter;
                    ss << ("PowerEstimator::getInstance().initializeOperations(name(), " + std::to_string(operationsCounter) + ");" + "\n");
                }
            }
        }

        lineCounter++;

    }
    inFile.close();

    return ss.str();
}

void InstrumentPower::debug(Module &node) {
    std::cout << "Module: " << node.getName() << std::endl;
    // int i = 0;
    for (auto state : node.getFSM()->getStateMap())  {
        std::cout << "\tState " << state.second->getStateId() << ": " << (state.second->isInit() || state.second->isWait()? "init or wait" : state.second->getCommunicationPort()->getName()) << std::endl;
        for (auto operation : state.second->getOutgoingOperationsList())  {
            std::cout << "\t\tOperation: " << operation->getId() << "\tto " << operation->getNextState()->getName() <<std::endl;
            for (auto statement : operation->getStatementsList())  {
                std::cout << "\t\t\t";
                statement->print(std::cout);
                std::cout << std::endl;
            }
        }
    }
    mapStates(*node.getFSM());
    for (auto port : ports2States)  {
        std::cout << "Port " << port.first->getName() << ": " << std::endl;
        for (auto state : port.second)
            std::cout << "\t" << state->getName() << std::endl;
    }
}

void InstrumentPower::mapStates(FSM &node) {
    for (auto port : portMap)
        ports2States.insert(std::pair <Port*, std::vector <State *>> (port.second, std::vector<State*> {}));
    for (auto state : node.getStateMap())
        if (!state.second->isInit() && !state.second->isWait())
            ports2States.at(state.second->getCommunicationPort()).push_back(state.second);
}

int InstrumentPower::whichLine(State &state) {
    int line;
    std::cout << "Please enter line number for state " << state.getStateId() << std::endl;
    std::cin >> line;
    return line;
}

void InstrumentPower::mapStates2Lines(FSM &node) {
    for (auto state : node.getStateMap())
        stateLines.insert(std::pair<int, State*> (whichLine(*state.second), state.second));
}

std::string InstrumentPower::lhs(std::string condition) {
    std::size_t startPosition, length;
    startPosition = condition.find("(");
    if (isPositive(condition)) startPosition += 2;
    else startPosition += 6;
    length = condition.substr(startPosition).find(" ");
    std::string lhs = condition.substr(startPosition, length);
    return lhs;
}

std::string InstrumentPower::rhs(std::string condition) {
    std::size_t startPosition, length;
    startPosition = condition.find("==");
    if (startPosition == std::string::npos)  {
        startPosition = condition.find("!=");
        if (startPosition == std::string::npos)  {
            startPosition = condition.find("<");
            if (startPosition == std::string::npos)  {
                startPosition = condition.find(">");
                if (startPosition == std::string::npos)  {
                    return "";
                }
            }
        }
    }
    startPosition = condition.substr(startPosition).find(" ") + 1 + startPosition;
    length = condition.substr(startPosition).find(")");
    std::string rhs = condition.substr(startPosition, length);
    return rhs;
}

bool InstrumentPower::isPositive(std::string condition) {
    if (condition.find("(not(") == std::string::npos)
        return true;
    return false;
}

void InstrumentPower::traverseProcessBody(FSM &node, unsigned int processPosition) {
    int startState, currentLine = -1, conditionLine;
    std::string statementString, condition;
    std::vector <std::string> currentConditions;
    for (auto state : node.getStateMap())  {
        for (int i = 0; i < processBody.size(); i++)  {
            std::string obj;
            if(state.first == 0) obj = "while (true)";
            else {
                LocationInfo loc = stateStmt.at(state.first)->getStmtInfo();
                obj = loc.getObject();
            }

            //if (processBody.at(i).find("/*State " + std::to_string(state.second->getStateId())) != std::string::npos)  {
            if (processBody.at(i).find(obj) != std::string::npos)  {
                startState = i;
                break;
            }
        }
        if (state.second->isInit())  {
            for (auto operation : state.second->getOutgoingOperationsList())
                if (!operationsCounted.at(operation))
                    processBody.insert(processBody.begin() + startState + 1, "PowerEstimator::getInstance().countOperation(name(), 0);");
        } else  {
            processBody.insert(processBody.begin() + startState + 1, "originState = " + std::to_string(state.first) + ";");
            for (auto operation : state.second->getOutgoingOperationsList())  {
                conditionLine = startState;
                for (auto statement : operation->getStatementsList())  {
                    statementString = PrintStmt::toString(statement);
                    if (currentLine == -1)
                        currentLine = startState;
                    if (statementString.find(".sync") == std::string::npos)  {
                        if (statementString.find("if (") == std::string::npos)  {
                            for (int i = startState; i < processBody.size(); i++)  {
                                if (processBody.at(i).find(statementString) != std::string::npos)  {
                                    currentLine = i;
                                    break;
                                } else currentLine = -1;
                            }
                            if (currentLine == -1) {
                                for (int i = 0; i < startState; i++) {
                                    if (processBody.at(i).find(statementString) != std::string::npos) {
                                        currentLine = i;
                                        break;
                                    } else currentLine = -1;
                                }
                            }
                            if (currentLine == -1)
                                currentLine = startState;
                        }  else {
                            for (int j = 0; j < currentConditions.size(); j++)  {
                                condition = currentConditions.at(j);
                                if (isPositive(condition))  {
                                    if (lhs(condition) == lhs(statementString))
                                        currentConditions.erase(currentConditions.begin() + j--);
                                } else if (lhs(condition) == lhs(statementString) && rhs(condition) == rhs(statementString))
                                    currentConditions.erase(currentConditions.begin() + j--);
                            }
                            currentConditions.push_back(statementString);
                            conditionLine = currentLine;
                        }
                    }
                }
                if (!operationsCounted.at(operation) && operation->getState() != operation->getNextState())  {
                    processBody.insert(processBody.begin() + conditionLine + 2, "PowerEstimator::getInstance().countOperation(name(), " + std::to_string(operation->getId()) + ");");
                    operationsCounted.at(operation) = true;
                    for (int i = currentConditions.size() - 1; i >= 0; i--)
                        processBody.insert(processBody.begin() + conditionLine + 2, currentConditions.at(i));
                    currentConditions.clear();
                    processBody.insert(processBody.begin() + conditionLine + 2, "if (originState == " + std::to_string(operation->getState()->getStateId()) + ")");
                }
            }


        }
    }
}


void InstrumentPower::findStateStmt(FSM *node) {
    for (auto state : node->getStateMap()){
        bool flag = false;
        for(auto op : state.second->getOutgoingOperationsList()){
            for (auto st : op->getStatementsList()){
                if(NodePeekVisitor::nodePeekRead(st) != nullptr | NodePeekVisitor::nodePeekWrite(st) != nullptr){
                    stateStmt.insert(std::make_pair(state.first,st));
                    flag = true;
                    break;
                }
            }
            if (flag) break;
        }
    }
}
