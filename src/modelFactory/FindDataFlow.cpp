//
// Created by tobias on 23.10.15.
//


#include <UnaryExpr.h>
#include <While.h>
#include <If.h>
#include <BoolValue.h>
#include <Arithmetic.h>

#include <clang/Lex/Lexer.h>
#include <Stmts/VariableOperand.h>
#include <Stmts/IntegerValue.h>
#include <Stmts/Read.h>
#include <Stmts/Write.h>
#include <Stmts/Logical.h>
#include <Stmts/Relational.h>
#include <Stmts/Cast.h>
#include <NodePeekVisitor.h>
#include <ModelGlobal.h>
#include <Stmts/StmtCastVisitor.h>
#include "PortOperand.h"
#include "FindDataFlow.h"
#include "FindStateName.h"

#include "DescamException.h"

#include "FindDataFlowFactory.h"
#include "clangCastVisitor.h"

bool DESCAM::FindDataFlow::isFunction = false;
std::string DESCAM::FindDataFlow::functionName;

bool DESCAM::FindDataFlow::VisitBinaryOperator(clang::BinaryOperator *binaryOperator) {
  //Binary Expression is always TOP statement. In case of a sub statement
  // , new FindDataFlow object is necessary
  if (pass_ == 0) {
    // Collecting statement location information from clang
    auto binaryOpLocationInfo = DESCAM::GlobalUtilities::getLocationInfo<clang::Stmt>(binaryOperator, ci_);

    //OperationName
    std::string operationName = binaryOperator->getOpcodeStr().str();
    //Pass = 1 LHS
    //LHS Operator
    auto lhs = binaryOperator->getLHS();
    auto
        findLHS = find_data_flow_factory_->create_new(lhs, this->module_, ci_, unsigned_flag_);

    auto lhsLocationInfo = DESCAM::GlobalUtilities::getLocationInfo<clang::Stmt>(lhs, ci_);
    this->lhs_expr_ = findLHS->getExpr();
    //RHS Operator
    if (this->lhs_expr_ && this->lhs_expr_->getDataType()->isUnsigned()) this->unsigned_flag_ = true;
    auto rhs = binaryOperator->getRHS();

    auto
        findRHS = find_data_flow_factory_->create_new(rhs, this->module_, ci_, unsigned_flag_);
    this->rhs_expr_ = findRHS->getExpr();

    auto rhsLocationInfo = DESCAM::GlobalUtilities::getLocationInfo<clang::Stmt>(rhs, ci_);

    //Are LHS and RHS Valid?
    if (this->rhs_expr_ == nullptr || this->lhs_expr_ == nullptr) {
      std::string message;
      if (!(this->rhs_expr_ && this->lhs_expr_)) message = "Could not translate LHS and RHS of Stmts";
      else if (!this->rhs_expr_) message = "Could not translate RHS of Stmts";
      else message = "Could not translate LHS of Stmts";
      return exitVisitor(message, binaryOpLocationInfo);
    }
    //Setting location information for the lhs and rhs
    this->lhs_expr_->setStmtInfo(lhsLocationInfo);
    this->rhs_expr_->setStmtInfo(rhsLocationInfo);

    //Create new Element
    if (binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_Assign) {
      DESCAM_ASSERT(this->stmt_ = new Assignment(this->lhs_expr_, this->rhs_expr_, binaryOpLocationInfo))
    } else if (binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_LAnd) {
      DESCAM_ASSERT(this->expr_ = new Logical(this->lhs_expr_, "and", this->rhs_expr_, binaryOpLocationInfo))
    } else if (binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_LOr) {
      DESCAM_ASSERT(this->expr_ = new Logical(this->lhs_expr_, "or", this->rhs_expr_, binaryOpLocationInfo))
    } else if (binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_EQ ||
        binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_NE ||
        binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_GE ||
        binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_LE ||
        binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_GT ||
        binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_LT) {
      DESCAM_ASSERT(this->expr_ = new Relational(this->lhs_expr_, operationName, this->rhs_expr_, binaryOpLocationInfo))
    } else if (binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_Add ||
        binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_Div ||
        binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_Rem ||
        binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_Mul ||
        binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_Sub) {
      DESCAM_ASSERT(this->expr_ = new Arithmetic(this->lhs_expr_, operationName, this->rhs_expr_, binaryOpLocationInfo))
    } else if (binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_AddAssign ||
        binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_SubAssign ||
        binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_MulAssign ||
        binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_DivAssign ||
        binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_RemAssign) {
      std::string arith_operator = operationName.substr(0, 1);
      DESCAM_ASSERT(this->stmt_ = new Assignment(this->lhs_expr_,
                                                 new Arithmetic(this->lhs_expr_, arith_operator, this->rhs_expr_,
                                                                binaryOpLocationInfo), binaryOpLocationInfo))
    } else if (binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_Shl) {
      //Special case ... shift depends on LHS Datatype
      if (binaryOperator->getType()->isUnsignedIntegerType()) {

        auto findRHS2 = find_data_flow_factory_->create_new(binaryOperator->getRHS(),
                                                            this->module_,
                                                            ci_,
                                                            true);
        this->rhs_expr_ = findRHS2->getExpr();
      }
      DESCAM_ASSERT(this->expr_ = new Bitwise(this->lhs_expr_, "<<", this->rhs_expr_, binaryOpLocationInfo))
    } else if (binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_Shr) {
      //Special case ... shift depends on LHS Datatype
      if (binaryOperator->getType()->isUnsignedIntegerType()) {
        auto findRHS2 = find_data_flow_factory_->create_new(binaryOperator->getRHS(),
                                                            this->module_,
                                                            ci_,
                                                            true);
        this->rhs_expr_ = findRHS2->getExpr();
      }
      DESCAM_ASSERT(this->expr_ = new Bitwise(this->lhs_expr_, ">>", this->rhs_expr_, binaryOpLocationInfo))
    } else if (binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_And) {
      DESCAM_ASSERT(this->expr_ = new Bitwise(this->lhs_expr_, "&", this->rhs_expr_, binaryOpLocationInfo))
    } else if (binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_Or) {
      DESCAM_ASSERT(this->expr_ = new Bitwise(this->lhs_expr_, "|", this->rhs_expr_, binaryOpLocationInfo))
    } else if (binaryOperator->getOpcode() == clang::BinaryOperator::Opcode::BO_Xor) {
      DESCAM_ASSERT(this->expr_ = new Bitwise(this->lhs_expr_, "^", this->rhs_expr_, binaryOpLocationInfo))
    } else {
      auto msg = "Operator " + operationName + " not defined";
      this->exitVisitor(msg, binaryOpLocationInfo);
    }
    if (DescamException::isExceptionHappened()) clearExpressions();
    return false;
  }
  return true;
}

bool DESCAM::FindDataFlow::VisitConditionalOperator(clang::ConditionalOperator *conditionalOperator) {
  auto condOpLocationInfo = DESCAM::GlobalUtilities::getLocationInfo<clang::Stmt>(conditionalOperator, ci_);
  auto findCond = find_data_flow_factory_->create_new(conditionalOperator->getCond(),
                                                      this->module_,
                                                      ci_,
                                                      false);
  auto condExpr = findCond->getExpr();
  auto findTrue = find_data_flow_factory_->create_new(conditionalOperator->getTrueExpr(),
                                                      this->module_,
                                                      ci_,
                                                      unsigned_flag_);
  auto trueExpr = findTrue->getExpr();
  auto findFalse = find_data_flow_factory_->create_new(conditionalOperator->getFalseExpr(),
                                                       this->module_,
                                                       ci_,
                                                       unsigned_flag_);
  auto falseExpr = findFalse->getExpr();
  if (condExpr && trueExpr && falseExpr) {
    //conditionalOperator->dumpColor();
    DESCAM_ASSERT(this->expr_ = new Ternary(condExpr, trueExpr, falseExpr, condOpLocationInfo))
    if (DescamException::isExceptionHappened())
      clearExpressions();
  } else return exitVisitor("Operator not correctly used!", condOpLocationInfo);
  return false;
}

bool DESCAM::FindDataFlow::VisitCXXMemberCallExpr(clang::CXXMemberCallExpr *memberCallExpr) {
  //Call: ->write(argument)
  if (pass_ == 0) {
    // Collecting statement location information from clang
    auto memberCallLocationInfo = DESCAM::GlobalUtilities::getLocationInfo<clang::Stmt>(memberCallExpr, ci_);
    //Return value:
//    std::string returnValue = memberCallExpr->getCallReturnType(ci_->getASTContext()).getAsString();
    //Callee: E.g. x.foo() -> foo() is callee
    //Assign CalleeOperator later for now store string
    std::string methodString;
    //Supported interface methods
    std::vector<std::string> supportedMethods = {"read", "write", "try_read", "try_write", "master_read",
                                                 "master_write", "slave_read", "slave_write", "set", "get", "wait",
                                                 "peek", "poke"};
    auto functions = module_->getFunctionMap();
//    if (auto *memberExpr = clangCastVisitor<clang::MemberExpr>(memberCallExpr->getCallee()).Get()) {
    if (auto *memberExpr = clangCastVisitor(memberCallExpr->getCallee()).GetMemberExpr()) {
      //Assign name of the method
      methodString = memberExpr->getMemberDecl()->getNameAsString();
      //Get location info of the method
      auto calleeLocationInfo = DESCAM::GlobalUtilities::getLocationInfo<clang::Stmt>(memberCallExpr->getCallee(), ci_);
      //Check whether method is supported, if not -> Bad Stmts
      if (std::find(supportedMethods.begin(), supportedMethods.end(), methodString) != supportedMethods.end()) {
//                this->pass__ = 1;
        //Including a wait, but only with SC_ZERO_TIME
        if (methodString == "wait") {
          if (memberCallExpr->getNumArgs() == 2) {
            auto firstArgument = find_data_flow_factory_->create_new(memberCallExpr->getArg(0),
                                                                     this->module_,
                                                                     ci_,
                                                                     false);
            auto secondArgument = find_data_flow_factory_->create_new(memberCallExpr->getArg(1),
                                                                      this->module_,
                                                                      ci_,
                                                                      false);
            DESCAM_ASSERT(this->stmt_ = new Wait(
                calleeLocationInfo)) //FIXME: don't know how to check for the arguments or if needed to begin with
            if (DescamException::isExceptionHappened()) clearExpressions();
            return false;
          } else
            return exitVisitor("Only wait(0) is allowed", calleeLocationInfo);
        } else this->pass_ = 1;
        //Function
      } else if (functions.find(methodString) != functions.end()) {
        //Analyse parameter
        auto function = functions.find(methodString)->second;
        std::map<std::string, DESCAM::Expr *> paramValueMap;
        for (int i = 0; i < memberCallExpr->getNumArgs(); i++) {
          std::string paramName = memberCallExpr->getMethodDecl()->getParamDecl(i)->getName().str();
          auto findArgument = find_data_flow_factory_->create_new(memberCallExpr->getArg(i),
                                                                  this->module_,
                                                                  ci_,
                                                                  false);
          if (findArgument->getExpr() == nullptr)
            return exitVisitor(methodString + "() has unsupported params", calleeLocationInfo);
          DESCAM::Expr *paramExpr = findArgument->getExpr();
          paramValueMap.insert(std::make_pair(paramName, paramExpr));
        }
        DESCAM_ASSERT(this->expr_ = new FunctionOperand(function, paramValueMap, calleeLocationInfo);
                          this->stmt_ = this->expr_)
        if (DescamException::isExceptionHappened()) clearExpressions();
        return false;
      } else {
        return exitVisitor(methodString + "() is not a supported method!", calleeLocationInfo);
      }
    } else
      return exitVisitor("[ADD StmtToStringHere] not a Variable", memberCallLocationInfo);


    //Search for member that is called on [e.G. x.foo(), find x]
    auto implicitObjArg = memberCallExpr->getImplicitObjectArgument();
    TraverseStmt(implicitObjArg);

    if (this->lhs_expr_ != nullptr) {
      //Get location info of the member
      auto member_location_info = DESCAM::GlobalUtilities::getLocationInfo<clang::Stmt>(implicitObjArg, ci_);
      if (auto *operand = StmtCastVisitor<PortOperand>(this->lhs_expr_).Get()) {
        //Lambda for finding the stateName
        auto getStateName = [=]() -> std::string {
          if (memberCallExpr->getNumArgs() == 2) {
            find_state_name_->setup(memberCallExpr->getArg(1));
            return find_state_name_->getStateName();
          } else if (memberCallExpr->getNumArgs() == 3) {
            this->find_state_name_->setup(memberCallExpr->getArg(2));
            return find_state_name_->getStateName();
          } else return "";
        };

        auto getArgument = [=](clang::Stmt *stmt) {
          auto findArgument = find_data_flow_factory_->create_new(stmt,
                                                                  this->module_,
                                                                  ci_,
                                                                  operand->getDataType()->isUnsigned());
          return findArgument->getExpr();
        };

        auto hasValidArgument = [=](clang::Stmt *stmt) {
          return getArgument(stmt) != nullptr;
        };

        auto interface = operand->getPort()->getInterface();
        if (interface->isBlocking()) {
          assert(memberCallExpr->getNumArgs() > 0 && memberCallExpr->getNumArgs() < 4 &&
              "Wrong number of arguments arguments");
          if (methodString == "peek" && memberCallExpr->getNumArgs() == 0) {
            DESCAM_ASSERT(this->expr_ = new Peek(operand->getPort(), memberCallLocationInfo))
          } else if (methodString == "poke" && memberCallExpr->getNumArgs() == 0) {
            DESCAM_ASSERT(this->expr_ = new Peek(operand->getPort(), memberCallLocationInfo))
          } else if (memberCallExpr->getNumArgs() > 0 && hasValidArgument(memberCallExpr->getArg((0)))) {
            //Blocking read
            if (methodString == "read") {
              //add variable as parameter
              if (auto variableOp = StmtCastVisitor<VariableOperand>(getArgument(
                  memberCallExpr->getArg((0)))).Get()) {
                DESCAM_ASSERT(auto read = new Read(operand->getPort(), variableOp, false, nullptr,
                                                   memberCallLocationInfo);
                                  read->setStateName(getStateName());
                                  this->stmt_ = read)
              } else
                return exitVisitor("Could not dynamically cast argument as VariableOperand",
                                   memberCallLocationInfo);
              //non Blocking read
            } else if (methodString == "try_read" && memberCallExpr->getNumArgs() == 1) {
              //add variable as parameter
              if (auto variableOp = StmtCastVisitor<VariableOperand>(getArgument(
                  memberCallExpr->getArg((0)))).Get()) {
                DESCAM_ASSERT(this->stmt_ = new Read(operand->getPort(), variableOp, true, nullptr,
                                                     memberCallLocationInfo))
              } else
                return exitVisitor("Could not dynamically cast argument as VariableOperand",
                                   memberCallLocationInfo);
            } else if (methodString == "try_read" && memberCallExpr->getNumArgs() > 1) {
              //add variable as parameter
              if (auto *variableOp = StmtCastVisitor<VariableOperand>(getArgument(
                  memberCallExpr->getArg(0))).Get()) {
                if (hasValidArgument(memberCallExpr->getArg(1))) {
                  if (auto statusOp = StmtCastVisitor<VariableOperand>(getArgument(
                      memberCallExpr->getArg(1))).Get()) {
                    DESCAM_ASSERT(auto read = new Read(operand->getPort(), variableOp, true, statusOp,
                                                       memberCallLocationInfo);
                                      read->setStateName(getStateName());
                                      this->stmt_ = read)
                  } else
                    return exitVisitor("Could not dynamically cast argument as VariableOperand",
                                       memberCallLocationInfo);
                } else
                  return exitVisitor("Could not find parameter", member_location_info);
              } else
                return exitVisitor("Could not dynamically cast argument as VariableOperand",
                                   memberCallLocationInfo);
            } else if (methodString == "write") {
              DESCAM_ASSERT(
                  auto write = new Write(operand->getPort(), getArgument(memberCallExpr->getArg(0)),
                                         false, nullptr, memberCallLocationInfo);
                  write->setStateName(getStateName());
                  this->stmt_ = write)
            }
              //non Blocking write
            else if (methodString == "try_write" && memberCallExpr->getNumArgs() == 1) {
              DESCAM_ASSERT(
                  this->stmt_ = new Write(operand->getPort(), getArgument(memberCallExpr->getArg(0)),
                                          true, nullptr, memberCallLocationInfo))
            }
              //non Blocking write with status flag
            else if (methodString == "try_write" && memberCallExpr->getNumArgs() > 1) {
              if (hasValidArgument(memberCallExpr->getArg(1))) {
                if (auto statusOp = StmtCastVisitor<VariableOperand>(getArgument(
                    memberCallExpr->getArg(1))).Get()) {
                  DESCAM_ASSERT(auto write = new Write(operand->getPort(),
                                                       getArgument(memberCallExpr->getArg(0)),
                                                       true, statusOp, memberCallLocationInfo);
                                    write->setStateName(getStateName());
                                    this->stmt_ = write)
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
            auto findArgument = find_data_flow_factory_->create_new(memberCallExpr->getArg(0),
                                                                    this->module_,
                                                                    ci_,
                                                                    false);
            if (findArgument->getExpr() != nullptr) {
              if (auto *variableOp = StmtCastVisitor<VariableOperand>(findArgument->getExpr()).Get()) {
                DESCAM_ASSERT(this->stmt_ = new Read(operand->getPort(), variableOp, true, nullptr,
                                                     memberCallLocationInfo))
              } else
                return exitVisitor("Read argument is not a variable!", memberCallLocationInfo);
            } else
              return exitVisitor("Could not find parameter", member_location_info);
          } else if (methodString == "set") {
            auto findArgument = find_data_flow_factory_->create_new(memberCallExpr->getArg(0),
                                                                    this->module_,
                                                                    ci_,
                                                                    operand->getDataType()->isUnsigned());
            if (findArgument->getExpr() != nullptr) {
              DESCAM_ASSERT(
                  this->stmt_ = new Write(operand->getPort(), findArgument->getExpr(), true, nullptr,
                                          memberCallLocationInfo))
            } else
              return exitVisitor("Could not find parameter", member_location_info);
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
              if (auto *variableOp = StmtCastVisitor<VariableOperand>(getArgument(
                  memberCallExpr->getArg((0)))).Get()) {
                DESCAM_ASSERT(auto read = new Read(operand->getPort(), variableOp, false, nullptr,
                                                   memberCallLocationInfo);
                                  this->stmt_ = read;
                                  read->setStateName(getStateName()))
              } else
                return exitVisitor("Could not dynamically cast argument as VariableOperand",
                                   memberCallLocationInfo);
            } else if (methodString == "master_write") {
              DESCAM_ASSERT(
                  auto write = new Write(operand->getPort(), getArgument(memberCallExpr->getArg((0))),
                                         false, nullptr, memberCallLocationInfo);
                  write->setStateName(getStateName());
                  this->stmt_ = write
              )
            } else
              return exitVisitor(
                  "Unsupported method: " + methodString + " for interface " + interface->getName(),
                  memberCallLocationInfo);
          } else
            return exitVisitor("Argument 1 can not be analyzed", memberCallLocationInfo);

        } else if (interface->isSlave()) {
          assert(memberCallExpr->getNumArgs() > 0 && memberCallExpr->getNumArgs() < 3 &&
              "Wrong number of arguments arguments");
          if (hasValidArgument(memberCallExpr->getArg((0)))) {
            if (methodString == "slave_read" && memberCallExpr->getNumArgs() == 1) {
              if (auto variableOp = StmtCastVisitor<VariableOperand>(getArgument(
                  memberCallExpr->getArg(0))).Get()) {
                DESCAM_ASSERT(this->stmt_ = new Read(operand->getPort(), variableOp, true, nullptr,
                                                     memberCallLocationInfo))
              } else
                return exitVisitor("Could not dynamically cast argument as VariableOperand",
                                   memberCallLocationInfo);
            } else if (methodString == "slave_read" && memberCallExpr->getNumArgs() > 1) {
              //add variable as parameter
              if (auto *variableOp = StmtCastVisitor<VariableOperand>(getArgument(
                  memberCallExpr->getArg(0))).Get()) {
                if (hasValidArgument(memberCallExpr->getArg(1))) {
                  if (auto statusOp = StmtCastVisitor<VariableOperand>(getArgument(
                      memberCallExpr->getArg(1))).Get()) {
                    DESCAM_ASSERT(auto read = new Read(operand->getPort(), variableOp, true, statusOp,
                                                       memberCallLocationInfo);
                                      read->setStateName(getStateName());
                                      this->stmt_ = read)
                  } else
                    return exitVisitor("Could not dynamically cast argument as VariableOperand",
                                       memberCallLocationInfo);
                } else
                  return exitVisitor("Could not find parameter", member_location_info);
              } else
                return exitVisitor("Could not dynamically cast argument as VariableOperand",
                                   memberCallLocationInfo);
            } else if (methodString == "slave_write") {
              DESCAM_ASSERT(
                  auto write = new Write(operand->getPort(), getArgument(memberCallExpr->getArg(0)));
                  this->stmt_ = write)
            } else
              return exitVisitor(
                  "Unsupported method: " + methodString + "for interface " + interface->getName(),
                  memberCallLocationInfo);
          } else {
            return exitVisitor("Unknown interface: " + interface->getName(), memberCallLocationInfo);
          }
        }

      } else {
        exitVisitor("couldn't dynamically cast this->lhs_expr_ to portOperand\n", memberCallLocationInfo);
      }
    }
    //Object analyzed
    if (DescamException::isExceptionHappened()) clearExpressions();
    return false;
  }
  //Here only if object is LHS or RHS
  //Member call: obj->
  if (pass_ == 1) {
    auto findMemberCall =
        find_data_flow_factory_->create_new(memberCallExpr, this->module_, ci_, false);
    this->lhs_expr_ = findMemberCall->getExpr();
  }
  //Case  var = x.foo(); RHS of operator
  //RHS is a Call
  if (pass_ == 2) {
    auto findMemberCall =
        find_data_flow_factory_->create_new(memberCallExpr, this->module_, ci_, false);
    this->rhs_expr_ = findMemberCall->getExpr();
    return false;
  }
  return true;
}

//Import here: Search for Compound variables first
bool DESCAM::FindDataFlow::VisitMemberExpr(clang::MemberExpr *memberExpr) {

  //Get location info of the member
  auto member_location_info = DESCAM::GlobalUtilities::getLocationInfo<clang::Stmt>(memberExpr, ci_);

  //Name of member field
  std::string name = memberExpr->getMemberDecl()->getName().str();
  if (name.empty()) exitVisitor("Member has no name ", member_location_info);

  //Get member Map for module
  const std::map<std::string, Variable *> &memberMap = module_->getVariableMap();
  auto globalVariableMap = ModelGlobal::getModel()->getGlobalVariableMap();

  const std::map<std::string, Function *> &functionMap = module_->getFunctionMap();

  // Determine name for compound: var.x;
  auto findParentOfSubVar = find_data_flow_factory_->create_new((*memberExpr->child_begin()),
                                                                this->module_,
                                                                ci_,
                                                                false);
  if (findParentOfSubVar->getExpr() != nullptr) {
    //FIXME: Get rid of sub variables by also using ArrayOperand on compound variables
    if (auto parent = StmtCastVisitor<DESCAM::VariableOperand>(findParentOfSubVar->getExpr()).Get()) {
      if (memberMap.find(parent->getOperandName()) != memberMap.end()) {
        //Assign value
        DESCAM_ASSERT(this->switchPassExpr(new VariableOperand(memberMap.at(parent->getOperandName())->getSubVar(name),
                                                               member_location_info)))
        if (DescamException::isExceptionHappened()) clearExpressions();
        return false;
      } else if (globalVariableMap.find(parent->getOperandName()) != globalVariableMap.end()) {
        //Assign value
        DESCAM_ASSERT(this->switchPassExpr(
            new VariableOperand(globalVariableMap.at(parent->getOperandName())->getSubVar(name), member_location_info)))
        if (DescamException::isExceptionHappened()) clearExpressions();
        return false;
      } else
        return exitVisitor(parent->getOperandName() + " is not a parent of " + name, member_location_info);
    } else if (auto parent = StmtCastVisitor<DESCAM::FunctionOperand>(findParentOfSubVar->getExpr()).Get()) {
      if (functionMap.find(parent->getOperandName()) != functionMap.end()) {
        //Assign value
        TERMINATE("Dont remove ... if never flags ... remove!")
      } else
        return exitVisitor(parent->getOperandName() + " is not a parent of " + name, member_location_info);
    } else if (auto parent = StmtCastVisitor<DESCAM::ParamOperand>(findParentOfSubVar->getExpr()).Get()) {
      auto paramMap = functionMap.find(FindDataFlow::functionName)->second->getParamMap();
      if (paramMap.find(parent->getOperandName()) != paramMap.end()) {
        //Assign value
        auto param = parent->getParameter()->getSubVar(name);
        DESCAM_ASSERT(this->switchPassExpr(new ParamOperand(param, member_location_info)))
        if (DescamException::isExceptionHappened()) clearExpressions();
        return false;
      } else
        return exitVisitor(parent->getOperandName() + " is not a parent of " + name, member_location_info);
    } else
      return exitVisitor("Cant find parent for variable: " + name, member_location_info);
  }
  //Simple Variable
  if (!memberMap.empty()) {
    if (memberMap.find(name) != memberMap.end()) {
      //Assign value
      DESCAM_ASSERT(this->switchPassExpr(new VariableOperand(memberMap.at(name), member_location_info)))
      if (DescamException::isExceptionHappened()) clearExpressions();
      return false;
    }
  }
  //Global Variable
  if (!globalVariableMap.empty()) {
    if (globalVariableMap.find(name) != globalVariableMap.end()) {
      //Assign value
      DESCAM_ASSERT(this->switchPassExpr(new VariableOperand(globalVariableMap.at(name), member_location_info)))
      if (DescamException::isExceptionHappened()) clearExpressions();
      return false;
    }
  }
  //Only the case, if the operation is Call
  std::map<std::string, Port *> portMap = module_->getPorts();
  //Read/Write on Port
  if (portMap.find(name) != portMap.end()) {
    //Assign value
    DESCAM_ASSERT(this->switchPassExpr(new PortOperand(portMap.find(name)->second, member_location_info)))
    if (DescamException::isExceptionHappened()) {
      clearExpressions();
      return false;
    }
    return true;
  }
  //TODO: remove
  //States Enum
//    if (name == "section" || name == "next_section") {
//        //Assign value
//        if (name == "section") this->switchPassExpr(new SectionOperand(module_->getFSM()->getSectionVariable()));
//        else this->switchPassExpr(new SectionOperand(module_->getFSM()->getNextSectionVariable()));
//        return true;
//    } else return exitVisitor("Could not analyze " + name);
  return exitVisitor("Could not analyze " + name, member_location_info);
}

bool DESCAM::FindDataFlow::VisitIntegerLiteral(clang::IntegerLiteral *integerLiteral) {

  auto valLocInfo = DESCAM::GlobalUtilities::getLocationInfo<clang::Stmt>(integerLiteral, ci_);
  if (unsigned_flag_) {
    unsigned int ret = (unsigned int) *integerLiteral->getValue().getRawData();
    //Assign value
    DESCAM_ASSERT(auto unsignedVal = new UnsignedValue(ret, valLocInfo);
                      unsignedVal->setStmtInfo(valLocInfo);
                      this->switchPassExpr(unsignedVal))
  } else {
    int ret = (int) integerLiteral->getValue().getSExtValue();
    //Assign value
    DESCAM_ASSERT(auto signedVal = new IntegerValue(ret, valLocInfo);
                      signedVal->setStmtInfo(valLocInfo);
                      this->switchPassExpr(signedVal))
  }
  if (DescamException::isExceptionHappened()) clearExpressions();
  return false;

}

/*!
 * Pointing to a Variable Declaration
 */
bool DESCAM::FindDataFlow::VisitDeclRefExpr(clang::DeclRefExpr *declRefExpr) {

  //Name
  std::string name = declRefExpr->getDecl()->getNameAsString();

  //Get location info of the varDecl
  auto varDeclLocationInfo = DESCAM::GlobalUtilities::getLocationInfo<clang::Stmt>(declRefExpr, ci_);

  //Check for global variables
  auto globalVars = ModelGlobal::getModel()->getGlobalVariableMap();
  if (!globalVars.empty() && globalVars.find(name) != globalVars.end()) {
    DESCAM_ASSERT(auto variableOp = new VariableOperand((globalVars.find(name))->second, varDeclLocationInfo);
                      variableOp->setStmtInfo(varDeclLocationInfo);
                      this->switchPassExpr(variableOp))
    if (DescamException::isExceptionHappened()) clearExpressions();
    return false;
  }

  //Check for state values
  if (auto enumDecl = clangCastVisitor(declRefExpr->getDecl()).GetEnumConstantDecl()) {

    //Regular enum-value
    std::string typeName = enumDecl->getType()->getAs<clang::EnumType>()->getDecl()->getName().str();
    std::string value = enumDecl->getName().str();
    if (DataTypes::isDataType(typeName)) {
      DESCAM_ASSERT(auto enumVal = new EnumValue(value, DataTypes::getDataType(typeName), varDeclLocationInfo);
                        enumVal->setStmtInfo(varDeclLocationInfo);
                        this->switchPassExpr(enumVal))
      if (DescamException::isExceptionHappened()) clearExpressions();
      return false;
    } else if (DataTypes::isLocalDataType(typeName, module_->getName())) {
      DESCAM_ASSERT(auto enumVal =
          new EnumValue(value, DataTypes::getLocalDataType(module_->getName(), typeName), varDeclLocationInfo);
                        enumVal->setStmtInfo(varDeclLocationInfo);
                        this->switchPassExpr(enumVal))
      if (DescamException::isExceptionHappened()) clearExpressions();
      return false;
    }

  }

  if (auto parmVarDecl = clangCastVisitor(declRefExpr->getDecl()).GetParmVarDecl()) {
    if (FindDataFlow::isFunction) {
      auto moduleFuncMap = this->module_->getFunctionMap();
      auto globalFunctionMap = ModelGlobal::getModel()->getGlobalFunctionMap();
      if (moduleFuncMap.find(FindDataFlow::functionName) != moduleFuncMap.end()) {
        auto function = moduleFuncMap.find(FindDataFlow::functionName)->second;
        auto paramMap = function->getParamMap();
        if (paramMap.find(name) != paramMap.end()) {
          DESCAM_ASSERT(auto paramOp = new ParamOperand(paramMap.find(name)->second, varDeclLocationInfo);
                            paramOp->setStmtInfo(varDeclLocationInfo);
                            this->switchPassExpr(paramOp))
          if (DescamException::isExceptionHappened()) clearExpressions();
          return false;
        } else
          exitVisitor("Unknown parameter " + name + " for function " + function->getName(),
                      varDeclLocationInfo);
      } else if (globalFunctionMap.find(FindDataFlow::functionName) != globalFunctionMap.end()) {
        auto function = globalFunctionMap.find(FindDataFlow::functionName)->second;
        auto paramMap = function->getParamMap();
        if (paramMap.find(name) != paramMap.end()) {
          DESCAM_ASSERT(auto paramOp = new ParamOperand(paramMap.find(name)->second, varDeclLocationInfo);
                            paramOp->setStmtInfo(varDeclLocationInfo);
                            this->switchPassExpr(paramOp))
          if (DescamException::isExceptionHappened()) clearExpressions();
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

bool DESCAM::FindDataFlow::VisitUnaryOperator(clang::UnaryOperator *unaryOperator) {

  //Unary operator !var, var++ and var-- everything is going to result in a fault.
  if (pass_ == 0) {
    // Collecting statement location information from clang
    auto unaryOpLocationInfo = DESCAM::GlobalUtilities::getLocationInfo<clang::Stmt>(unaryOperator, ci_);

    //Opcode as string: ++,--,!
    std::string opcode = clang::UnaryOperator::getOpcodeStr(unaryOperator->getOpcode()).str();
    //Increase pass_(LHS assignment)
    pass_ = 1;
    //Find operand the operation is performed on -> stored in LHS
    auto subExpr = find_data_flow_factory_->create_new(unaryOperator->getSubExpr(),
                                                       this->module_,
                                                       ci_,
                                                       unsigned_flag_);
    if (subExpr->getExpr() == nullptr)
      return exitVisitor("Could not translate unary operator", unaryOpLocationInfo);
    //TraverseStmt(unaryOperator->getSubExpr());

    switch (unaryOperator->getOpcode()) {
      case clang::UnaryOperator::Opcode::UO_PreInc:
        if (subExpr->getExpr()->getDataType()->isUnsigned()) {
          DESCAM_ASSERT(this->stmt_ = new Assignment(subExpr->getExpr(),
                                                     new Arithmetic(subExpr->getExpr(),
                                                                    "+",
                                                                    new UnsignedValue(1),
                                                                    unaryOpLocationInfo), unaryOpLocationInfo))
        } else
          DESCAM_ASSERT(this->stmt_ = new Assignment(subExpr->getExpr(),
                                                     new Arithmetic(subExpr->getExpr(),
                                                                    "+",
                                                                    new IntegerValue(1),
                                                                    unaryOpLocationInfo), unaryOpLocationInfo))
        break;
      case clang::UnaryOperator::Opcode::UO_LNot:DESCAM_ASSERT(
            this->expr_ = new UnaryExpr("not", subExpr->getExpr(), unaryOpLocationInfo))
        break;
      case clang::UnaryOperator::Opcode::UO_PreDec:
        if (subExpr->getExpr()->getDataType()->isUnsigned()) {
          DESCAM_ASSERT(this->stmt_ = new Assignment(subExpr->getExpr(),
                                                     new Arithmetic(subExpr->getExpr(),
                                                                    "-",
                                                                    new UnsignedValue(1),
                                                                    unaryOpLocationInfo), unaryOpLocationInfo))
        } else
          DESCAM_ASSERT(this->stmt_ = new Assignment(subExpr->getExpr(),
                                                     new Arithmetic(subExpr->getExpr(),
                                                                    "-",
                                                                    new IntegerValue(1),
                                                                    unaryOpLocationInfo), unaryOpLocationInfo))
        break;
      case clang::UnaryOperator::Opcode::UO_Minus:DESCAM_ASSERT(
            this->expr_ = new UnaryExpr("-", subExpr->getExpr(), unaryOpLocationInfo))
        break;
      case clang::UnaryOperator::Opcode::UO_Not:DESCAM_ASSERT(
            this->expr_ = new UnaryExpr("~", subExpr->getExpr(), unaryOpLocationInfo))
        break;
      default:return exitVisitor("Unknown/Disallowed unary operator: " + opcode, unaryOpLocationInfo);
    }
    if (DescamException::isExceptionHappened()) clearExpressions();
  }
  return false;
}

bool DESCAM::FindDataFlow::VisitWhileStmt(clang::WhileStmt *whileStmt) {
  if (pass_ == 0) {
    // Collecting statement location information from clang
    auto whileLocationInfo = DESCAM::GlobalUtilities::getLocationInfo<clang::Stmt>(whileStmt, ci_);

    auto conditionStmt =
        find_data_flow_factory_->create_new(whileStmt->getCond(), this->module_, ci_, false);
    DESCAM_ASSERT(this->stmt_ = new While(conditionStmt->getExpr(), whileLocationInfo))
  }
  if (DescamException::isExceptionHappened()) clearExpressions();
  return false;
}

bool DESCAM::FindDataFlow::VisitIfStmt(clang::IfStmt *ifStmt) {
  if (pass_ == 0) {
    // Collecting statement location information from clang
    auto ifLocationInfo = DESCAM::GlobalUtilities::getLocationInfo<clang::Stmt>(ifStmt, ci_);

    auto conditionStmt =
        find_data_flow_factory_->create_new(ifStmt->getCond(), this->module_, ci_, false);
    if (conditionStmt->getExpr() == nullptr)
      return exitVisitor("Translation of condition failed)", ifLocationInfo);
    DESCAM_ASSERT(this->stmt_ = new If(conditionStmt->getExpr(), ifLocationInfo))
  }
  if (DescamException::isExceptionHappened()) clearExpressions();
  return false;
}

bool DESCAM::FindDataFlow::VisitCXXBoolLiteralExpr(clang::CXXBoolLiteralExpr *boolLiteralExpr) {

  // Collecting statement location information from clang
  auto boolExprLocationInfo = DESCAM::GlobalUtilities::getLocationInfo<clang::Stmt>(boolLiteralExpr, ci_);
  DESCAM_ASSERT(
      switch (pass_) {
        case 0:this->expr_ = new BoolValue(boolLiteralExpr->getValue(), boolExprLocationInfo);
          this->stmt_ = this->expr_;
          break;
        case 1:return exitVisitor("Boolean Value on LHS", boolExprLocationInfo);
        case 2:this->expr_ = new BoolValue(boolLiteralExpr->getValue(), boolExprLocationInfo);
          this->stmt_ = this->expr_;
          break;
      }
  )
  if (DescamException::isExceptionHappened()) clearExpressions();
//  return false;
}

bool DESCAM::FindDataFlow::VisitCXXOperatorCallExpr(clang::CXXOperatorCallExpr *operatorCallExpr) {
  if (pass_ == 0) {

    // Collecting statement location information from clang
    auto opCallLocationInfo = DESCAM::GlobalUtilities::getLocationInfo<clang::Stmt>(operatorCallExpr, ci_);

    //Find assignment of structs -> which is represented as an overloaded copy
    // ComplexType foo = port[ComplexType].read()
    //Return-type is an expression(is that always the case?)
    if (!operatorCallExpr->isTypeDependent() && operatorCallExpr->getCallReturnType(ci_->getASTContext())->isReferenceType()) {
      if (clang::OverloadedOperatorKind::OO_Equal == operatorCallExpr->getOperator()) {
        if (operatorCallExpr->getNumArgs() == 2) {
          //get foo
          this->pass_ = 1;
          TraverseStmt(operatorCallExpr->getArg(0));
          if (this->lhs_expr_ == nullptr) {
            return exitVisitor("Unknown error: Stmts can't be processed(a)", opCallLocationInfo);
          }
          //get port.read()
          this->pass_ = 2;
          TraverseStmt(operatorCallExpr->getArg(1));
          if (this->rhs_expr_ == nullptr) {
            return exitVisitor("Unknown error: Stmts can't be processed(b)", opCallLocationInfo);
          }
          DESCAM_ASSERT(this->stmt_ = new Assignment(this->lhs_expr_, this->rhs_expr_, opCallLocationInfo))
          if (DescamException::isExceptionHappened()) {
            clearExpressions();
            return false;
          }
        } else
          return exitVisitor("Unknown error: Stmts can't be processed(c)", opCallLocationInfo);

      } else
        return exitVisitor("Unknown error: Stmts can't be processed(d)", opCallLocationInfo);
    }
    //else
     // return exitVisitor("Unknown error: Stmts can't be processed(e)", opCallLocationInfo);
  }
  return true;
}

bool DESCAM::FindDataFlow::VisitCallExpr(clang::CallExpr *callExpr) {
  auto callee = callExpr->getDirectCallee();
  if (callee == nullptr || callee->isCXXClassMember()) {
    return true;
  }

  // Collecting statement location information from clang
  auto callLocationInfo = DESCAM::GlobalUtilities::getLocationInfo<clang::Stmt>(callExpr, ci_);

  std::string func_name = callee->getNameAsString();
  if (func_name == "insert_state") {
    if (callExpr->getNumArgs() == 0) {
      DESCAM_ASSERT(this->stmt_ = new Wait(callLocationInfo))
      if (DescamException::isExceptionHappened()) clearExpressions();
      return false;
    } else if (callExpr->getNumArgs() == 1) {
      DESCAM_ASSERT(auto wait = new Wait(callLocationInfo);
                        this->find_state_name_->setup(callExpr->getArg(0));
                        wait->setStateName(find_state_name_->getStateName());
                        this->stmt_ = wait)
      if (DescamException::isExceptionHappened()) clearExpressions();
      return false;
    } else {
      return exitVisitor("Disallowed number of param for important_state()", callLocationInfo);
    }
  }
  auto globalFunctionMap = ModelGlobal::getModel()->getGlobalFunctionMap();
  if (globalFunctionMap.find(func_name) != globalFunctionMap.end()) {
    auto function = globalFunctionMap.find((func_name))->second;
    std::map<std::string, DESCAM::Expr *> paramExprMap;
    for (int i = 0; i < callExpr->getNumArgs(); i++) {
      std::string paramName = callee->getParamDecl(i)->getName().str();
      auto findArgument =
          find_data_flow_factory_->create_new(callExpr->getArg(i), this->module_, ci_, false);
      if (findArgument->getExpr() == nullptr)
        return exitVisitor(func_name + "() has unsupported params", callLocationInfo);
      DESCAM::Expr *paramExpr = findArgument->getExpr();
      paramExprMap.insert(std::make_pair(paramName, paramExpr));
    }
    DESCAM_ASSERT(this->expr_ = new FunctionOperand(function, paramExprMap, callLocationInfo);
                      this->stmt_ = this->expr_)
    if (DescamException::isExceptionHappened()) { clearExpressions(); }
    return false;

  } else {
    std::string funcName = callExpr->getDirectCallee()->getNameAsString();
    return exitVisitor(funcName + "() is not a valid function", callLocationInfo);
  }

}

bool DESCAM::FindDataFlow::VisitImplicitCastExpr(clang::ImplicitCastExpr *implicitCastExpr) {
  if (implicitCastExpr->getType()->isUnsignedIntegerType() &&
      implicitCastExpr->getType().getAsString() == "unsigned int") {
    auto unsigned_search =
        find_data_flow_factory_->create_new(implicitCastExpr->getSubExpr(), module_, ci_,
                                            implicitCastExpr->getType()->isUnsignedIntegerType());
    if (unsigned_search->getExpr() == nullptr) {
      // Collecting statement location information from clang
      auto castExprLocationInfo = DESCAM::GlobalUtilities::getLocationInfo<clang::Stmt>(implicitCastExpr, ci_);
      return exitVisitor("Unknown unsigned value", castExprLocationInfo);
    }
    switchPassExpr(unsigned_search->getExpr());
    return false;
  }
  return true;

}

void DESCAM::FindDataFlow::switchPassExpr(DESCAM::Expr *expr) {
  if (expr == nullptr) TERMINATE(" Can't pass_ a nullptr")
  switch (this->pass_) {
    case 0:this->expr_ = expr;
      break;
    case 1:this->lhs_expr_ = expr;
      break;
    case 2:this->rhs_expr_ = expr;
      break;
    default: TERMINATE("Pass is out of range")
  }
}

DESCAM::Expr *DESCAM::FindDataFlow::getExpr() const {
  return expr_;
}

bool DESCAM::FindDataFlow::VisitCXXStaticCastExpr(clang::CXXStaticCastExpr *staticCastExpr) {
  // Collecting statement location information from clang
  auto castExprLocationInfo = DESCAM::GlobalUtilities::getLocationInfo<clang::Stmt>(staticCastExpr, ci_);

  //FIXME: is the restriction to casting only variables necessary? Remove if hardware is designable
  if (staticCastExpr->getType()->isUnsignedIntegerType() &&
      staticCastExpr->getType().getAsString() == "unsigned int") {
    auto subExpr =
        find_data_flow_factory_->create_new(staticCastExpr->getSubExpr(), module_, ci_, false);
    if (subExpr->getExpr() != nullptr) {
      DESCAM_ASSERT(switchPassExpr(new DESCAM::Cast(subExpr->getExpr(),
                                                    DataTypes::getDataType("unsigned"),
                                                    castExprLocationInfo)))
    } else
      return exitVisitor("static_cast: only variables are allowed as parameter", castExprLocationInfo);
    if (DescamException::isExceptionHappened()) clearExpressions();
    return false;
  } else if (staticCastExpr->getType()->isIntegerType() && staticCastExpr->getType().getAsString() == "int") {
    auto subExpr =
        find_data_flow_factory_->create_new(staticCastExpr->getSubExpr(), module_, ci_, false);
    if (subExpr->getExpr() != nullptr) {
      DESCAM_ASSERT(switchPassExpr(new DESCAM::Cast(subExpr->getExpr(),
                                                    DataTypes::getDataType("int"),
                                                    castExprLocationInfo)))
    } else
      return exitVisitor("static_cast: only variables are allowed as parameter", castExprLocationInfo);
    if (DescamException::isExceptionHappened()) clearExpressions();
    return false;
  } else
    return exitVisitor("static_cast: disallowed static cast", castExprLocationInfo);

}

bool DESCAM::FindDataFlow::VisitReturnStmt(clang::ReturnStmt *returnStmt) {

  auto returnExpr =
      find_data_flow_factory_->create_new(returnStmt->getRetValue(), module_, ci_, false);
  // Collecting statement location information from clang
  auto returnLocationInfo = DESCAM::GlobalUtilities::getLocationInfo<clang::Stmt>(returnStmt, ci_);
  if (returnExpr->getExpr() == nullptr) {
    return exitVisitor(" return value is null", returnLocationInfo);
  }

  DESCAM_ASSERT(this->stmt_ = new DESCAM::Return(returnExpr->getExpr(), returnLocationInfo))
  if (DescamException::isExceptionHappened()) clearExpressions();
  return false;
}

bool DESCAM::FindDataFlow::VisitCompoundStmt(clang::CompoundStmt *compoundStmt) {
  return false;
}

bool DESCAM::FindDataFlow::VisitArraySubscriptExpr(clang::ArraySubscriptExpr *arraySubscriptExpr) {

  // Collecting statement location information from clang
  auto arraySubExprLocationInfo =
      DESCAM::GlobalUtilities::getLocationInfo<clang::Stmt>(arraySubscriptExpr->getLHS(), ci_);

  auto array =
      find_data_flow_factory_->create_new(arraySubscriptExpr->getLHS(), module_, ci_, false);

  if (array->getExpr() != nullptr && array->getExpr()->getDataType()->isArrayType()) {
    if (auto varOp = NodePeekVisitor::nodePeekVariableOperand(array->getExpr())) {
      auto findIndex = find_data_flow_factory_->create_new(arraySubscriptExpr->getIdx(),
                                                           module_,
                                                           ci_,
                                                           false);
      if (auto index = NodePeekVisitor::nodePeekIntegerValue(findIndex->getExpr())) {
        DESCAM_ASSERT(auto varOp2 =
            new DESCAM::VariableOperand(varOp->getVariable()->getSubVar(index->getValueAsString()),
                                        arraySubExprLocationInfo);
                          switchPassExpr(varOp2))
        if (DescamException::isExceptionHappened()) clearExpressions();
        return false;
      } else {
        DESCAM_ASSERT(auto arrOp =
            new ArrayOperand(varOp->getVariable(), findIndex->getExpr(), arraySubExprLocationInfo);
                          switchPassExpr(arrOp))
        if (DescamException::isExceptionHappened()) clearExpressions();
        //TODO: Implement function for arrays.
        /*
         * Implement a functions that allows to select from array with an expression.
         * Because a variable myArray[index] does not represent a variable that is referencable. It depends on the concrete evaluation of [index].
         * After value propagation it could be possible to translate it back to a concrete array select, if the value evaluates to be constant.
         */
        //TERMINATE("Not implemented");
        return false;
      }
    } else return exitVisitor("Stmt is null", arraySubExprLocationInfo);
  } else return exitVisitor("Not an array type!", arraySubExprLocationInfo);
}

DESCAM::Stmt *DESCAM::FindDataFlow::getStmt() {
  return this->stmt_;
}

bool DESCAM::FindDataFlow::exitVisitor(const std::string &msg, const DESCAM::LocationInfo &stmtInfo) {
  this->stmt_ = nullptr;
  //Add loggerMsg to the logger
  DESCAM::LoggerMsg loggerMsg(msg,
                              stmtInfo,
                              LoggerMsg::SeverityLevel::Error,
                              LoggerMsg::ViolationType::SystemC_PPA_compliance,
                              Logger::getCurrentProcessedLocation());
  DESCAM::Logger::addMsg(loggerMsg);
  return false;
}

void DESCAM::FindDataFlow::clearExpressions() {
  this->rhs_expr_ = nullptr;
  this->lhs_expr_ = nullptr;
  this->expr_ = nullptr;
  this->stmt_ = nullptr;
}
bool DESCAM::FindDataFlow::setup(clang::Stmt *_stmt,
                                 DESCAM::Module *_module_,
                                 clang::CompilerInstance *_ci_,
                                 bool _unsigned_flag) {
  this->module_ = _module_;
  this->ci_ = _ci_;
  this->unsigned_flag_ = _unsigned_flag;
  this->pass_ = 0;

  clearExpressions();
  TraverseStmt(_stmt);
  return true;
}
DESCAM::FindDataFlow::FindDataFlow(DESCAM::IFindStateName *find_state_name,
                                   IFindDataFlowFactory *find_data_flow_factory) :
    find_state_name_(find_state_name),
    find_data_flow_factory_(find_data_flow_factory) {}
