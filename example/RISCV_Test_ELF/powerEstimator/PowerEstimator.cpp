//
// Created by mehmedag on 10.04.20.
//

#include "PowerEstimator.h"
#include <fstream>
#include <iostream>

PowerEstimator& PowerEstimator::getInstance() {
    static PowerEstimator instance;
    return instance;
}

void PowerEstimator::enterHierarchy(const std::string& name) {
    std::size_t pointPlace = name.find('.');
    std::string residueName, target, child;
    if (pointPlace != std::string::npos)  {
        residueName = name.substr(pointPlace + 1);
        child = residueName.substr(0, residueName.find('.'));
        target = name.substr(0, pointPlace);
    }  else  {
        residueName = "";
        child = "";
        target = name.substr(0, pointPlace);
    }
    if (hierarchy.find(target) == hierarchy.end())  {
        if (!child.empty()) hierarchy.insert(std::pair <std::string, std::vector <std::string>> (target, {child}));
        else hierarchy.insert(std::pair <std::string, std::vector <std::string>> (target, {}));
    } else
        hierarchy.at(target).push_back(child);
    if (!residueName.empty()) enterHierarchy(residueName);
}

void PowerEstimator::initializeOperations(const std::string &moduleName, unsigned int operationsNumber) {
    operations.insert(std::pair <std::string, std::vector <unsigned int>> (moduleName, {}));
    for (int i = 0; i < operationsNumber; i++)
        operations.at(moduleName).push_back(0);

}

void PowerEstimator::countOperation(const std::string &moduleName, unsigned int operation) {
    operations.at(moduleName).at(operation)++;
}

void PowerEstimator::displayResults(const std::string& moduleName) {
    std::ofstream logFile;
    unsigned int total = 0;
    logFile.open("../../RISCV_ISA/Dino_test/Log_files/" + moduleName + "_operations_count.txt");
    logFile << "Operation:\tNumber:" << std::endl;
    for (auto module : operations)  {
        int i = 0;
        for (auto operation : module.second)  {
            logFile << i++ << "\t\t" << operation << std::endl;
            total += operation;
        }
    }
    logFile << "TOTAL: \t\t" << total << std::endl;
    logFile.close();
}

void PowerEstimator::displayResults(const std::string &moduleName, const std::string &testName) {
    std::ofstream logFile;
    unsigned int total = 0;
    logFile.open("../../RISCV_ISA/Dino_test/Log_files/" + moduleName + "_" + testName + ".txt");
    logFile << "Operation:\tNumber:" << std::endl;
    for (auto module : operations)  {
        int i = 0;
        for (auto operation : module.second)  {
            logFile << i++ << "\t\t" << operation << std::endl;
            total += operation;
        }
    }
    logFile << "TOTAL: \t\t" << total << std::endl;
    logFile.close();
}

