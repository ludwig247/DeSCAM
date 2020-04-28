#include <iostream>
#include <clang/AST/PrettyPrinter.h>
#include "FindPorts.h"
#include "FindNewDatatype.h"
#include "FatalError.h"
#include "Logger/Logger.h"


namespace SCAM {
    /*!
    * \brief Methods that checks wheter a subString is contained in a given String
     */
    bool containsSubstring(std::string fullString, std::string subString) {
        if (fullString.size() == 0) {
            return false;
        }
        if (fullString.find(subString) < fullString.size()) {
            return true;
        }
        return false;
    }

    //Constructor
    FindPorts::FindPorts(clang::CXXRecordDecl *recordDecl, const clang::ASTContext &context) :
            context(context),
            pass(0) {
        TraverseDecl(recordDecl);
        //recordDecl->dump();
    }

    //Destructor
    FindPorts::~FindPorts() {

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
bool FindPorts::VisitFieldDecl(clang::FieldDecl *fieldDecl) {
        clang::QualType qualType = fieldDecl->getType();
        //Synch: find by name, doesn't have a parameter
        if (const clang::TemplateSpecializationType *templateClass = llvm::dyn_cast<clang::TemplateSpecializationType>(
                qualType.getTypePtr())) {
            //In order to have a port there needs to be a qualType with 3 parameters
            //Dissassemble the template
            portTemplates.clear();
            this->recursiveTemplateVisitor(qualType);
            //Determine type of port:
            if (portTemplates.size() == 2) {
                //if (portTemplates.at(0) == "sc_port" && portTemplates.at(1) == "rendezvous_out_if") {
                if (portTemplates.at(0) == "blocking_out") {
                    this->outPortMap.insert(std::make_pair(fieldDecl->getNameAsString(), portTemplates.at(1)));
                }
                else if (portTemplates.at(0) == "blocking_in") {
                    this->inPortMap.insert(std::make_pair(fieldDecl->getNameAsString(), portTemplates.at(1)));
                }
                else if (portTemplates.at(0) == "master_out") {
                    this->masterOutPortMap.insert(std::make_pair(fieldDecl->getNameAsString(), portTemplates.at(1)));
                }
                else if (portTemplates.at(0) == "master_in") {
                    this->masterInPortMap.insert(std::make_pair(fieldDecl->getNameAsString(), portTemplates.at(1)));
                }
                else if (portTemplates.at(0) == "slave_in") {
                    this->slaveInPortMap.insert(std::make_pair(fieldDecl->getNameAsString(), portTemplates.at(1)));
                }
                else if (portTemplates.at(0) == "slave_out") {
                    this->slaveOutPortMap.insert(std::make_pair(fieldDecl->getNameAsString(), portTemplates.at(1)));
                }
                else if (portTemplates.at(0) == "shared_in") {
                    this->inSharedPortMap.insert(std::make_pair(fieldDecl->getNameAsString(), portTemplates.at(1)));

                }
                else if (portTemplates.at(0) == "shared_out") {
                    this->outSharedPortMap.insert(std::make_pair(fieldDecl->getNameAsString(), portTemplates.at(1)));
                }else{
                    TERMINATE("Unknown interface: " + portTemplates.at(0));
                }
            }
        }
        return true;
    }


    void FindPorts::recursiveTemplateVisitor(clang::QualType qualType) {
        //Is there another template class?
        if (const clang::TemplateSpecializationType *templateClass = llvm::dyn_cast<clang::TemplateSpecializationType>(
                qualType.getTypePtr())) {

            //Get name of the template class
            std::string templateName;
            llvm::raw_string_ostream templateNameStream(templateName);
            //Dump name into stream
            templateClass->getTemplateName().dump(templateNameStream);
            //Get string from stream and add to vector
            this->portTemplates.push_back(templateNameStream.str());
            for (int i = 0; i < templateClass->getNumArgs(); i++) {
                clang::TemplateArgument templateArgument = templateClass->getArg(i);
                if(templateArgument.getKind() ==  clang::TemplateArgument::ArgKind::Expression){
                    clang::Expr * expr = templateArgument.getAsExpr();
                    if (const clang::IntegerLiteral * value = llvm::dyn_cast<clang::IntegerLiteral>(expr)) {
                        //if(this->portTemplates.at(0) != "sc_uint") TERMINATE("Type: " + this->portTemplates.at(0) + " is not allowed");
                        this->portTemplates.push_back(std::to_string(value->getValue().getSExtValue()));
                    }else TERMINATE("Expr is not an integer");
                }else{
                    this->recursiveTemplateVisitor(templateArgument.getAsType());
                }
            }
        }
            //Type of port int, bool, struct ...
        else if (qualType.isCanonical()) {
            this->portTemplates.push_back(FindNewDatatype::getTypeName(qualType));
        }
        return;


    }

    const std::map<std::string, std::string> &FindPorts::getInPortMap() const {
        return inPortMap;
    }

    const std::map<std::string, std::string> &FindPorts::getOutPortMap() const {
        return outPortMap;
    }

    const std::map<std::string, std::string> &FindPorts::getInSharedPortMap() const {
        return inSharedPortMap;
    }

    const std::map<std::string, std::string> &FindPorts::getOutSharedPortMap() const {
        return outSharedPortMap;
    }

    const std::map<std::string, std::string> &FindPorts::getSlaveInPortMap() const {
        return slaveInPortMap;
    }

    const std::map<std::string, std::string> &FindPorts::getSlaveOutPortMap() const {
        return slaveOutPortMap;
    }

    const std::map<std::string, std::string> &FindPorts::getMasterInPortMap() const {
        return masterInPortMap;
    }

    const std::map<std::string, std::string> &FindPorts::getMasterOutPortMap() const {
        return masterOutPortMap;
    }

}


