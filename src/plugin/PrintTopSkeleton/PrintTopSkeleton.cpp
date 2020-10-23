
//
// Created by Silvio on 13.08.20.
//
#include <utility>
#include <PrintStmt.h>
#include <math.h>
#include <ModelGlobal.h>
#include "PrintTopSkeleton.h"

std::map<std::string, std::string> PrintTopSkeleton::printModel(Model *node) {
    setLanguage();
    globalPackageName = node->getName();
    for (auto &module: node->getModules()) {
        this->module = module.second;
        localPackageName = module.first;

        std::stringstream result;
        try {
            result << generateTopS2QEDHDLSkeleton();
        } catch (std::runtime_error &err) {
            std::cout << "Problem with module: " << module.first << "\n";
            std::cout << err.what() << std::endl;
        }
        pluginOutput.insert(std::make_pair(module.first + "_top" + getFilenameExtention(), result.str()));
    }
    return pluginOutput;
}

std::pair<std::string, std::string> PrintTopSkeleton::printModule(SCAM::Module *module) {
    setLanguage();

    globalPackageName = ModelGlobal::getModel()->getName();

    this->module = module;
    localPackageName = module->getName();

    std::stringstream result;
    try {
        result << generateTopS2QEDHDLSkeleton();
    } catch (std::runtime_error &err) {
        std::cout << "Problem with module: " << module->getName() << "\n";
        std::cout << err.what() << std::endl;
    }
    return std::make_pair(module->getName() + getFilenameExtention(), result.str());
}

////////////////
void PrintTopSkeleton::setLanguage() {
    if (getOptionMap()["vhdl"]) {
        language = VHDL;
        comment = "-- ";
    } else if (getOptionMap()["sv"]) {
        language = SV;
        comment = "// ";
    } else if (getOptionMap()["sv"] && getOptionMap()["vhdl"]) {
        std::cout << "More than one language chosen. Default (VHDL) selected." << std::endl;
        language = VHDL;
        comment = "-- ";
    } else {
        language = VHDL;
        comment = "-- ";
    }
}

std::string PrintTopSkeleton::generateTopS2QEDHDLSkeleton() {

    if (this->module->getName() == "TestBasic16") {
        std::cout << "TestBasic16" << std::endl;
    }

    std::stringstream skeletonStream;

    header(skeletonStream);

    //  insert clk and rst and input ports for each instance
    ports(skeletonStream);

    //  insert signals for inputs and outputs for each instance
    signals(skeletonStream);

    //  insert input assignments
    assignments(skeletonStream);

    //  insert modules of both instances
    instances(skeletonStream);

    footer(skeletonStream);

    return skeletonStream.str();

}

void PrintTopSkeleton::header(std::stringstream &ss) {
    if (language == VHDL) {
        ss << "library ieee;\n";
        ss << "use ieee.std_logic_1164.all;\n";
        ss << "use IEEE.numeric_std.all; \n";
    }
    if (!globalPackageName.empty()) {
        insertImport(ss, globalPackageName + "_types");
    }
    insertImport(ss, localPackageName + "_types");
    ss << "\n";
}

void PrintTopSkeleton::ports(std::stringstream &ss) {
    std::string syncNotifyType;
    std::string clockResetType;
    std::string endLine;

    if (language == VHDL) {
        syncNotifyType = "bool";
        clockResetType = "std_logic";
        endLine = ";";
    } else if (language == SV) {
        syncNotifyType = "logic";
        clockResetType = "logic";
        endLine = ",";
    }

    if (language == VHDL) {
        ss << "entity " + module->getName() + "_top is\n";
        ss << "port(\t\n";
    } else if (language == SV) {
        ss << "module " + module->getName() + "_top (\n";
    }

    insertPortVariable(ss, "clk", getDirectionWrapper("in"), clockResetType, 0, false);
    insertPortVariable(ss, "rst", getDirectionWrapper("in"), clockResetType, 0, false);

    //insert ports only for input signals
    for (int inst = 1; inst <= 2; inst++){
        for (auto port = module->getPorts().begin(); port != module->getPorts().end(); ++port) {
            std::string name = port->first;
            auto interface = port->second->getInterface();
            std::string type = getDataTypeWrapper(port->second->getDataType());
            std::string direction = getDirectionWrapper(interface->getDirection());

            if (direction == "input" || direction == "in"){
                if (port != module->getPorts().begin() || inst > 1){
                    ss << endLine + "\n";
                }
                insertPortVariable(ss, name, direction, type, inst, true);
            }
            //Synch signals
            if (interface->isBlocking()) {
                if (port != module->getPorts().begin() || inst > 1){
                    ss << endLine + "\n";
                }
                insertPortVariable(ss, name + "_sync", getDirectionWrapper("in"), syncNotifyType, inst, true);
            } else if (interface->isSlaveIn()) {
                if (port != module->getPorts().begin() || inst > 1){
                    ss << endLine + "\n";
                }
                insertPortVariable(ss, name + "_sync", getDirectionWrapper("in"), syncNotifyType, inst, true);
            }
        }
    }
    if (language == VHDL) {
        ss << "\n);\n";
        ss << "end " + module->getName() << "_top;\n\n";
    } else if (language == SV) {
        ss << "\n\t);\n\n";
    }
}

void PrintTopSkeleton::signals(std::stringstream &ss) {
    std::string syncNotifyType;
    if (language == VHDL) {
        syncNotifyType = "bool";
        ss << "architecture " + module->getName() << "_top_arch of " + module->getName() + "_top is\n";
    } else if (language == SV) {
        syncNotifyType = "logic";
    }

    //insert port signal for all inputs and outputs
    for (int inst = 1; inst <= 2; inst++){
        ss << "\n\t" + comment + "Port signals for instance " + std::to_string(inst) + "\n";
        for (auto port = module->getPorts().begin(); port != module->getPorts().end(); ++port) {
            std::string name = port->first;
            auto interface = port->second->getInterface();
            std::string type = getDataTypeWrapper(port->second->getDataType());
            std::string direction = getDirectionWrapper(interface->getDirection());

            insertPortSignal(ss, name, type, inst);

            //Synch signals
            if (interface->isBlocking()) {
                insertPortSignal(ss, name + "_sync", syncNotifyType, inst);
                insertPortSignal(ss, name + "_notify", syncNotifyType, inst);
            } else if (interface->isSlaveIn()) {
                insertPortSignal(ss, name + "_sync", syncNotifyType, inst);
            } else if (interface->isMasterOut()) {
                insertPortSignal(ss, name + "_notify", syncNotifyType, inst);
            }
        }
    }

    //insert components
    if(language == VHDL){
        ss << "\n\tCOMPONENT " + module->getName() + " PORT (\n";
        for (auto port = module->getPorts().begin(); port != module->getPorts().end(); ++port) {
            std::string name = port->first;
            auto interface = port->second->getInterface();
            std::string type = getDataTypeWrapper(port->second->getDataType());
            std::string direction = getDirectionWrapper(interface->getDirection());

            //Data signal
            bool last = (port == --module->getPorts().end());
            ss << "\t";
            insertPortVariable(ss, name, direction, type, 0,
                               last && (interface->isShared() || interface->isSlaveOut() || interface->isMasterIn()));

            //Synch signals
            if (interface->isBlocking()) {
                ss << "\t";
                insertPortVariable(ss, name + "_sync", getDirectionWrapper("in"), syncNotifyType, 0, false);
                ss << "\t";
                insertPortVariable(ss, name + "_notify", getDirectionWrapper("out"), syncNotifyType, 0,  last);
            } else if (interface->isSlaveIn()) {
                ss << "\t";
                (ss, name + "_sync", getDirectionWrapper("in"), syncNotifyType, 0,  last);
            } else if (interface->isMasterOut()) {
                ss << "\t";
                insertPortVariable(ss, name + "_notify", getDirectionWrapper("out"), syncNotifyType, 0,  last);
            }
        }

        ss << "\n\t); END COMPONENT;\n";
    }

}

void PrintTopSkeleton::assignments(std::stringstream &ss) {
    if (language == VHDL) {
        ss << "\nbegin\n";
    }
    ss << "\n\t" + comment + "Input signals assignments\n";
    for (int inst = 1; inst <= 2; inst++){
        ss << "\t" + comment + "Assignment fot instance_" + std::to_string(inst) + "\n";
        for (auto port = module->getPorts().begin(); port != module->getPorts().end(); ++port) {
            std::string name = port->first;
            auto interface = port->second->getInterface();
            std::string type = getDataTypeWrapper(port->second->getDataType());
            std::string direction = getDirectionWrapper(interface->getDirection());

            if (direction == "input" || direction == "in"){
                insertAssignment(ss, name, inst);
            }
            //Synch signals
            if (interface->isBlocking()) {
                insertAssignment(ss, name + "_sync", inst);
            } else if (interface->isSlaveIn()) {
                insertAssignment(ss, name + "_sync", inst);
            }
        }
    }
}

void PrintTopSkeleton::instances(std::stringstream &ss) {
    for (int inst = 1; inst <= 2; inst++){
        ss << "\n\t" + comment + "Instance " + std::to_string(inst) + "\n";
        if (language == VHDL) {
            ss << "\t" + module->getName() + "_inst_" + std::to_string(inst) + " : " +
                module->getName() + " PORT MAP(\n";
        } else if (language == SV) {
            ss << "\t" + module->getName() + " " + module->getName() + "_inst_" + std::to_string(inst) + " (\n";
        }

        for (auto port = module->getPorts().begin(); port != module->getPorts().end(); ++port) {
            std::string name = port->first;
            auto interface = port->second->getInterface();
            std::string type = getDataTypeWrapper(port->second->getDataType());
            std::string direction = getDirectionWrapper(interface->getDirection());

            bool last = (port == --module->getPorts().end());
            insertPortAssociation(ss, name, inst,
                                  last && (interface->isShared() || interface->isSlaveOut() || interface->isMasterIn()));

            //Synch signals
            if (interface->isBlocking()) {
                insertPortAssociation(ss, name + "_sync", inst, false);
                insertPortAssociation(ss, name + "_notify", inst, last);
            } else if (interface->isSlaveIn()) {
                insertPortAssociation(ss, name + "_sync", inst, last);
            } else if (interface->isMasterOut()) {
                insertPortAssociation(ss, name + "_notify", inst, last);
            }
        }
        ss << "\t);\n";
    }
}

void PrintTopSkeleton::footer(std::stringstream &ss) {
    if (language == VHDL) {
        ss << "end " + module->getName() << "_top_arch;";
    } else if (language == SV) {
        ss << "endmodule";
    }
}

void PrintTopSkeleton::insertImport(std::stringstream &ss, const std::string &name) {
    if (language == VHDL) {
        ss << "use work." + name + ".all;\n";
    } else if (language == SV) {
        ss << "import " + convertToLower(name) + "::*;\n";
    }
}

void PrintTopSkeleton::insertPortVariable(std::stringstream &ss,
                                       const std::string &name,
                                       const std::string &direction,
                                       const std::string &type,
                                       const int &instance,
                                       bool last) {
    std::string s_inst;

    ss << "\t";

    if (instance == 0){
        s_inst = "";
    } else {
        s_inst = "_i" + std::to_string(instance);
    }

    if (language == VHDL) {
        ss << name + s_inst + ":\t\t" + direction + " " + type;
        if (!last) {
            ss << ";";
            ss << "\n";
        }
    } else if (language == SV) {
        ss << direction + " " + type + " " + name + s_inst;
        if (!last) {
            ss << ",";
            ss << "\n";
        }
    }
}

void PrintTopSkeleton::insertPortSignal(std::stringstream &ss, const std::string &name, const std::string &type, const int instance) {

    std::string inst = "_s" + std::to_string(instance);
    if (language == VHDL) {
        ss << "\tsignal " + name + inst + ": " + type + ";\n";
    } else if (language == SV) {
        ss << "\t" + type + " " + name + inst + ";\n";
    }
}

void PrintTopSkeleton::insertAssignment(std::stringstream &ss, const std::string &name, const int instance) {

    std::string sig = "_s" + std::to_string(instance);
    std::string in = "_i" + std::to_string(instance);
    if (language == VHDL) {
        ss << "\t" + name + sig + " <= " + name + in + ";\n";
    } else if (language == SV) {
        ss << "\tassign " + name + sig + " = " + name + in + ";\n";
    }
}

void PrintTopSkeleton::insertPortAssociation(std::stringstream &ss, const std::string &name, const int &instance, bool last) {
    std::string s_inst = "_s" + std::to_string(instance);

    ss << "\t\t";

    if (language == VHDL) {
        ss << name + " => " + name + s_inst;
    } else if (language == SV) {
        ss << "." + name + " ( " + name + s_inst + " )";
    }
    if (!last) {
        ss << ",";
    }
    ss << "\n";
}

std::string PrintTopSkeleton::getFilenameExtention() {
    switch (language) {
        case VHDL:
            return ".vhdl";
        case SV:
            return ".sv";
    }
}

std::string PrintTopSkeleton::getDirectionWrapper(const std::string &in) {
    if (language == SV) {
        if (in == "in") return "input";
        return "output";
    } else if (language == VHDL) {
        return in;
    }
}

std::string PrintTopSkeleton::getDataTypeWrapper(const SCAM::DataType *dataType) {
    if (language == SV) {
        if (dataType->isInteger()) {
            return "integer";
        } else if (dataType->isUnsigned()) {
            return "bit[31:0]";
        } else if (dataType->getName() == "bool") {
            return "bit";
        } else {
            return dataType->getName();
        }
    } else {
        if (dataType->isInteger()) {
            //if (variable.second->getDataType()->getName() == "unsigned" || variable.second->getDataType()->getName() == "signed") {
            //return "signed (31 downto 0)";
            return "signed(31 downto 0)";
        } else if (dataType->isUnsigned()) {
            return "unsigned (31 downto 0)";
        }
        return dataType->getName();
    }
}

std::string PrintTopSkeleton::convertToLower(const std::string &in_string) {
    std::locale loc; // for return type to be in lowercase
    std::stringstream ret;
    for (char i : in_string)
        ret << std::tolower(i, loc);
    return ret.str();
}



