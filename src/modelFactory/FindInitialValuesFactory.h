//
// Created by burr on 06.10.20.
//

#ifndef SCAM_SRC_MODELFACTORY_FINDINITIALVALUESFACTORY_H_
#define SCAM_SRC_MODELFACTORY_FINDINITIALVALUESFACTORY_H_

#include "IFindInitialValues.h"
#include "FindInitialValues.h"

namespace DESCAM{
/**
 * @brief Factory for FindInitialValues
 */
class FindInitialValuesFactory{
 public:
  static ConstValue* getInitValue(clang::CXXRecordDecl *recordDecl,
                                  clang::FieldDecl *fieldDecl,
                                  DESCAM::Module *module,
                                  clang::CompilerInstance &ci){
    std::unique_ptr<IFindInitialValues> findInitialValues = create(recordDecl,fieldDecl,module,ci);
    return  findInitialValues->getInitValue();
  }

 private:
  static std::unique_ptr<IFindInitialValues> create(clang::CXXRecordDecl *recordDecl,
                                                    clang::FieldDecl *fieldDecl,
                                                    DESCAM::Module *module,
                                                    clang::CompilerInstance &ci){
    std::unique_ptr<IFindInitialValues> pointer(new FindInitialValues(recordDecl,fieldDecl,module,ci));
    return pointer;
  }
};
}

#endif //SCAM_SRC_MODELFACTORY_FINDINITIALVALUESFACTORY_H_
