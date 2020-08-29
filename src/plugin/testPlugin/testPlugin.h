//
// Created by lanrez on 8/13/20.
//

#ifndef DESCAM_TESTPLUGIN_H
#define DESCAM_TESTPLUGIN_H

#include <PluginFactory.h>
#include "Model.h"
#include <sstream>

class testPlugin : public PluginFactory {
public:
    testPlugin()  = default;
    ~testPlugin() = default;
    std::map<std::string, std::string> printModel(Model *node);

    int returnBits(const DataType *dataType);

    std::stringstream ss;

private:
    /*std::map<std::string, Module *> moduleMap;
    FSM * myFSM;
    std::map<int, SCAM::State *> stateMap;*/

};


#endif //DESCAM_TESTPLUGIN_H
