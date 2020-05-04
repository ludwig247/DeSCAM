//
// Created by ludwig on 13.02.20.
//

#include "PropertyFactory.h"
#include "CreatePropertySuite.h"

SCAM::PropertyFactory::PropertyFactory(Module *module) {

    assert(module != nullptr);
    // Generate PropertySuite

    this->propertySuite = new PropertySuite(module->getName());

    //Ports
    SCAM::CreatePropertySuite::addNotifySignals(module, propertySuite);
    SCAM::CreatePropertySuite::addSyncSignals(module, propertySuite);
    SCAM::CreatePropertySuite::addDataSignals(module, propertySuite);

    //Vars
    SCAM::CreatePropertySuite::addVisibleRegisters(module, propertySuite);
    //States
    SCAM::CreatePropertySuite::addStates(module, propertySuite);

    //Functions
    SCAM::CreatePropertySuite::addFunctions(module, propertySuite);
    // RESET PROPERTY
    SCAM::CreatePropertySuite::addReset(module, propertySuite);

    //OPERATION PROPERTIES
    SCAM::CreatePropertySuite::addOperations(module, propertySuite);
    //SCAM::CreatePropertySuite::addTrueOperations(module, propertySuite);

    //SCAM::CreatePropertySuite::addOperations(module, propertySuite);
    //SCAM::CreatePropertySuite::addTrueOperations(module, propertySuite);

    // WAIT PROPERTIES
    SCAM::CreatePropertySuite::addWait(module, propertySuite);


}

SCAM::PropertyFactory::PropertyFactory(Module *module, Model *model) {

    assert(model != nullptr);
    assert(module != nullptr);
    // Generate PropertySuite
    this->propertySuite = new PropertySuite(module->getName());

    SCAM::CreatePropertySuite::addReset(module, propertySuite);

}

SCAM::PropertySuite *SCAM::PropertyFactory::getPropertySuite() const {
    return propertySuite;
}
