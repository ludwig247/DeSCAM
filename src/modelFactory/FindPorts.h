#ifndef _FIND_PORTS_H_
#define _FIND_PORTS_H_

#include "IFindPorts.h"
#include "IFindNewDatatype.h"
#include "GetClangPorts.h"

namespace DESCAM {

/**
 * \brief: Finds all ports of a given Module
 *
 * Ports are Members of the module, they might also be findable with FindMembers
 */
class FindPorts : public IFindPorts {
 public:
  explicit FindPorts(IFindNewDatatype *find_new_datatype);
  ~FindPorts() override = default;

  bool setup(clang::CXXRecordDecl *record_decl, clang::CompilerInstance *ci, Module *module) override;
  std::map<std::string, Port *> getPortMap() const override;

 private:
  IFindNewDatatype *find_new_datatype_;

  std::map<std::string, Port *> port_map;
  clang::CXXRecordDecl *record_decl_{};

  void setPorts(const std::map<std::string, std::string> &clangPorts,
                const std::string &type,
                const std::string &direction,
                Module *module,
                const std::map<std::string, LocationInfo> &LocInfo);
};

}
#endif
