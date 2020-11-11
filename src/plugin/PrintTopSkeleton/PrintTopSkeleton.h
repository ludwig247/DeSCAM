//
// Created by Silvio on 13.08.20.
//

#ifndef PROJECT_PRINTTOPSKELETON_H
#define PROJECT_PRINTTOPSKELETON_H

#include <PluginFactory.h>
#include <sstream>
#include "Model.h"

/*
 * Translates a model into a VHDL or SystemVerilog template
 */
class PrintTopSkeleton : public PluginFactory {
public:
    PrintTopSkeleton() = default;

    ~PrintTopSkeleton() = default;

    std::map<std::string, std::string> printModel(Model *node);

    std::pair<std::string, std::string> printModule(SCAM::Module *module);

  std::map<std::string, bool> getOptionMap() override {
    return CommandLineParameter::getOptionMap("PrintTopSkeleton");
  }
private:
    //std::stringstream ss;
    SCAM::Module *module;
    enum {
        VHDL, SV
    } language;
    std::string globalPackageName;
    std::string localPackageName;
    std::string comment;

    ////////////////
    std::string generateTopS2QEDHDLSkeleton();

    void setLanguage();

    void header(std::stringstream &ss);

    void ports(std::stringstream &ss);

    void signals(std::stringstream &ss);

    void assignments(std::stringstream &ss);

    void instances(std::stringstream &ss);

    void footer(std::stringstream &ss);

    std::string getFilenameExtention();

    std::string getDirectionWrapper(const std::string &direction);

    std::string getDataTypeWrapper(const SCAM::DataType *dataType);

    std::string convertToLower(const std::string &in_string);

    void insertImport(std::stringstream &ss, const std::string &name);

    void insertPortVariable(std::stringstream &ss, const std::string &name, const std::string &direction, const std::string &type, const int &instance, bool last);

    void insertPortSignal(std::stringstream &ss, const std::string &name, const std::string &type, const int instance);

    void insertAssignment(std::stringstream &ss, const std::string &name, const int instance);

    void insertPortAssociation(std::stringstream &ss, const std::string &name, const int &instance, bool last);


};

#endif //PROJECT_PRINTTOPSKELETON_H
