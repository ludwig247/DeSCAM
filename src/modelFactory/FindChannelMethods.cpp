#include <iostream>
#include "FindChannelMethods.h"


namespace SCAM {


    FindChannelMethods::FindChannelMethods(clang::CXXRecordDecl *cxxDecl) {
        assert(!(cxxDecl == NULL));
        TraverseDecl(cxxDecl);
    }

    bool FindChannelMethods::VisitCXXMethodDecl(clang::CXXMethodDecl *cxxDecl) {
        cxxDecl = cxxDecl->getMostRecentDecl();
        if (cxxDecl->getNameAsString() == "FIFO<T>")
        {
            constructor = cxxDecl;
            std::cout <<constructor->getNameAsString()<<std::endl;
        }
        else{
            _ChannelMethodMap.insert(std::pair<std::string, clang::CXXMethodDecl *>(cxxDecl->getName().str(), cxxDecl));
            for(auto it = FindChannelMethods::getChannelMethodMap().cbegin(); it != FindChannelMethods::getChannelMethodMap().cend(); ++it){
                std::cout << it->first << "\t" << it->second << std::endl;
            }
        }
        return true;
    }

    const std::map<std::string, clang::CXXMethodDecl *> & FindChannelMethods::getChannelMethodMap() {
        return _ChannelMethodMap;
    }


}