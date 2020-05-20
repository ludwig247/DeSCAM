//
// Created by tobias on 05.12.18.
//

#ifndef PROJECT_NOTIFY2_H
#define PROJECT_NOTIFY2_H

#include "Port.h"
#include "Expr.h"

namespace SCAM {
    class Notify : public Expr {
    public:
        Notify() = delete;

        Notify(Port *port);
        Notify(std::string name);

        virtual ~Notify() = default;

        virtual void accept(StmtAbstractVisitor &visitor);

        virtual bool operator==(const Stmt &other) const;

        Port *getPort() const;
        std::string getEventname();

    private:
        Port *port;
        std::string eventname;
    };
}

#endif //PROJECT_NOTIFY_H
