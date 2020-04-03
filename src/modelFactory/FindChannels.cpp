//
// Created by schmitz on 26.03.20.
//

#include "FindChannels.h"

#include <iostream>
#include <clang/AST/PrettyPrinter.h>
#include "FindNewDatatype.h"

namespace SCAM {


    //Constructor
    FindChannels::FindChannels(clang::CXXRecordDecl *recordDecl, const clang::ASTContext &context) :
            context(context),
            pass(0) {
        TraverseDecl(recordDecl);
        //recordDecl->dump();
    }

    //Destructor
    FindChannels::~FindChannels() {

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
    bool FindChannels::VisitFieldDecl(clang::FieldDecl *fieldDecl) {
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
                if (portTemplates.at(0) == "Shared") {
                    std::cout<< "Found Shared Channel" << std::endl;
                    this->SharedChannelMap.insert(std::make_pair(fieldDecl->getNameAsString(), portTemplates.at(1)));

                } else if (portTemplates.at(0) == "Blocking") {
                    std::cout<< "Found Blocking Channel" << std::endl;
                    this->BlockingChannelMap.insert(std::make_pair(fieldDecl->getNameAsString(), portTemplates.at(1)));

                }else{
                    throw std::runtime_error("Unknown interface: " + portTemplates.at(0));
                }
            }
        }
        return true;
    }


    void FindChannels::recursiveTemplateVisitor(clang::QualType qualType) {
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
                        //if(this->portTemplates.at(0) != "sc_uint") throw std::runtime_error("Type: " + this->portTemplates.at(0) + " is not allowed");
                        this->portTemplates.push_back(std::to_string(value->getValue().getSExtValue()));
                    }else throw std::runtime_error("Expr is not an integer");
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

    const std::map<std::string, std::string> &FindChannels::getBlockingChannelMap() const {
        return BlockingChannelMap;
    }

    const std::map<std::string, std::string> &FindChannels::getSharedChannelMap() const {
        return SharedChannelMap;
    }

}


