//
// Created by ludwig on 10.09.15.
//

#ifndef SCAM_CHANNEL_H
#define SCAM_CHANNEL_H

#include "AbstractNode.h"

namespace SCAM{

class Port;
class ModuleInstance;


class Channel: public AbstractNode {
public:
    Channel(std::string name);
    virtual ~Channel();

    //Accept
    void accept(AbstractVisitor &visitor);

    //GETTER
    Port* getFromPort();
    Port* getToPort();
    ModuleInstance* getFromInstance();
    ModuleInstance* getToInstance();
    //SETTER
    void setFromPort(Port* port);
    void setToPort(Port* port);
    void setFromInstance(ModuleInstance* instance);
    void setToInstance(ModuleInstance* instance);


private:
    Port* fromPort;
    Port* toPort;
    ModuleInstance* fromInstance;
    ModuleInstance* toInstance;

};

}

#endif //SCAM_INTERFACE_H
