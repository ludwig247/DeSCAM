//
// Created by tobias on 11.09.15.
//

#ifndef SCAM_MODULINSTANCE_H
#define SCAM_MODULINSTANCE_H

#include "Channel.h"


namespace SCAM{

class Module;
class Port;
class ModuleInstance : public AbstractNode  {
public:
    ModuleInstance(std::string name, Module* structure);
    ModuleInstance();
    virtual  ~ModuleInstance();

    void accept(AbstractVisitor &visitor);

    //ModuleInstances
    void addModuleInstance(ModuleInstance * modulInstance);
    std::map<std::string,ModuleInstance*> getModuleInstances();

    //Channel
    void addChannel(Channel* channel);
    std::map<std::string, Channel*> getChannelMap();
    SCAM::Channel * getChannel(SCAM::Port * port); //! Returns the channel that belongs to the port

    //GETTER
    Module* getStructure();


private:
    Module * structure; //! Pointing to the structure of the model
    std::map<std::string, SCAM::Channel*> channelMap; //! List of channels bound within this instance
    std::map<std::string,ModuleInstance*> moduleInstanceMap; //! Contains all instances of sub-modules instantiated in this modul
    std::map<SCAM::Port*,SCAM::Channel*> portChannelMap;
};

}


#endif //SCAM_MODULINSTANCE_H
