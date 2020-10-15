//
// Created by tobias on 30.12.16.
//

#ifndef SCAM_MODELGLOBAL_H
#define SCAM_MODELGLOBAL_H

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
              IModelFactory *model_factory, bool isWrapper = false) {

    std::vector<std::string> result;
    std::vector<const char *> commandLineArugmentsVector;
    //Analyzing Environmental Variables          -----Default Values for Reference
    std::string clang_dir = SCAM_HOME"/include/clang/3.4.2/include";//getenv("CLANG_DIR");
    std::string systemc_dir = SCAM_HOME"/include/";//getenv("SYSTEMC_DIR");
    std::string scam_dir = SCAM_HOME"/";//getenv("SCAM_HOME");
    std::string root_dir = "/";//getenv("ROOT_DIR");
    if (clang_dir.empty()) TERMINATE("Specify CLANG_DIR as environment variable");
    if (systemc_dir.empty()) TERMINATE("Specify SYSTEMC_DIR as environment variable");
    if (scam_dir.empty()) TERMINATE("Specify SCAM_DIR as environment variable");
    if (root_dir.empty()) TERMINATE("Specify ROOT_DIR as environment variable");

    //Binary
    commandLineArugmentsVector.push_back(Binary.c_str());

    //SRC-File to be analyzed
    commandLineArugmentsVector.push_back(srcFile.c_str());

    //Separator n
    commandLineArugmentsVector.push_back("--");

    //TestCases include-dir: may not be changed
    //commandLineArugmentsVector.push_back("-I /usr/include");
    //commandLineArugmentsVector.push_back("-I /usr/local/include");
    std::string root_usr = std::string("-I" + root_dir + "usr/include/**");
    commandLineArugmentsVector.push_back(root_usr.c_str());
    std::string root_usr_local = std::string("-I" + root_dir + "usr/local/include/**");
    commandLineArugmentsVector.push_back(root_usr_local.c_str());

    //Include dirs
    std::string clang = std::string("-I" + clang_dir);
    commandLineArugmentsVector.push_back(clang.c_str());
    std::string systemc = std::string("-I" + systemc_dir);
    commandLineArugmentsVector.push_back(systemc.c_str());
    std::string interfaces = std::string("-I" + scam_dir + "example/Interfaces/");
    commandLineArugmentsVector.push_back(interfaces.c_str());
    //Parameters for clang: may not be changed
    std::vector<const char *> clangParameter = {"-std=c++11", "-x", "c++", "-w", "-c"};
    for (auto item: clangParameter) {
      commandLineArugmentsVector.push_back(item);
    }
    //Creates an instance of ModelFactory and calls ModelFactory::HandleTranslationUnit
    const char *commandLineArgumentsArray[commandLineArugmentsVector.size()];
    for (int i = 0; i < commandLineArugmentsVector.size(); i++) {
      commandLineArgumentsArray[i] = commandLineArugmentsVector.at(i);
    }

    if (argc >= 1) {

      if (!isWrapper) {
        PluginAction
            pa2(commandLineArugmentsVector.size(), commandLineArgumentsArray, model_factory);

      } else {

        throw std::runtime_error("NOT ALLOWED");
        //For CheckErrors
        PluginAction pa2(commandLineArugmentsVector.size(), commandLineArgumentsArray, model_factory);
      }
    } else TERMINATE("Wrong use of DeSCAM");
  };

  static void createModel(int argc, const char **argv, IModelFactory *model_factory) {
    throw std::runtime_error("DEPRECATED");
    std::vector<std::string> result;
    std::vector<const char *> commandLineArugmentsVector;

    std::string clang_dir = SCAM_HOME"/include/clang/3.4.2/include";
    std::string systemc_dir = SCAM_HOME"/include/";
    std::string scam_dir = SCAM_HOME"/";
    std::string root_dir = "/"; //getenv("ROOT_DIR");       //"/";
    if (clang_dir == "") TERMINATE("Specfiy CLANG_DIR as environment variable");
    if (systemc_dir == "") TERMINATE("Specfiy SYSTEMC_DIR as environment variable");
    if (scam_dir == "") TERMINATE("Specfiy SCAM_DIR as environment variable");
    if (root_dir == "") TERMINATE("Specfiy ROOT_DIR as environment variable");

    //Binaray
    commandLineArugmentsVector.push_back(argv[0]);

    //SRC-File to be analyzed
    commandLineArugmentsVector.push_back(argv[1]);

    //Seperator n
    commandLineArugmentsVector.push_back("--");

    //TestCases include-dir: may not be changed
    //commandLineArugmentsVector.push_back("-I /usr/include");
    //commandLineArugmentsVector.push_back("-I /usr/local/include");
    std::string root_usr = std::string("-I" + root_dir + "usr/include/**");
    commandLineArugmentsVector.push_back(root_usr.c_str());
    std::string root_usr_local = std::string("-I" + root_dir + "usr/local/include/**");
    commandLineArugmentsVector.push_back(root_usr_local.c_str());

    //Include dirs
    std::string clang = std::string("-I" + clang_dir);
    commandLineArugmentsVector.push_back(clang.c_str());
    std::string systemc = std::string("-I" + systemc_dir);
    commandLineArugmentsVector.push_back(systemc.c_str());
    std::string interfaces = std::string("-I" + scam_dir + "example/Interfaces/");
    commandLineArugmentsVector.push_back(interfaces.c_str());
    //Parameters for clang: may not be changed
    std::vector<const char *> clangParameter = {"-std=c++11", "-x", "c++", "-w", "-c"};
    for (auto item: clangParameter) {
      commandLineArugmentsVector.push_back(item);
    }
    //Creates an instance of ModelFactory and calls ModelFactory::HandleTranslationUnit
    const char *commandLineArgumentsArray[commandLineArugmentsVector.size()];
    for (int i = 0; i < commandLineArugmentsVector.size(); i++) {
      commandLineArgumentsArray[i] = commandLineArugmentsVector.at(i);
    }
    if (argc >= 1) {
      PluginAction pa2(commandLineArugmentsVector.size(), commandLineArgumentsArray, model_factory);
    } else TERMINATE("Wrong use of DeSCAM");
  }

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

#endif //SCAM_MODELGLOBAL_H
