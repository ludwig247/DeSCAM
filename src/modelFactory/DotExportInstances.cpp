//
// Created by schmitz on 10.03.20.
//

#include "DotExportInstances.h"
#include "simple_svg_1.0.0.hpp"
#include <iostream>
#include <fstream>

#define standardheight 50
#define standardwidth 200
#define spacingleftMod 25
#define spacingleft 10
#define spacingup 10
#define spacingport 100
#define spacingmodule 100
#define spacingchannel 20
#define fontsize 10

namespace SCAM {

    void  DotExportInstances::addtoGraph(std::map<std::pair<std::string, std::string>, std::string> instanceMap) {

        for (auto elem : instanceMap) {
            _instanceMap.insert(elem);
        }
    }

    void  DotExportInstances::addChannels(Model* model) {


    }

    void DotExportInstances::printInstanceMap() {
        std::cout << "Instance Map:" << std::endl;
        for (auto elem : _instanceMap) {
            std::cout << "Name: "<<elem.first.first.c_str() << " Module: " << elem.first.second.c_str() << " Parent: "<< elem.second.c_str() << "\n";
        }
        std::cout << "#########" << std::endl;
    }

    void DotExportInstances::exportDot() {
        std::ofstream file;
        file.open ("Instances.dot");
        //Begin Graph
        file << "digraph D {\n";
        file << "top" << "[shape = diamond]" << "\n";
        for (auto elem : _instanceMap) {

            file << elem.first.first.c_str() << "[shape = circle]" << "\n";
        }
        int i = 0;
        for (auto elem_o : _instanceMap) {
            for (auto elem_i : _instanceMap) {
                if (elem_i.second.c_str() == elem_o.first.second) {
                    file << elem_o.first.first.c_str() << "->" << elem_i.first.first.c_str() << "\n";
                } else if (!elem_o.second.compare("top")) {
                    if (i == 0) {
                        file << "top" << "->" << elem_o.first.first.c_str() << "\n";
                        i = 1;
                    }

                }
            }
            i = 0;
        }



        file << "}\n"; //End Graph
        file.close();
    }

    void DotExportInstances::exportMain(Model* model) {
        std::ofstream file;
        file.open ("Main.dot");
        //Begin Graph
        file << "digraph g {\n";
        file << "node [shape = record,height=.1];" << "\n";

        //create nodes
        int i = 0;
        for (auto instance: model->getModuleInstanceMap()) {

            if (!instance.second->getStructure()->isStructural()) {
                _nodedata.push_back(nodedata());
                int j = 1;
                file << "node" << i << "[label = \"<f0>" << instance.first;
                _nodedata.at(i).nodenumber = i;
                _nodedata.at(i).nodename = instance.first;
                for (auto ports: instance.second->getStructure()->getPorts()) {
                    file << "| <f" << j << "> " << ports.first;
                    _nodedata.at(i).subnodemap.insert(std::pair<std::string, int>(ports.first, j));
                    j++;
                }
                file << "\"];" << "\n";
                _nodeMap.insert(std::pair<std::string, int >(instance.first, i));
                i++;
            }

        }
        i = 0;
        int j = 0;

        for (auto instance: model->getModuleInstanceMap()) {
            if (instance.second->getStructure()->isStructural()) {
                file << "subgraph cluster" << j << " {" << "\n";
                file << "label = \""<< instance.first << "\";" << "\n";
                j++;
                for (auto hiermods: instance.second->getStructure()->getInstanceMap()) {
                    if (!model->getModules().find(hiermods.first.second)->second->isStructural()) {
                        int number = 0;
                        for (auto elem: _nodedata) {
                            if (elem.nodename == hiermods.first.first) {
                                number = elem.nodenumber;
                                continue;
                            }
                        }
                        file << "\"node" << number << "\";" << "\n";
                    }
                }
                if (instance.second->getName() != "TopInstance") {
                    std::cout << instance.second->getName();
                    file << "}\n";
                }
            }
        }
        file << "}\n";
        /*while (j > 0) {
            file << "}\n";//End Subgraph
            j--;
        }*/

        //make connections
        for (auto instance: model->getModuleInstanceMap()) {

            for (auto channel: instance.second->getChannelMap()) {
                file << "\"node";
                for (auto elem: _nodedata) {
                    if (channel.second->getFromInstance()->getName() == elem.nodename) {
                        file << elem.nodenumber << "\"";
                        for (auto elem2: elem.subnodemap) {
                            if (elem2.first == channel.second->getFromPort()->getName()) {
                                file << ":f" << elem2.second << " -> ";
                            }
                        }
                    }
                }
                for (const auto& elem: _nodedata) {
                    if (channel.second->getToInstance()->getName() == elem.nodename) {
                        file << "\"node" << elem.nodenumber << "\"";
                        for (const auto& elem2: elem.subnodemap) {
                            if (elem2.first == channel.second->getToPort()->getName()) {
                                file << ":f" << elem2.second;
                            }
                        }
                    }
                }
                file << "[label=\"" << channel.first << "\"];" << "\n";
            }
        }
        file << "}\n"; //End Graph
        file.close();
    }


    void DotExportInstances::exportSVG(SCAM::Model *model) {

        int i = 0;
        int _maxlevel = 0;
        int channellevel = 0;

        for (auto instance: model->getModuleInstanceMap()) {

            ModuleInstance *inst = instance.second;
            int level = 0;

            while (inst->getParentInstance() != nullptr) {
                inst = inst->getParentInstance();
                level++;
            }
            if (_maxlevel < level) _maxlevel = level;

            auto svgmodule = new SVGModuleInstance(instance.second->getName());
            svgmodule->setModuleName(inst->getStructure()->getName());
            svgmodule->setLevel(level);
            svgmodule->setHeight(standardheight);
            svgmodule->setWidth(standardwidth);

            if (instance.second->getParentInstance() != nullptr) {
                svgmodule->setParentName(instance.second->getParentInstance()->getName());
            }

            svgmodule->setStructural(instance.second->getStructure()->isStructural());

            for (auto ports: instance.second->getStructure()->getPorts()) {
                svgmodule->increaseWidth(spacingport);
                auto svgport = new SVGPort(ports.first);
                if (ports.second->getChannel() != nullptr) {
                    svgport->setChannel(ports.second->getChannel()->getName());

                }
                svgmodule->addSVGPort(svgport);
            }
            /*
            channellevel = 0;
            for (auto channels: instance.second->getChannelMap()) {
                auto svgchannel = new SVGChannel(channels.first);
                svgchannel->setChannelParent(channels.second->getParentInstance()->getName());
                channellevel += spacingchannel;
                svgmodule->increaseHeight(spacingchannel);
                svgmodule->addSVGChannel(svgchannel);
                svgmodule->setChannelLevel(channellevel);
                this->_svgchannelMap.insert(std::make_pair(svgchannel->getName(), svgchannel));
            }*/
            i++;
            this->_moduleinstanceMap.insert(std::make_pair(svgmodule->getSVGName(), svgmodule));
        }

        for (auto instance: model->getModuleInstanceMap()) {
            auto svgmodule = _moduleinstanceMap.find(instance.first)->second;



            channellevel = 0;
            for (auto channels: instance.second->getChannelMap()) {
                auto svgchannel = new SVGChannel(channels.first);
                auto channelptr = channels.second;
                auto tosvginst = _moduleinstanceMap.find(channelptr->getToInstance()->getName())->second;
                auto fromsvginst = _moduleinstanceMap.find(channelptr->getFromInstance()->getName())->second;
                svgchannel->setChannelParent(channelptr->getParentInstance()->getName());
                svgchannel->setToSVGInstance(tosvginst);
                svgchannel->setFromSVGInstance(fromsvginst);
                svgchannel->setFromSVGPort(fromsvginst->getSVGPortMap().find(channelptr->getFromPort()->getName())->second);
                svgchannel->setToSVGPort(tosvginst->getSVGPortMap().find(channelptr->getToPort()->getName())->second);
                channellevel += spacingchannel;
                svgmodule->increaseHeight(spacingchannel);
                svgmodule->addSVGChannel(svgchannel);
                svgmodule->setChannelLevel(channellevel);
                std::cout << "Channel: " << svgchannel->getName() << " from: " << fromsvginst->getSVGName() << " to: " << tosvginst->getSVGName() << std::endl;
                this->_svgchannelMap.insert(std::make_pair(svgchannel->getName(), svgchannel));
            }

        }




        for (auto instance: _moduleinstanceMap) {
            //add children to parentmodule
            if(instance.second->getLevel()) {
                _moduleinstanceMap.find(instance.second->getParentName())->second->addSVGModuleInstance(instance.second);
            }
        }
        //set Y Positions
        for (int i = 1; i <= _maxlevel; i++) {
            for (auto instance: _moduleinstanceMap) {
                if (i == instance.second->getLevel()) {
                    instance.second->setY(_moduleinstanceMap.find(instance.second->getParentName())->second->getChannelLevel() + 5*spacingup);
                }
            }
        }

        //Adapt Y Positions
        for (auto instance: _moduleinstanceMap) {
            //See if a port depends on channels outside of the parent instance and lower the position
            for(auto ports: instance.second->getSVGPortMap()) {
                auto dependendcychannel = _svgchannelMap.find(ports.second->getChannel())->second;
                auto dependency = _moduleinstanceMap.find(dependendcychannel->getChannelParent())->second;
                if (dependency->getChannelLevel() > instance.second->getY()) {
                    //&& dependendcychannel->getChannelParent() != instance.second->getParentName()
                    instance.second->setY(dependency->getChannelLevel() + 5*spacingup);
                }
            }

        }

        int maxlevel = _maxlevel;
        while (maxlevel >= 0) {
            //Adapt Height
            for (auto instance: _moduleinstanceMap) {
                if (instance.second->getLevel() == maxlevel ) {
                    for (auto child: instance.second->getSVGModuleInstances()) {
                        if (child.second->getY() + child.second->getHeight() >=
                            instance.second->getY() + instance.second->getHeight()) {
                            instance.second->setHeight(
                                    child.second->getY() + child.second->getHeight() + standardheight + spacingup);
                        }
                    }
                }
            }
            maxlevel--;
        }


        maxlevel = _maxlevel;
        while (maxlevel > 0) {
            for (const auto& mod: _moduleinstanceMap) {
                if (mod.second->getLevel() == maxlevel ) {
                    //increase with so that children can fit
                    _moduleinstanceMap.find(mod.second->getParentName())->second->increaseWidth(mod.second->getWidth());

                }

            }
            maxlevel--;
        }


        _width = _moduleinstanceMap.find("TopInstance")->second->getWidth();
        _height = _moduleinstanceMap.find("TopInstance")->second->getHeight();
        svg::Dimensions dimensions(_width, _height);
        svg::Document doc("my_svg.svg", svg::Layout(dimensions, svg::Layout::TopLeft));

        int level = 0;

        int level0x = 0;
        int level1x = 0;
        int level2x = 0;

        while(level <= _maxlevel) {

            for (const auto& mod: _moduleinstanceMap) {

                if (level == mod.second->getLevel()) {
                    if (mod.second->getLevel() == 0) {
                        doc << svg::Rectangle(svg::Point(0, mod.second->getY()), mod.second->getWidth(), mod.second->getHeight(), svg::Fill(svg::Color::Silver), svg::Stroke(1, svg::Color(200, 250, 150)));
                        doc << svg::Text(svg::Point(level0x + spacingleft, mod.second->getY() + spacingup), mod.second->getSVGName() , svg::Color::Black, svg::Font(fontsize, "Verdana"));
                        printChannels(&doc, mod.second->getSVGChannelMap() , level0x , mod.second->getY());
                    } else if (mod.second->getLevel() == 1) {
                        level1x += spacingleftMod;
                        doc << svg::Rectangle(svg::Point(level1x, mod.second->getY()), mod.second->getWidth(),  mod.second->getHeight(),
                                              svg::Color::White , svg::Stroke(1, svg::Color::Green));
                        doc << svg::Text(svg::Point(level1x + spacingleft, mod.second->getY() + spacingup), mod.second->getSVGName() , svg::Color::Black, svg::Font(fontsize, "Verdana"));

                        printPorts(&doc, mod.second->getSVGPortMap() , level1x , mod.second->getY());
                        printChannels(&doc, mod.second->getSVGChannelMap() , level1x , mod.second->getY());

                        if (mod.second->getStructural()) {
                            int childx = level1x;
                            for (const auto struc: mod.second->getSVGModuleInstances()) {

                                 childx += spacingleftMod;
                                doc << svg::Rectangle(svg::Point(childx, struc.second->getY()), struc.second->getWidth(), struc.second->getHeight(),
                                                      svg::Color::White, svg::Stroke(1, svg::Color::Purple));
                                doc << svg::Text(svg::Point(childx + spacingleft, struc.second->getY() + spacingup ), struc.second->getSVGName() , svg::Color::Black, svg::Font(fontsize, "Verdana"));
                                printPorts(&doc, struc.second->getSVGPortMap() , childx, struc.second->getY());
                                childx += struc.second->getWidth();
                            }
                        }
                        //printPortConnections(&doc, mod.second->getSVGPortMap());
                        level1x += mod.second->getWidth();
                    } else if (mod.second->getLevel() == 2) {
                        /*level2x += spacingleftMod;
                        doc << svg::Rectangle(svg::Point(level2x, mod.second->getY()), mod.second->getWidth(), mod.second->getHeight(),
                                              svg::Color::White, svg::Stroke(1, svg::Color::Purple));
                        doc << svg::Text(svg::Point(level2x + spacingleft, mod.second->getY() + spacingup ), mod.second->getSVGName() , svg::Color::Black, svg::Font(fontsize, "Verdana"));

                        printPorts(&doc, mod.second->getSVGPortMap() , level2x, mod.second->getY());

                        //printPortConnections(&doc, mod.second->getSVGPortMap());
                        level2x += mod.second->getWidth();*/
                    }
                }
            }
            level++;

        }

        printPortConnections(&doc);
        //doc << svg::Line(svg::Point(300 , 400 ), svg::Point(400, 400 ) , svg::Stroke(1, svg::Color::Black));

        printLongerChannels(&doc);

        doc.save();

    }



    void DotExportInstances::printPorts(svg::Document* doc, std::map<std::string, SCAM::SVGPort *> portmap , int x, int y) {
        int portx = x + spacingleft + spacingport;
        for (auto ports: portmap) {
            *doc << svg::Text(svg::Point(portx, y + spacingup ), ports.first , svg::Color::Black, svg::Font(fontsize, "Verdana"));
            ports.second->setx(portx);
            ports.second->sety(y);
            portx += spacingport;
        }
    }

    void DotExportInstances::printChannels(svg::Document* doc, std::map<std::string, SCAM::SVGChannel *> channelmap , int x, int y) {
        int channelx = x + spacingleft + spacingport/2;
        int channely = y + 2*spacingup;
        for (auto channels: channelmap) {
            //*doc << svg::Text(svg::Point(channelx, channely ), channels.first , svg::Color::Black, svg::Font(fontsize, "Verdana"));
           // *doc << svg::Line(svg::Point(channelx + spacingport , channely - fontsize/2 ), svg::Point(channelx + 1000, channely - fontsize/2) , svg::Stroke(1, svg::Color::Black));
            channels.second->sety(channely -fontsize/2);
            channels.second->setxStart(channelx + spacingport);
            channels.second->setxEnd(channelx + spacingport);
            channely += spacingchannel;
        }
    }

    void DotExportInstances::printPortConnections(svg::Document* doc) {

        for (auto channels: _svgchannelMap) {
            auto channelptr = channels.second;
            auto toport = channelptr->getToSVGPort();
            auto fromport = channelptr->getFromSVGPort();

            if (fromport->getx() > toport->getx()) {
                channelptr->setxStart(toport->getx());
                channelptr->setxEnd(fromport->getx());
            } else {
                channelptr->setxStart(fromport->getx());
                channelptr->setxEnd(toport->getx());
            }


            *doc << svg::Circle(svg::Point(toport->getx() , toport->gety()), 5, svg::Fill(svg::Color::Black));
            //*doc << svg::Circle(svg::Point(toport->getx() , channelptr->gety()), 5, svg::Fill(svg::Color::Black));
            *doc << svg::Line(svg::Point(toport->getx() ,  toport->gety() ), svg::Point(toport->getx() , channelptr->gety()) , svg::Stroke(1, svg::Color::Black));

            *doc << svg::Circle(svg::Point(fromport->getx() , fromport->gety()), 5, svg::Fill(svg::Color::Black));
           //*doc << svg::Circle(svg::Point(fromport->getx() , channelptr->gety()), 5, svg::Fill(svg::Color::Black));
            *doc << svg::Line(svg::Point(fromport->getx() ,  fromport->gety() ), svg::Point(fromport->getx() , channelptr->gety()) , svg::Stroke(1, svg::Color::Black));
        }
    }

    void DotExportInstances::printLongerChannels(svg::Document* doc) {

        for (auto channels: _svgchannelMap) {
            for (int i = channels.second->getxStart(); i < channels.second->getxEnd() - channels.second->getName().length()*fontsize*2; i += 250) {
                *doc << svg::Text(svg::Point( i + 250 , channels.second->gety() ), channels.first , svg::Color::Black, svg::Font(fontsize, "Verdana"));

            }
            //*doc << svg::Line(svg::Point(channels.second->getxStart() , channels.second->gety() ), svg::Point(channels.second->getxEnd()/2 -channels.first.length() , channels.second->gety() ) , svg::Stroke(1, svg::Color::Black));

            *doc << svg::Line(svg::Point(channels.second->getxStart() , channels.second->gety() ), svg::Point(channels.second->getxEnd() , channels.second->gety() ) , svg::Stroke(1, svg::Color::Black));

            //*doc << svg::Line(svg::Point(channels.second->getxEnd()/2 + channels.first.length() , channels.second->gety() ), svg::Point(channels.second->getxEnd() , channels.second->gety() ) , svg::Stroke(1, svg::Color::Black));


        }
    }



}
