//
// Created by tobias on 13.02.17.
//

#ifndef PROJECT_PRINTSKELETON_H
#define PROJECT_PRINTSKELETON_H

#include <PluginFactory.h>
#include <sstream>
#include "Model.h"

/*
 * Translates a model into a VHDL or SystemVerilog template
 */
class PrintSkeleton : public PluginFactory {
 public:
  PrintSkeleton() = default;

  ~PrintSkeleton() = default;

  std::map<std::string, std::string> printModel(Model *node) override;

  std::pair<std::string, std::string> printModule(DESCAM::Module *module);

  std::pair<std::string, std::string> printGlobalTypes(Model *node);

  std::pair<std::string, std::string> printLocalTypes(DESCAM::Module *module);

  std::map<std::string, bool> getOptionMap() override {
    return CommandLineParameter::getOptionMap("PrintSkeleton");
  }
 private:
  //std::stringstream ss;
  DESCAM::Module *module;
  enum {
    VHDL, SV
  } language;
  std::string globalPackageName;
  std::string localPackageName;

  ////////////////
  std::string generateLocalTypes();

  std::string generateGlobalTypes();

  std::string generateGlobalDefs();

  std::string generateHDLSkeleton();

  void setLanguage();

  void printPackageHeader(std::stringstream &ss, const std::string &packageName);

  void printEnumType(std::stringstream &ss, const DESCAM::DataType *enumType);

  void printCompoundType(std::stringstream &ss, const DESCAM::DataType *compoundType);

  void printArrayType(std::stringstream &ss, const DESCAM::DataType *arrayType);

  void printPackageFooter(std::stringstream &ss, const std::string &packageName);

  void header(std::stringstream &ss);

  void ports(std::stringstream &ss);

  void registers(std::stringstream &ss);

  void resetLogic(std::stringstream &ss);

  void footer(std::stringstream &ss);

  int getLog2(int number);

  std::string getFilenameExtention();

  std::string convertToLower(const std::string &inString);

  std::string getDirectionWrapper(const std::string &direction);

  std::string getDataTypeWrapper(const DESCAM::DataType *dataType);

  std::string booleanWrapper(bool value);

  void insertImport(std::stringstream &ss, const std::string &name);

  void insertPortVariable(std::stringstream &ss,
                          const std::string &name,
                          const std::string &direction,
                          const std::string &type,
                          bool last);

  void insertRegister(std::stringstream &ss, const std::string &name, const std::string &type);

  void insertNonblockingAssignment(std::stringstream &ss,
                                   const std::string &name,
                                   const std::string &value,
                                   int indentation);

};

#endif //PROJECT_PRINTVHDL_H
