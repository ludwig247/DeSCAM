//
// Created by tobias on 30.12.16.
//

#ifndef SCAM_MODEL_GLOBAL_H
#define SCAM_MODEL_GLOBAL_H

#include <stdexcept>
#include "Config.h"
#include <vector>
#include <PluginAction.h>
#include "FatalError.h"

#include "IModelFactory.h"

namespace DESCAM {
/** \brief Singleton that contains a pointer to the model
 *
 *  Necessary, because it's really hard to extract the model from the CheckErrors,
 *  which is somehow instantiated within the clang environment
 */
class Model;

class ModelGlobal {
 public:
  static void setModel(Model *model) {
    if (model == nullptr) TERMINATE("ModelGlobal: model is null");
    ModelGlobal::getInstance().model = model;
  };

  static Model *getModel() {
    if (ModelGlobal::getInstance().model == nullptr) TERMINATE("ModelGlobal: model is null");
    return ModelGlobal::getInstance().model;
  };

  static void
  createModel(int argc, const std::string &Binary, const std::string &srcFile,
              IModelFactory *model_factory) {

    std::vector<std::string> result;
    std::vector<const char *> command_line_arguments_vector;
    //Analyzing Environmental Variables          -----Default Values for Reference
//    std::string clang_dir = SCAM_HOME"/include/clang/3.4.2/include";//getenv("CLANG_DIR");
    std::string clang_dir = SCAM_HOME"/bin";
    std::string systemc_dir = SCAM_HOME"/include/";//getenv("SYSTEMC_DIR");
    std::string scam_dir = SCAM_HOME"/";//getenv("SCAM_HOME");
    std::string root_dir = "/";//getenv("ROOT_DIR");
    if (clang_dir.empty()) TERMINATE("Specify CLANG_DIR as environment variable");
    if (systemc_dir.empty()) TERMINATE("Specify SYSTEMC_DIR as environment variable");
    if (scam_dir.empty()) TERMINATE("Specify SCAM_DIR as environment variable");
    if (root_dir.empty()) TERMINATE("Specify ROOT_DIR as environment variable");

    //Binary
    command_line_arguments_vector.push_back(Binary.c_str());

    //SRC-File to be analyzed
    command_line_arguments_vector.push_back(srcFile.c_str());

    //Separator n
    command_line_arguments_vector.push_back("--");

    //TestCases include-dir: may not be changed
    //command_line_arguments_vector.push_back("-I /usr/include");
    //command_line_arguments_vector.push_back("-I /usr/local/include");
    std::string root_usr = std::string("-I" + root_dir + "usr/include/**");
    command_line_arguments_vector.push_back(root_usr.c_str());
    std::string root_usr_local = std::string("-I" + root_dir + "usr/local/include/**");
    command_line_arguments_vector.push_back(root_usr_local.c_str());

    //Include dirs
    std::string clang = std::string("-I" + clang_dir);
    command_line_arguments_vector.push_back(clang.c_str());
    std::string systemc = std::string("-I" + systemc_dir);
    command_line_arguments_vector.push_back(systemc.c_str());
    std::string interfaces = std::string("-I" + scam_dir + "example/Interfaces/");
    command_line_arguments_vector.push_back(interfaces.c_str());
    //Parameters for clang: may not be changed
    std::vector<const char *> clangParameter = {"-std=c++11", "-x", "c++", "-w", "-c"};
    for (auto item: clangParameter) {
      command_line_arguments_vector.push_back(item);
    }
    //Creates an instance of ModelFactory and calls ModelFactory::HandleTranslationUnit
    const char *commandLineArgumentsArray[command_line_arguments_vector.size()];
    for (int i = 0; i < command_line_arguments_vector.size(); i++) {
      commandLineArgumentsArray[i] = command_line_arguments_vector.at(i);
    }

    if (argc >= 1) {
      PluginAction
          pa2(command_line_arguments_vector.size(), commandLineArgumentsArray, model_factory);
    } else TERMINATE("Wrong use of DeSCAM");
  };

 private:
  ModelGlobal() : model(nullptr) {
  }

  static ModelGlobal &getInstance() {
    static ModelGlobal instance;
    return instance;
  }

  DESCAM::Model *model;
};
}

#endif //SCAM_MODEL_GLOBAL_H
