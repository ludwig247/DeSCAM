//
// Created by altaleb on 8/17/18.
//

#ifndef PROJECT_OUTPUTMONITOR_H
#define PROJECT_OUTPUTMONITOR_H

#include <sys/stat.h>//for creating directory command
#include <dirent.h>//for finding files inside folder
#include <fstream>//for writing on files
#include "PrintMonitor.h"

namespace SCAM {
    class OutputMonitor {
    public:
        OutputMonitor() = default;
        ~OutputMonitor() = default;

        static std::string createMonitor(Model* node, std::string dir);

    private:
        std::stringstream ss;
        std::string DIRpath;
        std::ofstream fileStream;

        std::string createFiles(Model *node);
        void DirectoryManage();
    };
}

#endif //PROJECT_OUTPUTMONITOR_H
