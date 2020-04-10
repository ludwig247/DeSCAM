//
// Created by mehmedag on 10.04.20.
//

#include "PowerEstimator.h"

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

void PowerEstimator::initializeOperations(const std::string &name, unsigned int operationsNumber) {
    operations.insert(std::pair <std::string, std::vector <unsigned int>> (name, {}));
    for (int i = 0; i < operationsNumber; i++)
        operations.at(name).push_back(0);

}

