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
#include <Stmts/Logical.h>
#include <Stmts/Relational.h>
#include <Stmts/Cast.h>
#include <ExprVisitor.h>
#include <NodePeekVisitor.h>
#include <ModelGlobal.h>
#include "PortOperand.h"
#include "FindDataFlow.h"
#include "FindStateName.h"

#include "StmtException.h"

bool SCAM::FindDataFlow::isFunction = false;
std::string SCAM::FindDataFlow::functionName = "";

SCAM::FindDataFlow::FindDataFlow(clang::Stmt *stmt, Module *module, clang::CompilerInstance &ci, bool unsigned_flag) :
        module(module),
        ci(ci),
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
        // Collecting statement location information from clang
        auto binaryOpLocationInfo = getStmtInfo(binaryOperator);

        //OperationName
        std::string operationName = binaryOperator->getOpcodeStr().str();
        //Pass = 1 LHS
        //LHS Operator
        auto lhs = binaryOperator->getLHS();
        FindDataFlow findLHS(lhs, this->module, ci, unsigned_flag);
        auto lhsLocationInfo = getStmtInfo(lhs);
        this->lhsExpr = findLHS.getExpr();
        //RHS Operator
        if(this->lhsExpr && this->lhsExpr->getDataType()->isUnsigned()) this->unsigned_flag = true;
        auto rhs = binaryOperator->getRHS();
        FindDataFlow findRHS(rhs, this->module, ci, unsigned_flag);
        this->rhsExpr = findRHS.getExpr();
        auto rhsLocationInfo = getStmtInfo(rhs);

        //Are LHS and RHS Valid?
        if (this->rhsExpr == nullptr || this->lhsExpr == nullptr) {
            auto message = "";
            if (!(this->rhsExpr && this->lhsExpr)) message = "Could not translate LHS and RHS of Stmts";
            else if (!this->rhsExpr) message = "Could not translate RHS of Stmts";
            else message = "Could not translate LHS of Stmts";
            return exitVisitor(message, binaryOpLocationInfo);
        }

        //Setting location information for the lhs and rhs
        this->lhsExpr->setStmtInfo(lhsLocationInfo);
        this->rhsExpr->setStmtInfo(rhsLocationInfo);

        //Create new Element
        if (binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_Assign) {
            ASSERT_STMT(this->stmt = new Assignment(this->lhsExpr, this->rhsExpr, binaryOpLocationInfo))
        } else if (binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_LAnd) {
            ASSERT_STMT(this->expr = new Logical(this->lhsExpr, "and", this->rhsExpr, binaryOpLocationInfo))
        } else if (binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_LOr) {
            ASSERT_STMT(this->expr = new Logical(this->lhsExpr, "or", this->rhsExpr, binaryOpLocationInfo))
        } else if (binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_EQ ||
                   binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_NE ||
                   binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_GE ||
                   binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_LE ||
                   binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_GT ||
                   binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_LT) {
            ASSERT_STMT(this->expr = new Relational(this->lhsExpr, operationName, this->rhsExpr, binaryOpLocationInfo))
        } else if (binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_Add ||
                   binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_Div ||
                   binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_Rem ||
                   binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_Mul ||
                   binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_Sub) {
            ASSERT_STMT(this->expr = new Arithmetic(this->lhsExpr, operationName, this->rhsExpr, binaryOpLocationInfo))
        } else if (binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_AddAssign ||
                   binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_SubAssign ||
                   binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_MulAssign ||
                   binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_DivAssign ||
                   binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_RemAssign) {
            ASSERT_STMT(this->stmt = new Assignment(this->lhsExpr,
                                                    new Arithmetic(this->lhsExpr, operationName, this->rhsExpr,
                                                                   binaryOpLocationInfo), binaryOpLocationInfo))
        } else if (binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_Shl) {
            //Special case ... shiftings depends on LHS Datatype
            if (binaryOperator->getType()->isUnsignedIntegerType()) {
                FindDataFlow findRHS2(binaryOperator->getRHS(), this->module, ci, true);
                this->rhsExpr = findRHS2.getExpr();
            }
            ASSERT_STMT(this->expr = new Bitwise(this->lhsExpr, "<<", this->rhsExpr, binaryOpLocationInfo));
        } else if (binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_Shr) {
            //Special case ... shiftings depends on LHS Datatype
            if (binaryOperator->getType()->isUnsignedIntegerType()) {
                FindDataFlow findRHS2(binaryOperator->getRHS(), this->module, ci, true);
                this->rhsExpr = findRHS2.getExpr();
            }
            ASSERT_STMT(this->expr = new Bitwise(this->lhsExpr, ">>", this->rhsExpr, binaryOpLocationInfo));
        } else if (binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_And) {
            ASSERT_STMT(this->expr = new Bitwise(this->lhsExpr, "&", this->rhsExpr, binaryOpLocationInfo))
        } else if (binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_Or) {
            ASSERT_STMT(this->expr = new Bitwise(this->lhsExpr, "|", this->rhsExpr, binaryOpLocationInfo))
        } else if (binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_Xor) {
            ASSERT_STMT(this->expr = new Bitwise(this->lhsExpr, "^", this->rhsExpr, binaryOpLocationInfo))
        } else {
            auto msg = "Operator " + operationName + " not defined";
            this->exitVisitor(msg, binaryOpLocationInfo);
        }
        if (StmtException::isExceptionHappened()) clearExpressions();
        return false;
    }
    return true;
}

bool SCAM::FindDataFlow::VisitConditionalOperator(clang::ConditionalOperator* conditionalOperator){
    auto condOpLocationInfo = getStmtInfo(conditionalOperator);
    FindDataFlow findCond(conditionalOperator->getCond(), this->module,ci, false);
    auto condExpr = findCond.getExpr();
    FindDataFlow findTrue(conditionalOperator->getTrueExpr(), this->module,ci, unsigned_flag);
    auto trueExpr = findTrue.getExpr();
    FindDataFlow findFalse(conditionalOperator->getFalseExpr(), this->module,ci, unsigned_flag);
    auto falseExpr = findFalse.getExpr();
    if(condExpr && trueExpr && falseExpr){
    //conditionalOperator->dumpColor();
    //std::cout << *condExpr << "?" << *trueExpr << ":" << *falseExpr << std::endl;
    this->expr = new Ternary(condExpr,trueExpr,falseExpr,condOpLocationInfo);
    }else return exitVisitor("Operator not correctly used!",condOpLocationInfo);
    return false;
}

bool SCAM::FindDataFlow::VisitCXXMemberCallExpr(clang::CXXMemberCallExpr *memberCallExpr) {
    //Call: ->write(argument)
    if (pass == 0) {
        // Collecting statement location information from clang
        auto memberCallLocationInfo = getStmtInfo(memberCallExpr);
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
            //Get location info of the method
            auto calleeLocationInfo = getStmtInfo(memberCallExpr->getCallee());
            //Check whether method is supported, if not -> Bad Stmts
            if (std::find(supportedMethods.begin(), supportedMethods.end(), methodString) != supportedMethods.end()) {
//                this->pass = 1;
                //Including a wait, but onyl with SC_ZERO_TIME
                if (methodString == "wait") {
                    if (memberCallExpr->getNumArgs() == 2) {
                        SCAM::FindDataFlow firstArgument(memberCallExpr->getArg(0), this->module, ci, false);
                        SCAM::FindDataFlow secondArgument(memberCallExpr->getArg(1), this->module, ci, false);
                        ASSERT_STMT(this->stmt = new Wait(
                                calleeLocationInfo)); //FIXME: don't know how to check for the arguments or if needed to begin with
                        if (StmtException::isExceptionHappened()) clearExpressions();
                        return false;
                    } else
                        return exitVisitor("Only wait(0) is allowed", calleeLocationInfo);
                } else this->pass = 1;
                //Function
            } else if (functions.find(methodString) != functions.end()) {
                //Analyse paramter
                auto function = functions.find(methodString)->second;
                std::map<std::string, SCAM::Expr *> paramValueMap;
                for (int i = 0; i < memberCallExpr->getNumArgs(); i++) {
                    std::string paramName = memberCallExpr->getMethodDecl()->getParamDecl(i)->getName();
                    SCAM::FindDataFlow findArgument(memberCallExpr->getArg(i), this->module, ci, false);
                    if (findArgument.getExpr() == nullptr)
                        return exitVisitor(methodString + "() has unsupported params", calleeLocationInfo);
                    SCAM::Expr *paramExpr = findArgument.getExpr();
                    paramValueMap.insert(std::make_pair(paramName, paramExpr));
                }
                ASSERT_STMT(this->expr = new FunctionOperand(function, paramValueMap, calleeLocationInfo);
                this->stmt = this->expr)
                if (StmtException::isExceptionHappened()) clearExpressions();
                return false;
            } else {
                return exitVisitor(methodString + "() is not a supported method!", calleeLocationInfo);
            }
        } else
            return exitVisitor("[ADD StmtToStringHere] not a Variable", memberCallLocationInfo);


        //Search for member that is called on [e.G. x.foo(), find x]
        auto implicitObjArg = memberCallExpr->getImplicitObjectArgument();
        TraverseStmt(implicitObjArg);

        if (this->lhsExpr != nullptr) {
            //Get location info of the member
            auto membrLocationInfo = getStmtInfo(implicitObjArg);
            if (PortOperand *operand = dynamic_cast<PortOperand *>(this->lhsExpr)) {
                //Lambda for finding the stateName
                auto getStateName = [=]() -> std::string {
                    if (memberCallExpr->getNumArgs() == 2) {
                        FindStateName findStateName(memberCallExpr->getArg(1));
                        return findStateName.getStateName();
                    } else if (memberCallExpr->getNumArgs() == 3) {
                        FindStateName findStateName(memberCallExpr->getArg(2));
                        return findStateName.getStateName();
                    } else return "";
                };

                auto getArgument = [=](clang::Stmt *stmt) {
                    SCAM::FindDataFlow findArgument(stmt, this->module, ci, operand->getDataType()->isUnsigned());
                    return findArgument.getExpr();
                };

                auto hasValidArgument = [=](clang::Stmt *stmt) {
                    return getArgument(stmt) != nullptr;
                };

                auto interface = operand->getPort()->getInterface();
                if (interface->isBlocking()) {
                    assert(memberCallExpr->getNumArgs() > 0 && memberCallExpr->getNumArgs() < 4 &&
                           "Wrong number of arguments arguments");
                    if (methodString == "peek" && memberCallExpr->getNumArgs() == 0) {
                        ASSERT_STMT(this->expr = new Peek(operand->getPort(), memberCallLocationInfo))
                    } else if (methodString == "poke" && memberCallExpr->getNumArgs() == 0) {
                        ASSERT_STMT(this->expr = new Peek(operand->getPort(), memberCallLocationInfo))
                    } else if (memberCallExpr->getNumArgs() > 0 && hasValidArgument(memberCallExpr->getArg((0)))) {
                        //Blocking read
                        if (methodString == "read") {
                            //add variable as parameter
                            if (auto variableOp = dynamic_cast<VariableOperand *>(getArgument(
                                    memberCallExpr->getArg((0))))) {
                                ASSERT_STMT(auto read = new Read(operand->getPort(), variableOp, false, nullptr,
                                                                 memberCallLocationInfo);
                                                    read->setStateName(getStateName());
                                                    this->stmt = read)
                            } else
                                return exitVisitor("Could not dynamically cast argument as VariableOperand",
                                                   memberCallLocationInfo);
                            //non Blocking read
                        } else if (methodString == "try_read" && memberCallExpr->getNumArgs() == 1) {
                            //add variable as parameter
                            if (auto variableOp = dynamic_cast<VariableOperand *>(getArgument(
                                    memberCallExpr->getArg((0))))) {
                                ASSERT_STMT(this->stmt = new Read(operand->getPort(), variableOp, true, nullptr,
                                                                  memberCallLocationInfo))
                            } else
                                return exitVisitor("Could not dynamically cast argument as VariableOperand",
                                                   memberCallLocationInfo);
                        } else if (methodString == "try_read" && memberCallExpr->getNumArgs() > 1) {
                            //add variable as parameter
                            if (auto *variableOp = dynamic_cast<VariableOperand *>(getArgument(
                                    memberCallExpr->getArg(0)))) {
                                if (hasValidArgument(memberCallExpr->getArg(1))) {
                                    if (auto statusOp = dynamic_cast<VariableOperand *>(getArgument(
                                            memberCallExpr->getArg(1)))) {
                                        ASSERT_STMT(auto read = new Read(operand->getPort(), variableOp, true, statusOp,
                                                                         memberCallLocationInfo);
                                                            read->setStateName(getStateName());
                                                            this->stmt = read)
                                    } else
                                        return exitVisitor("Could not dynamically cast argument as VariableOperand",
                                                           memberCallLocationInfo);
                                } else
                                    return exitVisitor("Could not find parameter", membrLocationInfo);
                            } else
                                return exitVisitor("Could not dynamically cast argument as VariableOperand",
                                                   memberCallLocationInfo);
                        } else if (methodString == "write") {
                            ASSERT_STMT(
                                    auto write = new Write(operand->getPort(), getArgument(memberCallExpr->getArg(0)),
                                                           false, nullptr, memberCallLocationInfo);
                                    write->setStateName(getStateName());
                                    this->stmt = write)
                        }
                            //non Blocking write
                        else if (methodString == "try_write" && memberCallExpr->getNumArgs() == 1) {
                            ASSERT_STMT(
                                    this->stmt = new Write(operand->getPort(), getArgument(memberCallExpr->getArg(0)),
                                                           true, nullptr, memberCallLocationInfo))
                        }
                            //non Blocking write with status flag
                        else if (methodString == "try_write" && memberCallExpr->getNumArgs() > 1) {
                            if (hasValidArgument(memberCallExpr->getArg(1))) {
                                if (auto statusOp = dynamic_cast<VariableOperand *>(getArgument(
                                        memberCallExpr->getArg(1)))) {
                                    ASSERT_STMT(auto write = new Write(operand->getPort(),
                                                                       getArgument(memberCallExpr->getArg(0)),
                                                                       true, statusOp, memberCallLocationInfo);
                                                        write->setStateName(getStateName());
                                                        this->stmt = write)
                                } else
                                    return exitVisitor("Could not dynamically cast argument as VariableOperand",
                                                       memberCallLocationInfo);
                            } else return exitVisitor("Could not find parameter", memberCallLocationInfo);
                        }
                    } else
                        return exitVisitor(
                                "Unsupported method: " + methodString + " for interface " + interface->getName(),
                                memberCallLocationInfo);
                } else if (interface->isShared()) {
                    if (methodString == "get" && memberCallExpr->getNumArgs() == 1) {
                        SCAM::FindDataFlow findArgument(memberCallExpr->getArg(0), this->module, ci, false);
                        if (findArgument.getExpr() != nullptr) {
                            if (auto *variableOp = dynamic_cast<VariableOperand *>(findArgument.getExpr())) {
                                ASSERT_STMT(this->stmt = new Read(operand->getPort(), variableOp, true, nullptr,
                                                                  memberCallLocationInfo))
                            } else
                                return exitVisitor("Read argument is not a variable!", memberCallLocationInfo);
                        } else
                            return exitVisitor("Could not find parameter", membrLocationInfo);
                    } else if (methodString == "set") {
                        SCAM::FindDataFlow findArgument(memberCallExpr->getArg(0), this->module, ci,
                                                        operand->getDataType()->isUnsigned());
                        if (findArgument.getExpr() != nullptr) {
                            ASSERT_STMT(
                                    this->stmt = new Write(operand->getPort(), findArgument.getExpr(), true, nullptr,
                                                           memberCallLocationInfo))
                        } else
                            return exitVisitor("Could not find parameter", membrLocationInfo);
                    } else
                        return exitVisitor(
                                "Unsupported method: " + methodString + " for interface " + interface->getName(),
                                memberCallLocationInfo);

                } else if (interface->isMaster()) {
                    assert(memberCallExpr->getNumArgs() > 0 && memberCallExpr->getNumArgs() < 3 &&
                           "Wrong number of arguments arguments");
                    if (hasValidArgument(memberCallExpr->getArg((0)))) {
                        // evaluate parameters
                        if (methodString == "master_read") {
                            if (auto *variableOp = dynamic_cast<VariableOperand *>(getArgument(
                                    memberCallExpr->getArg((0))))) {
                                ASSERT_STMT(auto read = new Read(operand->getPort(), variableOp, false, nullptr,
                                                                 memberCallLocationInfo);
                                                    this->stmt = read;
                                                    read->setStateName(getStateName()))
                            } else
                                return exitVisitor("Could not dynamically cast argument as VariableOperand",
                                                   memberCallLocationInfo);
                        } else if (methodString == "master_write") {
                            ASSERT_STMT(
                                    auto write = new Write(operand->getPort(), getArgument(memberCallExpr->getArg((0))),
                                                           false, nullptr, memberCallLocationInfo);
                                    write->setStateName(getStateName());
                                    this->stmt = write
                            )
                        } else
                            return exitVisitor(
                                    "Unsupported method: " + methodString + " for interface " + interface->getName(),
                                    memberCallLocationInfo);
                    } else
                        return exitVisitor("Argument 1 is not analyzeable", memberCallLocationInfo);

                } else if (interface->isSlave()) {
                    assert(memberCallExpr->getNumArgs() > 0 && memberCallExpr->getNumArgs() < 3 &&
                           "Wrong number of arguments arguments");
                    if (hasValidArgument(memberCallExpr->getArg((0)))) {
                        if (methodString == "slave_read" && memberCallExpr->getNumArgs() == 1) {
                            if (auto variableOp = dynamic_cast<VariableOperand *>(getArgument(
                                    memberCallExpr->getArg(0)))) {
                                ASSERT_STMT(this->stmt = new Read(operand->getPort(), variableOp, true, nullptr,
                                                                  memberCallLocationInfo))
                            } else
                                return exitVisitor("Could not dynamically cast argument as VariableOperand",
                                                   memberCallLocationInfo);
                        } else if (methodString == "slave_read" && memberCallExpr->getNumArgs() > 1) {
                            //add variable as parameter
                            if (auto *variableOp = dynamic_cast<VariableOperand *>(getArgument(
                                    memberCallExpr->getArg(0)))) {
                                if (hasValidArgument(memberCallExpr->getArg(1))) {
                                    if (auto statusOp = dynamic_cast<VariableOperand *>(getArgument(
                                            memberCallExpr->getArg(1)))) {
                                        ASSERT_STMT(auto read = new Read(operand->getPort(), variableOp, true, statusOp,
                                                                         memberCallLocationInfo);
                                                            read->setStateName(getStateName());
                                                            this->stmt = read)
                                    } else
                                        return exitVisitor("Could not dynamically cast argument as VariableOperand",
                                                           memberCallLocationInfo);
                                } else
                                    return exitVisitor("Could not find parameter", membrLocationInfo);
                            } else
                                return exitVisitor("Could not dynamically cast argument as VariableOperand",
                                                   memberCallLocationInfo);
                        } else if (methodString == "slave_write") {
                            ASSERT_STMT(
                                    auto write = new Write(operand->getPort(), getArgument(memberCallExpr->getArg(0)));
                                    this->stmt = write)
                        } else
                            return exitVisitor(
                                    "Unsupported method: " + methodString + "for interface " + interface->getName(),
                                    memberCallLocationInfo);
                    } else {
                        return exitVisitor("Unknown interface: " + interface->getName(), memberCallLocationInfo);
                    }
                }

            } else {
                exitVisitor("couldn't dynamically cast this->lhsExpr to portOperand\n", memberCallLocationInfo);
            }
        }
        //Object analyzed
        if (StmtException::isExceptionHappened()) clearExpressions();
        return false;
    }
    //Here only if object is LHS or RHS
    //Membercall: obj->
    if (pass == 1) {
        FindDataFlow findMemberCall(memberCallExpr, this->module, ci, false);
        this->lhsExpr = findMemberCall.getExpr();
    }
    //Case  var = x.foo(); RHS of operator
    //RHS is a Call
    if (pass == 2) {
        FindDataFlow findMemberCall(memberCallExpr, this->module, ci, false);
        this->rhsExpr = findMemberCall.getExpr();
        return false;
    }
    return true;
}

//Import here: Search for Compound variables first
bool SCAM::FindDataFlow::VisitMemberExpr(clang::MemberExpr *memberExpr) {

    //Get location info of the member
    auto membrLocationInfo = getStmtInfo(memberExpr);

    //Name of memberfield
    std::string name = memberExpr->getMemberDecl()->getName();
    if (name == "")  exitVisitor("Member has no name ",membrLocationInfo);

    //Get mememberMap for module
    const std::map<std::string, Variable *> &memberMap = module->getVariableMap();
    auto globalVariableMap = ModelGlobal::getModel()->getGlobalVariableMap();

    const std::map<std::string, Function *> &functionMap = module->getFunctionMap();

    // Determine name for compound: var.x;
    FindDataFlow findParentOfSubVar((*memberExpr->child_begin()), this->module, ci, false);
    if (findParentOfSubVar.getExpr() != nullptr) {
        //FIXME: Get rid of subvars by also using ArrayOperand on compound variables
        if (auto parent = dynamic_cast<SCAM::VariableOperand *>(findParentOfSubVar.getExpr())) {
            if (memberMap.find(parent->getOperandName()) != memberMap.end()) {
                //Assign value
                ASSERT_STMT(this->switchPassExpr(new VariableOperand(memberMap.at(parent->getOperandName())->getSubVar(name),membrLocationInfo)))
                if (StmtException::isExceptionHappened()) clearExpressions();
                return false;
            } else if (globalVariableMap.find(parent->getOperandName()) != globalVariableMap.end()) {
                //Assign value
                ASSERT_STMT(this->switchPassExpr(
                        new VariableOperand(globalVariableMap.at(parent->getOperandName())->getSubVar(name),membrLocationInfo)))
                if (StmtException::isExceptionHappened()) clearExpressions();
                return false;
            } else
                return exitVisitor(parent->getOperandName() + " is not a parent of " + name, membrLocationInfo);
        } else if (auto parent = dynamic_cast<SCAM::FunctionOperand *>(findParentOfSubVar.getExpr())) {
            if (functionMap.find(parent->getOperandName()) != functionMap.end()) {
                //Assign value
                throw std::runtime_error("Dont remove ... if never flags ... remove!");
            } else
                return exitVisitor(parent->getOperandName() + " is not a parent of " + name, membrLocationInfo);
        } else if (auto parent = dynamic_cast<SCAM::ParamOperand *>(findParentOfSubVar.getExpr())) {
            auto paramMap = functionMap.find(FindDataFlow::functionName)->second->getParamMap();
            if (paramMap.find(parent->getOperandName()) != paramMap.end()) {
                //Assign value
                auto param = parent->getParameter()->getSubVar(name);
                ASSERT_STMT(this->switchPassExpr(new ParamOperand(param,membrLocationInfo)))
                if (StmtException::isExceptionHappened()) clearExpressions();
                return false;
            } else
                return exitVisitor(parent->getOperandName() + " is not a parent of " + name, membrLocationInfo);
        } else
            return exitVisitor("Cant find parent for variable: " + name, membrLocationInfo);
    }
    //Simple Variable
    if (!memberMap.empty()) {
        if (memberMap.find(name) != memberMap.end()) {
            //Assign value
            ASSERT_STMT(this->switchPassExpr(new VariableOperand(memberMap.at(name),membrLocationInfo)))
            if (StmtException::isExceptionHappened()) clearExpressions();
            return false;
        }
    }
    //Global Variable
    if (!globalVariableMap.empty()) {
        if (globalVariableMap.find(name) != globalVariableMap.end()) {
            //Assign value
            ASSERT_STMT(this->switchPassExpr(new VariableOperand(globalVariableMap.at(name),membrLocationInfo)))
            if (StmtException::isExceptionHappened()) clearExpressions();
            return false;
        }
    }
    //Only the case, if the operation is Call
    std::map<std::string, Port *> portMap = module->getPorts();
    //Read/Write on Port
    if (portMap.find(name) != portMap.end()) {
        //Assign value
        ASSERT_STMT(this->switchPassExpr(new PortOperand(portMap.find(name)->second,membrLocationInfo)))
        if (StmtException::isExceptionHappened()) {clearExpressions(); return false;}
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
     return exitVisitor("Could not analyze " + name,membrLocationInfo);
}


bool SCAM::FindDataFlow::VisitIntegerLiteral(clang::IntegerLiteral *integerLiteral) {

    auto valLocInfo = getStmtInfo(integerLiteral);
    if (unsigned_flag) {
        unsigned int ret = (unsigned int) *integerLiteral->getValue().getRawData();
        //Assign value
        ASSERT_STMT(auto unsignedVal = new UnsignedValue(ret, valLocInfo);
        unsignedVal->setStmtInfo(valLocInfo);
        this->switchPassExpr(unsignedVal))
    } else {
        int ret = (int) integerLiteral->getValue().getSExtValue();
        //Assign value
        ASSERT_STMT(auto signedVal = new IntegerValue(ret, valLocInfo);
        signedVal->setStmtInfo(valLocInfo);
        this->switchPassExpr(signedVal))
    }
    if (StmtException::isExceptionHappened()) clearExpressions();
    return false;

}

/*!
 * Pointing to a Variable Declartion
 */
bool SCAM::FindDataFlow::VisitDeclRefExpr(clang::DeclRefExpr *declRefExpr) {

    //Name
    std::string name = declRefExpr->getDecl()->getNameAsString();

    //Get location info of the varDecl
    auto varDeclLocationInfo = getStmtInfo(declRefExpr);

    //Check for global variables
    auto globalVars = ModelGlobal::getModel()->getGlobalVariableMap();
    if (!globalVars.empty() && globalVars.find(name) != globalVars.end()) {
        ASSERT_STMT(auto variableOp = new VariableOperand((globalVars.find(name))->second,varDeclLocationInfo);
        variableOp->setStmtInfo(varDeclLocationInfo);
        this->switchPassExpr(variableOp))
        if (StmtException::isExceptionHappened()) clearExpressions();
        return false;
    }

    //Check for state values
    if (auto enumDecl = llvm::dyn_cast<clang::EnumConstantDecl>(declRefExpr->getDecl())) {

        //Regular enum-value
        std::string typeName = enumDecl->getType()->getAs<clang::EnumType>()->getDecl()->getName().str();
        std::string value = enumDecl->getName().str();
        if (DataTypes::isDataType(typeName)) {
            ASSERT_STMT(auto enumVal = new EnumValue(value, DataTypes::getDataType(typeName),varDeclLocationInfo);
            enumVal->setStmtInfo(varDeclLocationInfo);
            this->switchPassExpr(enumVal))
            if (StmtException::isExceptionHappened()) clearExpressions();
            return false;
        } else if (DataTypes::isLocalDataType(typeName, module->getName())) {
            ASSERT_STMT(auto enumVal = new EnumValue(value, DataTypes::getLocalDataType(module->getName(), typeName),varDeclLocationInfo);
            enumVal->setStmtInfo(varDeclLocationInfo);
            this->switchPassExpr(enumVal))
            if (StmtException::isExceptionHappened()) clearExpressions();
            return false;
        }

    }
    if (auto parmVarDecl = dynamic_cast<clang::ParmVarDecl *>(declRefExpr->getDecl())) {
        if (FindDataFlow::isFunction) {
            auto moduleFuncMap = this->module->getFunctionMap();
            auto globalFunctionMap = ModelGlobal::getModel()->getGlobalFunctionMap();
            if (moduleFuncMap.find(FindDataFlow::functionName) != moduleFuncMap.end()) {
                auto function = moduleFuncMap.find(FindDataFlow::functionName)->second;
                auto paramMap = function->getParamMap();
                if (paramMap.find(name) != paramMap.end()) {
                    ASSERT_STMT(auto paramOp = new ParamOperand(paramMap.find(name)->second,varDeclLocationInfo);
                    paramOp->setStmtInfo(varDeclLocationInfo);
                    this->switchPassExpr(paramOp))
                    if (StmtException::isExceptionHappened()) clearExpressions();
                    return false;
                } else
                    exitVisitor("Unknown parameter " + name + " for function " + function->getName(),
                                varDeclLocationInfo);
            } else if (globalFunctionMap.find(FindDataFlow::functionName) != globalFunctionMap.end()) {
                auto function = globalFunctionMap.find(FindDataFlow::functionName)->second;
                auto paramMap = function->getParamMap();
                if (paramMap.find(name) != paramMap.end()) {
                    ASSERT_STMT(auto paramOp = new ParamOperand(paramMap.find(name)->second,varDeclLocationInfo);
                    paramOp->setStmtInfo(varDeclLocationInfo);
                    this->switchPassExpr(paramOp))
                    if (StmtException::isExceptionHappened()) clearExpressions();
                    return false;
                } else
                    exitVisitor("Unknown parameter " + name + " for function " + function->getName(),
                                varDeclLocationInfo);
            } else
                exitVisitor("Function " + FindDataFlow::functionName + " is not defined", varDeclLocationInfo);
        }
    }
    return true;
}

bool SCAM::FindDataFlow::VisitUnaryOperator(clang::UnaryOperator *unaryOperator) {

    //Unary operator !var, var++ and var-- everything is going to result in a fault.
    if (pass == 0) {
        // Collecting statement location information from clang
        auto unaryOpLocationInfo = getStmtInfo(unaryOperator);

        //Opcode as string: ++,--,!
        std::string opcode = unaryOperator->getOpcodeStr(unaryOperator->getOpcode()).str();
        //Increase pass(LHS assignment)
        pass = 1;
        //Find operand the operation is performed on -> stored in LHS
        FindDataFlow subExpr(unaryOperator->getSubExpr(), this->module, ci, unsigned_flag);
        if (subExpr.getExpr() == nullptr)
            return exitVisitor("Could not translate unary operator", unaryOpLocationInfo);
        //TraverseStmt(unaryOperator->getSubExpr());

        switch (unaryOperator->getOpcode()) {
            case clang::UnaryOperator::Opcode::UO_PreInc:
                if (subExpr.getExpr()->getDataType()->isUnsigned()) {
                    ASSERT_STMT(this->stmt = new Assignment(subExpr.getExpr(),
                                                new Arithmetic(subExpr.getExpr(), "+", new UnsignedValue(1),unaryOpLocationInfo),unaryOpLocationInfo))
                } else
                    ASSERT_STMT(this->stmt = new Assignment(subExpr.getExpr(),
                                                new Arithmetic(subExpr.getExpr(), "+", new IntegerValue(1),unaryOpLocationInfo),unaryOpLocationInfo))
                break;
            case clang::UnaryOperator::Opcode::UO_LNot:
                ASSERT_STMT(this->expr = new UnaryExpr("not", subExpr.getExpr(),unaryOpLocationInfo))
                break;
            case clang::UnaryOperator::Opcode::UO_PreDec:
                if (subExpr.getExpr()->getDataType()->isUnsigned()) {
                    ASSERT_STMT(this->stmt = new Assignment(subExpr.getExpr(),
                                                new Arithmetic(subExpr.getExpr(), "-", new UnsignedValue(1),unaryOpLocationInfo),unaryOpLocationInfo))
                } else
                    ASSERT_STMT(this->stmt = new Assignment(subExpr.getExpr(),
                                                new Arithmetic(subExpr.getExpr(), "-", new IntegerValue(1),unaryOpLocationInfo),unaryOpLocationInfo))
                break;
            case clang::UnaryOperator::Opcode::UO_Minus:
                ASSERT_STMT(this->expr = new UnaryExpr("-", subExpr.getExpr(),unaryOpLocationInfo));
                break;
            case clang::UnaryOperator::Opcode::UO_Not:
                ASSERT_STMT(this->expr = new UnaryExpr("~", subExpr.getExpr(),unaryOpLocationInfo))
                break;
            default:
                return exitVisitor("Unkown/Unallowed unaray operator: " + opcode, unaryOpLocationInfo);
        }
        if (StmtException::isExceptionHappened()) clearExpressions();
    }
    return false;
}

bool SCAM::FindDataFlow::VisitWhileStmt(clang::WhileStmt *whileStmt) {
    if (pass == 0) {
        // Collecting statement location information from clang
        auto whileLocationInfo = getStmtInfo(whileStmt);

        FindDataFlow conditionStmt(whileStmt->getCond(), this->module, ci, false);
        ASSERT_STMT(this->stmt = new While(conditionStmt.getExpr(),whileLocationInfo))
    }
    if (StmtException::isExceptionHappened()) clearExpressions();
    return false;
}

bool SCAM::FindDataFlow::VisitIfStmt(clang::IfStmt *ifStmt) {
    if (pass == 0) {
        // Collecting statement location information from clang
        auto ifLocationInfo = getStmtInfo(ifStmt);

        FindDataFlow conditionStmt(ifStmt->getCond(), this->module, ci, false);
        if (conditionStmt.getExpr() == nullptr)
            return exitVisitor("Translation of condition failed)", ifLocationInfo);
        ASSERT_STMT(this->stmt = new If(conditionStmt.getExpr(),ifLocationInfo))
    }
    if (StmtException::isExceptionHappened()) clearExpressions();
    return false;
}

bool SCAM::FindDataFlow::VisitCXXBoolLiteralExpr(clang::CXXBoolLiteralExpr *boolLiteralExpr) {

    // Collecting statement location information from clang
    auto boolExprLocationInfo = getStmtInfo(boolLiteralExpr);
    ASSERT_STMT(
    switch (pass) {
        case 0:
            this->expr = new BoolValue(boolLiteralExpr->getValue(),boolExprLocationInfo);
            this->stmt = this->expr;
            break;
        case 1:
            return exitVisitor("Boolean Value on LHS", boolExprLocationInfo);
        case 2:
            this->expr = new BoolValue(boolLiteralExpr->getValue(),boolExprLocationInfo);
            this->stmt = this->expr;
            break;
    }
    )
    if (StmtException::isExceptionHappened()) clearExpressions();
}


bool SCAM::FindDataFlow::VisitCXXOperatorCallExpr(clang::CXXOperatorCallExpr *operatorCallExpr) {
    if (pass == 0) {

        // Collecting statement location information from clang
        auto opCallLocationInfo = getStmtInfo(operatorCallExpr);

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
                        return exitVisitor("Unknown error: Stmts can't be processed(a)", opCallLocationInfo);
                    }
                    //get port.read()
                    this->pass = 2;
                    TraverseStmt(operatorCallExpr->getArg(1));
                    if (this->rhsExpr == nullptr) {
                        return exitVisitor("Unknown error: Stmts can't be processed(b)", opCallLocationInfo);
                    }
                    ASSERT_STMT(this->stmt = new Assignment(this->lhsExpr, this->rhsExpr,opCallLocationInfo))
                    if (StmtException::isExceptionHappened()) {clearExpressions(); return false;}
                } else
                    return exitVisitor("Unknown error: Stmts can't be processed(c)", opCallLocationInfo);

            } else
                return exitVisitor("Unknown error: Stmts can't be processed(d)", opCallLocationInfo);
        } else
            return exitVisitor("Unknown error: Stmts can't be processed(e)", opCallLocationInfo);
    }
    return true;
}


bool SCAM::FindDataFlow::VisitCallExpr(clang::CallExpr *callExpr) {
    auto callee = callExpr->getDirectCallee();
    if (callee == nullptr || callee->isCXXClassMember()) return true;

    // Collecting statement location information from clang
    auto callLocationInfo = getStmtInfo(callExpr);

    std::string functionName = callee->getNameAsString();
    if (functionName == "insert_state") {
        if (callExpr->getNumArgs() == 0) {
            ASSERT_STMT(this->stmt = new Wait(callLocationInfo))
            if (StmtException::isExceptionHappened()) clearExpressions();
            return false;
        } else if (callExpr->getNumArgs() == 1) {
            ASSERT_STMT(auto wait = new Wait(callLocationInfo);
            FindStateName findStateName(callExpr->getArg(0));
            wait->setStateName(findStateName.getStateName());
            this->stmt = wait)
            if (StmtException::isExceptionHappened()) clearExpressions();
            return false;
        } else {
            return exitVisitor("Unallowed number of param for important_state()", callLocationInfo);
        }
    }
    auto globalFunctionMap = ModelGlobal::getModel()->getGlobalFunctionMap();

    if (globalFunctionMap.find(functionName) != globalFunctionMap.end()) {
        auto function = globalFunctionMap.find((functionName))->second;
        std::map<std::string, SCAM::Expr *> paramExprMap;
        for (int i = 0; i < callExpr->getNumArgs(); i++) {
            std::string paramName = callee->getParamDecl(i)->getName();
            SCAM::FindDataFlow findArgument(callExpr->getArg(i), this->module, ci, false);
            if (findArgument.getExpr() == nullptr)
                return exitVisitor(functionName + "() has unsupported params", callLocationInfo);
            SCAM::Expr *paramExpr = findArgument.getExpr();
            paramExprMap.insert(std::make_pair(paramName, paramExpr));
        }
        ASSERT_STMT(this->expr = new FunctionOperand(function, paramExprMap,callLocationInfo);
        this->stmt = this->expr)
        if (StmtException::isExceptionHappened()) {clearExpressions(); return false;}
    } else {
        std::string funcName = callExpr->getDirectCallee()->getNameAsString();
        return exitVisitor(funcName + "() is not a valid function", callLocationInfo);
    }
}

bool SCAM::FindDataFlow::VisitImplicitCastExpr(clang::ImplicitCastExpr *implicitCastExpr) {
    if (implicitCastExpr->getType()->isUnsignedIntegerType() &&
        implicitCastExpr->getType().getAsString() == "unsigned int") {
        FindDataFlow unsigendSearch(implicitCastExpr->getSubExpr(), module, ci,
                                    implicitCastExpr->getType()->isUnsignedIntegerType());
        if (unsigendSearch.getExpr() == nullptr) {
            // Collecting statement location information from clang
            auto castExprLocationInfo = getStmtInfo(implicitCastExpr);
            return exitVisitor("Unknown unsigned value", castExprLocationInfo);
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

SCAM::Expr *SCAM::FindDataFlow::getExpr() const {
    return expr;
}

bool SCAM::FindDataFlow::VisitCXXStaticCastExpr(clang::CXXStaticCastExpr *staticCastExpr) {
    // Collecting statement location information from clang
    auto castExprLocationInfo = getStmtInfo(staticCastExpr);

    //FIXME: is the restirction to casting only variables necessary? Remove if hardware is designable
    if (staticCastExpr->getType()->isUnsignedIntegerType() &&
        staticCastExpr->getType().getAsString() == "unsigned int") {
        FindDataFlow subExpr(staticCastExpr->getSubExpr(), module, ci, false);
        if (subExpr.getExpr() != nullptr) {
            ASSERT_STMT(switchPassExpr(new SCAM::Cast(subExpr.getExpr(), DataTypes::getDataType("unsigned"),castExprLocationInfo)))
        } else
            return exitVisitor("static_cast: only variables are allowed as parameter", castExprLocationInfo);
        if (StmtException::isExceptionHappened()) clearExpressions();
        return false;
    } else if (staticCastExpr->getType()->isIntegerType() && staticCastExpr->getType().getAsString() == "int") {
        FindDataFlow subExpr(staticCastExpr->getSubExpr(), module, ci, false);
        if (subExpr.getExpr() != nullptr) {
            ASSERT_STMT(switchPassExpr(new SCAM::Cast(subExpr.getExpr(), DataTypes::getDataType("int"),castExprLocationInfo)))
        } else
            return exitVisitor("static_cast: only variables are allowed as parameter", castExprLocationInfo);
        if (StmtException::isExceptionHappened()) clearExpressions();
        return false;
    } else
        return exitVisitor("static_cast: unallowed static cast", castExprLocationInfo);

}

bool SCAM::FindDataFlow::VisitReturnStmt(clang::ReturnStmt *returnStmt) {
    FindDataFlow returnExpr(returnStmt->getRetValue(), module, ci, false);
    // Collecting statement location information from clang
    auto returnLocationInfo = getStmtInfo(returnStmt);
    if (returnExpr.getExpr() == nullptr)
        return exitVisitor(" return value is null", returnLocationInfo);
    ASSERT_STMT(this->stmt = new SCAM::Return(returnExpr.getExpr(),returnLocationInfo))
    if (StmtException::isExceptionHappened()) clearExpressions();
    return false;
}

bool SCAM::FindDataFlow::VisitCompoundStmt(clang::CompoundStmt *compoundStmt) {
    return false;
}

bool SCAM::FindDataFlow::VisitArraySubscriptExpr(clang::ArraySubscriptExpr *arraySubscriptExpr) {

    // Collecting statement location information from clang
    auto arraySubExprLocationInfo = getStmtInfo(arraySubscriptExpr->getLHS());

    FindDataFlow array(arraySubscriptExpr->getLHS(), module, ci, false);

    if (array.getExpr() != nullptr && array.getExpr()->getDataType()->isArrayType()) {
        if (auto varOp = NodePeekVisitor::nodePeekVariableOperand(array.getExpr())) {
            FindDataFlow findIndex(arraySubscriptExpr->getIdx(), module, ci, false);
            if (auto index = NodePeekVisitor::nodePeekIntegerValue(findIndex.getExpr())) {
                ASSERT_STMT(auto varOp2 = new SCAM::VariableOperand(varOp->getVariable()->getSubVar(index->getValueAsString()),arraySubExprLocationInfo);
                switchPassExpr(varOp2))
                if (StmtException::isExceptionHappened()) clearExpressions();
                return false;
            } else {
                ASSERT_STMT(auto arrOp = new ArrayOperand(varOp->getVariable(), findIndex.getExpr(),arraySubExprLocationInfo);
                switchPassExpr(arrOp))
                if (StmtException::isExceptionHappened()) clearExpressions();
                //TODO: Implement function for arrays.
                /*
                 * Implement a functions that allows to selct from array with an expression.
                 * Because a varialbe myArray[index] does not represent a varialbe that is referencable. It depends on the concrete evaluation of [index].
                 * After value propgation it could be possible to translate it back to a conecrete array select, if the value evaluates to be constant.
                 */
                //throw std::runtime_error("Not implemented");
                return false;
            }
        } else return exitVisitor("Stmt is null", arraySubExprLocationInfo);
    } else return exitVisitor("Not an array type!", arraySubExprLocationInfo);
}

SCAM::Stmt *SCAM::FindDataFlow::getStmt() {
    return this->stmt;
}

SCAM::StmtLocationInfo SCAM::FindDataFlow::getStmtInfo(clang::Stmt *clangStmt) {
    // Getting stmt information from clang
    std::string statement = clang::Lexer::getSourceText(
            clang::CharSourceRange::getTokenRange(clangStmt->getSourceRange()),
            ci.getSourceManager(), ci.getLangOpts()).str();
    auto locStartVec = SCAM::GlobalUtilities::stringSplit(
            clangStmt->getLocStart().printToString(ci.getSourceManager()), ':');
    auto locEndVec = SCAM::GlobalUtilities::stringSplit(
            clangStmt->getLocEnd().printToString(ci.getSourceManager()), ':');
    auto fileDir = locStartVec[0];
    auto rowStartNum = std::stoi(locStartVec[1]);
    auto rowEndNum = std::stoi(locEndVec[1]);
    auto colStartNum = std::stoi(locStartVec[2]);
    auto colEndNum = std::stoi(locEndVec[2]);
    if (colEndNum < colStartNum && rowStartNum == rowEndNum) colEndNum = colStartNum + 1;
    if (rowEndNum < rowStartNum) rowEndNum = rowStartNum;
    SCAM::StmtLocationInfo stmtInfo(statement, fileDir, rowStartNum, rowEndNum, colStartNum, colEndNum);
    return stmtInfo;
}


bool SCAM::FindDataFlow::exitVisitor(const std::string &msg, const SCAM::StmtLocationInfo &stmtInfo) {
    this->stmt = nullptr;
    //Add loggerMsg to the logger
    SCAM::LoggerMsg loggerMsg(msg, stmtInfo, LoggerMsg::SeverityLevel::Error, LoggerMsg::ViolationType::SystemC_PPA_compliance,Logger::getCurrentProcessedLocation());
    SCAM::Logger::addMsg(loggerMsg);
    return false;
}

void SCAM::FindDataFlow::clearExpressions() {
    this->rhsExpr = nullptr;
    this->lhsExpr = nullptr;
    this->expr = nullptr;
    this->stmt = nullptr;
}
