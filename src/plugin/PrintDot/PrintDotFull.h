//
// Created by ludwig on 9/6/18.
//

#ifndef PROJECT_PRINTDOTFULL_H
#define PROJECT_PRINTDOTFULL_H

#include <PluginFactory.h>
#include <sstream>
#include "Model.h"
#include "PrintStmtForDot.h"

class PrintDotFull : public PluginFactory {
public:
    PrintDotFull() = default;
    ~PrintDotFull() = default;

    std::map<std::string, std::string> printModel(Model *node);

private:
    std::stringstream ss;

    ////////////////
    std::string printDotFull(Module *module); //! Prints states + conditions + commitements
};

#endif //PROJECT_PRINTDOTFULL_H
