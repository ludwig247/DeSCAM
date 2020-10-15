//
// Created by tobias on 15.10.20.
//

#ifndef SCAM_SRC_MODELFACTORY_IFINDSTATENAME_H_
#define SCAM_SRC_MODELFACTORY_IFINDSTATENAME_H_
namespace DESCAM{
class IFindStateName{
 public:
  virtual ~IFindStateName() = default;
  virtual bool setup(clang::Stmt *stmt)=0;
  virtual bool hasStateName() const = 0;
  virtual const std::string &getStateName() const = 0;
};

}


#endif //SCAM_SRC_MODELFACTORY_IFINDSTATENAME_H_
