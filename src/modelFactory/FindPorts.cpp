#include <clang/AST/PrettyPrinter.h>
#include <GlobalUtilities.h>
#include "FindPorts.h"
#include "FindNewDatatype.h"
#include "FatalError.h"
#include "Logger/Logger.h"
#include "clangCastVisitor.h"

namespace DESCAM {

//Constructor
FindPorts::FindPorts(IFindNewDatatype *find_new_datatype) :
    record_decl_(nullptr),
    find_new_datatype_(find_new_datatype) {
  assert(find_new_datatype);
}

bool FindPorts::setup(clang::CXXRecordDecl *record_decl, clang::CompilerInstance *ci, Module *module) {
  assert(record_decl);
  assert(ci);
  assert(module);
  if (record_decl == record_decl_) {
    return true;
  } else {
    record_decl_ = record_decl;
    port_map.clear();

    bool success = true;
    GetClangPorts get_clang_ports(success, find_new_datatype_, ci, record_decl);
    if (!success)return success;

    auto portsLocationMap = get_clang_ports.getLocationInfoMap();
    //Add Ports -> requires Name, Interface and DataType
    //Rendezvous
    //Input ports
    for (auto &port: get_clang_ports.getInPortMap()) {
      Interface *interface = nullptr;
      DESCAM_ASSERT(interface = new Interface("blocking", "in"))
      if (DataTypes::isLocalDataType(port.second, module->getName())) {
        TERMINATE(
            "No local datatypes for ports allowed!\n Port: " + port.first + "\nType: " + port.second);
      }
      Port *inPort = nullptr;
      DESCAM_ASSERT (if (portsLocationMap.find(port.first) != portsLocationMap.end())
                       inPort = new Port(port.first, interface,
                                         DataTypes::getDataType(
                                             port.second),
                                         portsLocationMap[port.first]);
                     else inPort = new Port(port.first, interface, DataTypes::getDataType(port.second));
                         port_map.insert(std::make_pair(port.first, inPort)))
    }
    //Output ports
    for (auto &port: get_clang_ports.getOutPortMap()) {
      Interface *interface = nullptr;
      DESCAM_ASSERT(interface = new Interface("blocking", "out"))
      if (DataTypes::isLocalDataType(port.second, module->getName())) {
        TERMINATE(
            "No local datatypes for ports allowed!\n Port: " + port.first + "\nType: " + port.second);
      }
      Port *outPort = nullptr;
      DESCAM_ASSERT(if (portsLocationMap.find(port.first) != portsLocationMap.end())
                      outPort = new Port(port.first, interface,
                                         DataTypes::getDataType(
                                             port.second),
                                         portsLocationMap[port.first]);
                    else outPort = new Port(port.first, interface, DataTypes::getDataType(port.second));
                        port_map.insert(std::make_pair(port.first, outPort)))
    }

    //AlwaysReady
    //Input ports
    for (auto &port: get_clang_ports.getMasterInPortMap()) {
      Interface *interface = nullptr;
      DESCAM_ASSERT(interface = new Interface("master", "in"))
      if (DataTypes::isLocalDataType(port.second, module->getName())) {
        TERMINATE(
            "No local datatypes for ports allowed!\n Port: " + port.first + "\nType: " + port.second);
      }
      Port *inPort = nullptr;
      DESCAM_ASSERT(if (portsLocationMap.find(port.first) != portsLocationMap.end())
                      inPort = new Port(port.first, interface,
                                        DataTypes::getDataType(
                                            port.second),
                                        portsLocationMap[port.first]);
                    else inPort = new Port(port.first, interface, DataTypes::getDataType(port.second));
                        port_map.insert(std::make_pair(port.first, inPort)))

    }
    //Output ports
    for (auto &port: get_clang_ports.getMasterOutPortMap()) {
      Interface *interface = nullptr;
      DESCAM_ASSERT(interface = new Interface("master", "out"))
      if (DataTypes::isLocalDataType(port.second, module->getName())) {
        TERMINATE(
            "No local datatypes for ports allowed!\n Port: " + port.first + "\nType: " + port.second);
      }
      Port *outPort = nullptr;
      DESCAM_ASSERT(if (portsLocationMap.find(port.first) != portsLocationMap.end())
                      outPort = new Port(port.first, interface,
                                         DataTypes::getDataType(
                                             port.second),
                                         portsLocationMap[port.first]);
                    else outPort = new Port(port.first, interface, DataTypes::getDataType(port.second));
                        port_map.insert(std::make_pair(port.first, outPort)))
    }

    //Input ports
    for (auto &port: get_clang_ports.getSlaveInPortMap()) {
      Interface *interface = nullptr;
      DESCAM_ASSERT(interface = new Interface("slave", "in"))
      if (DataTypes::isLocalDataType(port.second, module->getName())) {
        TERMINATE(
            "No local datatypes for ports allowed!\n Port: " + port.first + "\nType: " + port.second);
      }
      Port *inPort = nullptr;
      DESCAM_ASSERT(if (portsLocationMap.find(port.first) != portsLocationMap.end())
                      inPort = new Port(port.first, interface,
                                        DataTypes::getDataType(
                                            port.second),
                                        portsLocationMap[port.first]);
                    else inPort = new Port(port.first, interface, DataTypes::getDataType(port.second));
                        port_map.insert(std::make_pair(port.first, inPort)))

    }
    //Output ports
    for (auto &port: get_clang_ports.getSlaveOutPortMap()) {
      if (DataTypes::isLocalDataType(port.second, module->getName())) {
        TERMINATE(
            "No local datatypes for ports allowed!\n Port: " + port.first + "\nType: " + port.second);
      }
      Interface *interface = nullptr;
      DESCAM_ASSERT(interface = new Interface("slave", "out"))
      Port *outPort = nullptr;
      DESCAM_ASSERT(if (portsLocationMap.find(port.first) != portsLocationMap.end())
                      outPort = new Port(port.first, interface,
                                         DataTypes::getDataType(
                                             port.second),
                                         portsLocationMap[port.first]);
                    else outPort = new Port(port.first, interface, DataTypes::getDataType(port.second));
                        port_map.insert(std::make_pair(port.first, outPort)))
    }

    //Shared ports
    //Input ports
    for (auto &port: get_clang_ports.getInSharedPortMap()) {
      if (DataTypes::isLocalDataType(port.second, module->getName())) {
        TERMINATE("No local datatypes for ports allowed!\n Port: " + port.first + "\nType: " + port.second);
      }
      Interface *interface = nullptr;
      DESCAM_ASSERT(interface = new Interface("shared", "in"))
      Port *inPort = nullptr;
      DESCAM_ASSERT(inPort = new Port(port.first, interface, DataTypes::getDataType(port.second));
                        port_map.insert(std::make_pair(port.first, inPort)))

    }
    //Output ports
    for (auto &port: get_clang_ports.getOutSharedPortMap()) {
      if (DataTypes::isLocalDataType(port.second, module->getName())) {
        TERMINATE(
            "No local datatypes for ports allowed!\n Port: " + port.first + "\nType: " + port.second);
      }
      Interface *interface = nullptr;
      DESCAM_ASSERT(interface = new Interface("shared", "out"))
      Port *inPort = nullptr;
      DESCAM_ASSERT(inPort = new Port(port.first, interface, DataTypes::getDataType(port.second));
                        port_map.insert(std::make_pair(port.first, inPort)))
    }

    return success;
  }
}
std::map<std::string, Port *> FindPorts::getPortMap() const {
  return this->port_map;
}

}


