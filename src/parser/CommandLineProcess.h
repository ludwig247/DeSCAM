//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 17.04.18.
//

#ifndef PROJECT_COMMANDLINEPROCESS_H
#define PROJECT_COMMANDLINEPROCESS_H

#include <list>
#include <string>
#include <fstream>
#include <sys/stat.h>//for managing directory commands
#include "CLI/CLI.hpp"
#include "CommandLineParameter.cpp"
#include "CommandLineParametersConfig.h"

namespace SCAM {
//    enum class OptimizeLevel : int { High, Medium, Low };
//
//    std::istream &operator>>(std::istream &in, OptimizeLevel &optimizelevel) {
//        int i;
//        in >> i;
//        optimizelevel = static_cast<OptimizeLevel >(i);
//        return in;
//    }
//
//    std::ostream &operator<<(std::ostream &in, const OptimizeLevel &optimizeLevel) { return in << static_cast<int>(optimizeLevel); }


    class CommandLineProcess {
    public:
        CommandLineProcess(int argc, const char **argv);

        ~CommandLineProcess() = default;

        const std::string &getSourceFile() const;

        const std::string &getOutputDirectory() const;

        const std::list<std::string> &getActivePlugins() const;
//        static bool ProcessCommandLine(int argc, const char **argv, std::list<std::string> &styles, std::string &sourceFile, std::string &outputDirectory) {
//            std::string tempArg;
//            for (int i = 1; i < argc; i++) { // Skip first argument, the program name (SCAM).
//                tempArg = argv[i];
//                if(isSourceFile(tempArg))
//                    sourceFile = tempArg;
//                else if(tempArg == "-o") { // OutputDirectoy should be following this "-o" option
//                    if(i == (argc - 1)){
//                        outputDirectory = ""; // Undefined output directory !!!!!
//                        return false;
//                    }
//                    else {
//                        tempArg = argv[++i];
//                        if (CreateOutputDirectory(tempArg))
//                            outputDirectory = tempArg;
//                        else
//                            return false;
//                    }
//                }
//                else if (tempArg != "-o" && !isDirectory(tempArg) && !isSourceFile(tempArg)) {
//                    tempArg.erase(0, 1);//erase the '-' from the commandline argument
//                    styles.emplace_back(tempArg);
//                }
//                else
//                    return false;
//            }
//
//            return true;
//        }

    private:
        void commandLineInitialize();

        void commandLineRead(int argc, const char **argv);

        static bool createOutputDirectory(const std::string &d) {
            struct stat st_buf{};
            int status = stat (d.c_str(), &st_buf);

            if(status != 0) { // This directory doesn't exist !!!!!
                int dir_err = mkdir(d.c_str(), S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
                return -1 != dir_err;
            }
        }

        static bool isDirectory(const std::string &d) {
            struct stat st_buf{};
            int status = stat (d.c_str(), &st_buf);
            return status == 0 && S_ISDIR (st_buf.st_mode); // Error creating output directory!!!!
        }

        static bool isSourceFile(const std::string &f){
            struct stat st_buf{};
            int status = stat (f.c_str(), &st_buf);
            return status == 0 && S_ISREG (st_buf.st_mode); // Error reading a sourcefile!!!!
        }

        CLI::App *app;
//        bool usingCLANG;
        std::string sourceFile;
        std::string outputDirectory;
//        OptimizeLevel optimizeLevel;
        std::list<std::string> activePlugins;
    };
}
#endif //PROJECT_COMMANDLINEPROCESS_H
