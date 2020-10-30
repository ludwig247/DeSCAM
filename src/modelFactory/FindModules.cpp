#include <iostream>
#include "FindModules.h"
#include "Logger/Logger.h"

namespace DESCAM {

FindModules::FindModules(IFindVariables *find_variables) :
    find_variables_(find_variables) {
  assert(find_variables);
}

bool FindModules::VisitCXXRecordDecl(clang::CXXRecordDecl *cxxDecl) {
  //Checks whether the module is just a declaration and not a implementation
  if (!cxxDecl->hasDefinition()) {
    return true;
  }

  //If class is a systemC module it has to have a base class
  if (cxxDecl->getNumBases() <= 0) {
    return true;
  }
  //Assume: All user defined modules can be identified by a basename "class sc::core::sc_module"
  //Issues: doesn't filters all classes, e.g. sc_event_queue has also this basename
  //Idea: sort out those modules by hand
  for (auto bi = cxxDecl->bases_begin(), be = cxxDecl->bases_end(); bi != be; ++bi) {
    clang::QualType q = bi->getType();
    //Check basename
    std::string baseName = q.getAsString();
    if (baseName == "class sc_core::sc_module" || baseName == "::sc_core::sc_module") {
      module_map_.insert(std::pair<std::string, clang::CXXRecordDecl *>(cxxDecl->getName().str(), cxxDecl));

    }
  }
  return true;
}

const std::map<std::string, clang::CXXRecordDecl *> &FindModules::getModuleMap() {
  return module_map_;
}

void FindModules::setup(clang::TranslationUnitDecl *decl, clang::CompilerInstance *ci) {
  this->module_map_.clear();
  this->ci_ = ci;
  assert(decl);
  assert(ci);
  TraverseDecl(decl);

}
DESCAM::Module *FindModules::createModule(clang::CXXRecordDecl *record_decl,
                                          std::string name,
                                          LocationInfo locationInfo) {
  auto module = new Module(name, locationInfo);

  //Members
  this->addVariables(module, record_decl);
  return module;
}

//! Adds every Member of a sc_module to the DESCAM::Module
void DESCAM::FindModules::addVariables(DESCAM::Module *module, clang::CXXRecordDecl *decl) {
  Logger::setCurrentProcessedLocation(LoggerMsg::ProcessedLocation::Variables);
  //Find all Variables within the Module
  find_variables_->setup(decl, this->ci_, module);

  module->addVariables(find_variables_->getVariableMap());
}
}