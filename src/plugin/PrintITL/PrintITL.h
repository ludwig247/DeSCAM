//
// Created by ludwig on 27.10.16.
//

#ifndef SCAM_SYNTHESIZE_H
#define SCAM_SYNTHESIZE_H

#include <functional>
#include <sstream>

#include "Model.h"
#include "CommandLineParameter.h"
#include "ConditionVisitor.h"
#include "DatapathVisitor.h"
#include "PluginFactory.h"
#include "TimePointVisitor.h"

class PrintITL : public PluginFactory {

 public:
  PrintITL();
  ~PrintITL() = default;

  std::map<std::string, std::string> printModel(Model *node) override;
  std::map<std::string, std::string> printModule(DESCAM::Module *node);

  std::string print();

  std::map<std::string, bool> getOptionMap() override {
    return CommandLineParameter::getOptionMap("PrintITL");
  }

 private:

  std::string functions();
  std::string globalFunctions();

  static std::string convertDataType(std::string dataTypeName);
  static std::string convertDataTypeForHLS(std::string dataTypeName);

  std::string location(bool loc);

  static std::string printTemporalExpr(TemporalExpr *temporalExpr);

  std::string printProperty(const std::shared_ptr<Property>& property);

  std::string macros();
  std::string macrosForHLS();
  std::string operations();

  DESCAM::Module *module_ = nullptr;
  Model *model_ = nullptr;

  std::function<std::string()> macro_function_;
};

#endif //SCAM_SYNTHESIZE_H
