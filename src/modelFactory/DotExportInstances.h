//
// Created by schmitz on 10.03.20.
//

#ifndef DESCAM_DOTEXPORTINSTANCES_H
#define DESCAM_DOTEXPORTINSTANCES_H

#include <map>
#include <string>
#include <vector>
#include "Model.h"

namespace SCAM{

    class DotExportInstances {
    public:

        struct nodedata {
            std::string nodename;
            int nodenumber;
            std::map<std::string, int> subnodemap;
        };

        void  addtoGraph(std::map<std::pair<std::string, std::string>, std::string> instanceMap);
        void  addChannels(Model* model);
        void  exportDot();
        void exportMain(Model* model);
        void printInstanceMap();
    private:
        std::map<std::pair<std::string, std::string>, std::string> _instanceMap;
        std::map<std::string, int> _nodeMap;
        std::map<std::pair<std::string, std::string>, std::pair<std::string, std::string>> _channelMap; //!<<instance, port>, <channelName, channelParent>>

        std::vector<nodedata> _nodedata;

        /*
        clang::CXXRecordDecl* recordDecl;
        std::map<std::string,clang::FieldDecl*> memberMap; //! <NameOfField,Declaration>
        std::map<std::string, std::string> memberTypeMap; //! <NameOfField,Declaration>
        std::map<std::string, clang::CXXRecordDecl *> _moduleMap;
        */
    };
}


#endif //DESCAM_DOTEXPORTINSTANCES_H
