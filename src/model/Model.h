//
// Created by ludwig on 10.09.15.
//

#ifndef SCAM_MODEL_H
#define SCAM_MODEL_H

#include <vector>

#include "Module.h"
#include "ModuleInstance.h"

namespace SCAM{

    class Model: public AbstractNode {
    public:
        Model();
        Model(std::string name);
        virtual ~Model();

        virtual void accept(AbstractVisitor &visitor);

        //Modules
        void addModule(Module* module);
        std::map<std::string,Module*> getModules();

        //ModuleInstances
        void addTopInstance(ModuleInstance *instance);

        ModuleInstance *getTopInstance() const;

        const std::map<std::string, ModuleInstance *> &getModuleInstanceMap() const;

    private:
        std::map<std::string,Module*> moduleMap; //! Contains the structural describtion of each _module
        std::map<std::string,ModuleInstance*> moduleInstanceMap; //! Contains the structural describtion of each _module

        ModuleInstance * topInstance;

    };
}
#endif //SCAM_MODEL_H
