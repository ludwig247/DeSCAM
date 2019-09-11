//
// Created by ludwig on 09.11.15.
//

#include <sstream>
#include <Stmts/IntegerValue.h>
#include <Stmts/BoolValue.h>
#include <PrintStmt.h>
#include <toPPA/DataPathOptimizer.h>
#include "FindInitalValues.h"
#include "FindNewDatatype.h"
#include "FindDataFlow.h"

SCAM::FindInitalValues::FindInitalValues(clang::CXXRecordDecl *recordDecl, const std::map<std::string, clang::FieldDecl *> &variableMap,
                                         SCAM::Module *module) :
        variableMap(variableMap),
        module(module),
        pass(0) {
    TraverseDecl(recordDecl);
}

bool SCAM::FindInitalValues::VisitCXXConstructorDecl(clang::CXXConstructorDecl *constructorDecl) {
    //Check whether constructor body is empty
    int cnt = 0;
    for (auto it = constructorDecl->getBody()->children().first; it != constructorDecl->getBody()->children().second; it++) {
        cnt++;
        if (cnt > 2)
            throw std::runtime_error("The body of the constructor has to remain empty and is not analyzed."
                                     "\n Please use a section to initialize your systems instead of the constructor body\n");
    }
    //Only one Constructor allowed
    if (pass == 0) {
        //Increase pass
        pass = 1;
        //Iterate over each initializer of initializerlist
        for (clang::CXXConstructorDecl::init_iterator initList = constructorDecl->init_begin();
             initList != constructorDecl->init_end(); initList++) {
            clang::CXXCtorInitializer *initializer = *initList;
            //Check whether initializer intializes a member: other possibilites are base classes ...
            if (initializer->isMemberInitializer()) {
                //Name of member
                std::string varName = initializer->getMember()->getNameAsString();
                //Find Variable in Variable(not ports) and assign initial value
                auto variable = variableMap.find(varName);
                //If type is compound -> skip
                //Find values
                if (variable != variableMap.end()) {
                    auto type = variable->second->getType();
                    if (!type->isBuiltinType() && !type->isEnumeralType()) {
                        std::cout << "-I- Default init value for variable " << varName << std::endl;
                        continue;
                    }
                    //Find value and store in this->value
                    //If something goes wrong
                    try {
                        FindDataFlow findDataFlow(initializer->getInit(), module);
                        if (findDataFlow.getExpr() != nullptr) {
                            auto assignment = Assignment(findDataFlow.getExpr(), findDataFlow.getExpr());
                            auto result = DataPathOptimizer::optimize(&assignment, module);
                            if (auto *valueT = dynamic_cast<ConstValue *>(result->getRhs())) {
                                this->variableInitialMap.insert(std::make_pair(varName, valueT));
                            } else throw std::runtime_error("All intializer are required to have a constant value");

                        } else std::cout << "-I- Default init value for variable " << varName << std::endl;
                    } catch (std::runtime_error error) {
                        std::string msg = "Error for initialization of variable " + varName + " ";
                        throw std::runtime_error(msg + error.what());
                    }
                }
            }
        }
    }else throw std::runtime_error("Only one constructor allowed");

    return false;
}


const std::map<std::string, SCAM::ConstValue *> &SCAM::FindInitalValues::getVariableInitialMap() const {
    return variableInitialMap;
}

