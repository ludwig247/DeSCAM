//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 5/22/19.
//

#ifndef SCAM_PRINTCFGDOT_H
#define SCAM_PRINTCFGDOT_H

#include <PluginFactory.h>
#include <sstream>
#include "Model.h"
#include "PrintStmtForDot.h"

class PrintCFGDot : public PluginFactory {
public:
    PrintCFGDot() = default;

    ~PrintCFGDot() = default;

    std::map<std::string, std::string> printModel(Model *node);

    static std::string printCFG_Spurious(std::map<int, DESCAM::CfgNode *> cfg, std::vector<DESCAM::CfgNode *> importantStates, std::vector<DESCAM::CfgNode *> spuriousPath);

  std::map<std::string, bool> getOptionMap() override {
    return CommandLineParameter::getOptionMap("PrintCFGDot");
  }
private:
    std::stringstream ss;

    ////////////////
    std::string printDot(Module *module);
};


#endif //SCAM_PRINTCFGDOT_H
