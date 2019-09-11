//
// Created by tobias on 05.12.18.
//

#ifndef PROJECT_NOTIFY2_H
#define PROJECT_NOTIFY2_H

#include "Port.h"
#include "Expr.h"
namespace SCAM{
    class Notify: public Expr {
    public:
        Notify() = delete;
        Notify(Port * port);
        virtual ~Notify() = default;

        virtual void accept(StmtAbstractVisitor &visitor);

        virtual bool operator==(const Stmt &other) const;

        Port *getPort() const;

    private:
        Port * port;

    };
}

#endif //PROJECT_NOTIFY_H
