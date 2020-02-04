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
        static void addVisibleRegisters(const std::map<std::string,Variable*>& varMap,PropertySuite * propertySuite);
        static void addStates(const Module * module,PropertySuite * propertySuite);
        static void addFunctions(const Module * module,PropertySuite * propertySuite);
        static void addReset(const Module *module, PropertySuite *propertySuite);
        static void addOperations(const Module *module, PropertySuite *propertySuite);
        static void addTrueOperations(const std::vector<std::vector<const Operation2 *> >& cyclesList, const Module * module, PropertySuite *propertySuite);
        static void addWait(const Module *module, PropertySuite *propertySuite);

    private:


    };
}



#endif //DESCAM_CREATEPROPERTYSUITE_H
