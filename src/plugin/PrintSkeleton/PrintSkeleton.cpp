#include <utility>

//
// Created by tobias on 13.02.17.
//

#include <PrintStmt.h>
#include "PrintSkeleton.h"

std::map<std::string, std::string> PrintSkeleton::printModel(Model *node) {
    pluginOutput.insert(std::make_pair("types.vhdl", Text_types(std::move(node->getName()))));

    for (auto &module: node->getModules()) {
        std::stringstream result;
        try{
            result << header(node->getName()) << entities(module.second) << architecture_synch(module.second);
        } catch (std::runtime_error &err) {
            std::cout << "Problem with module: " << module.first << "\n";
            std::cout << err.what() << std::endl;
        }
        pluginOutput.insert(std::make_pair(module.first + ".vhdl", result.str()));
    }
    return pluginOutput;
}

////////////////
std::string PrintSkeleton::Text_types(std::string Name) {
    std::stringstream typeStream;

    typeStream << "package " + Name << "_types is\n";
    //TestCases
    typeStream << "subtype bool is Boolean;\n";
    typeStream << "subtype int is Integer;\n";
    //Enum
    for (auto type: DataTypes::getDataTypeMap()) {
        std::string typeName = type.second->getName();
        if (type.second->isEnumType()) {
            typeStream << "type " + typeName << " is (";
            for (auto iterator = type.second->getEnumValueMap().begin();
                 iterator != type.second->getEnumValueMap().end(); ++iterator) {
                typeStream << iterator->first;
                if (iterator != --type.second->getEnumValueMap().end()) {
                    typeStream << ",";
                }
            }
            typeStream << ");\n";
        }
    }
    //Composite
    for (auto type: DataTypes::getDataTypeMap()) {
        if (type.second->isCompoundType()) {
            std::string typeName = type.second->getName();
            typeStream << "type " + typeName << " is record\n";
            for (auto sub_var: type.second->getSubVarMap()) {
                typeStream << "\t" + sub_var.first << ": " << sub_var.second->getName() << ";\n";
            }
            typeStream << "end record;\n";
        }
    }
    typeStream << "end package " + Name << "_types;" << std::endl;
    return typeStream.str();
}

std::string PrintSkeleton::header(std::string Name) {
    std::stringstream headerStream;
    headerStream << "library ieee ;\n";
    headerStream << "use ieee.std_logic_1164.all;\n";
    headerStream << "use IEEE.numeric_std.all; \n";
    headerStream << "use work." + Name + "_types.all;\n\n";
    return headerStream.str();
}

std::string PrintSkeleton::entities(Module *node) {
    std::stringstream entityStream;
    entityStream << "entity " + node->getName() + " is\n";
    entityStream << "port(\t\n";
    entityStream << "\tclk:\t\tin std_logic;\n";
    entityStream << "\trst:\t\tin std_logic;\n";


    for (auto port = node->getPorts().begin(); port != node->getPorts().end(); ++port) {
        std::string name = port->first;
        std::string interface = port->second->getInterface()->getName();
        std::string direction = port->second->getInterface()->getDirection();
        std::string type = port->second->getDataType()->getName();
        //Data signal

        entityStream << "\t" + name + ":\t\t" + direction + " " + type;
        if (port != --node->getPorts().end() || interface != "shared") {
            entityStream << ";\n";
        }
        //Synch signals
        if (interface != "shared") {
            entityStream << "\t" + name + "_sync:\t in bool;\n";
            entityStream << "\t" + name + "_notify:\t out bool";
            if (port != --node->getPorts().end()) {
                entityStream << ";\n";
            }
        }
    }

    entityStream << ");\n";
    entityStream << "end " + node->getName() << ";\n\n";
    return entityStream.str();
}

std::string PrintSkeleton::architecture_synch(Module *node) {
    std::stringstream archStream;
    archStream << "architecture " + node->getName() << "_arch of " + node->getName() + " is\n";
    archStream << "signal section: " + node->getName() << "_SECTIONS;\n";
    for (auto variable: node->getVariableMap()) {
        archStream << "\t\t\t signal " + variable.first << "_signal:" << variable.second->getDataType()->getName();
        if (variable.second->getDataType()->getName() == "unsigned" || variable.second->getDataType()->getName() == "signed") {
            archStream << "(31 down to 0)"<< ";\n";
        }
        else {
            archStream << ";\n";
        }
    }
    archStream << "begin\n";
    archStream << "\t process(clk)\n";
    archStream << "\t begin\n";

    archStream << "\t if(clk='1' and clk'event) then\n";
    archStream << "\t\t if rst = '1' then\n";
    archStream << "\t\t\t section <=" + node->getFSM()->getInitialSection() << ";\n";
    for (auto variable: node->getVariableMap()) {
        if (variable.second->getDataType()->isCompoundType()) {
            for (auto subVar: variable.second->getSubVarList()) {
                archStream << "\t\t\t" + variable.first + "_signal." << subVar->getName();
                archStream << "<=";
                archStream << PrintStmt::toString(subVar->getInitialValue());
                archStream << ";\n";
            }
        } else {
            archStream << "\t\t\t" + variable.first + "_signal";
            if (variable.second->getDataType()->getName() == "unsigned" || variable.second->getDataType()->getName() == "signed") {
                archStream << ":= (others => " + PrintStmt::toString(variable.second->getInitialValue()) + ")";
            }
            else {
                archStream << "<=" + PrintStmt::toString(variable.second->getInitialValue());
            }
            archStream << ";\n";
        }


    }
    //Notify signals for ports
    auto opList = node->getFSM()->getStateMap().at(-1)->getOutgoingOperationList();
    assert(opList.size() == 1);
    for (auto port: node->getPorts()) {
        if (port.second->getInterface()->isShared()) continue;
        if (port.second->getInterface()->isMasterIn()) continue;
        if (opList.at(0)->getNextState()->getCommPort() == port.second) {
            archStream << "\t\t\t" + port.first << "_notify <= true;\n";
        } else {
            archStream << "\t\t\t" + port.first << "_notify <= false;\n";
        }
    }

    archStream << "\t\t else\n";
    auto section_list = node->getFSM()->getSectionList();
    for (auto &&section : section_list) {
        archStream << "\t\t if section = " + section + " then\n";
        archStream << "\t\t -- FILL OUT HERE;\n";
        archStream << "\t\t end if;\n";
    }
    archStream << "\t\t end if;\n";
    archStream << "\t end if;\n";
    archStream << "\t end process;\n";
    archStream << "end " + node->getName() << "_arch;\n";
    return archStream.str();
}
