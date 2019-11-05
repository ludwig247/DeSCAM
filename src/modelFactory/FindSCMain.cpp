#include <iostream>
#include "FindSCMain.h"

namespace SCAM {

    FindSCMain::FindSCMain(clang::TranslationUnitDecl *tuDecl):
            pass(0),
            scMainFound(false),
            _scmainFunctionDecl(NULL){
        assert (!(tuDecl == NULL));
        //Find sc_main
        TraverseDecl(tuDecl);
        //Is found
    }

    bool FindSCMain::VisitFunctionDecl(clang::FunctionDecl *functionDecl) {

        /// Find sc_main.
        /// There are three conditions to satisfy this:
        /// 1. Must have sc_main in its name.
        /// 2. Must have a body
        /// 3. Must *not* be a first declaration. (This is becuase systemc.h includes a null definition of sc_main.
        if ((functionDecl->getNameInfo().getAsString() == "sc_main") && (functionDecl->hasBody())) {
            //Pass the null definition of main
            if(pass == 1){
                _scmainFunctionDecl = functionDecl;
                scMainFound = true;
                return false;
            }
            pass = 1;
        }
        return true;
    }


    clang::FunctionDecl *FindSCMain::getSCMainFunctionDecl() {
        assert (!(_scmainFunctionDecl == NULL));
        return _scmainFunctionDecl;
    }

    bool FindSCMain::isScMainFound() const {
        return scMainFound;
    }

}