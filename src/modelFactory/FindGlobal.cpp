//
// Created by tobias on 13.11.19.
//

#include <iostream>
#include "FindGlobal.h"
#include "FindDataFlow.h"
#include "FindNewDatatype.h"

SCAM::FindGlobal::FindGlobal(clang::TranslationUnitDecl *decl, SCAM::Module *module) :
        decl(decl),
        module(module) {
    assert(!(decl == NULL));
    TraverseDecl(decl);

}

bool SCAM::FindGlobal::VisitVarDecl(const clang::VarDecl *varDecl) {
    auto type = varDecl->getType();
    auto isConst = type.isConstant(decl->getASTContext());
    auto isBuiltIn = type->isBuiltinType();

    if (isConst && isBuiltIn) {
        if (varDecl->getAnyInitializer(varDecl) != nullptr) {

            auto init = varDecl->getAnyInitializer(varDecl)->IgnoreImpCasts();
            if (init->getType()->isBuiltinType()) {
                auto isUnsigned = varDecl->getType()->isUnsignedIntegerType();
                try {
                    FindDataFlow checkForExpr(const_cast<clang::Expr *>(init), module, isUnsigned);
                    ErrorMsg::clear();
                    if (checkForExpr.getExpr()) {
                        std::string typeName = init->getType().getAsString();
                        if (typeName == "_Bool") typeName = "bool";
                        else if (varDecl->getType()->isUnsignedIntegerType()) {
                            typeName = "unsigned";
                        } else if (varDecl->getType()->isIntegerType()) {
                            typeName = "int";
                        } else throw std::runtime_error("unsupported type");

                        std::string name = varDecl->getName().str();
                        std::string value = PrintStmt::toString(checkForExpr.getExpr());

                        //Determine type
                        auto type = varDecl->getType();
                        DataType *descam_type;
                        if (type.isConstant(decl->getASTContext())) {
                            if (type->isBooleanType()) descam_type = DataTypes::getDataType("bool");
                            else if (type->isUnsignedIntegerType()) descam_type = DataTypes::getDataType("unsigned");
                            else if (type->isIntegerType()) descam_type = DataTypes::getDataType("int");
                            else throw std::runtime_error("Type: " + type.getAsString() + " for var " + name + " is not allowed");
                        }

                        //Types have to be equivalent
                        if(checkForExpr.getExpr()->getDataType() == descam_type){
                            //set initval && create new global constant variable
                            if (auto initVal = dynamic_cast<ConstValue *>(checkForExpr.getExpr())) {
                                auto var = new Variable(name, descam_type, initVal);
                                var->setConstant(true);
                                this->variableMap.insert(std::make_pair(name, var));
                            }else {
                                //std::cout << "Global variable: " << name << " with value " << PrintStmt::toString(checkForExpr.getExpr()) << " is not added as global var." << std::endl;
                                //std::cout << "The reason is that the initialvalue has to be of constant and simple type without expressions of any kind" << std::endl;
                                //FIXME move back to exception
                                //throw std::runtime_error("Init value has to be const");
                            }
                        }
                    }
                } catch (std::runtime_error e) {
                    std::cout << e.what() << std::endl;

                }

            }
        }
    }
    return true;
}

const std::map<std::string, SCAM::Variable *> &SCAM::FindGlobal::getVariableMap() const {
    return variableMap;
}

bool SCAM::FindGlobal::VisitFunctionDecl(const clang::FunctionDecl *funDecl) {

    std::string name = funDecl->getNameAsString();

    auto valid_result_type = [=](){
        auto res = funDecl->getResultType();
        return((res->isIntegerType()||res->isBooleanType()) && !res->isReferenceType() && !res->isAnyPointerType());

    };

    auto valid_function_type = [=](){
        return funDecl->isGlobal() && funDecl->isUsed() && funDecl->getResultType()->isBuiltinType()  && !funDecl->isCXXClassMember();
    };

    auto valid_parameters = [=](){
        for(int i=0;i<funDecl->getNumParams();i++) {
            auto type = funDecl->getParamDecl((i))->getType();
            if (type->isReferenceType() || type->isAnyPointerType()) {
                return false;
                if (!type->isIntegerType() && !type->isBooleanType()) {

                }
            }
        }
        return true;
    };

    if(result_type() && fun_type()){

        }
        funDecl->dumpColor();
    }
    return true;
}

