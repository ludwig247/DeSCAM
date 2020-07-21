//
// Created by tobias on 13.02.17.
//

#ifndef PROJECT_PRINTVHDL_H
#define PROJECT_PRINTVHDL_H

#include <PluginFactory.h>
#include <sstream>
#include "Model.h"

/*
 * Translates a model into a VHDL or SystemVerilog template
 */
class PrintVHDL : public PluginFactory {
public:
    PrintVHDL() = default;

    ~PrintVHDL() = default;

    std::map<std::string, std::string> printModel(Model *node);

    std::pair<std::string, std::string> printModule(SCAM::Module *module);


    std::pair<std::string, std::string> printGlobalTypes(Model *node);

    std::pair<std::string, std::string> printLocalTypes(SCAM::Module *module);

private:
    //std::stringstream ss;
    SCAM::Module *module;
    SCAM::Model *model;

    std::string globalPackageName;
    std::string localPackageName;

    int bitwidth;

    ////////////////
    std::string generateLocalTypes();

    std::string generateGlobalTypes();

    std::string generateGlobalDefs();

    std::string generateHDLSkeleton();

    void setBitwidth();

    void printPackageHeader(std::stringstream &ss, const std::string &packageName);

    void printEnumType(std::stringstream &ss, const SCAM::DataType *enumType);

    void printCompoundType(std::stringstream &ss, const SCAM::DataType *compoundType);

    void printArrayType(std::stringstream &ss, const SCAM::DataType *arrayType);

    void printPackageFooter(std::stringstream &ss, const std::string &packageName);

    void header(std::stringstream &ss);

    void ports(std::stringstream &ss);

    void ports(std::stringstream &ss, SCAM::Module* child);

    void registers(std::stringstream &ss);

    void channels(std::stringstream &ss);

    void components(std::stringstream &ss);

    void instances(std::stringstream &ss);

    void resetLogic(std::stringstream &ss);

    void footer(std::stringstream &ss);

    int getLog2(int number);

    std::string getFilenameExtention();

    std::string convertToLower(const std::string &inString);

    std::string getDirectionWrapper(const std::string &direction);

    std::string getDataTypeWrapper(const SCAM::DataType *dataType);
    std::string getDataTypeWrapper_Port(const SCAM::DataType *dataType);

    std::string booleanWrapper(bool value);

    void insertImport(std::stringstream &ss, const std::string &name);

    void insertPortVariable(std::stringstream &ss, const std::string &name, const std::string &direction, const std::string &type);

    void insertRegister(std::stringstream &ss, const std::string &name, const std::string &type);

    void insertNonblockingAssignment(std::stringstream &ss, const std::string &name, const std::string &value, int indentation);


};

#endif //PROJECT_PRINTVHDL_H
