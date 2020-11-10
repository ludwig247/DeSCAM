//
// Created by burr on 23.10.20.
//
#include <clang/AST/PrettyPrinter.h>
#include <GlobalUtilities.h>
#include <clang/AST/Type.h>
#include "GetClangPorts.h"
#include "FatalError.h"
#include "Logger/Logger.h"

DESCAM::GetClangPorts::GetClangPorts(bool &success,
                                     IFindNewDatatype *find_new_datatype,
                                     clang::CompilerInstance *ci,
                                     clang::CXXRecordDecl *record_decl) :
    find_new_datatype_(find_new_datatype),
    ci_(ci) {
  success = TraverseDecl(record_decl);
}

/*!
 * \brief Visits every FieldDecl and check whether a fieldDecl represents a port
 *
 * Ports are:
 * sc_port<rendezvous_out_if<TYPE> >
 * sc_port<rendezvous_in_if<TYPE> >
 * sc_port<shared_out_if<TYPE> >
 * sc_port<shared_in_if<TYPE> >
 */
bool DESCAM::GetClangPorts::VisitFieldDecl(clang::FieldDecl *fieldDecl) {
  clang::QualType qualType = fieldDecl->getType();
  //Sync: find by name, doesn't have a parameter
  //TODO: What's the templateClass used for? Line of outdated legacy code? Just checking for dyn_cast?
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
                                                              fieldDecl, ci_)));
    }
  }
  return true;
}

void DESCAM::GetClangPorts::recursiveTemplateVisitor(clang::QualType qual_type) {
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

const std::map<std::string, std::string> &DESCAM::GetClangPorts::getInPortMap() const {
  return in_port_map_;
}

const std::map<std::string, std::string> &DESCAM::GetClangPorts::getOutPortMap() const {
  return out_port_map_;
}

const std::map<std::string, std::string> &DESCAM::GetClangPorts::getInSharedPortMap() const {
  return in_shared_port_map_;
}

const std::map<std::string, std::string> &DESCAM::GetClangPorts::getOutSharedPortMap() const {
  return out_shared_port_map_;
}

const std::map<std::string, std::string> &DESCAM::GetClangPorts::getSlaveInPortMap() const {
  return slave_in_port_map_;
}

const std::map<std::string, std::string> &DESCAM::GetClangPorts::getSlaveOutPortMap() const {
  return slave_out_port_map_;
}

const std::map<std::string, std::string> &DESCAM::GetClangPorts::getMasterInPortMap() const {
  return master_in_port_map_;
}

const std::map<std::string, std::string> &DESCAM::GetClangPorts::getMasterOutPortMap() const {
  return master_out_port_map_;
}

const std::map<std::string, DESCAM::LocationInfo> &DESCAM::GetClangPorts::getLocationInfoMap() const {
  return this->port_location_info_map_;
}

#include "GetClangPorts.h"