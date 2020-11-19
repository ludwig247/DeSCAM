//
// Created by Dino Mehmedagić on 10.04.20.
//

#include <vector>
#include <string>
#include <map>

#ifndef DESCAM_POWERESTIMATOR_H
#define DESCAM_POWERESTIMATOR_H


class ModulePower{
public:
    ModulePower(const std::string& name, std::vector<unsigned int> operations, std::vector<unsigned int> values);
    void update(unsigned int operation, std::vector<unsigned int> values);
    std::map<unsigned int, std::vector<unsigned int>> getOperationMap ();

private:
    std::map<unsigned int, std::vector<unsigned int>> operationMap;
    std::vector<unsigned int> variables;
    std::vector<std::vector<unsigned int>> valueList;
    //std::stringstream ss;

    int countToggle(int x, int y);

};


class PowerEstimator  {

private:

    std::map <std::string, std::vector <std::string>> hierarchy;
    std::map <std::string, std::vector <unsigned int>> operations;
    //std::vector<int> variableValues;
    //std::vector<std::vector<unsigned int>> operationList;
    //std::map<unsigned int, std::vector<unsigned int>> operationMap;
    std::map<std::string, ModulePower> moduleMap;

    PowerEstimator() = default;


public:

    static PowerEstimator &getInstance();
    PowerEstimator(PowerEstimator const &) = delete;
    void operator=(PowerEstimator const &) = delete;
    void enterHierarchy(const std::string& name);
    void initializeOperations(const std::string& name, unsigned int operationsNumber);

    void initialize(const std::string& name, std::vector<unsigned int> operationsNumber, std::vector<unsigned int> values);
    void initValues(const std::string &moduleName, std::vector<unsigned int> values);
    void updateValues(unsigned int operation, std::vector<unsigned int> values);
    void update(const std::string &moduleName, unsigned int operation, std::vector<unsigned int> values);

    void countOperation(const std::string &moduleName, unsigned int operation);
    void displayResults(const std::string& moduleName, const std::string& testName);
    void displayResults2(const std::string& testName);





};



#endif //DESCAM_POWERESTIMATOR_H