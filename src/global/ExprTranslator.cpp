//


#include <tgmath.h>

#include "ExprTranslator.h"
#include "ModelGlobal.h"
#include "DescamException.h"


//
// Created by joakim on 06.11.16.
DESCAM::ExprTranslator::ExprTranslator() :
        unsigned_flag(false),
        bitvector_flag(false),
        context(new z3::context()),
        z3_expr(*context),
        datatypeMap(DataTypes::getDataTypeMap()) {
    assert(false && "Should not be used");

}

DESCAM::ExprTranslator::ExprTranslator(z3::context *context) :
        context(context),
        unsigned_flag(false),
        bitvector_flag(false),
        z3_expr(*context),
        datatypeMap(DataTypes::getDataTypeMap()) {

    relationalOperatorMap.insert(std::make_pair(">", ">"));
    relationalOperatorMap.insert(std::make_pair(">=", ">="));
    relationalOperatorMap.insert(std::make_pair("<", "<"));
    relationalOperatorMap.insert(std::make_pair("<=", "<="));
    relationalOperatorMap.insert(std::make_pair("distinct", "!="));
    relationalOperatorMap.insert(std::make_pair("=", "=="));
    logicalOperatorMap.insert(std::make_pair("and", "and"));
    logicalOperatorMap.insert(std::make_pair("or", "or"));
    unaryOperatorMap.insert(std::make_pair("not", "not"));
    unaryOperatorMap.insert(std::make_pair("-", "-"));
    unaryOperatorMap.insert(std::make_pair("bvnot", "not"));
    arithOperatorMap.insert(std::make_pair("+", "+"));
    arithOperatorMap.insert(std::make_pair("*", "*"));
    arithOperatorMap.insert(std::make_pair("div", "/"));
    bvArithOperatorMap.insert(std::make_pair("bvadd", "+"));
    bvArithOperatorMap.insert(std::make_pair("bvsub", "-"));
    bvArithOperatorMap.insert(std::make_pair("bvmul", "*"));
    bvArithOperatorMap.insert(std::make_pair("bvsdiv", "/"));
    bvArithOperatorMap.insert(std::make_pair("bvurem", "%"));
    bvArithOperatorMap.insert(std::make_pair("bvsrem", "%"));
    bvArithOperatorMap.insert(std::make_pair("bvurem_i", "%"));
    bvArithOperatorMap.insert(std::make_pair("bvsrem_i", "%"));
    bvBitwiseOperatorMap.insert(std::make_pair("bvshl", "<<"));
    bvBitwiseOperatorMap.insert(std::make_pair("bvlshr", ">>"));
    bvBitwiseOperatorMap.insert(std::make_pair("bvand", "&"));
    bvBitwiseOperatorMap.insert(std::make_pair("bvor", "|"));
    bvBitwiseOperatorMap.insert(std::make_pair("bvxor", "^"));
    bvBitwiseOperatorMap.insert(std::make_pair("bvashr", ">>"));

    bvRelationalOperatorMap.insert(std::make_pair("bvugt", ">"));
    bvRelationalOperatorMap.insert(std::make_pair("bvuge", ">="));
    bvRelationalOperatorMap.insert(std::make_pair("bvult", "<"));
    bvRelationalOperatorMap.insert(std::make_pair("bvule", "<="));
    bvRelationalOperatorMap.insert(std::make_pair("bvsle", "<="));

}


z3::expr &DESCAM::ExprTranslator::translate(DESCAM::Expr *scam_expr) {

//    std::cout << "ExprTranslator::translate: " << PrintStmt::toString(scam_expr) << "   ------ " << ExprVisitor::isBitwise(scam_expr) << "\n";
    bitvector_flag = ExprVisitor::isBitwise(scam_expr) || bitvector_flag;
    scam_expr->accept(*this);


    return z3_expr;
}

DESCAM::Expr *DESCAM::ExprTranslator::translate(z3::expr &z3_expr, const DESCAM::Module *module) {
    //datatype map must at least contain built-in types
    if (datatypeMap.empty() || datatypeMap.find("int") == datatypeMap.end() ||
        datatypeMap.find("bool") == datatypeMap.end()) {
        TERMINATE(
                "ExprTranslator translation from z3 to DESCAM requires a datatypeMap including the built-in types");
    }

    if (module == nullptr) {
        TERMINATE("Module passed to ExprTranslator is null");
    }

    this->module = module; //allowed to be nullptr !


    return this->translate_intern(z3_expr);
}

//is private, only enterered when the maps exists (and{TERMINATE("ExprSCAMtoZ3 did not expect SyncSignal");} when at least "int" and "bool" is a datatype
DESCAM::Expr *DESCAM::ExprTranslator::translate_intern(const z3::expr &z3_expr_intern) {

    DESCAM::Expr *returnExpr = nullptr;
    //TERMINAL EXPRESSION
    if (z3_expr_intern.is_const()) {
        std::string symbolname = z3_expr_intern.decl().name().str();

        //integer value
        if (symbolname == "Int") {
            if (this->unsigned_flag) {
                unsigned int value = z3_expr_intern.get_numeral_int64();
                if (value > 4294967295) TERMINATE("Result of unsigned computation is > 2^32-1");
                DESCAM_ASSERT(returnExpr = new DESCAM::UnsignedValue(value))
                CHECK_EXCEPTION_AND_RETURN(returnExpr)
            } else {
                DESCAM_ASSERT(returnExpr = new DESCAM::IntegerValue(z3_expr_intern.get_numeral_int()))
                CHECK_EXCEPTION_AND_RETURN(returnExpr)
            }
        };

        if (symbolname == "bv") {
            if (this->unsigned_flag) {
                unsigned int value = z3_expr_intern.get_numeral_int64();
                if (value > 4294967295) TERMINATE("Result of unsigned computation is > 2^32-1");
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
        for (auto &&type : datatypeMap) {
            if (type.second->isEnumType()) {
                for (auto &&enumValPair : type.second->getEnumValueMap()) {
                    if (enumValPair.first == symbolname) {
                        DESCAM_ASSERT(returnExpr = new DESCAM::EnumValue(symbolname, type.second))
                        CHECK_EXCEPTION_AND_RETURN(returnExpr)
                    }
                }
            }
        }
        if (DataTypes::hasLocalDataTypes(module->getName())) {
            for (auto &&type : DataTypes::getLocalDataTypes(module->getName())) {
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
        if (module == nullptr) {
            TERMINATE(
                    "ExprTranslator : translate z3::expr to DESCAM::Expr, module must be set for such conversion");
        }

        //section operand
        //TODO: remove
//        if (symbolname == "nextsection") {
//            return new SectionOperand(module->getFSM()->getSectionVariable());
//        }
        //Variable operand
        if (module->isVariable(symbolname)) {
            DESCAM_ASSERT(returnExpr = new VariableOperand(module->getVariable(symbolname)))
            CHECK_EXCEPTION_AND_RETURN(returnExpr)
        }


        //Synch & DataSignals
        for (auto port: module->getPorts()) {
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
                    this->unsigned_flag = port.second->getDataSignal()->getDataType()->isUnsigned();
                    DESCAM_ASSERT(returnExpr = new DataSignalOperand(port.second->getDataSignal()))
                    CHECK_EXCEPTION_AND_RETURN(returnExpr)
                }
            }
        }

        if (functionOperandMap.find(symbolname) != functionOperandMap.end())
            return functionOperandMap.find(symbolname)->second;

        if (arrayMap.find(symbolname) != arrayMap.end())
            return arrayMap.at(symbolname);


        auto globalVars = ModelGlobal::getModel()->getGlobalVariableMap();
        if (globalVars.find(symbolname) != globalVars.end()) {
            DESCAM_ASSERT(returnExpr = new VariableOperand(globalVars.find(symbolname)->second))
            CHECK_EXCEPTION_AND_RETURN(returnExpr)
        }
        //NOTHING found!
        TERMINATE(
                "ExprTranslator : translate z3::expr to DESCAM::Expr, missing variable for " + symbolname);
    }

        //NON-TERMINAL EXPRESSION
    else /*! z3_expr.is_const()*/ {
        std::string oper = z3_expr_intern.decl().name().str();
        if (relationalOperatorMap.find(oper) != relationalOperatorMap.end()) {
            if (z3_expr_intern.num_args() == 2) {
                z3::expr lhs = z3_expr_intern.arg(0);
                this->unsigned_flag = translate_intern(lhs)->getDataType()->isUnsigned();
                z3::expr rhs = z3_expr_intern.arg(1);
                DESCAM_ASSERT(returnExpr = new DESCAM::Relational(translate_intern(lhs), relationalOperatorMap.at(oper),
                                                                translate_intern(rhs)))
                CHECK_EXCEPTION_AND_RETURN(returnExpr)
            } else TERMINATE("Expecte 2 arguments for " + oper);
        } else if (logicalOperatorMap.find(oper) != logicalOperatorMap.end()) {
            if (z3_expr_intern.num_args() < 2)
                TERMINATE(
                        "ExprTranslator : translate z3::expr to DESCAM::Expr expected 2 or more arguments");

            z3::expr first = z3_expr_intern.arg(0);
            z3::expr second = z3_expr_intern.arg(1);
            DESCAM::Logical *multiple = nullptr;
            DESCAM_ASSERT(multiple = new DESCAM::Logical(translate_intern(first), logicalOperatorMap.at(oper),
                                                       translate_intern(second)))

            for (unsigned int i = 2; i < z3_expr_intern.num_args(); ++i) {
                z3::expr next = z3_expr_intern.arg(i);
                DESCAM_ASSERT(multiple = new DESCAM::Logical(multiple, logicalOperatorMap.at(oper), translate_intern(next)))
            }
            CHECK_EXCEPTION_AND_RETURN(multiple)
        } else if (unaryOperatorMap.find(oper) != unaryOperatorMap.end()) {
            if (oper == "not") { // UNARY
                if (z3_expr_intern.num_args() != 1)
                    TERMINATE(
                            "ExprTranslator : translate z3::expr to DESCAM::Expr, operator not, expected 1 argument");
                z3::expr rhs = z3_expr_intern.arg(0);
                DESCAM_ASSERT(returnExpr = new DESCAM::UnaryExpr("not", translate_intern(rhs)))
                CHECK_EXCEPTION_AND_RETURN(returnExpr)
            } else if (oper == "bvnot") { // UNARY
                if (z3_expr_intern.num_args() != 1)
                    TERMINATE(
                            "ExprTranslator : translate z3::expr to DESCAM::Expr, operator not, expected 1 argument");
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
                } else
                    TERMINATE(
                            "ExprTranslator : translate z3::expr to DESCAM::Expr, operator -, expected 1 or 2 arguments");

            } else TERMINATE("ExprTranslator : unknown Unary: " + oper);
        } else if (arithOperatorMap.find(oper) != arithOperatorMap.end()) {
            if (z3_expr_intern.num_args() < 2)
                TERMINATE(
                        "ExprTranslator : translate z3::expr to DESCAM::Expr, operator +, expected 2 or more arguments");
            z3::expr first = z3_expr_intern.arg(0);
            z3::expr second = z3_expr_intern.arg(1);

            DESCAM::Arithmetic *multiple = nullptr;
            DESCAM_ASSERT(multiple = new DESCAM::Arithmetic(translate_intern(first), arithOperatorMap.at(oper),
                                                          translate_intern(second)))
            for (unsigned int i = 2; i < z3_expr_intern.num_args(); ++i) {
                z3::expr next = z3_expr_intern.arg(i);
                DESCAM_ASSERT(
                        multiple = new DESCAM::Arithmetic(multiple, arithOperatorMap.at(oper), translate_intern(next)))
            }
            CHECK_EXCEPTION_AND_RETURN(multiple)
        } else if (bvArithOperatorMap.find(oper) != bvArithOperatorMap.end()) {
            if (z3_expr_intern.num_args() == 2) {
                z3::expr lhs = z3_expr_intern.arg(0);
                z3::expr rhs = z3_expr_intern.arg(1);
                DESCAM_ASSERT(returnExpr = new DESCAM::Arithmetic(translate_intern(lhs), bvArithOperatorMap.at(oper),
                                                                translate_intern(rhs)))
                CHECK_EXCEPTION_AND_RETURN(returnExpr)
            } else {
                //std::cout << z3_expr_intern << std::endl;
                TERMINATE("ExprTranslator : translate z3::expr to DESCAM::Expr expected 2 arguments");
            }
        } else if (bvBitwiseOperatorMap.find(oper) != bvBitwiseOperatorMap.end()) {
            if (z3_expr_intern.num_args() == 2) {
                z3::expr lhs = z3_expr_intern.arg(0);
                z3::expr rhs = z3_expr_intern.arg(1);
                DESCAM_ASSERT(returnExpr = new DESCAM::Bitwise(translate_intern(lhs), bvBitwiseOperatorMap.at(oper),
                                                             translate_intern(rhs)))
                CHECK_EXCEPTION_AND_RETURN(returnExpr)
            } else {
                //std::cout << z3_expr_intern << std::endl;
                TERMINATE("ExprTranslator : translate z3::expr to DESCAM::Expr expected 2 arguments");
            }
        } else if (bvRelationalOperatorMap.find(oper) != bvRelationalOperatorMap.end()) {
            if (z3_expr_intern.num_args() == 2) {
                z3::expr lhs = z3_expr_intern.arg(0);
                z3::expr rhs = z3_expr_intern.arg(1);
                if (oper == "bvule") this->unsigned_flag = true;
                if (oper == "bvsle") this->unsigned_flag = false;

                DESCAM_ASSERT(returnExpr = new DESCAM::Relational(translate_intern(lhs), bvRelationalOperatorMap.at(oper),
                                                                translate_intern(rhs)))
                CHECK_EXCEPTION_AND_RETURN(returnExpr)
            } else TERMINATE("ExprTranslator : translate z3::expr to DESCAM::Expr expected 2 arguments");
        } else if (oper == "concat") {
//            std::cout<<"EXprTranslator: concat\n";
            abort = true;
            z3::expr abort = context->int_val(0);
            return translate_intern(abort);
        } else if (oper == "extract") {
//            std::cout<<"EXprTranslator: extract " << z3_expr.is_algebraic() << "\n";
            abort = true;
            z3::expr extract = z3_expr_intern;
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
        } else TERMINATE("ExprTranslator : translate z3::expr to DESCAM::Expr, unknown operator: " + oper);
    }
}

z3::context *DESCAM::ExprTranslator::getContext() {
    return context;
}

z3::sort DESCAM::ExprTranslator::find_or_add_sort(const DESCAM::DataType *pType) {
    if (!pType->isEnumType()) TERMINATE(pType->getName() + " is not an enum type");
    if (this->enumTypeSortMap.find(pType) == this->enumTypeSortMap.end()) {
        //define a sort (z3 term for datatype) with the name of the enumType
        z3::func_decl_vector enum_consts(*context);
        z3::func_decl_vector enum_testers(*context);
        const char *enum_values[pType->getEnumValueMap().size()];
        for (auto &&item : pType->getEnumValueMap()) {
            enum_values[item.second] = item.first.c_str();
        }
        z3::sort s = context->enumeration_sort(pType->getName().c_str(), pType->getEnumValueMap().size(), enum_values,
                                               enum_consts,
                                               enum_testers);
        this->enumTypeSortMap.insert(std::make_pair(pType, s));
        this->enumTypeValueMap.insert(std::make_pair(pType, enum_consts));
        return s;

    }
    return this->enumTypeSortMap.find(pType)->second;
}

bool DESCAM::ExprTranslator::isAbort() const {
    return abort;
}

void DESCAM::ExprTranslator::reset() {
    this->unsigned_flag = false;
    this->bitvector_flag = false;
}

void DESCAM::ExprTranslator::visit(DESCAM::UnsignedValue &node) {
    if (bitvector_flag) {
//        std::cout<<"EXprTranslator: visit(UnsignedValue) - bitvector_flag\n";
        z3_expr = context->bv_val(node.getValue(), 32);
    } else {
        z3_expr = context->int_val(node.getValue());
    }
    unsigned_flag = true;
}

void DESCAM::ExprTranslator::visit(DESCAM::IntegerValue &node) {
    if (bitvector_flag) {
//        std::cout<<"EXprTranslator: visit(IntegerValue) - bitvector_flag\n";
        z3_expr = context->bv_val(node.getValue(), 32);
    } else {
        z3_expr = context->int_val(node.getValue());
    }
    unsigned_flag = false;
}


void DESCAM::ExprTranslator::visit(DESCAM::CompoundValue &node) {
    TERMINATE("NOT DONE YET");

}


void DESCAM::ExprTranslator::visit(DESCAM::BoolValue &node) {
    z3_expr = context->bool_val(node.getValue());
}

//EnumValue is given as the identifying int (from the enumValueMap)
void DESCAM::ExprTranslator::visit(DESCAM::EnumValue &node) {
    //define a sort (z3 term for datatype) with the name of the enumType
    find_or_add_sort(node.getDataType());
    z3::func_decl_vector enumValues = this->enumTypeValueMap.find(node.getDataType())->second;
    int enumInt = node.getDataType()->getEnumValueMap().find(node.getEnumValue())->second;
    z3_expr = enumValues[enumInt]();

}


//SectionValue is just a special kind of an Enum, treated like an enum
void DESCAM::ExprTranslator::visit(DESCAM::SectionValue &node) {
    z3_expr = context->int_val(node.getDataType()->getEnumValueMap().find(node.getValue())->second);
}

void DESCAM::ExprTranslator::visit(DESCAM::VariableOperand &node) {

    //a new variable (int_const or bool_const) is created each time an operand is found
    //this is ok, since z3 automatically sees them as the same operand as long as it has the same name

    if (node.getDataType()->isBuiltInType()) {
        if (node.getDataType() == DataTypes::getDataType("int")) {
            if (bitvector_flag) z3_expr = context->bv_const(node.getOperandName().c_str(), 32);
            else z3_expr = context->int_const(node.getOperandName().c_str());
            return;
        } else if (node.getDataType() == DataTypes::getDataType("bool")) { //bool
            z3_expr = context->bool_const(node.getOperandName().c_str());
            return;
        } else if (node.getDataType() == DataTypes::getDataType("unsigned")) { //unsigned
            if (bitvector_flag) z3_expr = context->bv_const(node.getOperandName().c_str(), 32);
            else z3_expr = context->int_const(node.getOperandName().c_str());
            unsigned_flag = true;
            return;
        } else TERMINATE("Unknown datatype");
    }
    //enum, added as an integer, but with range limit representing its possible values
    if (node.getDataType()->isEnumType()) {
        this->z3_expr = context->constant(node.getOperandName().c_str(), find_or_add_sort(node.getDataType()));
        return;
    }

    //compound operands, should never appear since they are used only as lhs of assignments to communication calls
    TERMINATE("ExprTranslator VariableOperand: did not expect compound type operand");
}

void DESCAM::ExprTranslator::visit(DESCAM::SectionOperand &node) {

    if (node.getDataType()->isEnumType()) {
        z3_expr = context->int_const("nextsection");
        return;
    }
    TERMINATE("ExprTranslator SectionOperand: a section operand must be of enum type");
}


void DESCAM::ExprTranslator::visit(DESCAM::UnaryExpr &node) {
    z3::expr rhs = translate(node.getExpr());

    if (node.getOperation() == "not") {
        z3_expr = !rhs;
        return;
    }
    if (node.getOperation() == "-") {
        z3_expr = -rhs;
        return;
    }

    if (node.getOperation() == "~") {
        z3_expr = ~(rhs);
        return;
    }
    TERMINATE("ExprTranslator UnaryExpr: cannot be translated");
}

void DESCAM::ExprTranslator::visit(DESCAM::Arithmetic &node) {
    z3::expr lhs = translate(node.getLhs());
    z3::expr rhs = translate(node.getRhs());

    if (node.getOperation() == "+") {
        z3_expr = lhs + rhs;
        return;
    }
    if (node.getOperation() == "-") {
        z3_expr = lhs - rhs;
        return;
    }
    if (node.getOperation() == "*") {
        z3_expr = lhs * rhs;
        return;
    }
    if (node.getOperation() == "/") {
        z3_expr = lhs / rhs;
        return;
    }
    if (node.getOperation() == "%") {
        //It's required by z3 to have a bitvector for reminder operations
        z3::expr lhs = translate(node.getLhs());
        z3::expr rhs = translate(node.getRhs());

        try {
            if (unsigned_flag) z3_expr = z3::urem(lhs, rhs);
            else z3_expr = z3::srem(lhs, rhs);

        } catch (z3::exception e) {

            std::cout << lhs << "%" << rhs << std::endl;
            std::cout << e << std::endl;
        }
        return;
    }
    TERMINATE("ExprTranslator Arithmetic: cannot be translated");
}

void DESCAM::ExprTranslator::visit(DESCAM::Logical &node) {
    z3::expr lhs = translate(node.getLhs());
    z3::expr rhs = translate(node.getRhs());

    if (node.getOperation() == "and") {
        z3_expr = lhs and rhs;
        return;
    }
    if (node.getOperation() == "nand") {
        z3_expr = !(lhs and rhs);
        return;
    }
    if (node.getOperation() == "or") {
        z3_expr = lhs or rhs;
        return;
    }
    if (node.getOperation() == "nor") {
        z3_expr = !(lhs or rhs);
        return;
    }
    if (node.getOperation() == "xor") {
        z3_expr = lhs != rhs;
        return;
    }
    if (node.getOperation() == "xnor") {

        z3_expr = lhs == rhs;
        return;
    }
    TERMINATE("ExprTranslator Logical: cannot be translated");
}


void DESCAM::ExprTranslator::visit(DESCAM::Bitwise &node) {
    z3::expr lhs = translate(node.getLhs());
    z3::expr rhs = translate(node.getRhs());


    if (node.getOperation() == ">>") {
        if (node.getDataType()->isUnsigned()) {
            z3_expr = z3::lshr(lhs, rhs);
        } else z3_expr = z3::ashr(lhs, rhs);
        return;
    } else if (node.getOperation() == "<<") {
        z3_expr = z3::shl(lhs, rhs);
        return;
    } else if (node.getOperation() == "&") {
        z3_expr = lhs & rhs;
        return;
    } else if (node.getOperation() == "|") {
        z3_expr = lhs | rhs;
        return;
    } else if (node.getOperation() == "^") {
        z3_expr = lhs ^ rhs;
        return;
    } else TERMINATE("ExprTranslator Bitwise: cannot be translated");

}


void DESCAM::ExprTranslator::visit(DESCAM::Cast &node) {
//    std::cout<<"EXprTranslator: visit(Cast)\n";
    this->abort = true;
    if (node.getDataType()->isUnsigned()) {
        unsigned_flag = true;
        node.getSubExpr()->accept(*this);
    } else node.getSubExpr()->accept(*this);


}


void DESCAM::ExprTranslator::visit(DESCAM::Relational &node) {

    z3::expr lhs = translate(node.getLhs());
    z3::expr rhs = translate(node.getRhs());


    if (node.getOperation() == "==") {

        try {
            z3_expr = lhs == rhs;
        } catch (z3::exception e) {
            std::cout << lhs << " == " << rhs << std::endl;
            std::cout << e << std::endl;
        }
        return;
    }
    if (node.getOperation() == "!=") {
        z3_expr = lhs != rhs;
        return;
    }
    if (node.getOperation() == ">") {
        if (node.getLhs()->getDataType()->isUnsigned()) {
            z3_expr = z3::ugt(lhs, rhs);
        } else z3_expr = lhs > rhs;
        return;
    }
    if (node.getOperation() == "<") {
        if (node.getLhs()->getDataType()->isUnsigned()) {
            z3_expr = z3::ult(lhs, rhs);
        } else z3_expr = lhs < rhs;
        return;
    }
    if (node.getOperation() == ">=") {
        if (node.getLhs()->getDataType()->isUnsigned()) {
            z3_expr = z3::uge(lhs, rhs);
        } else z3_expr = (lhs >= rhs);
        return;
    }
    if (node.getOperation() == "<=") {
        if (node.getLhs()->getDataType()->isUnsigned()) {
            z3_expr = z3::ule(lhs, rhs);
        } else z3_expr = (lhs <= rhs);
        return;
    }

    TERMINATE("ExprTranslator Relational: cannot be translated");
}

void DESCAM::ExprTranslator::visit(DESCAM::SyncSignal &node) {
    //A new variable for synch is created and synch is always of type bool
    //this is ok, since z3 automatically sees them as the same operand as long as it has the same name
    std::string name = node.getPort()->getName() + "_synch";
    z3_expr = context->bool_const(name.c_str());
    return;

}


void DESCAM::ExprTranslator::visit(DESCAM::DataSignalOperand &node) {
    if (node.getDataType()->isCompoundType())
        TERMINATE("ExprTranslator DataSignal: Signal is not allowed to be compound type");
    std::string name = "";
    if (node.getDataSignal()->isSubVar()) {
        name = node.getDataSignal()->getPort()->getName() + "_dataXYZ_" + node.getDataSignal()->getName();
    } else name = node.getDataSignal()->getPort()->getName() + "_dataXYZ";

    if (node.getDataType()->isBuiltInType()) {
        if (node.getDataType()->getName() == "int") {
            if (bitvector_flag) z3_expr = context->bv_const(name.c_str(), 32);
            else z3_expr = context->int_const(name.c_str());
            return;
        } else if (node.getDataType()->getName() == "unsigned") {
            if (bitvector_flag) z3_expr = context->bv_const(name.c_str(), 32);
            else z3_expr = context->int_const(name.c_str());
            unsigned_flag = true;
            return;
        } else { //bool
            z3_expr = context->bool_const(name.c_str());
            return;
        }
    }
        //enum, added as an integer, but with range limit representing its possible values
    else if (node.getDataType()->isEnumType()) {
        z3_expr = context->constant(name.c_str(), find_or_add_sort(node.getDataType()));
        return;
    } else {
        TERMINATE("Unsupported type: " + node.getDataType()->getName());
    }
    return;

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
            if (bitvector_flag) z3_expr = context->bv_const(name.c_str(), 32);
            else z3_expr = context->int_const(name.c_str());
        } else if (node.getDataType() == DataTypes::getDataType("bool")) { //bool
            z3_expr = context->bool_const(name.c_str());
        } else if (node.getDataType() == DataTypes::getDataType("unsigned")) { //unsigned
            if (bitvector_flag) z3_expr = context->bv_const(name.c_str(), 32);
            else z3_expr = context->int_const(name.c_str());
            unsigned_flag = true;

        } else TERMINATE("Unknown datatype");
        this->functionOperandMap.insert(std::make_pair(name, &node));
        return;
    }
    //enum, added as an integer, but with range limit representing its possible values
    if (node.getDataType()->isEnumType()) {
        this->z3_expr = context->constant(name.c_str(), find_or_add_sort(node.getDataType()));
        this->functionOperandMap.insert(std::make_pair(name, &node));
        return;
    }

    //compound operands, should never appear since they are used only as lhs of assignments to communication calls
    TERMINATE("ExprTranslator VariableOperand: did not expect compound type operand");

}

void DESCAM::ExprTranslator::visit(struct ArrayOperand &node) {

    auto name = (node.getArrayOperand()->getOperandName() + "[" + PrintStmt::toString(node.getIdx()) + "]");
    if (node.getDataType()->isBuiltInType()) {
        if (node.getDataType() == DataTypes::getDataType("int")) {
            if (bitvector_flag) z3_expr = context->bv_const(name.c_str(), 32);
            else z3_expr = context->int_const(name.c_str());
        } else if (node.getDataType() == DataTypes::getDataType("bool")) { //bool
            z3_expr = context->bool_const(name.c_str());
        } else if (node.getDataType() == DataTypes::getDataType("unsigned")) { //unsigned
            if (bitvector_flag) z3_expr = context->bv_const(name.c_str(), 32);
            else z3_expr = context->int_const(name.c_str());
            unsigned_flag = true;

        } else TERMINATE("Unknown datatype");
        this->arrayMap.insert(std::make_pair(name, &node));
        return;
    } else TERMINATE("Unknown datatype");

}


void DESCAM::ExprTranslator::visit(DESCAM::Ternary &node) {

    auto condition = translate(node.getCondition());
    auto trueExpr = translate(node.getTrueExpr());
    auto falseExpr = translate(node.getFalseExpr());

    z3_expr = z3::ite(condition, trueExpr, falseExpr);

}
