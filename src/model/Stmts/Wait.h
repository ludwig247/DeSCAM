//
// Created by tobias on 29.04.19.
//

#ifndef PROJECT_WAIT_H
#define PROJECT_WAIT_H

#include "Stmt.h"

namespace SCAM {
    class Wait : public Stmt {
    public:
        Wait();

        virtual ~Wait() = default;

        virtual void accept(StmtAbstractVisitor &visitor) override;

        virtual bool operator==(const Stmt &other) const;

        virtual std::ostream &print(std::ostream &) const;

        const std::string &getStateName() const;

        void setStateName(const std::string &stateName);

        // Serialization
        friend class Serializer;

    private:

        std::string stateName ="";

    };

}

#endif //PROJECT_WAIT_H
