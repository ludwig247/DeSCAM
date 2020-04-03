//
// Created by schmitz on 10.03.20.
//

#include "DotExportInstances.h"
#include <iostream>
#include <fstream>

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
}
