//
// Created by schmitz on 05.03.20.
//

#include "FindInstancesInModule.h"
#include <iostream>



namespace SCAM {


    FindInstancesInModules::FindInstancesInModules(clang::CXXRecordDecl * RecDecl,std::map<std::string, clang::CXXRecordDecl *> ModuleMap) {
        assert(!(RecDecl == NULL));
        _moduleMap = ModuleMap;
        _recDecl = RecDecl;
        TraverseDecl(RecDecl);
    }

    bool FindInstancesInModules::VisitFieldDecl(clang::FieldDecl *fieldDecl) {
        //Instances of Modules inside Modules are found as a fieldDecl of a Struct Type
        std::string instanceName;
        std::string moduleName;
        std::string parentName;
        //Check if field Decl ist StructureType
        if ( fieldDecl->getType()->isStructureType()) {
            if (_moduleMap.find(fieldDecl->getType()->getAsCXXRecordDecl()->getName().str()) == _moduleMap.end() ) {
                //StructType is not a Module
            }
            else {
                instanceName = fieldDecl->getName().str();
                moduleName = fieldDecl->getType()->getAsCXXRecordDecl()->getName().str();
                parentName = _recDecl->getName().str();
                auto inst_innerEntry = std::pair<std::string, std::string>(instanceName, moduleName);
                auto inst_outerEntry = std::pair<std::pair<std::string, std::string>, std::string>(
                        inst_innerEntry, parentName);
                this->_instanceMap.insert(inst_outerEntry);
            }
        }
        return true;
    }


    std::map<std::pair<std::string, std::string>, std::string> FindInstancesInModules::getInstanceMap() {
        return _instanceMap;
    }

    void FindInstancesInModules::printInstanceMap() {
        std::cout << "Instance Map:" << std::endl;
        for (auto elem : this->getInstanceMap()) {
            std::cout << "Name: "<<elem.first.first.c_str() << " Module: " << elem.first.second.c_str() << " Parent: "<< elem.second.c_str() << "\n";
        }
        std::cout << "#########" << std::endl;
    }

}
