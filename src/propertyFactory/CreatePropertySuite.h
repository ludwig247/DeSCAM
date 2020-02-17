//
// Created by tobias on 03.02.20.
//

#ifndef DESCAM_CREATEPROPERTYSUITE_H
#define DESCAM_CREATEPROPERTYSUITE_H

#include <Model.h>

namespace SCAM{
    class CreatePropertySuite {
    public:
        CreatePropertySuite() = delete;

        static void addNotifySignals(const Module * module,PropertySuite * propertySuite);
        static void addSyncSignals(const Module * module,PropertySuite * propertySuite);
        static void addDataSignals(const Module * module,PropertySuite * propertySuite);
        static void addVisibleRegisters(const Module * module,PropertySuite * propertySuite);
        static void addStates(const Module * module,PropertySuite * propertySuite);
        static void addFunctions(const Module * module,PropertySuite * propertySuite);
        static void addReset(const Module *module, PropertySuite *propertySuite);
        static void addWait(const Module *module, PropertySuite *propertySuite);
        static void addOperations(const Module *module, PropertySuite *propertySuite);

        static void addTrueOperations(const SCAM::Module *module, SCAM::PropertySuite *propertySuite);

    private:


        static Timepoint *findTimeExpr(const std::map<Timepoint *, Expr *> &map, std::basic_string<char, std::char_traits<char>, std::allocator<char>> basicString);
    };
}



#endif //DESCAM_CREATEPROPERTYSUITE_H
