//
// Created by tobias on 17.02.16.
//

#ifndef SCAM_ITE_H
#define SCAM_ITE_H

#include "If.h"
#include <vector>

namespace DESCAM {

/*
 * \brief class is only used for conversion to AML, might be removed later
 *
 */
    class ITE : public If {
    public:
        ITE(Expr *conditionStmt, LocationInfo stmtLocationInfo = LocationInfo());

        void addIfList(DESCAM::Stmt *);

        void addElseList(DESCAM::Stmt *);

        void setIfList(const std::vector<Stmt *> &ifList);

        void setElseList(const std::vector<Stmt *> &elseList);


        const std::vector<Stmt *> &getIfList() const;

        const std::vector<Stmt *> &getElseList() const;


        virtual void accept(DESCAM::StmtAbstractVisitor &visitor);

        virtual bool operator==(const Stmt &other) const;

    private:
        std::vector<DESCAM::Stmt *> ifList; //! List containing each entry for each element that is within the if block
        std::vector<DESCAM::Stmt *> elseList; //! List containing an entry for each element that is within the else block
    };
}

#endif //SCAM_ITE_H
