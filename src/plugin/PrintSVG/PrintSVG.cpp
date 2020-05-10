//
// Created by schmitz on 22.04.20.
//
#include "PrintSVG.h"
#include "simple_svg_1.0.0.hpp"
#include <iostream>
//defines for dimensions of the graphic
#define standardheight 50
#define standardwidth 100
#define spacingleft 10
#define spacingup 10
#define spacingport 150
#define spacingmodule 50
#define spacingchannel 20
#define fontsize 10
#define trianglesize 15
#define spacinghorizontal 20

std::map<std::string, std::string> PrintSVG::printModel(Model *node) {
    //init
    this->model = node;
    _r = 255;
    _g = 0;
    _b = 0;

    ModuleInstance* topInstance = model->getTopInstance();
    if (topInstance == nullptr) {
        pluginOutput.insert(std::make_pair("PrintSVG.log", "Could not generate graphical representation -- TopInstance is missing"));
        return pluginOutput;
    }

    setX(topInstance, 0);
    setY(topInstance, 0);
    setHeight(topInstance, standardheight);
    setWidth(topInstance, standardwidth);

    std::vector<ModuleInstance*> iterate;
    iterate.push_back(topInstance);

    //create instances
    while(!iterate.empty()) {
        for (auto children: iterate.front()->getSubmoduleInstances()) {
            setWidth(children.second, standardwidth);
            setHeight(children.second, standardheight);
            if (children.second->getStructure()->isStructural()) {
                iterate.push_back(children.second);
            }
        }
        iterate.erase(iterate.begin());
    }
    //Start from the bottom of the tree to be able to react to dependencies
    //Set  width and height
    int currentLevel = model->getMaxLevel();
    while(currentLevel >= 0) {
        std::vector<ModuleInstance*> queue = model->getInstancesAtLevel(currentLevel);
        while (!queue.empty()) {
            ModuleInstance* instance = queue.front();
            //increase width for each port
            unsigned portwidth = spacingport* instance->getStructure()->getPorts().size();
            unsigned childwidth = 0;
            //if it is an instance of a structural module increase width by size + spacing
            //increase height by channels
            if (instance->getStructure()->isStructural()) {
                unsigned maxheight = standardheight;
                for(const auto& subinst: instance->getSubmoduleInstances()) {
                    childwidth += getWidth(subinst.second) + spacingmodule;
                    if (maxheight < getHeight(subinst.second)) {
                        //maxheight = subinst.second->getHeight();
                        maxheight = getHeight(subinst.second);
                    }
                }
                //increase height by channels
                unsigned channelnumber = instance->getChannelMap().size();
                unsigned portmapchannels = instance->getPortMapChannelMap().size();
                increaseHeight(instance, channelnumber * spacingchannel);
                increaseHeight(instance, portmapchannels * spacingchannel);
                increaseHeight(instance, maxheight + spacinghorizontal);
                //increase height by "biggest" submodule
            }
            unsigned width = (childwidth > portwidth) ? childwidth : portwidth;
            increaseWidth(instance, width);
            queue.erase(queue.begin());
        }
        currentLevel--;
    }
    //set Y Positions
    for (int i = 1; i <= model->getMaxLevel(); i++) {
        std::vector<ModuleInstance *> queue = model->getInstancesAtLevel(i);
        while (!queue.empty()) {

            ModuleInstance *instance = queue.front();
            unsigned parentY = getY(instance->getParentInstance());
            unsigned parentChannelLevel = instance->getParentInstance()->getChannelMap().size() * spacingchannel + instance->getParentInstance()->getPortMapChannelMap().size() * spacingchannel;
            //at the beginning set Y positions under the channelheight of the parent
            setY(instance, parentY + parentChannelLevel + 5 * spacingup);
            queue.erase(queue.begin());
        }
    }
    //adapt Y Positions if necessary
    for (int i = 1; i <= model->getMaxLevel(); i++) {
        std::vector<ModuleInstance *> queue = model->getInstancesAtLevel(i);
        while (!queue.empty()) {
            ModuleInstance *instance = queue.front();
            for (auto ports: instance->getStructure()->getPorts()) {
                //See if a port depends on channels outside of the parent instance and lower the position
                if (! ports.second->getMapped()) {
                    auto channel = ports.second->getChannel();

                    auto channelparent = channel->getParentInstance();

                    if (getY(channelparent) + channelparent->getChannelMap().size()*spacingchannel > getY(instance)) {
                        for (auto y: instance->getInstanceSiblings(instance)) {
                            for (const auto& children: y->getSubmoduleInstances()) {
                                setY(instance, getY(children.second));
                                for (auto siblings: instance->getInstanceSiblings(instance)) {
                                    //Bring all siblings exept for the channelparent to the same level
                                    if (siblings->getName() != channelparent->getName()) {
                                        setY(siblings, getY(children.second));
                                    }
                                }
                                break;
                            }
                        }
                    }
                }
            }
            queue.erase(queue.begin());
        }
    }
    svg::Dimensions dimensions(getWidth(topInstance), getHeight(topInstance));
    svg::Document doc("Plugin.svg", svg::Layout(dimensions, svg::Layout::TopLeft));

    std::vector<ModuleInstance *> queue;
    queue.push_back(topInstance);


    doc << svg::Rectangle(svg::Point(0, 0), getWidth(topInstance), getHeight(topInstance), svg::Fill(svg::Color::Silver), svg::Stroke(2, svg::Color(r(0), g(0), b(0))));
    doc << svg::Text(svg::Point(spacingleft, spacingup), topInstance->getName() , svg::Color::Black, svg::Font(fontsize, "Verdana"));

    //if topInstance is not empty it may have ports
    unsigned portx = standardwidth + trianglesize;
    for(const auto& ports: topInstance->getStructure()->getPorts()) {
        doc << svg::Text(svg::Point(portx, spacingup), ports.first , svg::Color::Black, svg::Font(fontsize, "Verdana"));
        portx += spacingport;
    }

    while (!queue.empty()) {
        unsigned x = getX(queue.front()) + spacingmodule;
        for (auto children: queue.front()->getSubmoduleInstances()) {

            ModuleInstance *instance = children.second;
            setX(instance, x);
            x += getWidth(instance) + spacingmodule;

            doc << svg::Rectangle(svg::Point(getX(instance), getY(instance)), getWidth(instance), getHeight(instance), svg::Fill(svg::Color::Silver), svg::Stroke(2, svg::Color(r(instance->getLevel()), g(instance->getLevel()), b(instance->getLevel()))));
            doc << svg::Text(svg::Point(getX(instance) + spacingleft, getY(instance) + spacingup), instance->getName() , svg::Color::Black, svg::Font(fontsize, "Verdana"));
            doc << svg::Text(svg::Point(getX(instance) + spacingleft, getY(instance) + 2*spacingup + fontsize), instance->getStructure()->getName() , svg::Color::Black, svg::Font(fontsize, "Verdana"));


            unsigned portx = getX(instance) + standardwidth;
            unsigned porty = getY(instance) + spacingup;

            for(const auto& ports: instance->getStructure()->getPorts()) {
                doc << svg::Text(svg::Point(portx, porty), ports.first , svg::Color::Black, svg::Font(fontsize, "Verdana"));
                portx += spacingport;
            }

            if (children.second->getStructure()->isStructural()) {
                queue.push_back(children.second);
            }
        }
        queue.erase(queue.begin());
    }






    //iterate over instances and draw channels
    queue.push_back(topInstance);
    while (!queue.empty()) {

        ModuleInstance *instance = queue.front();
        unsigned channelY = getY(instance);
        for(const auto& channels: instance->getChannelMap()) {
            channelY += spacingchannel;
            auto channel = channels.second;
            setY(channel, channelY);
            unsigned toportx;
            unsigned fromportx;
            //check for incomplete channels (if the input file is structural and some channels are connected one level above
            if(channel->getToPort() == nullptr ) {
                fromportx = getFromPortX(channel);
                doc << svg::Line(svg::Point(fromportx , getY(channel) ), svg::Point(getX(channel->getParentInstance())+getWidth(channel->getParentInstance())  , getY(channel)) , svg::Stroke(1, svg::Color::Aqua));
                doc << svg::Line(svg::Point( fromportx , getY(channel->getFromInstance()) ), svg::Point(fromportx , getY(channel)) , svg::Stroke(1, svg::Color::Aqua));
                doc << svg::Text(svg::Point(fromportx, getY(channel)), channel->getName() , svg::Color::Black, svg::Font(fontsize, "Verdana"));
                //Draw triangle to indicate port direction OUT
                doc << (svg::Polygon(svg::Color::Aqua, svg::Stroke(.5, svg::Color::Black))
                        << svg::Point(fromportx, getY(channel->getFromInstance())  - trianglesize)
                        << svg::Point(fromportx + trianglesize, getY(channel->getFromInstance()) )
                        << svg::Point(fromportx - trianglesize, getY(channel->getFromInstance())));

                continue;
            } else if (channel->getFromPort() == nullptr ){
                toportx = getToPortX(channel);
                doc << svg::Line(svg::Point(toportx , getY(channel) ), svg::Point(getX(channel->getParentInstance())+getWidth(channel->getParentInstance())  , getY(channel)) , svg::Stroke(1, svg::Color::Aqua));
                doc << svg::Line(svg::Point( toportx , getY(channel->getToInstance()) ), svg::Point(toportx , getY(channel)) , svg::Stroke(1, svg::Color::Aqua));
                doc << svg::Text(svg::Point(toportx, getY(channel)), channel->getName() , svg::Color::Black, svg::Font(fontsize, "Verdana"));
                //Draw triangle to indicate port direction IN
                doc << (svg::Polygon(svg::Color::Aqua, svg::Stroke(.5, svg::Color::Black))
                        << svg::Point(toportx, getY(channel->getToInstance()))
                        << svg::Point(toportx + trianglesize, getY(channel->getToInstance()) - trianglesize )
                        << svg::Point(toportx - trianglesize, getY(channel->getToInstance()) - trianglesize ));

                continue;
            }
            toportx = getToPortX(channel);
            fromportx = getFromPortX(channel);

            setXStart(channel, toportx);
            setXEnd(channel, fromportx);

            //Draw triangle to indicate port direction IN
            doc << (svg::Polygon(svg::Color::Black, svg::Stroke(.5, svg::Color::Black))
                    << svg::Point(toportx, getY(channel->getToInstance()))
                    << svg::Point(toportx + trianglesize, getY(channel->getToInstance()) - trianglesize )
                    << svg::Point(toportx - trianglesize, getY(channel->getToInstance()) - trianglesize ));

            //Draw triangle to indicate port direction OUT
            doc << (svg::Polygon(svg::Color::Black, svg::Stroke(.5, svg::Color::Black))
                    << svg::Point(fromportx, getY(channel->getFromInstance())  - trianglesize)
                    << svg::Point(fromportx + trianglesize, getY(channel->getFromInstance()) )
                    << svg::Point(fromportx - trianglesize, getY(channel->getFromInstance())));

            doc << svg::Line(svg::Point(getXStart(channel) , getY(channel) ), svg::Point(getXEnd(channel) , getY(channel)) , svg::Stroke(1, svg::Color::Black));

            doc << svg::Line(svg::Point( toportx , getY(channel->getToInstance()) ), svg::Point( toportx , getY(channel)) , svg::Stroke(1, svg::Color::Black));
            doc << svg::Line(svg::Point( fromportx , getY(channel->getFromInstance()) ), svg::Point(fromportx , getY(channel)) , svg::Stroke(1, svg::Color::Black));

            //select smaller value for start and larger value for end
            unsigned start = (toportx < fromportx) ? toportx : fromportx;
            unsigned end = (toportx > fromportx) ? toportx : fromportx;

            for (unsigned i = start; i < end- channel->getName().length()*10; i+= 6*spacingport) {
                doc << svg::Text(svg::Point(i, getY(channel)), channel->getName() , svg::Color::Black, svg::Font(fontsize, "Verdana"));
            }
        }
        //Draw PortMap Channels
        for(const auto& channels: instance->getPortMapChannelMap()) {
            channelY += spacingchannel;
            auto channel = channels.second;
            setY(channel, channelY);

            unsigned toportx = getHigherPortX(channel);
            unsigned fromportx = getLowerPortX(channel);

            setXStart(channel, toportx);
            setXEnd(channel, fromportx);
            if (channel->getLowerPort()->getInterface()->getDirection() == "in") {
                //Draw triangle to indicate port direction IN
                doc << (svg::Polygon(svg::Color::Blue, svg::Stroke(.5, svg::Color::Blue))
                        << svg::Point(toportx, getY(channel->getHigherInstance()) + trianglesize)
                        << svg::Point(toportx + trianglesize, getY(channel->getHigherInstance())  )
                        << svg::Point(toportx - trianglesize, getY(channel->getHigherInstance())  ));

                doc << (svg::Polygon(svg::Color::Blue, svg::Stroke(.5, svg::Color::Blue))
                        << svg::Point(fromportx, getY(channel->getLowerInstance()))
                        << svg::Point(fromportx + trianglesize, getY(channel->getLowerInstance()) - trianglesize )
                        << svg::Point(fromportx - trianglesize, getY(channel->getLowerInstance()) - trianglesize ));
            } else if (channel->getLowerPort()->getInterface()->getDirection() == "out") {
                //Draw triangle to indicate port direction OUT
                doc << (svg::Polygon(svg::Color::Blue, svg::Stroke(.5, svg::Color::Blue))
                        << svg::Point(fromportx, getY(channel->getLowerInstance())  - trianglesize)
                        << svg::Point(fromportx + trianglesize, getY(channel->getLowerInstance()) )
                        << svg::Point(fromportx - trianglesize, getY(channel->getLowerInstance())));

                doc << (svg::Polygon(svg::Color::Blue, svg::Stroke(.5, svg::Color::Blue))
                        << svg::Point(toportx, getY(channel->getHigherInstance())  )
                        << svg::Point(toportx + trianglesize, getY(channel->getHigherInstance()) + trianglesize )
                        << svg::Point(toportx - trianglesize, getY(channel->getHigherInstance()) + trianglesize));
            }

            doc << svg::Line(svg::Point(getXStart(channel) , getY(channel) ), svg::Point(getXEnd(channel) , getY(channel)) , svg::Stroke(1, svg::Color::Blue));

            doc << svg::Line(svg::Point( toportx , getY(channel->getHigherInstance()) ), svg::Point( toportx , getY(channel)) , svg::Stroke(1, svg::Color::Blue));
            doc << svg::Line(svg::Point( fromportx , getY(channel->getLowerInstance()) ), svg::Point(fromportx , getY(channel)) , svg::Stroke(1, svg::Color::Blue));

            //select smaller value for start and larger value for end
            unsigned start = (toportx < fromportx) ? toportx : fromportx;
            unsigned end = (toportx > fromportx) ? toportx : fromportx;

            for (unsigned i = start; i < end- channel->getName().length()*10; i+= 6*spacingport) {
                doc << svg::Text(svg::Point(i, getY(channel)), channel->getName() , svg::Color::Black, svg::Font(fontsize, "Verdana"));
            }
        }


        for (const auto& children: queue.front()->getSubmoduleInstances()) {
            queue.push_back(children.second);
        }

        queue.erase(queue.begin());
    }



    doc.save();
    pluginOutput.insert(std::make_pair("PrintSVG.log", "Output saved to svg file - Plugin.svg"));
    //maybe add useful information to PrintSVG.log
    return pluginOutput;

}

int PrintSVG::r(int level) {
    return _r-40*level;
}
int PrintSVG::g(int level) {
    return _g+40*level;
}
int PrintSVG::b(int level) {
    return _b+15*level;
}

void PrintSVG::increaseWidth(SCAM::ModuleInstance* instance, unsigned width) {
    _widthMap.find(instance)->second += width;
}
void PrintSVG::increaseHeight(SCAM::ModuleInstance* instance, unsigned height) {
    _heightMap.find(instance)->second += height;
}

unsigned PrintSVG::getHeight(SCAM::ModuleInstance* instance) {
    return this->_heightMap.find(instance)->second;
}
unsigned PrintSVG::getWidth(SCAM::ModuleInstance* instance) {
    return this->_widthMap.find(instance)->second;
}
unsigned PrintSVG::getX(SCAM::ModuleInstance* instance) {
    return this->_xMap.find(instance)->second;
}
unsigned PrintSVG::getY(SCAM::ModuleInstance* instance) {
    return this->_yMap.find(instance)->second;
}
unsigned PrintSVG::getY(SCAM::Channel* channel) {
    return this->_ChannelYMap.find(channel)->second;
}
unsigned PrintSVG::getXStart(SCAM::Channel* channel) {
    return this->_xStartMap.find(channel)->second;
}
unsigned PrintSVG::getXEnd(SCAM::Channel* channel) {
    return this->_xEndMap.find(channel)->second;
}

void PrintSVG::setHeight(SCAM::ModuleInstance* instance, unsigned height) {
    if (_heightMap.find(instance) != _heightMap.end()) {
        _heightMap.erase(_heightMap.find(instance));
    }
    _heightMap.insert(std::make_pair(instance, height));
}
void PrintSVG::setWidth(SCAM::ModuleInstance* instance, unsigned width) {
    if (_widthMap.find(instance) != _widthMap.end()) {
        _widthMap.erase(_widthMap.find(instance));
    }
    _widthMap.insert(std::make_pair(instance, width));
}
void PrintSVG::setX(SCAM::ModuleInstance* instance, unsigned x) {
    if (_xMap.find(instance) != _xMap.end()) {
        _xMap.erase(_xMap.find(instance));
    }
    _xMap.insert(std::make_pair(instance, x));

}

void PrintSVG::setY(SCAM::ModuleInstance* instance, unsigned y) {
    if (_yMap.find(instance) != _yMap.end()) {
        _yMap.erase(_yMap.find(instance));
    }
    _yMap.insert(std::make_pair(instance, y));
}
void PrintSVG::setY(SCAM::Channel* channel, unsigned y) {
    if (_ChannelYMap.find(channel) != _ChannelYMap.end()) {
        _ChannelYMap.erase(_ChannelYMap.find(channel));
    }
    _ChannelYMap.insert(std::make_pair(channel, y));
}
void PrintSVG::setXStart(SCAM::Channel* channel, unsigned x) {
    if (_xStartMap.find(channel) != _xStartMap.end()) {
        _xStartMap.erase(_xStartMap.find(channel));
    }
    _xStartMap.insert(std::make_pair(channel, x));
}
void PrintSVG::setXEnd(SCAM::Channel* channel, unsigned x) {
    if (_xEndMap.find(channel) != _xEndMap.end()) {
        _xEndMap.erase(_xEndMap.find(channel));
    }
    _xEndMap.insert(std::make_pair(channel, x));
}

unsigned PrintSVG::getToPortX(SCAM::Channel* channel) {
    unsigned x = getX(channel->getToInstance()) + standardwidth;

    for(const auto& ports: channel->getToInstance()->getStructure()->getPorts()) {
        if (ports.first == channel->getToPort()->getName()) {
            break;
        }
        x += spacingport;
    }
    return x;
}
unsigned PrintSVG::getFromPortX(SCAM::Channel* channel) {
    unsigned x = getX(channel->getFromInstance()) + standardwidth;

    for(const auto& ports: channel->getFromInstance()->getStructure()->getPorts()) {
        if (ports.first == channel->getFromPort()->getName()) {
            break;
        }
        x += spacingport;
    }
    return x;
}

unsigned PrintSVG::getHigherPortX(SCAM::PortMapChannel* channel) {
    unsigned x = getX(channel->getHigherInstance()) + standardwidth;

    for(const auto& ports: channel->getHigherInstance()->getStructure()->getPorts()) {
        if (ports.first == channel->getHigherPort()->getName()) {
            break;
        }
        x += spacingport;
    }
    return x;
}

unsigned PrintSVG::getLowerPortX(SCAM::PortMapChannel* channel) {
    unsigned x = getX(channel->getLowerInstance()) + standardwidth;

    for(const auto& ports: channel->getLowerInstance()->getStructure()->getPorts()) {
        if (ports.first == channel->getLowerPort()->getName()) {
            break;
        }
        x += spacingport;
    }
    return x;
}

void PrintSVG::setY(SCAM::PortMapChannel* channel, unsigned y) {
    if (_ChannelYPortMapMap.find(channel) != _ChannelYPortMapMap.end()) {
        _ChannelYPortMapMap.erase(_ChannelYPortMapMap.find(channel));
    }
    _ChannelYPortMapMap.insert(std::make_pair(channel, y));
}

void PrintSVG::setXStart(SCAM::PortMapChannel* channel, unsigned x) {
    if (_xStartPortMapMap.find(channel) != _xStartPortMapMap.end()) {
        _xStartPortMapMap.erase(_xStartPortMapMap.find(channel));
    }
    _xStartPortMapMap.insert(std::make_pair(channel, x));
}
void PrintSVG::setXEnd(SCAM::PortMapChannel* channel, unsigned x) {
    if (_xEndPortMapMap.find(channel) != _xEndPortMapMap.end()) {
        _xEndPortMapMap.erase(_xEndPortMapMap.find(channel));
    }
    _xEndPortMapMap.insert(std::make_pair(channel, x));
}

unsigned PrintSVG::getY(SCAM::PortMapChannel* channel) {
    return this->_ChannelYPortMapMap.find(channel)->second;
}
unsigned PrintSVG::getXStart(SCAM::PortMapChannel* channel) {
    return this->_xStartPortMapMap.find(channel)->second;
}
unsigned PrintSVG::getXEnd(SCAM::PortMapChannel* channel) {
    return this->_xEndPortMapMap.find(channel)->second;
}