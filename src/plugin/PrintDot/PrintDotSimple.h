//
// Created by ludwig on 9/6/18.
//

#ifndef PROJECT_PRINTDOTSIMPLE_H
#define PROJECT_PRINTDOTSIMPLE_H

#include <PluginFactory.h>
#include <sstream>
#include "Model.h"
#include "PrintStmtForDot.h"

class PrintDotSimple : public PluginFactory {
public:
    PrintDotSimple() = default;

    ~PrintDotSimple() = default;

    std::map<std::string, std::string> printModel(Model *node);

private:
    std::stringstream ss;

    ////////////////
    std::string printDotSimple(Module *module); //! Prints states + conditions
};

#endif //PROJECT_PRINTDOTSIMPLE_H
