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
    double total = 0;
    const double R = 2045.679303890155;
    const double B = 2039.979233442413;
    const double S = 3997.215110772804;
    const double U = 2051.223097038867;
    const double J = 2071.77403060257;
    const double I_I = 2181.599331151734;
    const double I_L = 4062.646783599133;
    const double I_J = 2066.009061328963;

    logFile.open("../../RISCV_ISA/Dino_test/Log_files/" + moduleName + "_" + testName + ".txt");
    logFile << "Operation:\tNumber:" << std::endl;
    std::cout << "Operation:\tNumber:" << std::endl;
        int i = 0;
        for (auto operation : operations.at(moduleName))  {
            logFile << i++ << "\t\t" << operation << std::endl;
            std::cout << i++ << "\t\t" << operation << std::endl;
            total += operation;
        }
    logFile << "TOTAL: \t\t" << (int) (total + 0.5) << std::endl;
   std::cout << "TOTAL: \t\t" << (int) (total + 0.5) << std::endl;

    double power = R * (operations.at(moduleName).at(2) / total) + B * (operations.at(moduleName).at(3) / total) + S * (operations.at(moduleName).at(4) / total) +
            U * (operations.at(moduleName).at(5) / total) + J * (operations.at(moduleName).at(6) / total) + I_I * (operations.at(moduleName).at(7) / total) +
            I_L * (operations.at(moduleName).at(8) / total) + I_J * (operations.at(moduleName).at(9) / total);

    logFile << "Estimated dynamic power consumption: " << power << "uW" << std::endl;
    std::cout << "Estimated dynamic power consumption: " << power << "uW" << std::endl;
    logFile.close();
}

