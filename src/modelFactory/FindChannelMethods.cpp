#include <iostream>
#include "FindChannelMethods.h"


namespace SCAM {


    FindChannelMethods::FindChannelMethods(clang::CXXRecordDecl *recordDecl)
            : FindFunctions(recordDecl) {
        assert(!(recordDecl == NULL));
        TraverseDecl(recordDecl);
    }

    bool FindChannelMethods::VisitCXXMethodDecl(clang::CXXMethodDecl *methodDecl) {
        methodDecl = methodDecl->getMostRecentDecl();
        std::string name = methodDecl->getNameAsString();
        if (name == "FIFO<T>") {
            constructor = methodDecl;
            //Param name and param type
            std::vector<std::string> ConstructorparamNameList;
            std::vector<std::string> ConstructorparamTypeList;
            for (int i = 0; i < methodDecl->getNumParams(); i++) {
                auto param = methodDecl->getParamDecl(i);
                ConstructorparamNameList.push_back(param->getName().str());
                ConstructorparamTypeList.push_back(this->clangToScamType(param->getType()));
            }
            this->ConstructorParamNameMap.insert(std::make_pair(name, ConstructorparamNameList));
        } else {
            this->functionMap.insert(std::make_pair(name,methodDecl));

            //Return type
            this->functionReturnTypeMap.insert(std::make_pair(name, this->clangToScamType(methodDecl->getResultType())));

            //Param name and param type
            std::vector<std::string> paramNameList;
            std::vector<std::string> paramTypeList;
            for (int i = 0; i < methodDecl->getNumParams(); i++) {
                auto param = methodDecl->getParamDecl(i);
                paramNameList.push_back(param->getName().str());
                paramTypeList.push_back(this->clangToScamType(param->getType()));
            }
            this->functionParamNameMap.insert(std::make_pair(name,paramNameList));
            this->functionParamTypeMap.insert(std::make_pair(name,paramTypeList));

        }
        return true;
    }
}
