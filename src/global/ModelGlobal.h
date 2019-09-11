//
// Created by tobias on 30.12.16.
//

#ifndef SCAM_MODELGLOBAL_H
#define SCAM_MODELGLOBAL_H

#include <stdexcept>


#include "Config.h"
#include <vector>
#include <PluginAction.h>
#include <ModelFactory.h>


namespace SCAM{
/** \brief Singleton that contains a pointer to the model
 *
 *  Necessary, because it's really hard to extract the model from the ModelFactory,
 *  which is somehow instantiated within the clang environment
 */
    class Model;
    class ModelGlobal {
    public:
        static void setModel(Model * model) {
            if(model == nullptr) throw std::runtime_error("ModelGlobal: model is null");
            ModelGlobal::getInstance().model = model;
        }


        static Model * getModel() {
            if(ModelGlobal::getInstance().model == nullptr) throw std::runtime_error("ModelGlobal: model is null");
            return ModelGlobal::getInstance().model;
        }

        static void createModel(int argc, const std::string& Binary, const std::string& srcFile) {
            std::vector<std::string> result;
            std::vector<const char *> commandLineArugmentsVector;

            std::string clang_dir = SCAM_HOME"/include/clang/3.4.2/include";
            std::string systemc_dir = SCAM_HOME"/include/";
            std::string scam_dir = SCAM_HOME"/";
            if(clang_dir == "") throw std::runtime_error("Specfiy CLANG_DIR as environment variable");
            if(systemc_dir == "") throw std::runtime_error("Specfiy SYSTEMC_DIR as environment variable");
            if(scam_dir == "") throw std::runtime_error("Specfiy SCAM_DIR as environment variable");

            //Binaray
            commandLineArugmentsVector.push_back(Binary.c_str());

            //SRC-File to be analyzed
            commandLineArugmentsVector.push_back(srcFile.c_str());

            //Seperator n
            commandLineArugmentsVector.push_back("--");

            //TestCases include-dir: may not be changed
            commandLineArugmentsVector.push_back("-I/usr/include");
            commandLineArugmentsVector.push_back("-I/usr/local/include");

            //Include dirs
            std::string clang = std::string("-I"+clang_dir);
            commandLineArugmentsVector.push_back(clang.c_str());
            std::string systemc = std::string("-I"+systemc_dir);
            commandLineArugmentsVector.push_back(systemc.c_str());
            std::string interfaces = std::string("-I"+scam_dir+"example/Interfaces/");
            commandLineArugmentsVector.push_back(interfaces.c_str());
            //Parameters for clang: may not be changed
            std::vector<const char *> clangParameter = {"-std=c++11","-x", "c++", "-w", "-c"};
            for (auto item: clangParameter) {
                commandLineArugmentsVector.push_back(item);
            }
            //Creates an instance of ModelFactory and calls ModelFactory::HandleTranslationUnit
            const char *commandLineArgumentsArray[commandLineArugmentsVector.size()];
            for (int i = 0; i < commandLineArugmentsVector.size(); i++) {
                commandLineArgumentsArray[i] = commandLineArugmentsVector.at(i);
            }
            if(argc >= 1) {
                PluginAction<SCAM::ModelFactory> pa2(commandLineArugmentsVector.size(), commandLineArgumentsArray);
            }else throw std::runtime_error("Wrong use of SCAM");
        }

        static void createModel(int argc, const char **argv) {
            std::vector<std::string> result;
            std::vector<const char *> commandLineArugmentsVector;

            std::string clang_dir = SCAM_HOME"/include/clang/3.4.2/include";
            std::string systemc_dir = SCAM_HOME"/include/";
            std::string scam_dir = SCAM_HOME"/";
            if(clang_dir == "") throw std::runtime_error("Specfiy CLANG_DIR as environment variable");
            if(systemc_dir == "") throw std::runtime_error("Specfiy SYSTEMC_DIR as environment variable");
            if(scam_dir == "") throw std::runtime_error("Specfiy SCAM_DIR as environment variable");

            //Binaray
            commandLineArugmentsVector.push_back(argv[0]);

            //SRC-File to be analyzed
            commandLineArugmentsVector.push_back(argv[1]);

            //Seperator n
            commandLineArugmentsVector.push_back("--");

            //TestCases include-dir: may not be changed
            commandLineArugmentsVector.push_back("-I/usr/include");
            commandLineArugmentsVector.push_back("-I/usr/local/include");

            //Include dirs
            std::string clang = std::string("-I"+clang_dir);
            commandLineArugmentsVector.push_back(clang.c_str());
            std::string systemc = std::string("-I"+systemc_dir);
            commandLineArugmentsVector.push_back(systemc.c_str());
            std::string interfaces = std::string("-I"+scam_dir+"example/Interfaces/");
            commandLineArugmentsVector.push_back(interfaces.c_str());
            //Parameters for clang: may not be changed
            std::vector<const char *> clangParameter = {"-std=c++11","-x", "c++", "-w", "-c"};
            for (auto item: clangParameter) {
                commandLineArugmentsVector.push_back(item);
            }
            //Creates an instance of ModelFactory and calls ModelFactory::HandleTranslationUnit
            const char *commandLineArgumentsArray[commandLineArugmentsVector.size()];
            for (int i = 0; i < commandLineArugmentsVector.size(); i++) {
                commandLineArgumentsArray[i] = commandLineArugmentsVector.at(i);
            }
            if(argc >= 1) {
                PluginAction<SCAM::ModelFactory> pa2(commandLineArugmentsVector.size(), commandLineArgumentsArray);
            }else throw std::runtime_error("Wrong use of SCAM");
        }

    private:
        ModelGlobal():model(nullptr) {};
        static ModelGlobal & getInstance() {
            static ModelGlobal instance;
            return instance;
        }

        SCAM::Model * model;
    };
}



#endif //SCAM_MODELGLOBAL_H
