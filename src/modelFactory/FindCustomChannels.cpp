//
// Created by ludwig on 15.09.20.
//

#include "FindCustomChannels.h"


bool DESCAM::FindCustomChannels::VisitCXXRecordDecl(clang::CXXRecordDecl *recordDecl) {
    //Checks wheter the module is just a declaration and not a implementation
    if (recordDecl->hasDefinition() == false) {
        return true;
    }

    //If class is a systemC module it has to have a base class
    if (recordDecl->getNumBases() <= 0) {
        return true;
    }
    //Assume: All user defined modules can be identified by a basname "class sc::core::sc_module"
    //Issues: doesn't filters all classes, e.g. sc_event_queue has also this basename
    //Idea: sortout those modules by hand
    auto name = recordDecl->getNameAsString();
    if (name == "Regfile") {
        recordDecl->dump();
        this->channel_map.insert(std::pair<std::string, clang::CXXRecordDecl *>(recordDecl->getName().str(), recordDecl));
    }
    //TODO:  implement proper finding thing
//    for (clang::CXXRecordDecl::base_class_iterator bi = recordDecl->bases_begin(), be = recordDecl->bases_end(); bi != be; ++bi) {
//        clang::QualType q = bi->getType();
//        //Check basename
//        std::string baseName = q.getAsString();
//        if (baseName == "sc_prim_channel" || baseName == "sc_prim_channel") {
//            this->channel_map.insert(std::pair<std::string, clang::CXXRecordDecl *>(recordDecl->getName().str(), recordDecl));
//        }
//    }
    return true;
}

const std::map<std::string, clang::CXXRecordDecl *> &DESCAM::FindCustomChannels::getChannelMap() const {
    return channel_map;
}

DESCAM::FindCustomChannels::FindCustomChannels(clang::TranslationUnitDecl *tuDecl) {
    assert(!(tuDecl == NULL));
    TraverseDecl(tuDecl);
}
