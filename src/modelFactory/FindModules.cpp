#include <iostream>
#include "FindModules.h"


namespace SCAM {


    FindModules::FindModules(clang::TranslationUnitDecl *tuDecl) {
        assert(!(tuDecl == NULL));
        TraverseDecl(tuDecl);
    }

    bool FindModules::VisitCXXRecordDecl(clang::CXXRecordDecl *cxxDecl) {
        //Checks wheter the module is just a declaration and not a implementation
        if (cxxDecl->hasDefinition() == false) {
            return true;
        }

        //If class is a systemC module it has to have a base class
        if (cxxDecl->getNumBases() <= 0) {
            return true;
        }
        //Assume: All user defined modules can be identified by a basname "class sc::core::sc_module"
        //Issues: doesn't filters all classes, e.g. sc_event_queue has also this basename
        //Idea: sortout those modules by hand
        for (clang::CXXRecordDecl::base_class_iterator bi = cxxDecl->bases_begin(), be = cxxDecl->bases_end(); bi != be; ++bi) {
            clang::QualType q = bi->getType();
            //Check basename
            std::string baseName = q.getAsString();
            if (baseName == "class sc_core::sc_module" || baseName == "::sc_core::sc_module") {
                _moduleMap.insert(std::pair<std::string, clang::CXXRecordDecl *>(cxxDecl->getName().str(), cxxDecl));

            }
        }
        return true;
    }

    const std::map<std::string, clang::CXXRecordDecl *> & FindModules::getModuleMap() {
        return _moduleMap;
    }


}