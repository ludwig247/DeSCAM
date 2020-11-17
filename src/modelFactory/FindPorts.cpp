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

    const auto &kLocationMap = get_clang_ports.getLocationInfoMap();
    //Rendezvous
    //Input ports
    setPorts(get_clang_ports.getInPortMap(), "blocking", "in", module, kLocationMap);
    //Output ports
    setPorts(get_clang_ports.getOutPortMap(), "blocking", "out", module, kLocationMap);

    //AlwaysReady
    setPorts(get_clang_ports.getMasterInPortMap(), "master", "in", module, kLocationMap);
    //Output ports
    setPorts(get_clang_ports.getMasterOutPortMap(), "master", "out", module, kLocationMap);

    //Input ports
    setPorts(get_clang_ports.getSlaveInPortMap(), "slave", "in", module, kLocationMap);
    //Output ports
    setPorts(get_clang_ports.getSlaveOutPortMap(), "slave", "out", module, kLocationMap);

    //Shared ports
    //Input ports
    setPorts(get_clang_ports.getInSharedPortMap(), "shared", "in", module, kLocationMap);
    //Output ports
    setPorts(get_clang_ports.getOutSharedPortMap(), "shared", "out", module, kLocationMap);

    return success;
  }
}
std::map<std::string, Port *> FindPorts::getPortMap() const {
  return this->port_map;
}

void FindPorts::setPorts(const std::map<std::string, std::string> &clangPorts,
                         const std::string &type,
                         const std::string &direction,
                         Module *module,
                         const std::map<std::string, LocationInfo> &LocInfo) {

  for (auto &port: clangPorts) {
    if (DataTypes::isLocalDataType(port.second, module->getName())) {
      TERMINATE("No local datatypes for ports allowed!\n Port: " + port.first + "\nType: " + port.second)
    }

    DESCAM_ASSERT(
        {
          auto interface = new Interface(type, direction);
          Port *p;
          if (LocInfo.find(port.first) != LocInfo.end()) {
            p = new Port(port.first, interface, DataTypes::getDataType(port.second), LocInfo.at(port.first));
          } else {
            p = new Port(port.first, interface, DataTypes::getDataType(port.second));
          }
          port_map.emplace(port.first, p);
        })
  }
}

}


