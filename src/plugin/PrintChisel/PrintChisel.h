//
// Created by lukas on 05.02.19.
//

#ifndef PROJECT_PRINTCHISEL_H
#define PROJECT_PRINTCHISEL_H

#include <PluginFactory.h>
#include <sstream>
#include "Model.h"
//#include <PropertyFactory.h>
#include <functional>

class PrintChisel : public PluginFactory {

public:
    PrintChisel() = default;

    ~PrintChisel() = default;

    std::map<std::string, std::string> printModel(Model *node);

    std::map<std::string, std::string> printModule(SCAM::Module *node);

    std::string print();

private:
    std::stringstream ss;

    /*=======================Chisel=========================*/
    std::string printIncludes(PropertySuite *ps);

    std::string printCompoundTypes(PropertySuite *ps);

    std::string printIoPorts(PropertySuite *ps);

    std::string printRegisters(PropertySuite *ps);

    std::string printEnums(PropertySuite *ps);

    std::string printBehaviour(PropertySuite *ps);

    std::string printDontTouch(PropertySuite *ps);

    std::string printOutputAssignments(PropertySuite *ps);

    std::string constructScala();

    std::string convertDataType(std::string dataTypeName);

    std::string functions();

    std::string convertDataTypeFunction(std::string dataTypeName);

    std::string convertDataTypeFunctionSVA(std::string dataTypeName);

    std::string convertEnumType(std::string enumTypeName);

    std::string convertCompoundType(std::string compoundTypeName);

    std::string convertPortDirection(std::string direction);

    std::string location(bool loc);

    std::string propertySuite();

    std::string pipelined();

    SCAM::Module *module;

    /*=========================SVA============================*/
    std::string sva_functions();

    std::string autorefine();

    std::string types();

    std::string Text_ipc();

};

#endif //PROJECT_PRINTCHISEL_H
