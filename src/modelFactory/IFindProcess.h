//
// Created by schwarz on 08.10.20.
//

#ifndef SCAM_SRC_MODELFACTORY_IFINDPROCESS_H_
#define SCAM_SRC_MODELFACTORY_IFINDPROCESS_H_

#include <string>
#include <map>
#include "clang/AST/DeclCXX.h"
#include "enums.h"

namespace DESCAM {

/**
 * TODO Comment
 */
class IFindProcess {
 public:

  virtual ~IFindProcess() = default;

  virtual bool setup(clang::CXXRecordDecl *recordDecl) = 0;
  //Getter
  virtual const std::map<std::string, std::pair<clang::CXXMethodDecl *, PROCESS_TYPE>> &getProcessMap() = 0;
  virtual bool isValidProcess() const = 0;
  virtual clang::CXXMethodDecl *getProcess() const = 0;

};
}

#endif //SCAM_SRC_MODELFACTORY_IFINDPROCESS_H_
