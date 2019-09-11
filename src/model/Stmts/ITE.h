//
// Created by tobias on 17.02.16.
//

#ifndef SCAM_ITE_H
#define SCAM_ITE_H

#include "If.h"
#include <vector>
namespace SCAM {

/*
 * \brief class is only used for conversion to AML, might be removed later
 *
 */
class ITE: public If {
public:
    ITE(Expr *conditionStmt);

    void addIfList(SCAM::Stmt*);
    void addElseList(SCAM::Stmt*);

    void setIfList(const std::vector<Stmt *> &ifList);
    void setElseList(const std::vector<Stmt *> &elseList);


    const std::vector<Stmt *> &getIfList() const;
    const std::vector<Stmt *> &getElseList() const;


    virtual void accept(SCAM::StmtAbstractVisitor& visitor);
    virtual bool operator==(const Stmt &other) const;
private:
    std::vector<SCAM::Stmt *> ifList; //! List containing each entry for each element that is within the if block
    std::vector<SCAM::Stmt *> elseList; //! List containing an entry for each element that is within the else block
};
}

#endif //SCAM_ITE_H
