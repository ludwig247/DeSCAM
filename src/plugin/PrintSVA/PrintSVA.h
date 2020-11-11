//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 17.04.18.
//

#ifndef DESCAM_PRINTSVA_H
#define DESCAM_PRINTSVA_H

#include <PluginFactory.h>
#include <sstream>
#include "Model.h"

class PrintSVA : public PluginFactory {

 public:
  PrintSVA() = default;

  ~PrintSVA() = default;

  std::map<std::string, std::string> printModel(Model *node);

  std::map<std::string, std::string> printModule(DESCAM::Module *node);

  std::map<std::string, bool> getOptionMap() override {
    return CommandLineParameter::getOptionMap("PrintSVA");
  }
 private:
  std::stringstream ss;
  Model *model;
  DESCAM::Module *module;

  ////////////////
  std::string Text_ipc();

  std::string properties();

  std::string functions();

  std::string globalFunctions();

  std::string dataTypes();

  std::string signals();

  std::string registers();

  std::string states();

  std::string reset_sequence();

  std::string temporalExpr(TemporalExpr *temporalExpr);

  std::string reset_operation();

  std::string operations();

  std::string convertDataType(const DataType *dataType) const;

  std::string location(bool loc);

  std::string tolower(std::string str);

  std::string macros();
};

#endif //DESCAM_PRINTSVA_H
