//
// Created by Dino Mehmedagić on 10.04.20.
//

#include "PowerEstimator.h"
#include <fstream>
#include <sstream>
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
    for (int i = 0; i < operationsNumber; i++){
        operations.at(moduleName).push_back(0);
        //operationMap.insert(std::pair <unsigned int, std::vector<unsigned int>>(i,{}));
    }

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



    logFile.open("Log_files/" + moduleName + "_" + testName + ".txt");
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


    std::cout << "Operation map" << std::endl;
    /*for (auto v : operationMap){
        std::cout << v.first << " :\t";
        for (auto w : v.second){
            std::cout << w << " ";
        }
        std::cout << std::endl;
    }*/
}

void PowerEstimator::displayResults2(const std::string &testName) {
    std::stringstream ss;
    std::ofstream logFile;

    for (auto module: moduleMap){
        ss << module.first << std::endl;
        ss << "Operation \tNumber \tToggle" << std::endl;
        for (auto op: module.second.getOperationMap()){
            int tot = 0;
            //std::cout << op.first << " :\t";
            for (auto tog: op.second){
                //std::cout << tog << " ";
                tot += tog;
            }
            //std::cout << std::endl;
            ss << op.first << "\t\t\t" << op.second.size() << "\t\t" << tot << std::endl;
        }
    }

    std::cout << ss.str();

}



void PowerEstimator::initValues(const std::string &moduleName, std::vector<unsigned int> values) {
    for (auto val : values){
        //variableValues.push_back(val);
    }
    //variableValues = values;
}
void PowerEstimator::updateValues(unsigned int operation, std::vector<unsigned int> values) {
    unsigned int toggleTotal = 0;
    int i = 0;
    for (auto var : values){
        //int toggle = countToggle(var, variableValues.at(i));
        //std::cout << var << ' ' << variableValues.at(i) << std::endl;
        //toggleTotal += toggle;
        //variableValues.at(i++) = var;
    }
    //operationList.push_back({operation,toggleTotal});
    //operationMap.at(operation).push_back(toggleTotal);
    //std::cout << "Operation No: " << operation << " Total: " << toggleTotal << std::endl;
    //std::cout << "----------------------------------------------------------------------------" << std::endl;
}

void PowerEstimator::initialize(const std::string &name, std::vector<unsigned int> operations, std::vector<unsigned int> values) {
    //initializeOperations(name, operationsNumber);
    //initValues(name, values);
    moduleMap.insert(std::pair <std::string, ModulePower>(name,ModulePower(name,operations,values)));
}

void PowerEstimator::update(const std::string &moduleName, unsigned int operation, std::vector<unsigned int> values) {
    //countOperation(moduleName, operation);
    //updateValues(operation, values);
    moduleMap.at(moduleName).update(operation,values);
}

ModulePower::ModulePower(const std::string &name, std::vector<unsigned int> operations, std::vector<unsigned int> values) {
    values.insert(values.begin(),0);
    variables = values;
    for (auto i : operations){
        operationMap.insert(std::pair <unsigned int, std::vector<unsigned int>>(i,{}));
    }
    valueList.push_back(values);
}

void ModulePower::update(unsigned int operation, std::vector<unsigned int> values) {
    values.insert(values.begin(),operation);
    unsigned int toggleTotal = 0;
    for (int i = 1; i < values.size(); i++){
        int toggle = countToggle(variables.at(i), values.at(i));
        toggleTotal += toggle;
    }
    variables = values;
    operationMap.at(operation).push_back(toggleTotal);
    valueList.push_back(values);
}

int ModulePower::countToggle(int x, int y) {
    unsigned diff = x xor y;
    int val = 0;

    while (diff > 0){
        val++;
        diff &= diff - 1;
    }

    return val;
}

std::map<unsigned int, std::vector<unsigned int>> ModulePower::getOperationMap() {
    return operationMap;
}