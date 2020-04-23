//
// Created by tobias on 11.09.15.
//

#ifndef SCAM_MODULINSTANCE_H
#define SCAM_MODULINSTANCE_H

#include "Channel.h"


namespace SCAM {

    class Module;

    class Port;

    class ModuleInstance : public AbstractNode {
    public:
        ModuleInstance(std::string name, Module *structure);

        ModuleInstance();

        ModuleInstance(std::string name, Module *structure, Module *parentModule, ModuleInstance *parentInstance);

        virtual  ~ModuleInstance();

        void accept(AbstractVisitor &visitor);

        //ModuleInstances
        void addSubmoduleInstance(ModuleInstance *moduleInstance);

        std::map<std::string, ModuleInstance *> getSubmoduleInstances();
        std::vector<ModuleInstance*> getInstanceSiblings(SCAM::ModuleInstance *moduleInstance);

        //Channel
        void addChannel(Channel *channel);

        std::map<std::string, Channel *> getChannelMap();

        SCAM::Channel *getChannel(SCAM::Port *port); //! Returns the channel that belongs to the port

        //SETTER
        void setLevel(int level);
        void setID(int id);
        void setChannelConnectionMap(std::map<std::pair<std::string,std::string>, std::string> channelConnectionMap);
        void setHierChannelConnectionMap(std::map<std::pair<std::string,std::string>, std::pair<std::string,std::string>> hierChannelConnectionMap);

        //GETTER
        Module *getStructure();
        Module *getParent();
        ModuleInstance *getParentInstance();
        int getLevel();
        int getID();
        std::map<std::pair<std::string,std::string>, std::pair<std::string,std::string>> getHierChannelConnectionMap();
        std::map<std::pair<std::string,std::string>, std::string> getChannelConnectionMap();




    private:
        Module *structure; //! Pointing to the structure of the model
        std::map<std::string, SCAM::Channel *> channelMap; //! List of channels bound within this instance
        std::map<std::string, ModuleInstance *> submoduleInstanceMap; //! Contains all instances of sub-modules instantiated in this module
        std::map<SCAM::Port *, SCAM::Channel *> portChannelMap;

        std::map<std::pair<std::string,std::string>, std::string> _channelConnectionMap; //! <<instance, port>, channelName>
        std::map<std::pair<std::string,std::string>, std::pair<std::string,std::string>> _hierchannelConnectionMap; //! <<instance, port>, <channelName,channelparentinstance>>

        Module *parentModule;
        ModuleInstance *parentInstance;

        int _level;
        int _id;

    };

}


#endif //SCAM_MODULINSTANCE_H
