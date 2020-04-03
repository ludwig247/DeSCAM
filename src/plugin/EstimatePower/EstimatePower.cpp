//
// Created by Dino Mehmedagić on 21.03.20.
//

#include "EstimatePower.h"
#include <sstream>
#include <string>
#include <PrintStmt.h>

std::map<std::string, std::string> EstimatePower::printModel(Model *node) {

    std::map<std::string, Module *> moduleMap = node->getModules();
    for (auto module : moduleMap) {
        portMap = module.second->getPorts();
        std::cout << "Module " << module.first << std::endl;
        registerOperations(*module.second->getFSM());
        debug(*module.second);
      //  mapStates2Lines(*module.second->getFSM());
        pluginOutput.insert(std::make_pair(module.first + "_instrumented.h", writeFile(module)));
    }

    return pluginOutput;
}

void EstimatePower::registerOperations(FSM &node) {
    for (auto state : node.getStateMap())  {
        for (auto operation : state.second->getOutgoingOperationsList())  {
            if (operation->getNextState() != operation->getState())
                operationsCounter++;
                operationsCounted.insert(std::pair <Operation *, bool> (operation, false));
        }
    }
}





std::string EstimatePower::writeFile(std::pair <std::string, Module*> module ) {
    std::string ss = "";
    std::ifstream inFile;
    inFile.open(module.first + ".h");
    if (!inFile) throw(std::runtime_error("Unable to open file."));
    bool insideProcess = false;
    std::string line;
    std::string functionName = "qwertyuiopdfghjkl;cvbnm,.";
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
            traverseProcessBody(*module.second->getFSM(), processPosition);
            for (auto process_line : processBody)
                ss += (process_line + "\n");
        }
        if (insideProcess)
            processBody.push_back(line);
        if (line.find("SC_HAS_PROCESS(") != std::string::npos)  {
            ss += ("unsigned int operations[" + std::to_string(operationsCounter) + "];\n");
            ss += ("unsigned int originState;\n");
        }
        startPosition = line.find("SC_THREAD(");
        if (startPosition != std::string::npos) {
            startPosition += 10;
            length = line.find(")") - startPosition;
            functionName = line.substr(startPosition, length);
            std::cout << "Function name: " << functionName << std::endl;
        }
        if (!insideProcess)
            ss += (line + "\n");
        startPosition = line.find("void ");
        if (startPosition != std::string::npos) {
            startPosition = line.find(functionName);
            if (startPosition != std::string::npos) {
                startPosition = line.find(";");
                if (startPosition == std::string::npos) {
                    insideProcess = true;
                    bracketTarget = bracketCounter;
                    processPosition = lineCounter;
                }
            }
        }

        lineCounter++;

    }
    inFile.close();

    return ss;
}

void EstimatePower::insertOperationLines(std::vector <Operation *> &operationsList, int line) {

}

void EstimatePower::traverseProcessBody(FSM &node, unsigned int processPosition) {
    std::size_t endPosition;
    std::string number;
    std::string statementString;
    std::string line;
    State* currentState;
  //  for (auto stateLine : stateLines)
     //   processBody.at(stateLine.first - processPosition - 2).insert(0, "/*State " + std::to_string(stateLine.second->getStateId()) + "*/");
    for (int i = 0; i < processBody.size(); i++)   {
        line = processBody.at(i);
        if (line.find("/*State ") != std::string::npos)  {
            endPosition = line.find("*/");
            number = line.substr(8, endPosition - 8);
            currentState = node.getStateMap().at(std::stoi(number));
            if (processBody.at(i + 1) != "originState = " + std::to_string(currentState->getStateId()) + ";")
                processBody.insert(processBody.begin() + i + 1, "originState = " + std::to_string(currentState->getStateId()) + ";");
            for (auto operation : currentState->getIncomingOperationsList())  {
                if (!operationsCounted.at(operation) && operation->getState() != operation->getNextState())  {
                    processBody.insert(processBody.begin() + i, "operations[" + std::to_string(operation->getId()) + "]++;");
                    for (auto statement : operation->getStatementsList())  {
                        statementString = PrintStmt::toString(statement);
                        if (statementString.find(".sync") == std::string::npos)//  {
                            if (statementString.find("if") != std::string::npos && statementString.find("(") != std::string::npos && statementString.find(")") != std::string::npos)
                                processBody.insert(processBody.begin() + i, statementString);
                        //}
                    }
                    processBody.insert(processBody.begin() + i, "if (originState == " + std::to_string(operation->getState()->getStateId()) + ")");
                    operationsCounted.at(operation) = true;

                }
            }
        }
    }

}

void EstimatePower::debug(Module &node) {
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

void EstimatePower::mapStates(FSM &node) {
    for (auto port : portMap)
        ports2States.insert(std::pair <Port*, std::vector <State *>> (port.second, std::vector<State*> {}));
    for (auto state : node.getStateMap())
        if (!state.second->isInit() && !state.second->isWait())
            ports2States.at(state.second->getCommunicationPort()).push_back(state.second);
}

int EstimatePower::whichLine(State &state) {
    int line;
    std::cout << "Please enter line number for state " << state.getStateId() << std::endl;
    std::cin >> line;
    return line;
}

void EstimatePower::mapStates2Lines(FSM &node) {
    for (auto state : node.getStateMap())
        stateLines.insert(std::pair<int, State*> (whichLine(*state.second), state.second));
}

