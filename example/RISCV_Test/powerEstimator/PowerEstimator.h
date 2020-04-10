//
// Created by Dino Mehmedagić on 10.04.20.
//

#include <vector>
#include <string>
#include <map>

#ifndef DESCAM_POWERESTIMATOR_H
#define DESCAM_POWERESTIMATOR_H

#endif //DESCAM_POWERESTIMATOR_H

class PowerEstimator  {

private:

    std::map <std::string, std::vector <std::string>> hierarchy;
    std::map <std::string, std::vector <unsigned int>> operations;

    PowerEstimator() = default;

public:

    static PowerEstimator &getInstance();
    PowerEstimator(PowerEstimator const &) = delete;
    void operator=(PowerEstimator const &) = delete;
    void enterHierarchy(const std::string& name);
    void initializeOperations(const std::string& name, unsigned int operationsNumber);
};