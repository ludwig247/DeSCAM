//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 9/20/18.
//

#ifndef PROJECT_MANAGEOUTPUT_H
#define PROJECT_MANAGEOUTPUT_H

#include <string>
#include <map>
#include <iostream>
#include <sstream>
#include <sys/stat.h>//for managing directory commands
#include <fstream>//for writing on files
#include <cxxabi.h>

namespace SCAM{

    inline void createFile(const std::string &pluginName, const std::string &fileName, const std::string &fileText, const std::string &dir) {
        std::cout << " " << pluginName << ": " << fileName << " generated in " << dir << std::endl;
        std::ofstream fileStream;
        fileStream.open(dir + "/" + pluginName + "/" + fileName);
        fileStream << fileText;
        fileStream.close();
    }

    inline void printFile(const std::string &pluginName, const std::string &fileName, const std::string &fileText) {
        std::cout << "---------------------------------------------------------------------------" << std::endl;
        std::cout << pluginName << ": " << fileName << " -------------------------" << std::endl;
        std::cout << "---------------------------------------------------------------------------" << std::endl;
        std::cout << fileText;
        std::cout << std::endl << std::endl;
    }

    bool createDirectory(const std::string &pluginName, const std::string &dir){
        struct stat st_buf{};
        int status = stat((dir + "/" + pluginName + "/").c_str(), &st_buf);
        if (status != 0) { // This directory doesn't exist !!!!!
            int dir_err = mkdir((dir + "/" + pluginName + "/").c_str(), S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
            return -1 != dir_err;
        }
        return true;
    }

    void createFiles(const std::string &pluginName, std::map<std::string, std::string> pluginOutput, std::string dir){
        for (const auto &text : pluginOutput){
            createFile(pluginName, text.first, text.second, dir);
        }
    }

    void printFiles(const std::string &pluginName, std::map<std::string, std::string> pluginOutput){
        for (const auto &text : pluginOutput){
            printFile(pluginName, text.first, text.second);
        }
    }
}

#endif //PROJECT_MANAGEOUTPUT_H
