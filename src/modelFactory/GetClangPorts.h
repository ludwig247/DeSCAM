//
// Created by burr on 23.10.20.
//

#ifndef SCAM_SRC_MODELFACTORY_GETCLANGPORTS_H_
#define SCAM_SRC_MODELFACTORY_GETCLANGPORTS_H_

#include "clang/AST/RecursiveASTVisitor.h"
#include "IFindNewDatatype.h"

namespace DESCAM {
class GetClangPorts : public clang::RecursiveASTVisitor<GetClangPorts> {
 public:
  GetClangPorts(bool &success,
                IFindNewDatatype *find_new_datatype,
                clang::CompilerInstance *ci,
                clang::CXXRecordDecl *record_decl);

  //Visitor
  virtual bool VisitFieldDecl(clang::FieldDecl *field_decl);
  //GETTER
  const std::map<std::string, std::string> &getInPortMap() const;
  const std::map<std::string, std::string> &getOutPortMap() const;

  const std::map<std::string, std::string> &getInSharedPortMap() const;
  const std::map<std::string, std::string> &getOutSharedPortMap() const;

  const std::map<std::string, std::string> &getMasterInPortMap() const;
  const std::map<std::string, std::string> &getMasterOutPortMap() const;

  const std::map<std::string, std::string> &getSlaveInPortMap() const;
  const std::map<std::string, std::string> &getSlaveOutPortMap() const;

  const std::map<std::string, DESCAM::LocationInfo> &getLocationInfoMap() const;

 private:
  clang::CompilerInstance *ci_;
  IFindNewDatatype *find_new_datatype_;

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

  //Helper
  std::vector<std::string>
      port_templates_; //! sc_port<sc_fifo_in_if<_Bool> > Contains an entry for each Template used {sc_port,sc_fifo_in,_Bool}

  void recursiveTemplateVisitor(clang::QualType qual_type);
};
}

#endif //SCAM_SRC_MODELFACTORY_GETCLANGPORTS_H_
