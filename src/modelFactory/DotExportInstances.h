//
// Created by schmitz on 10.03.20.
//

#ifndef DESCAM_DOTEXPORTINSTANCES_H
#define DESCAM_DOTEXPORTINSTANCES_H

#include <map>
#include <string>

namespace SCAM{

    class DotExportInstances {
    public:
        void  addtoGraph(std::map<std::pair<std::string, std::string>, std::string> instanceMap);
        void  exportDot();
        void printInstanceMap();
    private:
        std::map<std::pair<std::string, std::string>, std::string> _instanceMap;
        /*
        clang::CXXRecordDecl* recordDecl;
        std::map<std::string,clang::FieldDecl*> memberMap; //! <NameOfField,Declaration>
        std::map<std::string, std::string> memberTypeMap; //! <NameOfField,Declaration>
        std::map<std::string, clang::CXXRecordDecl *> _moduleMap;
        */
    };
}


#endif //DESCAM_DOTEXPORTINSTANCES_H
