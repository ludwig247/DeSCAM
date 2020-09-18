//
// Created by ludwig on 09.11.15.
//

#include <sstream>
#include <Stmts/IntegerValue.h>
#include <PrintStmt.h>
#include <OperationOptimizations/AssignmentOptimizer2.h>
#include "FindInitalValues.h"
#include "FindNewDatatype.h"
#include "FindDataFlow.h"

bool DESCAM::FindInitalValues::VisitCXXConstructorDecl(clang::CXXConstructorDecl *constructorDecl) {
    //Check whether constructor body is empty
    int cnt = 0;
    for (auto it = constructorDecl->getBody()->children().first; it != constructorDecl->getBody()->children().second; it++) {
        cnt++;
        if (cnt > 2)
            TERMINATE("The body of the constructor has to remain empty and is not analyzed."
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
                auto variable = fieldDecl;
                //If type is compound -> skip
                //Find values
                if(varName == variable->getName().str()){
                    auto type = variable->getType();
                    if (!type->isBuiltinType() && !type->isEnumeralType()) {
                        std::cout << "-I- Default init value for variable " << varName << std::endl;
                        continue;
                    }
                    //Find value and store in this->value
                    //If something goes wrong
                    try {
                        FindDataFlow findDataFlow(initializer->getInit(), module, ci);

                        auto initExpr = findDataFlow.getExpr();
                        if (initExpr != nullptr) {
                                //Part start:
                                DataType * place_holder_type = const_cast<DataType*>(initExpr->getDataType());
                                Variable place_holder_variable("foo",place_holder_type);
                                VariableOperand variableOperand(&place_holder_variable);
                                auto assignment = Assignment(&variableOperand, findDataFlow.getExpr());
                                auto result = DESCAM::AssignmentOptimizer2::optimizeAssignment(&assignment, module);
                                if (auto *valueT = dynamic_cast<ConstValue *>(result->getRhs())) {
                                    this->initValue = valueT;
                                } else TERMINATE("All intializer are required to have a constant value");

                        } else std::cout << "-I- Default init value for variable " << varName << std::endl;
                    } catch (std::runtime_error error) {
                        std::string msg = "Error for initialization of variable " + varName;
                        TERMINATE(msg + error.what());
                    }
                }
            }
        }
    }else TERMINATE("Only one constructor allowed");

    return false;
}


DESCAM::FindInitalValues::FindInitalValues(clang::CXXRecordDecl *recordDecl, clang::FieldDecl * fieldDecl, DESCAM::Module *module, clang::CompilerInstance& ci):
    module(module),
    fieldDecl(fieldDecl),
    initValue(nullptr),
    ci(ci),
    pass(0) {
    TraverseDecl(recordDecl);

}

DESCAM::ConstValue *DESCAM::FindInitalValues::getInitValue(clang::CXXRecordDecl *recordDecl, clang::FieldDecl *fieldDecl, DESCAM::Module *module, clang::CompilerInstance& ci) {
    FindInitalValues findInitalValues(recordDecl,fieldDecl,module,ci);
    return findInitalValues.initValue;
}


