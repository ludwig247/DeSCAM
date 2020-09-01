//
// Created by lanrez on 8/13/20.
//

#ifndef DESCAM_TESTPLUGIN_H
#define DESCAM_TESTPLUGIN_H

#include <PluginFactory.h>
#include "Model.h"
#include <sstream>
#include "Stmt.h"

class testPlugin : public PluginFactory {
public:
    testPlugin()  = default;
    ~testPlugin() = default;
    std::map<std::string, std::string> printModel(Model *node);

    int returnBits(const DataType *dataType);

    void findStateStmt(FSM * node);

    std::stringstream ss;


private:
    /*std::map<std::string, Module *> moduleMap;
    FSM * myFSM;
    std::map<int, SCAM::State *> stateMap;*/
    std::map <int, DESCAM::Stmt *> stateStmt;
};


#endif //DESCAM_TESTPLUGIN_H
