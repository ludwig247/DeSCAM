//
// Created by ludwig on 9/6/18.
//

#ifndef PROJECT_PRINTDOTSTATES_H
#define PROJECT_PRINTDOTSTATES_H

#include <PluginFactory.h>
#include <sstream>
#include "Model.h"
#include "PrintStmtForDot.h"

class PrintDotStates : public PluginFactory {
public:
    PrintDotStates() = default;
    ~PrintDotStates() = default;

    std::map<std::string, std::string> printModel(Model *node);

private:
    std::stringstream ss;

    ////////////////
    std::string printDotStates(Module *module); //! Prints out only the states
};

#endif //PROJECT_PRINTDOTSTATES_H
