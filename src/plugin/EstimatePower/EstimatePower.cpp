//
// Created by Dino Mehmedagić on 21.03.20.
//

#include "EstimatePower.h"
#include <sstream>
#include <string>

std::map<std::string, std::string> EstimatePower::printModel(Model *node) {

    std::map<std::string, Module *> moduleMap = node->getModules();
    for (auto module : moduleMap) {
        portMap = module.second->getPorts();
        std::cout << "Module " << module.first << std::endl;
        registerOperations(*module.second->getFSM());
        pluginOutput.insert(std::make_pair(module.first + "_instrumented.h", writeFile(module)));
        debug(*module.second);
    }

    return pluginOutput;
}

void EstimatePower::registerOperations(FSM &node) {
    for (auto state : node.getStateMap())  {
        for (auto operation : state.second->getOutgoingOperationsList())  {
            operationsMap.insert (std::pair<unsigned int, Operation*> (operationsCounter++, operation));
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
    while (std::getline(inFile, line))  {
        if (line.find("{") != std::string::npos)
            bracketCounter++;
        if (line.find("}") != std::string::npos)
            bracketCounter--;
        if (insideProcess && bracketCounter < bracketTarget)  {
            insideProcess = false;
            traverseProcessBody(*module.second->getFSM());
            for (auto process_line : processBody)
                ss += (process_line + "\n");
        }
        if (insideProcess)
            processBody.push_back(line);
        if (line.find("SC_HAS_PROCESS(") != std::string::npos)
            ss += ("unsigned int operations[" + std::to_string(operationsCounter) + "];\n");
        startPosition = line.find("SC_THREAD(");
        if (startPosition != std::string::npos) {
            startPosition += 10;
            length = line.find(")") - startPosition;
            functionName = line.substr(startPosition, length);
            std::cout << "Function name: " << functionName << std::endl;
        }
        startPosition = line.find("void ");
        if (startPosition != std::string::npos) {
            startPosition = line.find(functionName);
            if (startPosition != std::string::npos) {
                startPosition = line.find(";");
                if (startPosition == std::string::npos) {
                    insideProcess = true;
                    bracketTarget = bracketCounter;
                }
            }
        }
        if (!insideProcess)
            ss += (line + "\n");

    }
    inFile.close();

    return ss;
}

void EstimatePower::insertOperationLines(State *currentState, State *nextState) {
    std::size_t startPosition;
   // std::vector<std::string>::iterator it = processBody.begin();
   int it = 0;
    for (auto line : processBody) {
        for (auto port : portMap) {
            startPosition = line.find(port.first);
            if (startPosition != std::string::npos) {
                 if (nextState->getCommunicationPort() == port.second) {
                     for (auto operation : nextState->getIncomingOperationsList())
                         if (operation->getState() == currentState && !operationsCounted.at(operation))  {
                             processBody.insert(processBody.begin() + it, "operations[" + std::to_string(operation->getId()) + "]++;");
                             operationsCounted.at(operation) = true;
                         }
                     break;
                 }
            }
        }
        it++;
    }
}

void EstimatePower::traverseProcessBody(FSM &node) {
    std::vector <State *> possibleNextStates;
    for (auto state : node.getStateMap())  {
        for (auto operation : state.second->getOutgoingOperationsList())  {
            if (std::find(possibleNextStates.begin(), possibleNextStates.end(), operation->getNextState()) == possibleNextStates.end())
                possibleNextStates.push_back(operation->getNextState());
        }
        for (auto nextState : possibleNextStates)
            insertOperationLines(state.second, nextState);
        possibleNextStates.clear();
    }
}

void EstimatePower::debug(Module &node) {
    std::cout << "Module: " << node.getName() << std::endl;
    int i = 0;
    for (auto state : node.getFSM()->getStateMap())  {
        std::cout << "\tState: " << state.second->getName() <<std::endl;
        for (auto operation : state.second->getOutgoingOperationsList())  {
            std::cout << "\t\tOperation: " << i++ << "\tto " << operation->getNextState()->getName() <<std::endl;
            for (auto assumption : operation->getAssumptionsList())  {
                std::cout << "\t\t\t";
                assumption->print(std::cout);
                std::cout << std::endl;
            }
        }
    }
}
