//
// Created by ludwig on 10.09.15.
//

#ifndef SCAM_MODEL_H
#define SCAM_MODEL_H

#include <vector>

#include "Module.h"
#include "ModuleInstance.h"

namespace SCAM {

    class Model : public AbstractNode {
    public:
        Model();

        Model(std::string name);

        virtual ~Model();

        virtual void accept(AbstractVisitor &visitor);

        //Modules
        void addModule(Module *module);

        std::map<std::string, Module *> getModules();

        //ModuleInstances
        void addTopInstance(ModuleInstance * instance);

        ModuleInstance *getTopInstance() const;

        void addGlobalVariable(Variable * variable);
        void addGlobalFunction(Function * function);
        void removeGlobalVariable(Variable * variable);
        void removeGlobalFunction(Function * function);
        const std::map<std::string, Variable *> &getGlobalVariableMap() const;

        const std::map<std::string, Function *> &getGlobalFunctionMap() const;

        const std::map<std::string, ModuleInstance *> &getModuleInstanceMap() const;

        void addModuleInstance(ModuleInstance* modInstance);

    private:
        std::map<std::string, Module *> moduleMap; //! Contains the structural describtion of each _module
        std::map<std::string, Variable*> globalVariableMap; //! Contains variables that are used throughout the model
        std::map<std::string, Function*> globalFunctionMap; //! Contains variables that are used throughout the model
        std::map<std::string, ModuleInstance *> moduleInstanceMap; //! Contains the structural describtion of each _module

        ModuleInstance *topInstance;

    };
}
#endif //SCAM_MODEL_H
