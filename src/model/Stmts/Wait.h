//
// Created by tobias on 29.04.19.
//

#ifndef PROJECT_WAIT_H
#define PROJECT_WAIT_H

#include "Stmt.h"

namespace DESCAM {
    class Wait : public Stmt {
    public:
        Wait(LocationInfo stmtLocationInfo = LocationInfo());

        virtual ~Wait() = default;

        virtual void accept(StmtAbstractVisitor &visitor) override;

        bool operator==(const Stmt &other) const override;

        std::ostream &print(std::ostream &) const override;

        const std::string &getStateName() const;

        void setStateName(const std::string &stateName);

    private:

        std::string stateName ="";

    };

}

#endif //PROJECT_WAIT_H
