//
// Created by Dino Mehmedagić on 10.04.20.
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


void PowerEstimator::displayResults(const std::string &moduleName, const std::string &testName) {
    std::ofstream logFile;
    double total = 0;
    const double R = 475.89628;
    const double B = 477.71575;
    const double S = 802.46415;
    const double U = 514.803881;
    const double J = 515.44433;
    const double I_I = 479.016149;
    const double I_L = 808.394055;
    const double I_J = 475.644236;
    const double RESTART = 1495.242;
   // int switches = 1283;



    logFile.open("Log_files/" +moduleName + "_" + testName + ".txt");
    logFile << "Operation:\tNumber:" << std::endl;
    std::cout << "Operation:\tNumber:" << std::endl;
        int i = 0;
        for (auto operation : operations.at(moduleName))  {
            logFile << i << "\t\t" << operation << std::endl;
            std::cout << i++ << "\t\t" << operation << std::endl;
            total += operation;
        }
    logFile << "TOTAL: \t\t" << (int) (total + 0.5) << std::endl;
   std::cout << "TOTAL: \t\t" << (int) (total + 0.5) << std::endl;

    double power = R * operations.at(moduleName).at(2) + B * operations.at(moduleName).at(3) + S * operations.at(moduleName).at(4) +
            U * operations.at(moduleName).at(5) + J * operations.at(moduleName).at(6) + I_I * operations.at(moduleName).at(7) +
            I_L * operations.at(moduleName).at(8) + I_J * operations.at(moduleName).at(9) + RESTART * operations.at(moduleName).at(0);
    power /= total;
  //  power += switches * 0.02;

    logFile << "Estimated dynamic power consumption: " << power << "uW" << std::endl;
    std::cout << "Estimated dynamic power consumption: " << power << "uW" << std::endl;
    logFile.close();
}

