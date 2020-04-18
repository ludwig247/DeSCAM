//
// Created by schmitz on 06.04.20.
//

#ifndef DESCAM_SVGCHANNEL_H
#define DESCAM_SVGCHANNEL_H

//
// Created by schmitz on 10.03.20.
//

#include <map>
#include <string>
#include <vector>
#include "Model.h"
#include "simple_svg_1.0.0.hpp"

namespace SCAM{

    class SVGPort;

    class SVGModuleInstance;

    class SVGChannel {
    public:


        SVGChannel(std::string name);

        virtual  ~SVGChannel();


        std::string getName();
        std::string getChannelParent();
        int getxStart();
        int getxEnd();
        int gety();

        SVGPort *getFromSVGPort();
        SVGPort *getToSVGPort();
        SVGModuleInstance *getFromSVGInstance();
        SVGModuleInstance *getToSVGInstance();

        void setxStart(int x);
        void setxEnd(int x);
        void sety(int y);
        void setChannelParent(std::string name);

        void setFromSVGPort(SVGPort *port);
        void setToSVGPort(SVGPort *port);
        void setFromSVGInstance(SVGModuleInstance *instance);
        void setToSVGInstance(SVGModuleInstance *instance);


    private:
        int _x_start;
        int _x_end;
        int _y;
        std::string _name;
        std::string _channelparent;
        SVGPort *_fromPort;
        SVGPort *_toPort;
        SVGModuleInstance *_fromInstance;
        SVGModuleInstance *_toInstance;
    };
}


#endif //DESCAM_SVGCHANNEL_H
