//
// Created by schmitz on 22.04.20.
//

#ifndef DESCAM_PRINTSVG_H
#define DESCAM_PRINTSVG_H

#include <PluginFactory.h>
#include "Model.h"

class PrintSVG : public PluginFactory {
public:
    PrintSVG() = default;
    ~PrintSVG() = default;
    std::map<std::string, std::string> printModel(Model *node);

    void increaseWidth(SCAM::ModuleInstance* instance, unsigned width);
    void increaseHeight(SCAM::ModuleInstance* instance, unsigned height);


private:
    Model *model;
    std::map<SCAM::ModuleInstance*, unsigned> _heightMap;
    std::map<SCAM::ModuleInstance*, unsigned > _widthMap;
    std::map<SCAM::ModuleInstance*, unsigned> _xMap;
    std::map<SCAM::ModuleInstance*, unsigned> _yMap;
    std::map<SCAM::Channel*, unsigned> _xStartMap;
    std::map<SCAM::Channel*, unsigned> _xEndMap;
    std::map<SCAM::Channel*, unsigned> _ChannelYMap;
    std::map<SCAM::PortMapChannel*, unsigned> _xStartPortMapMap;
    std::map<SCAM::PortMapChannel*, unsigned> _xEndPortMapMap;
    std::map<SCAM::PortMapChannel*, unsigned> _ChannelYPortMapMap;
    int _r;
    int _g;
    int _b;
    int r(int level);
    int g(int level);
    int b(int level);

    unsigned getHeight(SCAM::ModuleInstance* instance);
    unsigned getWidth(SCAM::ModuleInstance* instance);
    unsigned getX(SCAM::ModuleInstance* instance);
    unsigned getY(SCAM::ModuleInstance* instance);
    unsigned getY(SCAM::Channel* channel);
    unsigned getXStart(SCAM::Channel* channel);
    unsigned getXEnd(SCAM::Channel* channel);

    unsigned getToPortX(SCAM::Channel* channel);
    unsigned getFromPortX(SCAM::Channel* channel);

    unsigned getLowerPortX(SCAM::PortMapChannel* channel);
    unsigned getHigherPortX(SCAM::PortMapChannel* channel);

    void setHeight(SCAM::ModuleInstance* instance, unsigned height);
    void setWidth(SCAM::ModuleInstance* instance, unsigned width);
    void setX(SCAM::ModuleInstance* instance, unsigned x);
    void setY(SCAM::ModuleInstance* instance, unsigned y);
    void setY(SCAM::Channel* channel, unsigned y);
    void setXStart(SCAM::Channel* channel, unsigned x);
    void setXEnd(SCAM::Channel* channel, unsigned x);

    void setY(SCAM::PortMapChannel* channel, unsigned y);
    void setXStart(SCAM::PortMapChannel* channel, unsigned x);
    void setXEnd(SCAM::PortMapChannel* channel, unsigned x);

    unsigned getY(SCAM::PortMapChannel* channel);
    unsigned getXStart(SCAM::PortMapChannel* channel);
    unsigned getXEnd(SCAM::PortMapChannel* channel);

};

#endif //DESCAM_PRINTSVG_H
