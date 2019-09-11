//
// Created by nawras on 16.08.18.
//

#ifndef PROJECT_OUTPUTOPERATIONS_H
#define PROJECT_OUTPUTOPERATIONS_H

#include "Model.h"
#include <sys/stat.h>//for creating directory command
#include <dirent.h>//for finding files inside folder
#include <fstream>//for writing on files
#include <sstream>

namespace SCAM {
    class OutputOperations {
    public:
        OutputOperations() = default;
        ~OutputOperations() = default;

        static std::string createOperations(Model* node, std::string dir);

    private:
        std::stringstream ss;
        std::string DIRpath;
        std::ofstream fileStream;

        std::string createFiles(Model *node);
        void DirectoryManage();
    };
}

#endif //PROJECT_OUTPUTOPERATIONS_H
