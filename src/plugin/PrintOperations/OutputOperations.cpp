//
// Created by nawras on 16.08.18.
//

#include "OutputOperations.h"


std::string SCAM::OutputOperations::createOperations(Model *node, std::string dir) {
    OutputOperations printer;
    printer.DIRpath = dir + "/Operations/";
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

std::string SCAM::OutputOperations::createFiles(Model *node) {
    DirectoryManage();

    for (auto module:node->getModules()) {
        try {
            this->ss.str("");
            for (auto state:  module.second->getFSM()->getStateMap()) {
                this->ss << state.second->printOutgoingOperations() << std::endl;
            }
            fileStream.open(DIRpath + "/" + module.first + ".txt");
            fileStream << ss.rdbuf();
            fileStream.close();
        } catch (std::runtime_error &err) {
            std::cout << err.what() << std::endl;
        }
    }
    this->ss.str("");
    this->ss<< "Operations files created..." << std::endl;
    return this->ss.str();
}

void SCAM::OutputOperations::DirectoryManage() {
    DIR *pDir;
    int dir_err;
    pDir = opendir (DIRpath.c_str());
    if (pDir == nullptr) {
        dir_err = mkdir(DIRpath.c_str(), S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
        if (-1 == dir_err) {
            std::cout << "Error creating directory!!!" << std::endl << std::endl;
            exit(1);
        }
    }
}