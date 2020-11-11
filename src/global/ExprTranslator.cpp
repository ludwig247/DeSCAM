//


#include <ctgmath>

#include "ExprTranslator.h"
#include "ModelGlobal.h"
#include "DescamException.h"

//
// Created by joakim on 06.11.16.
DESCAM::ExprTranslator::ExprTranslator() :
    unsigned_flag_(false),
    bitvector_flag_(false),
    context_(new z3::context()),
    z3_expr_(*context_),
    datatype_map_(DataTypes::getDataTypeMap()) {
  assert(false && "Should not be used");

}

DESCAM::ExprTranslator::ExprTranslator(z3::context *context) :
    context_(context),
    unsigned_flag_(false),
    bitvector_flag_(false),
    z3_expr_(*context),
    datatype_map_(DataTypes::getDataTypeMap()) {

  relational_operator_map_.insert(std::make_pair(">", ">"));
  relational_operator_map_.insert(std::make_pair(">=", ">="));
  relational_operator_map_.insert(std::make_pair("<", "<"));
  relational_operator_map_.insert(std::make_pair("<=", "<="));
  relational_operator_map_.insert(std::make_pair("distinct", "!="));
  relational_operator_map_.insert(std::make_pair("=", "=="));
  logical_operator_map_.insert(std::make_pair("and", "and"));
  logical_operator_map_.insert(std::make_pair("or", "or"));
  unary_operator_map_.insert(std::make_pair("not", "not"));
  unary_operator_map_.insert(std::make_pair("-", "-"));
  unary_operator_map_.insert(std::make_pair("bvnot", "not"));
  arith_operator_map_.insert(std::make_pair("+", "+"));
  arith_operator_map_.insert(std::make_pair("*", "*"));
  arith_operator_map_.insert(std::make_pair("div", "/"));
  bv_arith_operator_map_.insert(std::make_pair("bvadd", "+"));
  bv_arith_operator_map_.insert(std::make_pair("bvsub", "-"));
  bv_arith_operator_map_.insert(std::make_pair("bvmul", "*"));
  bv_arith_operator_map_.insert(std::make_pair("bvsdiv", "/"));
  bv_arith_operator_map_.insert(std::make_pair("bvurem", "%"));
  bv_arith_operator_map_.insert(std::make_pair("bvsrem", "%"));
  bv_arith_operator_map_.insert(std::make_pair("bvurem_i", "%"));
  bv_arith_operator_map_.insert(std::make_pair("bvsrem_i", "%"));
  bv_bitwise_operator_map_.insert(std::make_pair("bvshl", "<<"));
  bv_bitwise_operator_map_.insert(std::make_pair("bvlshr", ">>"));
  bv_bitwise_operator_map_.insert(std::make_pair("bvand", "&"));
  bv_bitwise_operator_map_.insert(std::make_pair("bvor", "|"));
  bv_bitwise_operator_map_.insert(std::make_pair("bvxor", "^"));
  bv_bitwise_operator_map_.insert(std::make_pair("bvashr", ">>"));

  bv_relational_operator_map_.insert(std::make_pair("bvugt", ">"));
  bv_relational_operator_map_.insert(std::make_pair("bvuge", ">="));
  bv_relational_operator_map_.insert(std::make_pair("bvult", "<"));
  bv_relational_operator_map_.insert(std::make_pair("bvule", "<="));
  bv_relational_operator_map_.insert(std::make_pair("bvsle", "<="));

}

z3::expr &DESCAM::ExprTranslator::translate(DESCAM::Expr *scam_expr) {

//    std::cout << "ExprTranslator::translate: " << PrintStmt::toString(scam_expr) << "   ------ " << ExprVisitor::isBitwise(scam_expr) << "\n";
  bitvector_flag_ = ExprVisitor::isBitwise(scam_expr) || bitvector_flag_;
  scam_expr->accept(*this);

  return z3_expr_;
}

DESCAM::Expr *DESCAM::ExprTranslator::translate(z3::expr &z3_expr, const DESCAM::Module *module) {
  //datatype map must at least contain built-in types
  if (datatype_map_.empty() || datatype_map_.find("int") == datatype_map_.end() ||
      datatype_map_.find("bool") == datatype_map_.end()) {
    TERMINATE(
        "ExprTranslator translation from z3 to DESCAM requires a datatypeMap including the built-in types")
  }

  if (module == nullptr) {
    TERMINATE("Module passed to ExprTranslator is null")
  }

  this->module_ = module; //allowed to be nullptr !


  return this->translate_intern(z3_expr);
}

//TODO Break this abomination up into manageable chunks.
//is private, only entered when the maps exists (and{TERMINATE("ExprSCAMtoZ3 did not expect SyncSignal");} when at least "int" and "bool" is a datatype
DESCAM::Expr *DESCAM::ExprTranslator::translate_intern(const z3::expr &z3_expr_intern) {

  DESCAM::Expr *returnExpr = nullptr;
  //TERMINAL EXPRESSION
  if (z3_expr_intern.is_const()) {
    std::string symbolname = z3_expr_intern.decl().name().str();

    //integer value
    if (symbolname == "Int") {
      if (this->unsigned_flag_) {
        unsigned int value = z3_expr_intern.get_numeral_int64();
        if (value > 4294967295) TERMINATE("Result of unsigned computation is > 2^32-1")
        DESCAM_ASSERT(returnExpr = new DESCAM::UnsignedValue(value))
        CHECK_EXCEPTION_AND_RETURN(returnExpr)
      } else {
        DESCAM_ASSERT(returnExpr = new DESCAM::IntegerValue(z3_expr_intern.get_numeral_int()))
        CHECK_EXCEPTION_AND_RETURN(returnExpr)
      }
    }

    if (symbolname == "bv") {
      if (this->unsigned_flag_) {
        unsigned int value = z3_expr_intern.get_numeral_int64();
        if (value > 4294967295) TERMINATE("Result of unsigned computation is > 2^32-1")
        DESCAM_ASSERT(returnExpr = new DESCAM::UnsignedValue(value))
        CHECK_EXCEPTION_AND_RETURN(returnExpr)
      } else {
        //z3 doesn't translate a bitvector back into a signed integer, always interprets it unsigned
        if (z3_expr_intern.get_numeral_uint() > 2147483647) {
          DESCAM_ASSERT(returnExpr = new DESCAM::IntegerValue(z3_expr_intern.get_numeral_uint() - 4294967296))
          CHECK_EXCEPTION_AND_RETURN(returnExpr)
        } else {
          DESCAM_ASSERT(returnExpr = new DESCAM::IntegerValue(z3_expr_intern.get_numeral_int()))
          CHECK_EXCEPTION_AND_RETURN(returnExpr)
        }
      }
    }
    //boolean value
    if (symbolname == "true") {
      DESCAM_ASSERT(returnExpr = new DESCAM::BoolValue(true))
      CHECK_EXCEPTION_AND_RETURN(returnExpr)

    }
    if (symbolname == "false") {
      DESCAM_ASSERT(returnExpr = new DESCAM::BoolValue(false))
      CHECK_EXCEPTION_AND_RETURN(returnExpr)
    }

    //enum value
    for (auto &&type : datatype_map_) {
      if (type.second->isEnumType()) {
        for (auto &&enumValPair : type.second->getEnumValueMap()) {
          if (enumValPair.first == symbolname) {
            DESCAM_ASSERT(returnExpr = new DESCAM::EnumValue(symbolname, type.second))
            CHECK_EXCEPTION_AND_RETURN(returnExpr)
          }
        }
      }
    }
    if (DataTypes::hasLocalDataTypes(module_->getName())) {
      for (auto &&type : DataTypes::getLocalDataTypes(module_->getName())) {
        if (type.second->isEnumType()) {
          for (auto &&enumValPair : type.second->getEnumValueMap()) {
            if (enumValPair.first == symbolname) {
              DESCAM_ASSERT(returnExpr = new DESCAM::EnumValue(symbolname, type.second))
              CHECK_EXCEPTION_AND_RETURN(returnExpr)
            }
          }
        }
      }
    }

    //Check for variables, dataSignal or synchSignals
    if (module_ == nullptr) {
      TERMINATE(
          "ExprTranslator : translate z3::expr to DESCAM::Expr, module must be set for such conversion")
    }

    //section operand
    //TODO: remove
//        if (symbolname == "nextsection") {
//            return new SectionOperand(module->getFSM()->getSectionVariable());
//        }
    //Variable operand
    if (module_->isVariable(symbolname)) {
      DESCAM_ASSERT(returnExpr = new VariableOperand(module_->getVariable(symbolname)))
      CHECK_EXCEPTION_AND_RETURN(returnExpr)
    }


    //Synch & DataSignals
    for (const auto &port: module_->getPorts()) {
      if (symbolname == port.first + "_synch") {
        return port.second->getSynchSignal();
      }

      if (port.second->hasSubVar()) {
        //Compound type port: multiple subsignals
        for (auto subSig: port.second->getDataSignal()->getSubVarList()) {
          if (symbolname == port.first + "_dataXYZ_" + subSig->getName()) {
            DESCAM_ASSERT(returnExpr = new DataSignalOperand(subSig))
            CHECK_EXCEPTION_AND_RETURN(returnExpr)
          }
        }
      } else {
        //Built-in type ports
        if (symbolname == port.first + "_dataXYZ") {
          this->unsigned_flag_ = port.second->getDataSignal()->getDataType()->isUnsigned();
          DESCAM_ASSERT(returnExpr = new DataSignalOperand(port.second->getDataSignal()))
          CHECK_EXCEPTION_AND_RETURN(returnExpr)
        }
      }
    }

    if (function_operand_map_.find(symbolname) != function_operand_map_.end())
      return function_operand_map_.find(symbolname)->second;

    if (array_map_.find(symbolname) != array_map_.end())
      return array_map_.at(symbolname);

    auto globalVars = ModelGlobal::getModel()->getGlobalVariableMap();
    if (globalVars.find(symbolname) != globalVars.end()) {
      DESCAM_ASSERT(returnExpr = new VariableOperand(globalVars.find(symbolname)->second))
      CHECK_EXCEPTION_AND_RETURN(returnExpr)
    }
    //NOTHING found!
    TERMINATE(
        "ExprTranslator : translate z3::expr to DESCAM::Expr, missing variable for " + symbolname)
  }

    //NON-TERMINAL EXPRESSION
  else /*! z3_expr.is_const()*/ {
    std::string oper = z3_expr_intern.decl().name().str();
    if (relational_operator_map_.find(oper) != relational_operator_map_.end()) {
      if (z3_expr_intern.num_args() == 2) {
        z3::expr lhs = z3_expr_intern.arg(0);
        this->unsigned_flag_ = translate_intern(lhs)->getDataType()->isUnsigned();
        z3::expr rhs = z3_expr_intern.arg(1);
        DESCAM_ASSERT(returnExpr = new DESCAM::Relational(translate_intern(lhs), relational_operator_map_.at(oper),
                                                          translate_intern(rhs)))
        CHECK_EXCEPTION_AND_RETURN(returnExpr)
      } else TERMINATE("Expected 2 arguments for " + oper)
    } else if (logical_operator_map_.find(oper) != logical_operator_map_.end()) {
      if (z3_expr_intern.num_args() < 2) TERMINATE(
          "ExprTranslator : translate z3::expr to DESCAM::Expr expected 2 or more arguments")

      z3::expr first = z3_expr_intern.arg(0);
      z3::expr second = z3_expr_intern.arg(1);
      DESCAM::Logical *multiple = nullptr;
      DESCAM_ASSERT(multiple = new DESCAM::Logical(translate_intern(first), logical_operator_map_.at(oper),
                                                   translate_intern(second)))

      for (unsigned int i = 2; i < z3_expr_intern.num_args(); ++i) {
        z3::expr next = z3_expr_intern.arg(i);
        DESCAM_ASSERT(multiple = new DESCAM::Logical(multiple, logical_operator_map_.at(oper), translate_intern(next)))
      }
      CHECK_EXCEPTION_AND_RETURN(multiple)
    } else if (unary_operator_map_.find(oper) != unary_operator_map_.end()) {
      if (oper == "not") { // UNARY
        if (z3_expr_intern.num_args() != 1) TERMINATE(
            "ExprTranslator : translate z3::expr to DESCAM::Expr, operator not, expected 1 argument")
        z3::expr rhs = z3_expr_intern.arg(0);
        DESCAM_ASSERT(returnExpr = new DESCAM::UnaryExpr("not", translate_intern(rhs)))
        CHECK_EXCEPTION_AND_RETURN(returnExpr)
      } else if (oper == "bvnot") { // UNARY
        if (z3_expr_intern.num_args() != 1) TERMINATE(
            "ExprTranslator : translate z3::expr to DESCAM::Expr, operator not, expected 1 argument")
        z3::expr rhs = z3_expr_intern.arg(0);
        DESCAM_ASSERT(returnExpr = new DESCAM::UnaryExpr("~", translate_intern(rhs)))
        CHECK_EXCEPTION_AND_RETURN(returnExpr)
      } else if (oper == "-") { //NOTE: can be unary or binary, check num_arg
        if (z3_expr_intern.num_args() == 2) {
          z3::expr lhs = z3_expr_intern.arg(0);
          z3::expr rhs = z3_expr_intern.arg(1);
          DESCAM_ASSERT(returnExpr = new DESCAM::Arithmetic(translate_intern(lhs), "-", translate_intern(rhs)))
          CHECK_EXCEPTION_AND_RETURN(returnExpr)
        } else if (z3_expr_intern.num_args() == 1) {
          z3::expr rhs = z3_expr_intern.arg(0);
          DESCAM_ASSERT(returnExpr = new DESCAM::UnaryExpr("-", translate_intern(rhs)))
          CHECK_EXCEPTION_AND_RETURN(returnExpr)
        } else TERMINATE(
            "ExprTranslator : translate z3::expr to DESCAM::Expr, operator -, expected 1 or 2 arguments")

      } else TERMINATE("ExprTranslator : unknown Unary: " + oper)
    } else if (arith_operator_map_.find(oper) != arith_operator_map_.end()) {
      if (z3_expr_intern.num_args() < 2) TERMINATE(
          "ExprTranslator : translate z3::expr to DESCAM::Expr, operator +, expected 2 or more arguments")
      z3::expr first = z3_expr_intern.arg(0);
      z3::expr second = z3_expr_intern.arg(1);

      DESCAM::Arithmetic *multiple = nullptr;
      DESCAM_ASSERT(multiple = new DESCAM::Arithmetic(translate_intern(first), arith_operator_map_.at(oper),
                                                      translate_intern(second)))
      for (unsigned int i = 2; i < z3_expr_intern.num_args(); ++i) {
        z3::expr next = z3_expr_intern.arg(i);
        DESCAM_ASSERT(
            multiple = new DESCAM::Arithmetic(multiple, arith_operator_map_.at(oper), translate_intern(next)))
      }
      CHECK_EXCEPTION_AND_RETURN(multiple)
    } else if (bv_arith_operator_map_.find(oper) != bv_arith_operator_map_.end()) {
      if (z3_expr_intern.num_args() == 2) {
        z3::expr lhs = z3_expr_intern.arg(0);
        z3::expr rhs = z3_expr_intern.arg(1);
        DESCAM_ASSERT(returnExpr = new DESCAM::Arithmetic(translate_intern(lhs), bv_arith_operator_map_.at(oper),
                                                          translate_intern(rhs)))
        CHECK_EXCEPTION_AND_RETURN(returnExpr)
      } else {
        //std::cout << z3_expr_intern << std::endl;
        TERMINATE("ExprTranslator : translate z3::expr to DESCAM::Expr expected 2 arguments")
      }
    } else if (bv_bitwise_operator_map_.find(oper) != bv_bitwise_operator_map_.end()) {
      if (z3_expr_intern.num_args() == 2) {
        z3::expr lhs = z3_expr_intern.arg(0);
        z3::expr rhs = z3_expr_intern.arg(1);
        DESCAM_ASSERT(returnExpr = new DESCAM::Bitwise(translate_intern(lhs), bv_bitwise_operator_map_.at(oper),
                                                       translate_intern(rhs)))
        CHECK_EXCEPTION_AND_RETURN(returnExpr)
      } else {
        //std::cout << z3_expr_intern << std::endl;
        TERMINATE("ExprTranslator : translate z3::expr to DESCAM::Expr expected 2 arguments")
      }
    } else if (bv_relational_operator_map_.find(oper) != bv_relational_operator_map_.end()) {
      if (z3_expr_intern.num_args() == 2) {
        z3::expr lhs = z3_expr_intern.arg(0);
        z3::expr rhs = z3_expr_intern.arg(1);
        if (oper == "bvule") this->unsigned_flag_ = true;
        if (oper == "bvsle") this->unsigned_flag_ = false;

        DESCAM_ASSERT(returnExpr = new DESCAM::Relational(translate_intern(lhs), bv_relational_operator_map_.at(oper),
                                                          translate_intern(rhs)))
        CHECK_EXCEPTION_AND_RETURN(returnExpr)
      } else TERMINATE("ExprTranslator : translate z3::expr to DESCAM::Expr expected 2 arguments")
    } else if (oper == "concat") {
//            std::cout<<"EXprTranslator: concat\n";
      abort_ = true;
      z3::expr abort = context_->int_val(0);
      return translate_intern(abort);
    } else if (oper == "extract") {
//            std::cout<<"EXprTranslator: extract " << z3_expr.is_algebraic() << "\n";
      abort_ = true;
      const z3::expr &extract = z3_expr_intern;
      assert(extract.decl().name().str() == "extract" && extract.num_args() == 1 && extract.arg(0).is_const() &&
          "Unknown apps");
      //Return something to work with
      z3::expr ret = z3_expr_intern.arg(0);
      return translate_intern(ret);
    } else if (oper == "if") {
      z3::expr simplifiedITE = z3_expr_intern.simplify();
      if (simplifiedITE.num_args() == 3) {
        auto cond = translate_intern(z3_expr_intern.arg(0));
        auto trueExpr = translate_intern(z3_expr_intern.arg(1));
        auto falseExpr = translate_intern(z3_expr_intern.arg(2));
        DESCAM_ASSERT(returnExpr = new Ternary(cond, trueExpr, falseExpr))
        CHECK_EXCEPTION_AND_RETURN(returnExpr)
      } else if ((simplifiedITE.num_args() == 0)) {
        return translate_intern(simplifiedITE);
      }
    } else TERMINATE("ExprTranslator : translate z3::expr to DESCAM::Expr, unknown operator: " + oper)
  }
}

z3::context *DESCAM::ExprTranslator::getContext() {
  return context_;
}

z3::sort DESCAM::ExprTranslator::find_or_add_sort(const DESCAM::DataType *pType) {
  if (!pType->isEnumType()) TERMINATE(pType->getName() + " is not an enum type")
  if (this->enum_type_sort_map_.find(pType) == this->enum_type_sort_map_.end()) {
    //define a sort (z3 term for datatype) with the name of the enumType
    z3::func_decl_vector enum_consts(*context_);
    z3::func_decl_vector enum_testers(*context_);
    const char *enum_values[pType->getEnumValueMap().size()];
    for (auto &&item : pType->getEnumValueMap()) {
      enum_values[item.second] = item.first.c_str();
    }
    z3::sort s = context_->enumeration_sort(pType->getName().c_str(), pType->getEnumValueMap().size(), enum_values,
                                            enum_consts,
                                            enum_testers);
    this->enum_type_sort_map_.insert(std::make_pair(pType, s));
    this->enum_type_value_map_.insert(std::make_pair(pType, enum_consts));
    return s;

  }
  return this->enum_type_sort_map_.find(pType)->second;
}

bool DESCAM::ExprTranslator::isAbort() const {
  return abort_;
}

void DESCAM::ExprTranslator::reset() {
  this->unsigned_flag_ = false;
  this->bitvector_flag_ = false;
}

void DESCAM::ExprTranslator::visit(DESCAM::UnsignedValue &node) {
  if (bitvector_flag_) {
//        std::cout<<"EXprTranslator: visit(UnsignedValue) - bitvector_flag\n";
    z3_expr_ = context_->bv_val(node.getValue(), 32);
  } else {
    z3_expr_ = context_->int_val(node.getValue());
  }
  unsigned_flag_ = true;
}

void DESCAM::ExprTranslator::visit(DESCAM::IntegerValue &node) {
  if (bitvector_flag_) {
//        std::cout<<"EXprTranslator: visit(IntegerValue) - bitvector_flag\n";
    z3_expr_ = context_->bv_val(node.getValue(), 32);
  } else {
    z3_expr_ = context_->int_val(node.getValue());
  }
  unsigned_flag_ = false;
}

void DESCAM::ExprTranslator::visit(DESCAM::CompoundValue &node) {
  TERMINATE("NOT DONE YET")

}

void DESCAM::ExprTranslator::visit(DESCAM::BoolValue &node) {
  z3_expr_ = context_->bool_val(node.getValue());
}

//EnumValue is given as the identifying int (from the enumValueMap)
void DESCAM::ExprTranslator::visit(DESCAM::EnumValue &node) {
  //define a sort (z3 term for datatype) with the name of the enumType
  find_or_add_sort(node.getDataType());
  z3::func_decl_vector enumValues = this->enum_type_value_map_.find(node.getDataType())->second;
  int enumInt = node.getDataType()->getEnumValueMap().find(node.getEnumValue())->second;
  z3_expr_ = enumValues[enumInt]();

}

//SectionValue is just a special kind of an Enum, treated like an enum
void DESCAM::ExprTranslator::visit(DESCAM::SectionValue &node) {
  z3_expr_ = context_->int_val(node.getDataType()->getEnumValueMap().find(node.getValue())->second);
}

void DESCAM::ExprTranslator::visit(DESCAM::VariableOperand &node) {

  //a new variable (int_const or bool_const) is created each time an operand is found
  //this is ok, since z3 automatically sees them as the same operand as long as it has the same name

  if (node.getDataType()->isBuiltInType()) {
    if (node.getDataType() == DataTypes::getDataType("int")) {
      if (bitvector_flag_) z3_expr_ = context_->bv_const(node.getOperandName().c_str(), 32);
      else z3_expr_ = context_->int_const(node.getOperandName().c_str());
      return;
    } else if (node.getDataType() == DataTypes::getDataType("bool")) { //bool
      z3_expr_ = context_->bool_const(node.getOperandName().c_str());
      return;
    } else if (node.getDataType() == DataTypes::getDataType("unsigned")) { //unsigned
      if (bitvector_flag_) z3_expr_ = context_->bv_const(node.getOperandName().c_str(), 32);
      else z3_expr_ = context_->int_const(node.getOperandName().c_str());
      unsigned_flag_ = true;
      return;
    } else TERMINATE("Unknown datatype")
  }
  //enum, added as an integer, but with range limit representing its possible values
  if (node.getDataType()->isEnumType()) {
    this->z3_expr_ = context_->constant(node.getOperandName().c_str(), find_or_add_sort(node.getDataType()));
    return;
  }

  //compound operands, should never appear since they are used only as lhs of assignments to communication calls
  TERMINATE("ExprTranslator VariableOperand: did not expect compound type operand")
}

void DESCAM::ExprTranslator::visit(DESCAM::SectionOperand &node) {

  if (node.getDataType()->isEnumType()) {
    z3_expr_ = context_->int_const("nextsection");
    return;
  }
  TERMINATE("ExprTranslator SectionOperand: a section operand must be of enum type")
}

void DESCAM::ExprTranslator::visit(DESCAM::UnaryExpr &node) {
  z3::expr rhs = translate(node.getExpr());

  if (node.getOperation() == "not") {
    z3_expr_ = !rhs;
    return;
  }
  if (node.getOperation() == "-") {
    z3_expr_ = -rhs;
    return;
  }

  if (node.getOperation() == "~") {
    z3_expr_ = ~(rhs);
    return;
  }
  TERMINATE("ExprTranslator UnaryExpr: cannot be translated")
}

void DESCAM::ExprTranslator::visit(DESCAM::Arithmetic &node) {
  z3::expr lhs = translate(node.getLhs());
  z3::expr rhs = translate(node.getRhs());

  if (node.getOperation() == "+") {
    z3_expr_ = lhs + rhs;
    return;
  }
  if (node.getOperation() == "-") {
    z3_expr_ = lhs - rhs;
    return;
  }
  if (node.getOperation() == "*") {
    z3_expr_ = lhs * rhs;
    return;
  }
  if (node.getOperation() == "/") {
    z3_expr_ = lhs / rhs;
    return;
  }
  if (node.getOperation() == "%") {
    //It's required by z3 to have a bitvector for reminder operations
    //fixme isn't this already done? Should be removed
    z3::expr lhs = translate(node.getLhs());
    z3::expr rhs = translate(node.getRhs());

    try {
      if (unsigned_flag_) z3_expr_ = z3::urem(lhs, rhs);
      else z3_expr_ = z3::srem(lhs, rhs);

    } catch (z3::exception &e) {

      std::cout << lhs << "%" << rhs << std::endl;
      std::cout << e << std::endl;
    }
    return;
  }
  TERMINATE("ExprTranslator Arithmetic: cannot be translated")
}

void DESCAM::ExprTranslator::visit(DESCAM::Logical &node) {
  z3::expr lhs = translate(node.getLhs());
  z3::expr rhs = translate(node.getRhs());

  if (node.getOperation() == "and") {
    z3_expr_ = lhs and rhs;
    return;
  }
  if (node.getOperation() == "nand") {
    z3_expr_ = !(lhs and rhs);
    return;
  }
  if (node.getOperation() == "or") {
    z3_expr_ = lhs or rhs;
    return;
  }
  if (node.getOperation() == "nor") {
    z3_expr_ = !(lhs or rhs);
    return;
  }
  if (node.getOperation() == "xor") {
    z3_expr_ = lhs != rhs;
    return;
  }
  if (node.getOperation() == "xnor") {

    z3_expr_ = lhs == rhs;
    return;
  }
  TERMINATE("ExprTranslator Logical: cannot be translated")
}

void DESCAM::ExprTranslator::visit(DESCAM::Bitwise &node) {
  z3::expr lhs = translate(node.getLhs());
  z3::expr rhs = translate(node.getRhs());

  if (node.getOperation() == ">>") {
    if (node.getDataType()->isUnsigned()) {
      z3_expr_ = z3::lshr(lhs, rhs);
    } else z3_expr_ = z3::ashr(lhs, rhs);
    return;
  } else if (node.getOperation() == "<<") {
    z3_expr_ = z3::shl(lhs, rhs);
    return;
  } else if (node.getOperation() == "&") {
    z3_expr_ = lhs & rhs;
    return;
  } else if (node.getOperation() == "|") {
    z3_expr_ = lhs | rhs;
    return;
  } else if (node.getOperation() == "^") {
    z3_expr_ = lhs ^ rhs;
    return;
  } else TERMINATE("ExprTranslator Bitwise: cannot be translated")

}

void DESCAM::ExprTranslator::visit(DESCAM::Cast &node) {
//    std::cout<<"EXprTranslator: visit(Cast)\n";
  this->abort_ = true;
  if (node.getDataType()->isUnsigned()) {
    unsigned_flag_ = true;
    node.getSubExpr()->accept(*this);
  } else node.getSubExpr()->accept(*this);

}

void DESCAM::ExprTranslator::visit(DESCAM::Relational &node) {

  z3::expr lhs = translate(node.getLhs());
  z3::expr rhs = translate(node.getRhs());

  if (node.getOperation() == "==") {

    try {
      z3_expr_ = lhs == rhs;
    } catch (z3::exception &e) {
      std::cout << lhs << " == " << rhs << std::endl;
      std::cout << e << std::endl;
    }
    return;
  }
  if (node.getOperation() == "!=") {
    z3_expr_ = lhs != rhs;
    return;
  }
  if (node.getOperation() == ">") {
    if (node.getLhs()->getDataType()->isUnsigned()) {
      z3_expr_ = z3::ugt(lhs, rhs);
    } else z3_expr_ = lhs > rhs;
    return;
  }
  if (node.getOperation() == "<") {
    if (node.getLhs()->getDataType()->isUnsigned()) {
      z3_expr_ = z3::ult(lhs, rhs);
    } else z3_expr_ = lhs < rhs;
    return;
  }
  if (node.getOperation() == ">=") {
    if (node.getLhs()->getDataType()->isUnsigned()) {
      z3_expr_ = z3::uge(lhs, rhs);
    } else z3_expr_ = (lhs >= rhs);
    return;
  }
  if (node.getOperation() == "<=") {
    if (node.getLhs()->getDataType()->isUnsigned()) {
      z3_expr_ = z3::ule(lhs, rhs);
    } else z3_expr_ = (lhs <= rhs);
    return;
  }

  TERMINATE("ExprTranslator Relational: cannot be translated")
}

void DESCAM::ExprTranslator::visit(DESCAM::SyncSignal &node) {
  //A new variable for synch is created and synch is always of type bool
  //this is ok, since z3 automatically sees them as the same operand as long as it has the same name
  std::string name = node.getPort()->getName() + "_synch";
  z3_expr_ = context_->bool_const(name.c_str());
}

void DESCAM::ExprTranslator::visit(DESCAM::DataSignalOperand &node) {
  if (node.getDataType()->isCompoundType()) TERMINATE(
      "ExprTranslator DataSignal: Signal is not allowed to be compound type")
  std::string name;
  if (node.getDataSignal()->isSubVar()) {
    name = node.getDataSignal()->getPort()->getName() + "_dataXYZ_" + node.getDataSignal()->getName();
  } else name = node.getDataSignal()->getPort()->getName() + "_dataXYZ";

  if (node.getDataType()->isBuiltInType()) {
    if (node.getDataType()->getName() == "int") {
      if (bitvector_flag_) z3_expr_ = context_->bv_const(name.c_str(), 32);
      else z3_expr_ = context_->int_const(name.c_str());
      return;
    } else if (node.getDataType()->getName() == "unsigned") {
      if (bitvector_flag_) z3_expr_ = context_->bv_const(name.c_str(), 32);
      else z3_expr_ = context_->int_const(name.c_str());
      unsigned_flag_ = true;
      return;
    } else { //bool
      z3_expr_ = context_->bool_const(name.c_str());
      return;
    }
  }
    //enum, added as an integer, but with range limit representing its possible values
  else if (node.getDataType()->isEnumType()) {
    z3_expr_ = context_->constant(name.c_str(), find_or_add_sort(node.getDataType()));
    return;
  } else {
    TERMINATE("Unsupported type: " + node.getDataType()->getName())
  }
}

void DESCAM::ExprTranslator::visit(struct FunctionOperand &node) {
  //a new variable (int_const or bool_const) is created each time an operand is found
  //this is ok, since z3 automatically sees them as the same operand as long as it has the same name

  auto name = PrintStmt::toString(&node);
  //Does function already exist?

  // auto name = (node.getOperandName() + "_function");
//    if(this->functionOperandMap.find(name) != this->functionOperandMap.end()){
//
//    }


  if (node.getDataType()->isBuiltInType()) {
    if (node.getDataType() == DataTypes::getDataType("int")) {
      if (bitvector_flag_) z3_expr_ = context_->bv_const(name.c_str(), 32);
      else z3_expr_ = context_->int_const(name.c_str());
    } else if (node.getDataType() == DataTypes::getDataType("bool")) { //bool
      z3_expr_ = context_->bool_const(name.c_str());
    } else if (node.getDataType() == DataTypes::getDataType("unsigned")) { //unsigned
      if (bitvector_flag_) z3_expr_ = context_->bv_const(name.c_str(), 32);
      else z3_expr_ = context_->int_const(name.c_str());
      unsigned_flag_ = true;

    } else TERMINATE("Unknown datatype")
    this->function_operand_map_.insert(std::make_pair(name, &node));
    return;
  }
  //enum, added as an integer, but with range limit representing its possible values
  if (node.getDataType()->isEnumType()) {
    this->z3_expr_ = context_->constant(name.c_str(), find_or_add_sort(node.getDataType()));
    this->function_operand_map_.insert(std::make_pair(name, &node));
    return;
  }

  //compound operands, should never appear since they are used only as lhs of assignments to communication calls
  TERMINATE("ExprTranslator VariableOperand: did not expect compound type operand")

}

void DESCAM::ExprTranslator::visit(struct ArrayOperand &node) {

  auto name = (node.getArrayOperand()->getOperandName() + "[" + PrintStmt::toString(node.getIdx()) + "]");
  if (node.getDataType()->isBuiltInType()) {
    if (node.getDataType() == DataTypes::getDataType("int")) {
      if (bitvector_flag_) z3_expr_ = context_->bv_const(name.c_str(), 32);
      else z3_expr_ = context_->int_const(name.c_str());
    } else if (node.getDataType() == DataTypes::getDataType("bool")) { //bool
      z3_expr_ = context_->bool_const(name.c_str());
    } else if (node.getDataType() == DataTypes::getDataType("unsigned")) { //unsigned
      if (bitvector_flag_) z3_expr_ = context_->bv_const(name.c_str(), 32);
      else z3_expr_ = context_->int_const(name.c_str());
      unsigned_flag_ = true;

    } else TERMINATE("Unknown datatype")
    this->array_map_.insert(std::make_pair(name, &node));
    return;
  } else TERMINATE("Unknown datatype")

}

void DESCAM::ExprTranslator::visit(DESCAM::Ternary &node) {

  auto condition = translate(node.getCondition());
  auto trueExpr = translate(node.getTrueExpr());
  auto falseExpr = translate(node.getFalseExpr());

  z3_expr_ = z3::ite(condition, trueExpr, falseExpr);

}
