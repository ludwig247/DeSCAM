//
// Created by tobias on 23.10.15.
//


#include <UnaryExpr.h>
#include <While.h>
#include <If.h>
#include <BoolValue.h>
#include <SectionOperand.h>
#include <SectionValue.h>
#include <Arithmetic.h>

#include <clang/Lex/Lexer.h>
#include <Stmts/VariableOperand.h>
#include <Stmts/IntegerValue.h>
#include <Stmts/Read.h>
#include <Stmts/Write.h>
//#include <Stmts/NBRead.h>
//#include <Stmts/NBWrite.h>
#include <Stmts/Logical.h>
#include <Stmts/Relational.h>
#include <Stmts/Cast.h>
#include <ExprVisitor.h>
#include <NodePeekVisitor.h>
#include <ModelGlobal.h>
#include "PortOperand.h"
#include "FindDataFlow.h"
#include "FindStateName.h"

bool SCAM::FindDataFlow::isFunction = false;
std::string SCAM::FindDataFlow::functionName = "";

SCAM::FindDataFlow::FindDataFlow(clang::Stmt *stmt, Module *module, bool unsigned_flag) :
        module(module),
        stmt(nullptr),
        expr(nullptr),
        rhsExpr(nullptr),
        lhsExpr(nullptr),
        unsigned_flag(unsigned_flag),
        pass(0) {

    //stmt->dump();

    TraverseStmt(stmt);


}

bool SCAM::FindDataFlow::VisitBinaryOperator(clang::BinaryOperator *binaryOperator) {
    //Binary Expression is always TOP statement. In case of a substmt, new FindDataFlow object is neccesary
    if (pass == 0) {
        //OperationName
        std::string operationName = binaryOperator->getOpcodeStr().str();
        //Pass = 1 LHS
        //LHS Operator
        FindDataFlow findLHS(binaryOperator->getLHS(), this->module, unsigned_flag);
        this->lhsExpr = findLHS.getExpr();
        //RHS Operator
        FindDataFlow findRHS(binaryOperator->getRHS(), this->module, unsigned_flag);
        this->rhsExpr = findRHS.getExpr();


        //Are LHS and RHS Valid?
        //if (this->rhs == nullptr || this->lhs == nullptr) return exitVisitor("Could not translate LHS or RHS of Stmts");
        if (this->rhsExpr == nullptr || this->lhsExpr == nullptr) {
            if (this->rhsExpr == nullptr && this->lhsExpr != nullptr) {
                return exitVisitor("Could not translate  RHS of Stmts");
            } else if (this->rhsExpr != nullptr && this->lhsExpr == nullptr)
                return exitVisitor("Could not translate  LHS of Stmts");
            else return exitVisitor("Could not translate  LHS and RHS of Stmts");
        }
        //Create new Element
        switch (binaryOperator->getOpcode()) {
            case clang::BinaryOperator::Opcode::BO_Assign:
                this->stmt = new Assignment(this->lhsExpr, this->rhsExpr);
                break;
            case clang::BinaryOperator::Opcode::BO_LAnd:
                this->expr = new Logical(this->lhsExpr, "and", this->rhsExpr);
                break;
            case clang::BinaryOperator::Opcode::BO_LOr:
                this->expr = new Logical(this->lhsExpr, "or", this->rhsExpr);
                break;
            case clang::BinaryOperator::Opcode::BO_EQ:
                this->expr = new Relational(this->lhsExpr, operationName, this->rhsExpr);
                break;
            case clang::BinaryOperator::Opcode::BO_NE:
                this->expr = new Relational(this->lhsExpr, operationName, this->rhsExpr);
                break;
            case clang::BinaryOperator::Opcode::BO_GE:
                this->expr = new Relational(this->lhsExpr, operationName, this->rhsExpr);
                break;
            case clang::BinaryOperator::Opcode::BO_LE:
                this->expr = new Relational(this->lhsExpr, operationName, this->rhsExpr);
                break;
            case clang::BinaryOperator::Opcode::BO_GT:
                this->expr = new Relational(this->lhsExpr, operationName, this->rhsExpr);
                break;
            case clang::BinaryOperator::Opcode::BO_LT:
                this->expr = new Relational(this->lhsExpr, operationName, this->rhsExpr);
                break;
            case clang::BinaryOperator::Opcode::BO_Add:
                this->expr = new Arithmetic(this->lhsExpr, operationName, this->rhsExpr);
                break;
            case clang::BinaryOperator::Opcode::BO_Div:
                this->expr = new Arithmetic(this->lhsExpr, operationName, this->rhsExpr);
                break;
            case clang::BinaryOperator::Opcode::BO_Rem:
                this->expr = new Arithmetic(this->lhsExpr, operationName, this->rhsExpr);
                break;
            case clang::BinaryOperator::Opcode::BO_Mul:
                this->expr = new Arithmetic(this->lhsExpr, operationName, this->rhsExpr);
                break;
            case clang::BinaryOperator::Opcode::BO_Sub:
                this->expr = new Arithmetic(this->lhsExpr, operationName, this->rhsExpr);
                break;
            case clang::BinaryOperator::Opcode::BO_AddAssign:
                this->stmt = new Assignment(this->lhsExpr, new Arithmetic(this->lhsExpr, "+", this->rhsExpr));
                break;
            case clang::BinaryOperator::Opcode::BO_SubAssign:
                this->stmt = new Assignment(this->lhsExpr, new Arithmetic(this->lhsExpr, "-", this->rhsExpr));
                break;
            case clang::BinaryOperator::Opcode::BO_MulAssign:
                this->stmt = new Assignment(this->lhsExpr, new Arithmetic(this->lhsExpr, "*", this->rhsExpr));
                break;
            case clang::BinaryOperator::Opcode::BO_DivAssign:
                this->stmt = new Assignment(this->lhsExpr, new Arithmetic(this->lhsExpr, "/", this->rhsExpr));
                break;
            case clang::BinaryOperator::Opcode::BO_Shl:
                //Special case ... shiftings depends on LHS Datatype
                if (binaryOperator->getType()->isUnsignedIntegerType()) {
                    FindDataFlow findRHS(binaryOperator->getRHS(), this->module, true);
                    this->rhsExpr = findRHS.getExpr();
                }
                this->expr = new Bitwise(this->lhsExpr, "<<", this->rhsExpr);
                break;
            case clang::BinaryOperator::Opcode::BO_Shr:
                //Special case ... shiftings depends on LHS Datatype
                if (binaryOperator->getType()->isUnsignedIntegerType()) {
                    FindDataFlow findRHS(binaryOperator->getRHS(), this->module, true);
                    this->rhsExpr = findRHS.getExpr();
                }
                this->expr = new Bitwise(this->lhsExpr, ">>", this->rhsExpr);
                break;
            case clang::BinaryOperator::Opcode::BO_And:
                this->expr = new Bitwise(this->lhsExpr, "&", this->rhsExpr);
                break;
            case clang::BinaryOperator::Opcode::BO_Or:
                this->expr = new Bitwise(this->lhsExpr, "|", this->rhsExpr);
                break;
            case clang::BinaryOperator::Opcode::BO_Xor:
                this->expr = new Bitwise(this->lhsExpr, "^", this->rhsExpr);
                break;
            default:
                this->exitVisitor("Operator " + operationName + " not defined");
                break;
        }
        return false;

    }
    return true;
}


bool SCAM::FindDataFlow::VisitCXXMemberCallExpr(clang::CXXMemberCallExpr *memberCallExpr) {
    //Call: ->write(argument)
    if (pass == 0) {
        //Return value:
        std::string returnValue = memberCallExpr->getCallReturnType().getAsString();
        //Callee: E.g. x.foo() -> foo() is callee
        //Assign CalleeOperator later for now store string
        std::string methodString;
        //Supported interface methods
        std::vector<std::string> supportedMethods = {"read", "write", "try_read", "try_write", "master_read",
                                                     "master_write", "slave_read", "slave_write", "set", "get", "wait",
                                                     "peek", "poke"};
        auto functions = module->getFunctionMap();
        if (clang::MemberExpr *memberExpr = llvm::dyn_cast<clang::MemberExpr>(memberCallExpr->getCallee())) {
            //Assign name of the method
            methodString = memberExpr->getMemberDecl()->getNameAsString();
            //Check whether method is supported, if not -> Bad Stmts
            if (std::find(supportedMethods.begin(), supportedMethods.end(), methodString) != supportedMethods.end()) {
//                this->pass = 1;
                //Including a wait, but onyl with SC_ZERO_TIME
                if (methodString == "wait") {
                    if (memberCallExpr->getNumArgs() == 2) {
                        SCAM::FindDataFlow firstArgument(memberCallExpr->getArg(0), this->module, false);
                        SCAM::FindDataFlow secondArgument(memberCallExpr->getArg(1), this->module, false);
                        this->stmt = new Wait(); //FIXME: don't know how to check for the arguments or if needed to begin with
                        return false;
                    } else return exitVisitor("Only wait(0) is allowed");
                } else this->pass = 1;
                //Function
            } else if (functions.find(methodString) != functions.end()) {
                //Analyse paramter
                auto function = functions.find(methodString)->second;
                std::map<std::string, SCAM::Expr *> paramValueMap;
                for (int i = 0; i < memberCallExpr->getNumArgs(); i++) {
                    std::string paramName = memberCallExpr->getMethodDecl()->getParamDecl(i)->getName();
                    SCAM::FindDataFlow findArgument(memberCallExpr->getArg(i), this->module, false);
                    if (findArgument.getExpr() == nullptr)
                        return exitVisitor(methodString + "() has unsupported params");
                    SCAM::Expr *paramExpr = findArgument.getExpr();
                    paramValueMap.insert(std::make_pair(paramName, paramExpr));
                }
                this->expr = new FunctionOperand(function, paramValueMap);
                this->stmt = this->expr;

                return false;
            } else {
                return exitVisitor(methodString + "() is not a supported method!");
            }
        } else return exitVisitor("[ADD StmtToStringHere] not a Variable");

        //Search for member that is called on [e.G. x.foo(), find x]
        TraverseStmt(memberCallExpr->getImplicitObjectArgument());

        if (this->lhsExpr != nullptr) {
            if (PortOperand *operand = dynamic_cast<PortOperand *>(this->lhsExpr)) {

                auto interface = operand->getPort()->getInterface();
                if (interface->isBlocking()) {
                    //Blocking read
                    if (methodString == "read" && memberCallExpr->getNumArgs() == 1) {
                        SCAM::FindDataFlow findArgument(memberCallExpr->getArg(0), this->module, false);
                        if (findArgument.getExpr() != nullptr) {
                            //add variable as parameter
                            if (VariableOperand *variableOp = dynamic_cast<VariableOperand *>(findArgument.getExpr())) {
                                this->stmt = new Read(operand->getPort(), variableOp);
                            } else return exitVisitor("Could not dynamically cast argument as VariableOperand");
                        } else return exitVisitor("Could not find parameter");
                    }
                        //non Blocking read
                    else if (methodString == "try_read" && memberCallExpr->getNumArgs() == 1) {
                        SCAM::FindDataFlow findArgument(memberCallExpr->getArg(0), this->module, false);
                        if (findArgument.getExpr() != nullptr) {
                            //add variable as parameter
                            if (VariableOperand *variableOp = dynamic_cast<VariableOperand *>(findArgument.getExpr())) {
                                this->stmt = new Read(operand->getPort(), variableOp, true);
                            } else return exitVisitor("Could not dynamically cast argument as VariableOperand");
                        } else return exitVisitor("Could not find parameter");
                    }
                        //non Blocking read with status flag
                    else if (methodString == "try_read" && memberCallExpr->getNumArgs() == 2) {
                        SCAM::FindDataFlow findVariable(memberCallExpr->getArg(0), this->module, false);
                        SCAM::FindDataFlow findStatus(memberCallExpr->getArg(1), this->module, false);
                        if ((findVariable.getExpr() != nullptr) && (findStatus.getExpr() != nullptr)) {
                            //add variable as parameter
                            if (auto *variableOp = dynamic_cast<VariableOperand *>(findVariable.getExpr())) {
                                if (auto *statusOp = dynamic_cast<VariableOperand *>(findStatus.getExpr())) {
                                    this->stmt = new Read(operand->getPort(), variableOp, true, statusOp);
                                } else return exitVisitor("Could not dynamically cast argument as VariableOperand");
                            } else return exitVisitor("Could not dynamically cast argument as VariableOperand");
                        } else return exitVisitor("Could not find parameter");
                    }
                        //Blocking write
                    else if (methodString == "write" && memberCallExpr->getNumArgs() == 1) {
                        if (memberCallExpr->getNumArgs() == 1) {
                            SCAM::FindDataFlow findArgument(memberCallExpr->getArg(0), this->module,
                                                            operand->getDataType()->isUnsigned());
                            if (findArgument.getExpr() != nullptr) {
                                this->stmt = new Write(operand->getPort(), findArgument.getExpr());
                            } else return exitVisitor("Could not find parameter");
                        } else return exitVisitor("Only one parameter for write(obj) supported");
                    }
                        //non Blocking write
                    else if (methodString == "try_write" && memberCallExpr->getNumArgs() == 1) {
                        SCAM::FindDataFlow findArgument(memberCallExpr->getArg(0), this->module,
                                                        operand->getDataType()->isUnsigned());
                        if (findArgument.getExpr() != nullptr) {
                            this->stmt = new Write(operand->getPort(), findArgument.getExpr(), true);
                        } else return exitVisitor("Could not find parameter");
                    }
                        //non Blocking write with status flag
                    else if (methodString == "try_write" && memberCallExpr->getNumArgs() == 2) {
                        SCAM::FindDataFlow findValue(memberCallExpr->getArg(0), this->module,
                                                     operand->getDataType()->isUnsigned());
                        SCAM::FindDataFlow findStatus(memberCallExpr->getArg(1), this->module,
                                                      operand->getDataType()->isUnsigned());
                        if ((findValue.getExpr() != nullptr) && (findStatus.getExpr() != nullptr)) {
                            if (auto *statusOp = dynamic_cast<VariableOperand *>(findStatus.getExpr())) {
                                this->stmt = new Write(operand->getPort(), findValue.getExpr(), true, statusOp);
                            } else return exitVisitor("Could not dynamically cast argument as VariableOperand");
                        } else return exitVisitor("Could not find parameter");
                    }
                        //Peek peek()
                    else if (methodString == "peek" && memberCallExpr->getNumArgs() == 0) {
                        this->expr = new Peek(operand->getPort());
                    }
                        //Peek poke()
                    else if (methodString == "poke" && memberCallExpr->getNumArgs() == 0) {
                        this->expr = new Peek(operand->getPort());
                    } else
                        return exitVisitor(
                                "Unsupported method: " + methodString + " for interface " + interface->getName());

                } else if (interface->isShared()) {
                    if (methodString == "get" && memberCallExpr->getNumArgs() == 1) {
                        SCAM::FindDataFlow findArgument(memberCallExpr->getArg(0), this->module, false);
                        if (findArgument.getExpr() != nullptr) {
                            if (auto *variableOp = dynamic_cast<VariableOperand *>(findArgument.getExpr())) {
                                this->stmt = new Read(operand->getPort(), variableOp, true);
                            } else return exitVisitor("Read argument is not a variable!");
                        } else return exitVisitor("Could not find parameter");
                    } else if (methodString == "set") {
                        SCAM::FindDataFlow findArgument(memberCallExpr->getArg(0), this->module,
                                                        operand->getDataType()->isUnsigned());
                        if (findArgument.getExpr() != nullptr) {
                            this->stmt = new Write(operand->getPort(), findArgument.getExpr(), true);
                        } else return exitVisitor("Could not find parameter");
                    } else
                        return exitVisitor(
                                "Unsupported method: " + methodString + " for interface " + interface->getName());

                } else if (interface->isMaster()) {
                    if (methodString == "master_read" && memberCallExpr->getNumArgs() == 1) {
                        SCAM::FindDataFlow findArgument(memberCallExpr->getArg(0), this->module, false);
                        if (findArgument.getExpr() != nullptr) {
                            if (auto *variableOp = dynamic_cast<VariableOperand *>(findArgument.getExpr())) {
                                this->stmt = new Read(operand->getPort(), variableOp);
                            } else return exitVisitor("Could not dynamically cast argument as VariableOperand");
                        } else return exitVisitor("Could not find parameter");
                    } else if (methodString == "master_write") {
                        SCAM::Write * write;
                        assert(memberCallExpr->getNumArgs() > 0 && memberCallExpr->getNumArgs() < 3 &&  "Wrong number of arguments arguments");
                        SCAM::FindDataFlow findArgument(memberCallExpr->getArg(0), this->module,
                                                        operand->getDataType()->isUnsigned());
                        if (findArgument.getExpr() != nullptr) {
                            write = new Write(operand->getPort(), findArgument.getExpr());
                        } else return exitVisitor("Argument 1 is not analyzeable");
                        if (memberCallExpr->getNumArgs() == 2) {
                            FindStateName findStateName(memberCallExpr->getArg(1));
                            if(findStateName.hasStateName()){
                                write->setStateName(findStateName.getStateName());
                            }
                        }
                        this->stmt = write;


                    } else {
                        memberCallExpr->dumpColor();
                        return exitVisitor(
                                "Unsupported method: " + methodString + " for interface " + interface->getName());
                    }

                } else if (interface->isSlave()) {
                    if (methodString == "slave_read" && memberCallExpr->getNumArgs() == 1) {
                        SCAM::FindDataFlow findArgument(memberCallExpr->getArg(0), this->module, false);
                        if (findArgument.getExpr() != nullptr) {
                            if (VariableOperand *variableOp = dynamic_cast<VariableOperand *>(findArgument.getExpr())) {
                                this->stmt = new Read(operand->getPort(), variableOp, true);
                            } else return exitVisitor("Could not dynamically cast argument as VariableOperand");
                        } else return exitVisitor("Could not find parameter");
                    } else if (methodString == "slave_read" && memberCallExpr->getNumArgs() == 2) {
                        SCAM::FindDataFlow findVariable(memberCallExpr->getArg(0), this->module, false);
                        SCAM::FindDataFlow findStatus(memberCallExpr->getArg(1), this->module, false);
                        if ((findVariable.getExpr() != nullptr) && (findStatus.getExpr() != nullptr)) {
                            if (auto *variableOp = dynamic_cast<VariableOperand *>(findVariable.getExpr())) {
                                if (auto *statusOp = dynamic_cast<VariableOperand *>(findStatus.getExpr())) {
                                    this->stmt = new Read(operand->getPort(), variableOp, true, statusOp);
                                } else return exitVisitor("Could not dynamically cast argument as VariableOperand");
                            } else return exitVisitor("Could not dynamically cast argument as VariableOperand");
                        } else return exitVisitor("Could not find parameter");
                    } else if (methodString == "slave_write" && memberCallExpr->getNumArgs() == 1) {
                        SCAM::FindDataFlow findArgument(memberCallExpr->getArg(0), this->module,
                                                        operand->getDataType()->isUnsigned());
                        if (findArgument.getExpr() != nullptr) {
                            this->stmt = new Write(operand->getPort(), findArgument.getExpr(), true);
                        } else return exitVisitor("Could not find parameter");
                    } else
                        return exitVisitor(
                                "Unsupported method: " + methodString + "for interface " + interface->getName());

                } else { return exitVisitor("Unknown interface: " + interface->getName()); }
            } else {
                std::cout << "couldn't dynamically cast this->lhsExpr to portOperand\n";
            }

        }
        //FIXME: else cause memory consumption issues
//        }else{
        //Object analyzed
        return false;
//        }
    }
    //Here only if object is LHS or RHS
    //Membercall: obj->
    if (pass == 1) {
        FindDataFlow findMemberCall(memberCallExpr, this->module, false);
        this->lhsExpr = findMemberCall.getExpr();
    }
    //Case  var = x.foo(); RHS of operator
    //RHS is a Call
    if (pass == 2) {
        FindDataFlow findMemberCall(memberCallExpr, this->module, false);
        this->rhsExpr = findMemberCall.getExpr();
        return false;
    }
    return true;
}


//Import here: Search for Compound variables first
bool SCAM::FindDataFlow::VisitMemberExpr(clang::MemberExpr *memberExpr) {
    //Name of memberfield
    std::string name = memberExpr->getMemberDecl()->getName();
    if (name == "") throw std::runtime_error(" Empty name ");

    //Get mememberMap for module
    const std::map<std::string, Variable *> &memberMap = module->getVariableMap();
    auto globalVariableMap = ModelGlobal::getModel()->getGlobalVariableMap();

    const std::map<std::string, Function *> &functionMap = module->getFunctionMap();

    // Determine name for compound: var.x;
    FindDataFlow findParentOfSubVar((*memberExpr->child_begin()), this->module, false);
    if (findParentOfSubVar.getExpr() != nullptr) {
        //FIXME: Get rid of subvars by also using ArrayOperand on compound variables
        if (SCAM::VariableOperand *parent = dynamic_cast<SCAM::VariableOperand *>(findParentOfSubVar.getExpr())) {
            if (memberMap.find(parent->getOperandName()) != memberMap.end()) {
                //Assign value
                this->switchPassExpr(new VariableOperand(memberMap.at(parent->getOperandName())->getSubVar(name)));
                return false;
            } else if (globalVariableMap.find(parent->getOperandName()) != globalVariableMap.end()) {
                //Assign value
                this->switchPassExpr(
                        new VariableOperand(globalVariableMap.at(parent->getOperandName())->getSubVar(name)));
                return false;
            } else return exitVisitor(parent->getOperandName() + " is not a parent of " + name);
        } else if (SCAM::FunctionOperand *parent = dynamic_cast<SCAM::FunctionOperand *>(findParentOfSubVar.getExpr())) {
            if (functionMap.find(parent->getOperandName()) != functionMap.end()) {
                //Assign value
                throw std::runtime_error("Dont remove ... if never flags ... remove!");
            } else return exitVisitor(parent->getOperandName() + " is not a parent of " + name);
        } else if (SCAM::ParamOperand *parent = dynamic_cast<SCAM::ParamOperand *>(findParentOfSubVar.getExpr())) {
            auto paramMap = functionMap.find(FindDataFlow::functionName)->second->getParamMap();
            if (paramMap.find(parent->getOperandName()) != paramMap.end()) {
                //Assign value
                auto param = parent->getParameter()->getSubVar(name);
                this->switchPassExpr(new ParamOperand(param));
                return false;
            } else return exitVisitor(parent->getOperandName() + " is not a parent of " + name);
        } else return exitVisitor("Cant find parent for variable: " + name);

    }

    //Simple Variable
    if (!memberMap.empty()) {
        if (memberMap.find(name) != memberMap.end()) {
            //Assign value
            this->switchPassExpr(new VariableOperand(memberMap.at(name)));
            return false;
        }
    }

    //Global Variable
    if (!globalVariableMap.empty()) {
        if (globalVariableMap.find(name) != globalVariableMap.end()) {
            //Assign value
            this->switchPassExpr(new VariableOperand(globalVariableMap.at(name)));
            return false;
        }
    }

    //Only the case, if the operation is Call
    std::map<std::string, Port *> portMap = module->getPorts();
    //Read/Write on Port
    if (portMap.find(name) != portMap.end()) {
        //Assign value
        this->switchPassExpr(new PortOperand(portMap.find(name)->second));
        return true;

    }

    //TODO: remove
    //States Enum
//    if (name == "section" || name == "nextsection") {
//        //Assign value
//        if (name == "section") this->switchPassExpr(new SectionOperand(module->getFSM()->getSectionVariable()));
//        else this->switchPassExpr(new SectionOperand(module->getFSM()->getNextSectionVariable()));
//        return true;
//    } else return exitVisitor("Could not analyze " + name);
}


bool SCAM::FindDataFlow::VisitIntegerLiteral(clang::IntegerLiteral *integerLiteral) {

    if (unsigned_flag) {
        unsigned int ret = (unsigned int) *integerLiteral->getValue().getRawData();
        //Assign value
        this->switchPassExpr(new UnsignedValue(ret));
    } else {
        int ret = (int) integerLiteral->getValue().getSExtValue();
        //Assign value
        this->switchPassExpr(new IntegerValue(ret));
    }
    return false;

}

/*!
 * Pointing to a Variable Declartion
 */
bool SCAM::FindDataFlow::VisitDeclRefExpr(clang::DeclRefExpr *declRefExpr) {

    //Name
    std::string name = declRefExpr->getDecl()->getNameAsString();

    //Check for global variables
    auto globalVars = ModelGlobal::getModel()->getGlobalVariableMap();
    if (!globalVars.empty() && globalVars.find(name) != globalVars.end()) {
        this->switchPassExpr(new VariableOperand((globalVars.find(name))->second));
        return false;
    }


    //Check for state values
    if (clang::EnumConstantDecl *enumDecl = llvm::dyn_cast<clang::EnumConstantDecl>(declRefExpr->getDecl())) {

        //Regular enum-value
        std::string typeName = enumDecl->getType()->getAs<clang::EnumType>()->getDecl()->getName().str();
        std::string value = enumDecl->getName().str();
        if (DataTypes::isDataType(typeName)) {
            this->switchPassExpr(new EnumValue(value, DataTypes::getDataType(typeName)));
            return false;
        } else if (DataTypes::isLocalDataType(typeName, module->getName())) {
            this->switchPassExpr(new EnumValue(value, DataTypes::getLocalDataType(module->getName(), typeName)));
            return false;
        }

    }
    if (clang::ParmVarDecl *parmVarDecl = dynamic_cast<clang::ParmVarDecl *>(declRefExpr->getDecl())) {
        if (FindDataFlow::isFunction) {
            auto function = this->module->getFunctionMap().find(FindDataFlow::functionName)->second;
            auto paramMap = function->getParamMap();
            if (paramMap.find(name) != paramMap.end()) {
                this->switchPassExpr(new ParamOperand(paramMap.find(name)->second));
                return false;
            } else exitVisitor("Unknown parameter " + name + " for function " + function->getName());
        }
    }
    return true;
}

SCAM::Stmt *SCAM::FindDataFlow::getStmt() {
    return this->stmt;
}


bool SCAM::FindDataFlow::VisitUnaryOperator(clang::UnaryOperator *unaryOperator) {

    //Unary operator !var, var++ and var-- everything is going to result in a fault.
    if (pass == 0) {
        //Opcode as string: ++,--,!
        std::string opcode = unaryOperator->getOpcodeStr(unaryOperator->getOpcode()).str();
        //Increase pass(LHS assignment)
        pass = 1;
        //Find operand the operation is performed on -> stored in LHS
        FindDataFlow subExpr(unaryOperator->getSubExpr(), this->module, unsigned_flag);
        if (subExpr.getExpr() == nullptr) return exitVisitor("Could not translate unary operator");
        //TraverseStmt(unaryOperator->getSubExpr());

        switch (unaryOperator->getOpcode()) {
            case clang::UnaryOperator::Opcode::UO_PreInc:
                if (subExpr.getExpr()->getDataType()->isUnsigned()) {
                    this->stmt = new Assignment(subExpr.getExpr(),
                                                new Arithmetic(subExpr.getExpr(), "+", new UnsignedValue(1)));
                } else
                    this->stmt = new Assignment(subExpr.getExpr(),
                                                new Arithmetic(subExpr.getExpr(), "+", new IntegerValue(1)));
                break;
            case clang::UnaryOperator::Opcode::UO_LNot:
                this->expr = new UnaryExpr("not", subExpr.getExpr());
                break;
            case clang::UnaryOperator::Opcode::UO_PreDec:
                if (subExpr.getExpr()->getDataType()->isUnsigned()) {
                    this->stmt = new Assignment(subExpr.getExpr(),
                                                new Arithmetic(subExpr.getExpr(), "-", new UnsignedValue(1)));
                } else
                    this->stmt = new Assignment(subExpr.getExpr(),
                                                new Arithmetic(subExpr.getExpr(), "-", new IntegerValue(1)));
                break;
            case clang::UnaryOperator::Opcode::UO_Minus:
                this->expr = new UnaryExpr("-", subExpr.getExpr());
                break;
            case clang::UnaryOperator::Opcode::UO_Not:
                this->expr = new UnaryExpr("~", subExpr.getExpr());
                break;
            default:
                return exitVisitor("Unkown/Unallowed unaray operator: " + opcode);
        }
    }
    return false;
}

bool SCAM::FindDataFlow::VisitWhileStmt(clang::WhileStmt *whileStmt) {
    if (pass == 0) {
        FindDataFlow conditionStmt(whileStmt->getCond(), this->module, false);
        this->stmt = new While(conditionStmt.getExpr());
    }
    return false;
}

bool SCAM::FindDataFlow::VisitIfStmt(clang::IfStmt *ifStmt) {
    if (pass == 0) {
        FindDataFlow conditionStmt(ifStmt->getCond(), this->module, false);
        if (conditionStmt.getExpr() == nullptr) return exitVisitor("Translation of condition failed)");
        this->stmt = new If(conditionStmt.getExpr());
    }
    return false;
}

bool SCAM::FindDataFlow::VisitCXXBoolLiteralExpr(clang::CXXBoolLiteralExpr *boolLiteralExpr) {
    switch (pass) {
        case 0:
            this->stmt = new BoolValue(boolLiteralExpr->getValue());
            this->expr = new BoolValue(boolLiteralExpr->getValue());
            break;
        case 1:
            return exitVisitor("Boolean Value on LHS");
        case 2:
            this->stmt = new BoolValue(boolLiteralExpr->getValue());
            this->expr = new BoolValue(boolLiteralExpr->getValue());
            break;
    }
}


bool SCAM::FindDataFlow::VisitCXXOperatorCallExpr(clang::CXXOperatorCallExpr *operatorCallExpr) {
    if (pass == 0) {
        //Find assignemnt of structs -> which is represented as an overloaded copy
        // ComplexType foo = port[ComplexType].read()
        //Return-type is an expression(is that always the case?)
        if (!operatorCallExpr->isTypeDependent() && operatorCallExpr->getCallReturnType()->isReferenceType()) {
            if (clang::OverloadedOperatorKind::OO_Equal == operatorCallExpr->getOperator()) {
                if (operatorCallExpr->getNumArgs() == 2) {
                    //get foo
                    this->pass = 1;
                    TraverseStmt(operatorCallExpr->getArg(0));
                    if (this->lhsExpr == nullptr) {
                        return exitVisitor("Unknown error: Stmts can't be processed(a)");
                    }
                    //get port.read()
                    this->pass = 2;
                    TraverseStmt(operatorCallExpr->getArg(1));
                    if (this->rhsExpr == nullptr) {
                        return exitVisitor("Unknown error: Stmts can't be processed(b)");
                    }
                    this->stmt = new Assignment(this->lhsExpr, this->rhsExpr);

                } else return exitVisitor("Unknown error: Stmts can't be processed(c)");

            } else return exitVisitor("Unknown error: Stmts can't be processed(d)");
        } else return exitVisitor("Unknown error: Stmts can't be processed(e)");
    }
    return true;
}


bool SCAM::FindDataFlow::VisitCallExpr(clang::CallExpr *callExpr) {
    if (callExpr->getDirectCallee() == nullptr) return true;
    if (callExpr->getDirectCallee()->isCXXClassMember()) return true;
    else {
        std::string functionName = callExpr->getDirectCallee()->getNameAsString();
        //std::string functionName = callExpr->getDirectCallee()->getName().str();
        return exitVisitor(functionName + "() is not a valid function");
    }
}

bool SCAM::FindDataFlow::VisitImplicitCastExpr(clang::ImplicitCastExpr *implicitCastExpr) {
    if (implicitCastExpr->getType()->isUnsignedIntegerType() &&
        implicitCastExpr->getType().getAsString() == "unsigned int") {
        FindDataFlow unsigendSearch(implicitCastExpr->getSubExpr(), module,
                                    implicitCastExpr->getType()->isUnsignedIntegerType());
        if (unsigendSearch.getExpr() == nullptr) {
            return exitVisitor("Unknown unsigned value");
        }
        switchPassExpr(unsigendSearch.getExpr());
        return false;
    }
    return true;


}

void SCAM::FindDataFlow::switchPassExpr(SCAM::Expr *expr) {
    if (expr == nullptr) throw std::runtime_error(" Can't pass a nullptr");
//    std::cout << PrintStmt::toString(expr) << std::endl;
    switch (this->pass) {
        case 0:
            this->expr = expr;
            break;
        case 1:
            this->lhsExpr = expr;
            break;
        case 2:
            this->rhsExpr = expr;
            break;
        default:
            throw std::runtime_error("Pass is out of range");
    }
}

bool SCAM::FindDataFlow::exitVisitor(std::string msg, ErrorMsg::ErrorType errorType) {

    switch (errorType) {
        case ErrorMsg::ErrorType::error:
            ErrorMsg::getInstance().addErrorLog("-E- " + msg);
            break;
        case ErrorMsg::ErrorType::warning:
            ErrorMsg::getInstance().addErrorLog("-W- " + msg);
            break;
        case ErrorMsg::ErrorType::information:
            ErrorMsg::getInstance().addErrorLog("-I- " + msg);
            break;
    }

    this->stmt = nullptr;
    if (errorType == ErrorMsg::ErrorType::information || errorType == ErrorMsg::ErrorType::warning) {
        return true;
    }
    return false;
}


SCAM::Expr *SCAM::FindDataFlow::getExpr() const {
    return expr;
}

bool SCAM::FindDataFlow::VisitCXXStaticCastExpr(clang::CXXStaticCastExpr *staticCastExpr) {
    //FIXME: is the restirction to casting only variables necessary? Remove if hardware is designable
    if (staticCastExpr->getType()->isUnsignedIntegerType() &&
        staticCastExpr->getType().getAsString() == "unsigned int") {
        FindDataFlow subExpr(staticCastExpr->getSubExpr(), module, false);
        if (ExprVisitor::isVar(subExpr.getExpr()) || true) {
            switchPassExpr(new SCAM::Cast(subExpr.getExpr(), DataTypes::getDataType("unsigned")));
        } else return exitVisitor("static_cast: only variables are allowed as parameter");
        return false;
    } else if (staticCastExpr->getType()->isIntegerType() && staticCastExpr->getType().getAsString() == "int") {
        FindDataFlow subExpr(staticCastExpr->getSubExpr(), module, false);
        //FIXME: || true!
        if (ExprVisitor::isVar(subExpr.getExpr()) || ExprVisitor::isParameter(subExpr.getExpr()) || true) {
            switchPassExpr(new SCAM::Cast(subExpr.getExpr(), DataTypes::getDataType("int")));
        } else return exitVisitor("static_cast: only variables are allowed as parameter");
        return false;
    } else return exitVisitor("static_cast: unallowed static cast");


    return true;
}

bool SCAM::FindDataFlow::VisitReturnStmt(clang::ReturnStmt *returnStmt) {
    FindDataFlow returnExpr(returnStmt->getRetValue(), module, false);

    if (returnExpr.getExpr() == nullptr) return exitVisitor(" return value is null");
    this->stmt = new SCAM::Return(returnExpr.getExpr());
    return false;
}

bool SCAM::FindDataFlow::VisitCompoundStmt(clang::CompoundStmt *compoundStmt) {
    return false;
}

bool SCAM::FindDataFlow::VisitArraySubscriptExpr(clang::ArraySubscriptExpr *arraySubscriptExpr) {

    FindDataFlow array(arraySubscriptExpr->getLHS(), module, false);
    if (array.getExpr() != nullptr && array.getExpr()->getDataType()->isArrayType()) {
        if (auto varOp = NodePeekVisitor::nodePeekVariableOperand(array.getExpr())) {
            FindDataFlow findIndex(arraySubscriptExpr->getIdx(), module, false);
            if (auto index = NodePeekVisitor::nodePeekIntegerValue(findIndex.getExpr())) {
                switchPassExpr(new SCAM::VariableOperand(varOp->getVariable()->getSubVar(index->getValueAsString())));
                return false;
            } else {
                auto foo = new ArrayOperand(varOp->getVariable(), findIndex.getExpr());
                switchPassExpr(foo);
                //TODO: Implement function for arrays.
                /*
                 * Implement a functions that allows to selct from array with an expression.
                 * Because a varialbe myArray[index] does not represent a varialbe that is referencable. It depends on the concrete evaluation of [index].
                 * After value propgation it could be possible to translate it back to a conecrete array select, if the value evaluates to be constant.
                 */
                //throw std::runtime_error("Not implemented");
                return false;
            }
        } else return exitVisitor("Stmt is null");
    } else return exitVisitor("Not an array type!");
}



