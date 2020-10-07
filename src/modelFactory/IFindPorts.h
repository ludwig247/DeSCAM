//
// Created by tobias on 07.10.20.
//

#ifndef SCAM_SRC_MODELFACTORY_IFINDPORTS_H_
#define SCAM_SRC_MODELFACTORY_IFINDPORTS_H_

#include <map>
#include <clang/AST/ASTContext.h>
#include "clang/AST/RecursiveASTVisitor.h"
#include "enums.h"
#include "LocationInfo.h"


class IFindPorts{
 public:
  virtual void setup(clang::CXXRecordDecl *recordDecl) = 0;
  //GETTER
  virtual const std::map<std::string, std::string> &getInPortMap() const = 0;
  virtual const std::map<std::string, std::string> &getOutPortMap() const = 0;

  virtual const std::map<std::string, std::string> &getInSharedPortMap() const = 0;
  virtual const std::map<std::string, std::string> &getOutSharedPortMap() const = 0;

  virtual const std::map<std::string, std::string> &getMasterInPortMap() const = 0;
  virtual const std::map<std::string, std::string> &getMasterOutPortMap() const = 0;

  virtual const std::map<std::string, std::string> &getSlaveInPortMap() const = 0;
  virtual const std::map<std::string, std::string> &getSlaveOutPortMap() const = 0;

  virtual const std::map<std::string, DESCAM::LocationInfo> &getLocationInfoMap() const = 0;
};
#endif //SCAM_SRC_MODELFACTORY_IFINDPORTS_H_
