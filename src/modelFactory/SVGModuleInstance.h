//
// Created by schmitz on 06.04.20.
//

#ifndef DESCAM_SVGMODULEINSTANCE_H
#define DESCAM_SVGMODULEINSTANCE_H


#include <map>
#include <string>
#include "SVGChannel.h"
#include "SVGPort.h"

namespace SCAM{

    class SVGModuleInstance {
    public:


        SVGModuleInstance(std::string name);
        virtual  ~SVGModuleInstance();


        std::string getSVGName();
        int getX();
        int getY();
        int getWidth();
        int getHeight();
        int getLevel();
        std::string getParentName();
        std::string getModuleName();
        int getChannelLevel();
        bool getStructural();
        int getLongestChannelName();

        void setX(int x);
        void setWidth(int width);
        void setY(int y);
        void setHeight(int height);
        void setLevel(int level);
        void setParentName(std::string name);
        void setModuleName(std::string name);
        void setChannelLevel(int x);
        void setStructural(bool structural);

        void increaseWidth(int x);
        void increaseHeight(int x);


        //ModuleInstances
        void addSVGModuleInstance(SVGModuleInstance *moduleInstance);

        std::map<std::string, SVGModuleInstance *> getSVGModuleInstances();

        //Channel
        void addSVGChannel(SVGChannel *channel);

        std::map<std::string, SVGChannel *> getSVGChannelMap();

        //Ports
        void addSVGPort(SVGPort *port);

        std::map<std::string, SCAM::SVGPort *> getSVGPortMap();


    private:
        int _x;
        int _width;
        int _y;
        int _height;
        int _level;
        bool _structural;
        int _channellevel;
        std::string _name;
        std::string _modulename;
        std::string _parentname;
        std::map<std::string, SVGChannel *> channelMap; //! List of channels bound within this instance
        std::map<std::string, SVGModuleInstance *> submoduleInstanceMap; //! Contains all instances of sub-modules instantiated in this module
        std::map<std::string, SCAM::SVGPort *> portMap;

    };
}
#endif //DESCAM_SVGMODULEINSTANCE_H
