//
// Created by schmitz on 25.04.20.
//

#ifndef DESCAM_PORTMAPCHANNEL_H
#define DESCAM_PORTMAPCHANNEL_H

#include "AbstractNode.h"

namespace SCAM {

    class Port;

    class ModuleInstance;


    class PortMapChannel : public AbstractNode {
    public:
        PortMapChannel(std::string name);

        virtual ~PortMapChannel();

        //Accept
        void accept(AbstractVisitor &visitor);

        //GETTER
        Port *getLowerPort();

        Port *getHigherPort();

        ModuleInstance *getLowerInstance();

        ModuleInstance *getHigherInstance();

        ModuleInstance *getParentInstance();

        std::string getType();

        //SETTER
        void setHigherPort(Port *port);

        void setLowerPort(Port *port);

        void setLowerInstance(ModuleInstance *instance);

        void setHigherInstance(ModuleInstance *instance);

        void setParentInstance(ModuleInstance *instance);

        void setType(std::string Type);

    private:

        Port *lowerPort;
        Port *higherPort;
        ModuleInstance *lowerInstance;
        ModuleInstance *higherInstance;
        ModuleInstance *parentInstance;
        std::string type;

    };

}

#endif //DESCAM_PORTMAPCHANNEL_H
