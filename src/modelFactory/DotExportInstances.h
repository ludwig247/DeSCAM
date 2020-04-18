//
// Created by schmitz on 10.03.20.
//

#ifndef DESCAM_DOTEXPORTINSTANCES_H
#define DESCAM_DOTEXPORTINSTANCES_H

#include <map>
#include <string>
#include <vector>
#include "Model.h"
#include "SVGChannel.h"
#include "simple_svg_1.0.0.hpp"
#include "SVGModuleInstance.h"

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
        void exportSVG(Model* model);
        void exportMain(Model* model);
        void printPorts(svg::Document* doc, std::map<std::string, SCAM::SVGPort *> portmap, int x, int y);
        void printChannels(svg::Document* doc, std::map<std::string, SCAM::SVGChannel *> channelmap , int x, int y);
        void printPortConnections(svg::Document* doc);
        void printLongerChannels(svg::Document* doc);
        void printInstanceMap();
    private:
        std::map<std::pair<std::string, std::string>, std::string> _instanceMap;
        std::map<std::string, int> _nodeMap;
        std::map<std::pair<std::string, std::string>, std::pair<std::string, std::string>> _channelMap; //!<<instance, port>, <channelName, channelParent>>
        std::map<std::string,  SVGModuleInstance*> _moduleinstanceMap;
        std::map<std::string,  SVGChannel*> _svgchannelMap;
        std::vector<nodedata> _nodedata;
        int _height;
        int _width;
        int _maxlevel;


        /*
        clang::CXXRecordDecl* recordDecl;
        std::map<std::string,clang::FieldDecl*> memberMap; //! <NameOfField,Declaration>
        std::map<std::string, std::string> memberTypeMap; //! <NameOfField,Declaration>
        std::map<std::string, clang::CXXRecordDecl *> _moduleMap;
        */
    };
}


#endif //DESCAM_DOTEXPORTINSTANCES_H
