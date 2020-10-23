#ifndef _FIND_PORTS_H_
#define _FIND_PORTS_H_

#include "IFindPorts.h"
#include "IFindNewDatatype.h"

namespace DESCAM {

/**
 * \brief: Finds all ports of a given Module
 *
 * Ports are Members of the module, they might also be findable with FindMembers
 */
class FindPorts : public IFindPorts, public clang::RecursiveASTVisitor<FindPorts> {
 public:
  FindPorts(IFindNewDatatype *findNewDatatype);
  virtual ~FindPorts() = default;

  bool setup(clang::CXXRecordDecl *record_decl, clang::CompilerInstance *ci) override;
  //Visitor
  virtual bool VisitFieldDecl(clang::FieldDecl *fieldDecl);

  //GETTER
  const std::map<std::string, std::string> &getInPortMap() const override;
  const std::map<std::string, std::string> &getOutPortMap() const override;

  const std::map<std::string, std::string> &getInSharedPortMap() const override;
  const std::map<std::string, std::string> &getOutSharedPortMap() const override;

  const std::map<std::string, std::string> &getMasterInPortMap() const override;
  const std::map<std::string, std::string> &getMasterOutPortMap() const override;

  const std::map<std::string, std::string> &getSlaveInPortMap() const override;
  const std::map<std::string, std::string> &getSlaveOutPortMap() const override;

  const std::map<std::string, DESCAM::LocationInfo> &getLocationInfoMap() const override;

 private:
  IFindNewDatatype *find_new_datatype_;

  clang::CXXRecordDecl *record_decl_;

  std::map<std::string, std::string> in_port_map_; //! Map containing an entry for every rendezVouz in-port,type
  std::map<std::string, std::string> out_port_map_; //! Map containing an entry for every rendezVouz out-port,type
  std::map<std::string, std::string> master_in_port_map_; //! Map containing an entry for every master in-port,type
  std::map<std::string, std::string> master_out_port_map_; //! Map containing an entry for every master out-port,type
  std::map<std::string, std::string> slave_in_port_map_; //! Map containing an entry for every slave in-port,type
  std::map<std::string, std::string> slave_out_port_map_; //! Map containing an entry for every slave out-port,type
  std::map<std::string, std::string> in_shared_port_map_; //! Map containing an entry for every shared  in-port,type
  std::map<std::string, std::string> out_shared_port_map_; //! Map containing an entry for every shared out-port,type
  std::map<std::string, DESCAM::LocationInfo>
      port_location_info_map_; //! Map containing an entry for every port and its location info
  int pass_;
  clang::CompilerInstance *ci_;
  //Helper
  std::vector<std::string>
      port_templates_; //! sc_port<sc_fifo_in_if<_Bool> > Contains an entry for each Template used {sc_port,sc_fifo_in,_Bool}
  void recursiveTemplateVisitor(clang::QualType qual_type);
  void clear();

};

}
#endif
