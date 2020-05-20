//
// Created by wezel on 2/27/20.
//

#ifndef DESCAM_PRINTCHANNEL_H
#define DESCAM_PRINTCHANNEL_H

#include <PluginFactory.h>
#include <sstream>
#include "Model.h"
#include "ConditionVisitor.h"


class PrintChannel : public PluginFactory {
public:
    PrintChannel() = default;
    ~PrintChannel() = default;
    std::map<std::string, std::string> printModel(Model *node);
    std::string convertDataType(std::string dataTypeName);

        private:
    SCAM::Module *module;

};



#endif //DESCAM_PRINTCHANNEL_H
