//
// Created by ludwig on 02.11.16.
//

#ifndef SCAM_EXPR_H
#define SCAM_EXPR_H

#include <DataType.h>
#include "StmtAbstractVisitor.h"
#include "Stmt.h"
#include <DataTypes.h>

namespace SCAM{

class Expr: public Stmt  {
public:
    Expr(const DataType * dataType);
    const DataType * getDataType() const;

    virtual std::ostream &print(std::ostream &ostream) const;

    bool isDataType(std::string n) const;



    virtual void accept(StmtAbstractVisitor& visitor) = 0;
private:
    const DataType * dataType;
};

}


#endif //SCAM_EXPR_H
