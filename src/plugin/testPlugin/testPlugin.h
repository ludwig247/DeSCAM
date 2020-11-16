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
    int s;
public:
    testPlugin()  = default;
    ~testPlugin() = default;
    std::map<std::string, std::string> printModel(Model *node);

    std::map<std::string, bool> getOptionMap() {
        //std::map<std::string, bool> m;
        //return m;

        return CommandLineParameter::getOptionMap("testPlugin");
    }

    std::stringstream ss;


private:
    void instrumentModule(DESCAM::Module *node);
    void printPrefix(int val);
    void printMain(int val1, int val2,FSM *node);
    void printSuffix();
    void findStateStmt(FSM *node);
    void findOpStmt(FSM *node);
    void setVarStr (std::set<std::string> vars);

    std::ifstream inFile;
    //unsigned int operationsCounter = 6;
    std::map <int, DESCAM::Stmt *> stateStmt;
    std::map <int, DESCAM::Stmt *> opStmt;
    std::set<std::string> vars;
    std::string varStr;
    unsigned int opNo = 0;

};


#endif //DESCAM_TESTPLUGIN_H
