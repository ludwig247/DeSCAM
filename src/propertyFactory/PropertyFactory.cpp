//
// Created by ludwig on 13.02.20.
//

#include "PropertyFactory.h"
#include "CreatePropertySuite.h"

DESCAM::PropertyFactory::PropertyFactory(const Module *module) {

    assert(module != nullptr);
    // Generate PropertySuite
    this->propertySuite = std::make_shared<PropertySuite>(module->getName());

    //Ports
    DESCAM::CreatePropertySuite::addNotifySignals(module, propertySuite);
    DESCAM::CreatePropertySuite::addSyncSignals(module, propertySuite);
    DESCAM::CreatePropertySuite::addDataSignals(module, propertySuite);

    //Vars
    DESCAM::CreatePropertySuite::addVisibleRegisters(module, propertySuite);

    //States
    DESCAM::CreatePropertySuite::addStates(module, propertySuite);

    //Functions
    DESCAM::CreatePropertySuite::addFunctions(module, propertySuite);

    // RESET PROPERTY
    DESCAM::CreatePropertySuite::addReset(module, propertySuite);

    //OPERATION PROPERTIES

    DESCAM::CreatePropertySuite::addOperations(module, propertySuite);
    //DESCAM::CreatePropertySuite::addTrueOperations(module, propertySuite);

//    DESCAM::CreatePropertySuite::addOperations(module, propertySuite);
//    DESCAM::CreatePropertySuite::addTrueOperations(module, propertySuite);


    // WAIT PROPERTIES
    DESCAM::CreatePropertySuite::addWait(module, propertySuite);
}

std::shared_ptr<DESCAM::PropertySuite> DESCAM::PropertyFactory::getPropertySuite() const {
    return propertySuite;
}
