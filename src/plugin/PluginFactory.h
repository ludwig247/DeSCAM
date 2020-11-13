//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 17.04.18.
//

#ifndef PROJECT_STYLEFACTORY_H
#define PROJECT_STYLEFACTORY_H

#include "../parser/CommandLineParameter.h"
#include <Model.h>

using namespace DESCAM;

class PluginFactory {

 public:
  PluginFactory() = default;

  ~PluginFactory() = default;

  virtual std::map<std::string, std::string> printModel(Model *node) = 0;

  static PluginFactory *create(std::string type);

  virtual std::map<std::string, bool> getOptionMap() = 0;

  std::map<std::string, std::string> pluginOutput;
};

#endif //PROJECT_STYLEFACTORY_H
