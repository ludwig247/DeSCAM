//
// Created by ludwig on 22.09.15.
//

#ifndef SCAM_INTERFACE_H
#define SCAM_INTERFACE_H

#include "AbstractNode.h"

namespace DESCAM {
    class Interface : public AbstractNode {
    public:
        Interface(std::string interfaceName, std::string direction, LocationInfo locationInfo = LocationInfo());

        virtual ~Interface();

        //GETTER
        std::string getDirection();

        bool isBlocking() const;

        bool isBlockingIn() const;

        bool isBlockingOut() const;

        //Master
        bool isMaster() const;

        bool isMasterOut() const;

        bool isMasterIn() const;

        //Slave
        bool isSlave() const;

        bool isSlaveOut() const;

        bool isSlaveIn() const;

        //Shared
        bool isShared() const;

        //General
        bool isInput() const;

        bool isOutput() const;


        //Accept
        void accept(AbstractVisitor &visitor);

    private:
        Interface();

        std::string _direction;
        std::string _interface;

    };

}
#endif //SCAM_INTERFACE_H
