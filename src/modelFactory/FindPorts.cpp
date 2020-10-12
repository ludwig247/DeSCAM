#include <iostream>
#include <utility>
#include <clang/AST/PrettyPrinter.h>
#include <GlobalUtilities.h>
#include "FindPorts.h"
#include "FindNewDatatype.h"
#include "FatalError.h"
#include "Logger/Logger.h"

namespace DESCAM {
/*!
* \brief Methods that checks whether a subString is contained in a given String
 */
bool containsSubstring(const std::string &full_string, const std::string &sub_string) {
  if (full_string.empty()) {
    return false;
  }
  if (full_string.find(sub_string) < full_string.size()) {
    return true;
  }
  return false;
}

//Constructor
FindPorts::FindPorts(clang::CompilerInstance *ci, IFindNewDatatype *findNewDatatype) :
    ci_(ci),
    find_new_datatype_(findNewDatatype),
    pass(0) {}

/*!
 * \brief Visits every FieldDecl and check whether a fieldDecl represents a port
 *
 * Ports are:
 * sc_port<rendezvous_out_if<TYPE> >
 * sc_port<rendezvous_in_if<TYPE> >
 * sc_port<shared_out_if<TYPE> >
 * sc_port<shared_in_if<TYPE> >
 */
bool FindPorts::VisitFieldDecl(clang::FieldDecl *fieldDecl) {
  clang::QualType qualType = fieldDecl->getType();
  //Synch: find by name, doesn't have a parameter
  if (const auto *templateClass = llvm::dyn_cast<clang::TemplateSpecializationType>(qualType.getTypePtr())) {
    //In order to have a port there needs to be a qualType with 3 parameters
    //Disassemble the template
    port_templates_.clear();
    this->recursiveTemplateVisitor(qualType);
    //Determine type of port:
    if (port_templates_.size() == 2) {
      //if (port_templates_.at(0) == "sc_port" && port_templates_.at(1) == "rendezvous_out_if") {
      if (port_templates_.at(0) == "blocking_out") {
        this->out_port_map_.insert(std::make_pair(fieldDecl->getNameAsString(), port_templates_.at(1)));
      } else if (port_templates_.at(0) == "blocking_in") {
        this->in_port_map_.insert(std::make_pair(fieldDecl->getNameAsString(), port_templates_.at(1)));
      } else if (port_templates_.at(0) == "master_out") {
        this->master_out_port_map_.insert(std::make_pair(fieldDecl->getNameAsString(), port_templates_.at(1)));
      } else if (port_templates_.at(0) == "master_in") {
        this->master_in_port_map_.insert(std::make_pair(fieldDecl->getNameAsString(), port_templates_.at(1)));
      } else if (port_templates_.at(0) == "slave_in") {
        this->slave_in_port_map_.insert(std::make_pair(fieldDecl->getNameAsString(), port_templates_.at(1)));
      } else if (port_templates_.at(0) == "slave_out") {
        this->slave_out_port_map_.insert(std::make_pair(fieldDecl->getNameAsString(), port_templates_.at(1)));
      } else if (port_templates_.at(0) == "shared_in") {
        this->in_shared_port_map_.insert(std::make_pair(fieldDecl->getNameAsString(), port_templates_.at(1)));

      } else if (port_templates_.at(0) == "shared_out") {
        this->out_shared_port_map_.insert(std::make_pair(fieldDecl->getNameAsString(), port_templates_.at(1)));
      } else {
        TERMINATE("Unknown interface: " + port_templates_.at(0));
      }
      this->port_location_info_map_.insert(std::make_pair(fieldDecl->getNameAsString(),
                                                          DESCAM::GlobalUtilities::getLocationInfo<clang::FieldDecl>(
                                                              fieldDecl,ci_)));
    }
  }
  return true;
}

void FindPorts::recursiveTemplateVisitor(clang::QualType qual_type) {
  //Is there another template class?
  if (const auto *templateClass = llvm::dyn_cast<clang::TemplateSpecializationType>(
      qual_type.getTypePtr())) {

    //Get name of the template class
    std::string templateName;
    llvm::raw_string_ostream templateNameStream(templateName);
    //Dump name into stream
    templateClass->getTemplateName().dump(templateNameStream);
    //Get string from stream and add to vector
    this->port_templates_.push_back(templateNameStream.str());
    for (int i = 0; i < templateClass->getNumArgs(); i++) {
      clang::TemplateArgument templateArgument = templateClass->getArg(i);
      if (templateArgument.getKind() == clang::TemplateArgument::ArgKind::Expression) {
        clang::Expr *expr = templateArgument.getAsExpr();
        if (const clang::IntegerLiteral *value = llvm::dyn_cast<clang::IntegerLiteral>(expr)) {
          //if(this->port_templates_.at(0) != "sc_uint") TERMINATE("Type: " + this->port_templates_.at(0) + " is not allowed");
          this->port_templates_.push_back(std::to_string(value->getValue().getSExtValue()));
        } else TERMINATE("Expr is not an integer");
      } else {
        this->recursiveTemplateVisitor(templateArgument.getAsType());
      }
    }
  }
    //Type of port int, bool, struct ...
  else if (qual_type.isCanonical()) {
    this->port_templates_.push_back(find_new_datatype_->getTypeName(qual_type));
  }
}

const std::map<std::string, std::string> &FindPorts::getInPortMap() const {
  return in_port_map_;
}

const std::map<std::string, std::string> &FindPorts::getOutPortMap() const {
  return out_port_map_;
}

const std::map<std::string, std::string> &FindPorts::getInSharedPortMap() const {
  return in_shared_port_map_;
}

const std::map<std::string, std::string> &FindPorts::getOutSharedPortMap() const {
  return out_shared_port_map_;
}

const std::map<std::string, std::string> &FindPorts::getSlaveInPortMap() const {
  return slave_in_port_map_;
}

const std::map<std::string, std::string> &FindPorts::getSlaveOutPortMap() const {
  return slave_out_port_map_;
}

const std::map<std::string, std::string> &FindPorts::getMasterInPortMap() const {
  return master_in_port_map_;
}

const std::map<std::string, std::string> &FindPorts::getMasterOutPortMap() const {
  return master_out_port_map_;
}

const std::map<std::string, DESCAM::LocationInfo> &FindPorts::getLocationInfoMap() const {
  return this->port_location_info_map_;
}
bool FindPorts::setup(clang::CXXRecordDecl *record_decl, clang::CompilerInstance *ci) {
  assert(record_decl);
  assert(ci);
  if (record_decl == record_decl_ && ci == ci_) {
    return true;
  } else {
    pass_ = 0;
    ci_ = ci;
    record_decl_ = record_decl;
    this->clear();
    return TraverseDecl(record_decl);
  }
}

void FindPorts::clear() {
  this->port_location_info_map_.clear();
  this->in_port_map_.clear();
  this->out_port_map_.clear();
  this->master_in_port_map_.clear();
  this->master_out_port_map_.clear();
  this->slave_in_port_map_.clear();
  this->slave_out_port_map_.clear();
  this->out_shared_port_map_.clear();
  this->in_shared_port_map_.clear();
  this->port_templates_.clear();
}

}


