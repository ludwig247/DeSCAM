//
// Created by tobias on 03.02.20.
//

#ifndef DESCAM_CREATEPROPERTYSUITE_H
#define DESCAM_CREATEPROPERTYSUITE_H

#include <Model.h>
#include <memory>

namespace DESCAM{
    class CreatePropertySuite {
    public:
        CreatePropertySuite() = delete;

        static void addNotifySignals(const Module * module, std::shared_ptr<PropertySuite>  propertySuite);
        static void addSyncSignals(const Module * module,std::shared_ptr<PropertySuite>  propertySuite);
        static void addDataSignals(const Module * module,std::shared_ptr<PropertySuite>  propertySuite);
        static void addVisibleRegisters(const Module * module,std::shared_ptr<PropertySuite>  propertySuite);
        static void addStates(const Module * module,std::shared_ptr<PropertySuite>  propertySuite);
        static void addFunctions(const Module * module,std::shared_ptr<PropertySuite>  propertySuite);
        static void addReset(const Module *module, std::shared_ptr<PropertySuite> propertySuite);
        static void addWait(const Module *module, std::shared_ptr<PropertySuite> propertySuite);
        static void addOperations(const Module *module, std::shared_ptr<PropertySuite> propertySuite);

        static void addTrueOperations(const DESCAM::Module *module, std::shared_ptr<PropertySuite> propertySuite);

    private:


        static Timepoint *findTimeExpr(const std::map<Timepoint *, Expr *> &map, std::basic_string<char, std::char_traits<char>, std::allocator<char>> basicString);
    };
}



#endif //DESCAM_CREATEPROPERTYSUITE_H
