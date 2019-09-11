//
// Created by altaleb on 8/17/18.
//

#include "OutputMonitor.h"


std::string SCAM::OutputMonitor::createMonitor(Model *node, std::string dir) {
    OutputMonitor printer;
    printer.DIRpath = dir + "/Monitor/";
    std::cout<<"WARNING: This request might replace some files inside directory: " << printer.DIRpath << std::endl;
    std::cout<<"Do you still want to continue [y/n]? ";
    char answer;
    std::cin >> answer;
    if(answer == 'y' || answer == 'Y') {
        std::cout<<std::endl;
        return printer.createFiles(node);
    }
    else{
        return "";
    }
}

std::string SCAM::OutputMonitor::createFiles(Model *node) {
    DirectoryManage();

    for (auto module:node->getModules()) {
        try {
            this->ss.str("");
            SCAM::PrintMonitor printMonitor(module.second);
            this->ss << printMonitor.print() << std::endl;

            fileStream.open(DIRpath + "/" + module.first + ".vhdl");
            fileStream << ss.rdbuf();
            fileStream.close();
        } catch (std::runtime_error &err) {
            std::cout << err.what() << std::endl;
        }
    }
    this->ss.str("");
    this->ss<< "Monitor files created..." << std::endl;
    return this->ss.str();
}

void SCAM::OutputMonitor::DirectoryManage() {
    DIR *pDir;
    int dir_err;
    pDir = opendir(DIRpath.c_str());
    if (pDir == nullptr) {
        dir_err = mkdir(DIRpath.c_str(), S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
        if (-1 == dir_err) {
            std::cout << "Error creating directory!!!" << std::endl << std::endl;
            exit(1);
        }
    }
}