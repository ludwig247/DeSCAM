#include <utility>

//
// Created by aashildl on 03.04.19.
//

#include <PrintStmt.h>
#include <math.h>
#include "PrintSkeletonSV.h"

std::map<std::string, std::string> PrintSkeletonSV::printModel(Model *node) {
    pluginOutput.insert(std::make_pair("types.sv", Text_types(std::move(node->getName()))));

    for (auto &module: node->getModules()) {
        std::stringstream result;
        try{
            result << header(node->getName()) << entities(module.second) << architecture_synch(module.second);
        } catch (std::runtime_error &err) {
            std::cout << "Problem with module: " << module.first << "\n";
            std::cout << err.what() << std::endl;
        }
        pluginOutput.insert(std::make_pair(module.first + ".sv", result.str()));
    }
    return pluginOutput;
}

////////////////
//
// Creates a systemVerilog Package for types defined in ESL design
//
////////////////
std::string PrintSkeletonSV::Text_types(std::string Name) {
    std::stringstream typeStream;

    typeStream << "package " + convert_to_lower(Name) << "_types;\n\n";
    //TestCases
    //typeStream << "subtype bool is Boolean;\n";
    //typeStream << "subtype int is signed(31 downto 0);\n";
    typeStream << "\ttypedef enum logic {\n\t\tfalse = 1'b0,\n\t\ttrue = 1'b1\n\t} bool;\n\n";
    //Enum
    for (auto type: DataTypes::getDataTypeMap()) {
        std::string typeName = type.second->getName();
        if (type.second->isEnumType()) {
            typeStream << "\ttypedef enum logic ";
            // SystemVerilog enum default type is integer, find a more suitable size
            int enumSize = get_log_2(type.second->getEnumValueMap().size());
            if (enumSize > 0) {
                typeStream << "[" << enumSize << ":0] ";
            }
            typeStream << "{\n";
            for (auto iterator = type.second->getEnumValueMap().begin();
                 iterator != type.second->getEnumValueMap().end(); ++iterator) {
                typeStream << "\t\t" + convert_to_lower(iterator->first);
                if (iterator != --type.second->getEnumValueMap().end()) {
                    typeStream << ",\n";
                } else { typeStream << "\n";}
            }
            typeStream << "\t} " + typeName << ";\n\n";
        }
    }
    //Composite (after all enum definitions are done
    for (auto type: DataTypes::getDataTypeMap()) {
        std::string typeName = type.second->getName();
        if (type.second->isCompoundType()) {
            typeStream << "\ttypedef struct {\n";
            for (auto sub_var: type.second->getSubVarMap()) {
                typeStream << "\t\t" << sub_var.second->getName() << " " << convert_to_lower(sub_var.first) << ";\n";
            }
            typeStream << "\t} " << typeName << ";\n\n";
        }
        else if((type.second->isArrayType())){
            typeStream << "\t" type.second->getArrayType()->getName() << " [" << type.second->getArraySize()-1;
            typeStream << ":0] " + typeName << ";\n";
        }
    }
    typeStream << "endpackage" << std::endl;
    return typeStream.str();
}

std::string PrintSkeletonSV::header(std::string Name) {
    std::stringstream headerStream;
    headerStream << "library ieee ;\n";
    headerStream << "use ieee.std_logic_1164.all;\n";
    headerStream << "use IEEE.numeric_std.all; \n";
    headerStream << "use work." + Name + "_types.all;\n\n";
    return headerStream.str();
}

std::string PrintSkeletonSV::entities(Module *node) {
    std::stringstream entityStream;
    entityStream << "entity " + node->getName() + " is\n";
    entityStream << "port(\t\n";
    entityStream << "\tclk:\t\tin std_logic;\n";
    entityStream << "\trst:\t\tin std_logic;\n";


    for (auto port = node->getPorts().begin(); port != node->getPorts().end(); ++port) {
        std::string name = port->first;
        auto interface = port->second->getInterface();
        //std::string direction = port->second->getInterface()->getDirection();
        std::string type = port->second->getDataType()->getName();
        //Data signal

        entityStream << "\t" << name << ":\t\t" << interface->getDirection() << " "  << type;
        if (port != --node->getPorts().end() || !interface->isShared()) {
            entityStream << ";\n";
        }
        //Synch signals
        if (interface->isBlocking()) {
            entityStream << "\t" + name + "_sync:\t in bool;\n";
            entityStream << "\t" + name + "_notify:\t out bool";
            if (port != --node->getPorts().end()) {
                entityStream << ";\n";
            }
        }
        else if (interface->isSlaveIn() ) {
            entityStream << "\t" + name + "_sync:\t in bool\n";
            if (port != --node->getPorts().end()) {
                entityStream << ";\n";
            }
        }else if (interface->isMasterOut()) {
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

std::string PrintSkeletonSV::architecture_synch(Module *node) {
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
        }else if(variable.second->isArrayType()){
            if(variable.second->getDataType()->getArrayType()->isInteger()){
                archStream << "\t\t\t" + variable.first + "_signal<=(";
                for(int i=0;i<variable.second->getSubVarList().size();i++){
                        archStream << "to_signed(0,32)";
                        if(i != variable.second->getSubVarList().size()-1) archStream << ",";
                }
                archStream << ");\n";
            }else throw std::runtime_error("not implemented");
        }else {
            archStream << "\t\t\t" + variable.first + "_signal";
            if (variable.second->getDataType()->getName() == "unsigned" || variable.second->getDataType()->getName() == "signed"){
                archStream << ":= (others => " + PrintStmt::toString(variable.second->getInitialValue()) + ")";
            }else if( variable.second->getDataType()->getName() == "int"){
                archStream << "<= to_signed(" <<  PrintStmt::toString(variable.second->getInitialValue()) << ",32)";
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

std::string PrintSkeletonSV::convert_to_lower(std::string in_string) {
    std::locale loc; // for return type to be in lowercase
    std::stringstream ret;
    for (char i : in_string)
        ret << std::tolower(i,loc);
    return ret.str();
}

int PrintSkeletonSV::get_log_2(int arraySize) {
    if (arraySize > 2) {
        //double log2result = log2(arraySize);
        return (int) ceil(log2(arraySize)-1.0);
    }
    return 0;
}
