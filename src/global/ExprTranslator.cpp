//


#include <tgmath.h>

#include "ExprTranslator.h"


//
// Created by joakim on 06.11.16.
SCAM::ExprTranslator::ExprTranslator() :
        unsigned_flag(false),
        bitvector_flag(false),
        context(new z3::context()),
        z3_expr(*context),
        datatypeMap(DataTypes::getDataTypeMap()) {
    assert(false && "Should not be used");

}

SCAM::ExprTranslator::ExprTranslator(z3::context *context) :
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


SCAM::ExprTranslator::~ExprTranslator() {

}

z3::expr &SCAM::ExprTranslator::translate(SCAM::Expr *scam_expr) {

    bitvector_flag = ExprVisitor::isBitwise(scam_expr) || bitvector_flag;

    scam_expr->accept(*this);

    return z3_expr;
}

SCAM::Expr *SCAM::ExprTranslator::translate(z3::expr &z3_expr, const SCAM::Module *module) {
    //datatype map must at least contain built-in types
    if (datatypeMap.empty() || datatypeMap.find("int") == datatypeMap.end() || datatypeMap.find("bool") == datatypeMap.end()) {
        throw std::runtime_error("ExprTranslator translation from z3 to SCAM requires a datatypeMap including the built-in types");
    }

    this->module = module; //allowed to be nullptr !

    return this->translate_intern(z3_expr);
}

//is private, only enterered when the maps exists (and{throw std::runtime_error("ExprSCAMtoZ3 did not expect SyncSignal");} when at least "int" and "bool" is a datatype
SCAM::Expr *SCAM::ExprTranslator::translate_intern(z3::expr &z3_expr) {

    //TERMINAL EXPRESSION
    if (z3_expr.is_const()) {
        std::string symbolname = z3_expr.decl().name().str();

        //integer value
        if (symbolname == "Int") {
            if (this->unsigned_flag) {
                unsigned int value = z3_expr.get_numeral_int64();
                if (value > 4294967295) throw std::runtime_error("Result of unsigned computation is > 2^32-1");
                return new SCAM::UnsignedValue(value);
            } else return new SCAM::IntegerValue(z3_expr.get_numeral_int());
        };

        if (symbolname == "bv") {
            if (this->unsigned_flag) {
                unsigned int value = z3_expr.get_numeral_int64();
                if (value > 4294967295) throw std::runtime_error("Result of unsigned computation is > 2^32-1");
                return new SCAM::UnsignedValue(value);
            } else {
                //z3 doesn't translate a bitvector back into a signed integer, always interprets it unsigned
                if (z3_expr.get_numeral_uint() > 2147483647) return new SCAM::IntegerValue(z3_expr.get_numeral_uint() - 4294967296);
                else return new SCAM::IntegerValue(z3_expr.get_numeral_int());
            }
        }
        //boolean value
        if (symbolname == "true") {
            return new SCAM::BoolValue(true);


        }
        if (symbolname == "false") {

            return new SCAM::BoolValue(false);
        }

        //enum value
        for (auto &&type : datatypeMap) {
            if (type.second->isEnumType()) {
                for (auto &&enumValPair : type.second->getEnumValueMap()) {
                    if (enumValPair.first == symbolname) {
                        return new SCAM::EnumValue(symbolname, type.second);
                    }
                }
            }
        }

        //Check for variables, dataSignal or synchSignals
        if (module == nullptr) {
            throw std::runtime_error("ExprTranslator : translate z3::expr to SCAM::Expr, module must be set for such conversion");
        }

        //section operand
        if (symbolname == "nextsection") {
            return new SectionOperand(module->getFSM()->getSectionVariable());
        }
        //Variable operand

        if (module->isVariable(symbolname)) {
            return new VariableOperand(module->getVariable(symbolname));
        }
        //Synch & DataSignals
        for (auto port: module->getPorts()) {
            if (symbolname == port.first + "_synch") {
                return port.second->getSynchSignal();
            }
            //Compound type port: multiple subsignals
            if (port.second->getDataSignal()->getDataType()->isCompoundType()) {
                for (auto subSig: port.second->getDataSignal()->getSubSigList()) {
                    if (symbolname == port.first + "_dataXYZ_" + subSig->getName()) {

                        return new DataSignalOperand(subSig);
                    }
                }
                //Built-in type ports
            } else {
                if (symbolname == port.first + "_dataXYZ") {
                    this->unsigned_flag = port.second->getDataSignal()->getDataType()->isUnsigned();
                    return new DataSignalOperand(port.second->getDataSignal());
                }
            }
        }
        if(functionOperandMap.find(symbolname) != functionOperandMap.end()){
            return functionOperandMap.find(symbolname)->second;
        }
        //NOTHING found!
        throw std::runtime_error("ExprTranslator : translate z3::expr to SCAM::Expr, missing variable for " + symbolname);
    }

        //NON-TERMINAL EXPRESSION
    else /*! z3_expr.is_const()*/ {
        std::string oper = z3_expr.decl().name().str();
        if (relationalOperatorMap.find(oper) != relationalOperatorMap.end()) {
            if (z3_expr.num_args() == 2) {
                z3::expr lhs = z3_expr.arg(0);
                z3::expr rhs = z3_expr.arg(1);
                return new SCAM::Relational(translate_intern(lhs), relationalOperatorMap.at(oper), translate_intern(rhs));
            } else throw std::runtime_error("Expecte 2 arguments for " + oper);
        } else if (logicalOperatorMap.find(oper) != logicalOperatorMap.end()) {
            if (z3_expr.num_args() < 2)
                throw std::runtime_error("ExprTranslator : translate z3::expr to SCAM::Expr expected 2 or more arguments");

            z3::expr first = z3_expr.arg(0);
            z3::expr second = z3_expr.arg(1);
            SCAM::Logical *multiple = new SCAM::Logical(translate_intern(first), logicalOperatorMap.at(oper), translate_intern(second));

            for (unsigned int i = 2; i < z3_expr.num_args(); ++i) {
                z3::expr next = z3_expr.arg(i);
                multiple = new SCAM::Logical(multiple, logicalOperatorMap.at(oper), translate_intern(next));
            }
            return multiple;
        } else if (unaryOperatorMap.find(oper) != unaryOperatorMap.end()) {
            if (oper == "not") { // UNARY
                if (z3_expr.num_args() != 1)
                    throw std::runtime_error("ExprTranslator : translate z3::expr to SCAM::Expr, operator not, expected 1 argument");
                z3::expr rhs = z3_expr.arg(0);
                return new SCAM::UnaryExpr("not", translate_intern(rhs));
            }else if (oper == "bvnot") { // UNARY
                if (z3_expr.num_args() != 1)
                    throw std::runtime_error("ExprTranslator : translate z3::expr to SCAM::Expr, operator not, expected 1 argument");
                z3::expr rhs = z3_expr.arg(0);
                return new SCAM::UnaryExpr("not", translate_intern(rhs));
            } else if (oper == "-") { //NOTE: can be unary or binary, check num_arg
                if (z3_expr.num_args() == 2) {
                    z3::expr lhs = z3_expr.arg(0);
                    z3::expr rhs = z3_expr.arg(1);
                    return new SCAM::Arithmetic(translate_intern(lhs), "-", translate_intern(rhs));
                } else if (z3_expr.num_args() == 1) {
                    z3::expr rhs = z3_expr.arg(0);
                    return new SCAM::UnaryExpr("-", translate_intern(rhs));
                } else throw std::runtime_error("ExprTranslator : translate z3::expr to SCAM::Expr, operator -, expected 1 or 2 arguments");

            } else throw std::runtime_error("ExprTranslator : unknown Unary: " + oper);
        } else if (arithOperatorMap.find(oper) != arithOperatorMap.end()) {
            if (z3_expr.num_args() < 2)
                throw std::runtime_error("ExprTranslator : translate z3::expr to SCAM::Expr, operator +, expected 2 or more arguments");
            z3::expr first = z3_expr.arg(0);
            z3::expr second = z3_expr.arg(1);

            SCAM::Arithmetic *multiple = new SCAM::Arithmetic(translate_intern(first), arithOperatorMap.at(oper), translate_intern(second));
            for (unsigned int i = 2; i < z3_expr.num_args(); ++i) {
                z3::expr next = z3_expr.arg(i);
                multiple = new SCAM::Arithmetic(multiple, arithOperatorMap.at(oper), translate_intern(next));
            }
            return multiple;
        } else if (bvArithOperatorMap.find(oper) != bvArithOperatorMap.end()) {
            if (z3_expr.num_args() == 2) {
                z3::expr lhs = z3_expr.arg(0);
                z3::expr rhs = z3_expr.arg(1);
                return new SCAM::Arithmetic(translate_intern(lhs), bvArithOperatorMap.at(oper), translate_intern(rhs));
            } else throw std::runtime_error("ExprTranslator : translate z3::expr to SCAM::Expr expected 2 arguments");
        } else if (bvBitwiseOperatorMap.find(oper) != bvBitwiseOperatorMap.end()) {
            if (z3_expr.num_args() == 2) {
                z3::expr lhs = z3_expr.arg(0);
                z3::expr rhs = z3_expr.arg(1);
                return new SCAM::Bitwise(translate_intern(lhs), bvBitwiseOperatorMap.at(oper), translate_intern(rhs));
            } else throw std::runtime_error("ExprTranslator : translate z3::expr to SCAM::Expr expected 2 arguments");
        } else if (bvRelationalOperatorMap.find(oper) != bvRelationalOperatorMap.end()) {
            if (z3_expr.num_args() == 2) {
                z3::expr lhs = z3_expr.arg(0);
                z3::expr rhs = z3_expr.arg(1);
                if(oper == "bvule") this->unsigned_flag = true;
                if(oper == "bvsle") this->unsigned_flag = false;
                return new SCAM::Relational(translate_intern(lhs), bvRelationalOperatorMap.at(oper), translate_intern(rhs));
            } else throw std::runtime_error("ExprTranslator : translate z3::expr to SCAM::Expr expected 2 arguments");
        } else if (oper == "concat") {
            abort = true;
            z3::expr abort = context->int_val(0);
            return translate_intern(abort);
        } else if (oper == "extract") {
            abort = true;
            z3::expr extract = z3_expr;
            assert(extract.decl().name().str() == "extract" && extract.num_args() == 1 && extract.arg(0).is_const() &&
                   "Unknown apps");
            //Return something to work with
            z3::expr ret = z3_expr.arg(0);
            return translate_intern(ret);
        } else throw std::runtime_error("ExprTranslator : translate z3::expr to SCAM::Expr, unknown operator: " + oper);
    }
}

z3::context *SCAM::ExprTranslator::getContext() {
    return context;
}

z3::sort SCAM::ExprTranslator::find_or_add_sort(const SCAM::DataType *pType) {
    if (!pType->isEnumType()) throw std::runtime_error(pType->getName() + " is not an enum type");
    if (this->enumTypeSortMap.find(pType) == this->enumTypeSortMap.end()) {
        //define a sort (z3 term for datatype) with the name of the enumType
        z3::func_decl_vector enum_consts(*context);
        z3::func_decl_vector enum_testers(*context);
        const char *enum_values[pType->getEnumValueMap().size()];
        for (auto &&item : pType->getEnumValueMap()) {
            enum_values[item.second] = item.first.c_str();
        }
        z3::sort s = context->enumeration_sort(pType->getName().c_str(), pType->getEnumValueMap().size(), enum_values, enum_consts,
                                               enum_testers);
        this->enumTypeSortMap.insert(std::make_pair(pType, s));
        this->enumTypeValueMap.insert(std::make_pair(pType, enum_consts));
        return s;

    }
    return this->enumTypeSortMap.find(pType)->second;
}

bool SCAM::ExprTranslator::isAbort() const {
    return abort;
}

void SCAM::ExprTranslator::reset() {
    this->unsigned_flag = false;
    this->bitvector_flag = false;
}



void SCAM::ExprTranslator::visit(SCAM::UnsignedValue &node) {
    if (bitvector_flag) {
        z3_expr = context->bv_val(node.getValue(), 32);
    } else {
        z3_expr = context->int_val(node.getValue());
    }
    unsigned_flag = true;
}

void SCAM::ExprTranslator::visit(SCAM::IntegerValue &node) {
    if (bitvector_flag) z3_expr = context->bv_val(node.getValue(), 32);
    else z3_expr = context->int_val(node.getValue());
    unsigned_flag = false;
}


void SCAM::ExprTranslator::visit(SCAM::CompoundValue &node) {
    throw std::runtime_error("NOT DONE YET");

}


void SCAM::ExprTranslator::visit(SCAM::BoolValue &node) {
    z3_expr = context->bool_val(node.getValue());
}

//EnumValue is given as the identifying int (from the enumValueMap)
void SCAM::ExprTranslator::visit(SCAM::EnumValue &node) {
    //define a sort (z3 term for datatype) with the name of the enumType
    find_or_add_sort(node.getDataType());
    z3::func_decl_vector enumValues = this->enumTypeValueMap.find(node.getDataType())->second;
    int enumInt = node.getDataType()->getEnumValueMap().find(node.getEnumValue())->second;
    z3_expr = enumValues[enumInt]();

}


//SectionValue is just a special kind of an Enum, treated like an enum
void SCAM::ExprTranslator::visit(SCAM::SectionValue &node) {
    z3_expr = context->int_val(node.getDataType()->getEnumValueMap().find(node.getValue())->second);
}

void SCAM::ExprTranslator::visit(SCAM::VariableOperand &node) {

    //a new variable (int_const or bool_const) is created each time an operand is found
    //this is ok, since z3 automatically sees them as the same operand as long as it has the same name

    if (node.getDataType()->isBuiltInType()) {
        if (node.getDataType() == DataTypes::getDataType("int") ) {
            if (bitvector_flag) z3_expr = context->bv_const(node.getOperandName().c_str(), 32);
            else z3_expr = context->int_const(node.getOperandName().c_str());
            return;
        } else if (node.getDataType() == DataTypes::getDataType("bool")) { //bool
            z3_expr = context->bool_const(node.getOperandName().c_str());
            return;
        } else if (node.getDataType() == DataTypes::getDataType("unsigned") ) { //unsigned
            if (bitvector_flag) z3_expr = context->bv_const(node.getOperandName().c_str(), 32);
            else z3_expr = context->int_const(node.getOperandName().c_str());
            unsigned_flag = true;
            return;
        } else throw std::runtime_error("Unknown datatype");
    }
    //enum, added as an integer, but with range limit representing its possible values
    if (node.getDataType()->isEnumType()) {
        this->z3_expr = context->constant(node.getOperandName().c_str(), find_or_add_sort(node.getDataType()));
        return;
    }




    //compound operands, should never appear since they are used only as lhs of assignments to communication calls
    throw std::runtime_error("ExprTranslator VariableOperand: did not expect compound type operand");
}

void SCAM::ExprTranslator::visit(SCAM::SectionOperand &node) {

    if (node.getDataType()->isEnumType()) {
        z3_expr = context->int_const("nextsection");
        return;
    }
    throw std::runtime_error("ExprTranslator SectionOperand: a section operand must be of enum type");
}


void SCAM::ExprTranslator::visit(SCAM::UnaryExpr &node) {
    z3::expr rhs = translate(node.getExpr());

    if (node.getOperation() == "not") {
        z3_expr = !rhs;
        return;
    }
    if (node.getOperation() == "-") {
        z3_expr = -rhs;
        return;
    }
    throw std::runtime_error("ExprTranslator UnaryExpr: cannot be translated");
}

void SCAM::ExprTranslator::visit(SCAM::Arithmetic &node) {
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
    throw std::runtime_error("ExprTranslator Arithmetic: cannot be translated");
}

void SCAM::ExprTranslator::visit(SCAM::Logical &node) {
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
    throw std::runtime_error("ExprTranslator Logical: cannot be translated");
}


void SCAM::ExprTranslator::visit(SCAM::Bitwise &node) {
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
    } else throw std::runtime_error("ExprTranslator Bitwise: cannot be translated");

}


void SCAM::ExprTranslator::visit(SCAM::Cast &node) {
    this->abort = true;
    if(node.getDataType()->isUnsigned()){
        unsigned_flag = true;
        node.getSubExpr()->accept(*this);
    }else node.getSubExpr()->accept(*this);



}


void SCAM::ExprTranslator::visit(SCAM::Relational &node) {
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
        if(node.getLhs()->getDataType()->isUnsigned()){
            z3_expr = z3::ugt(lhs,rhs);
        }else z3_expr = lhs > rhs;
        return;
    }
    if (node.getOperation() == "<") {
        if(node.getLhs()->getDataType()->isUnsigned()){
            z3_expr = z3::ult(lhs,rhs);
        }else z3_expr = lhs < rhs;
        return;
    }
    if (node.getOperation() == ">=") {
        if(node.getLhs()->getDataType()->isUnsigned()){
            z3_expr = z3::uge(lhs,rhs);
        }else z3_expr = (lhs >= rhs);
        return;
    }
    if (node.getOperation() == "<=") {
        if(node.getLhs()->getDataType()->isUnsigned()){
            z3_expr = z3::ule(lhs,rhs);
        }else z3_expr = (lhs <= rhs);
        return;
    }

    throw std::runtime_error("ExprTranslator Relational: cannot be translated");
}

void SCAM::ExprTranslator::visit(SCAM::SyncSignal &node) {
    //A new variable for synch is created and synch is always of type bool
    //this is ok, since z3 automatically sees them as the same operand as long as it has the same name
    std::string name = node.getPort()->getName() + "_synch";
    z3_expr = context->bool_const(name.c_str());
    return;

}


void SCAM::ExprTranslator::visit(SCAM::DataSignalOperand &node) {
    if (node.getDataType()->isCompoundType())
        throw std::runtime_error("ExprTranslator DataSignal: Signal is not allowed to be compound type");
    std::string name = "";
    if (node.getDataSignal()->isSubSig()) {
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
        throw std::runtime_error("Unsupported type: " + node.getDataType()->getName());
    }
    return;

}


void SCAM::ExprTranslator::visit(struct FunctionOperand &node) {
    //a new variable (int_const or bool_const) is created each time an operand is found
    //this is ok, since z3 automatically sees them as the same operand as long as it has the same name
    auto name = (node.getOperandName() + "_function_" + std::to_string(functionOperandMap.size()));
    if (node.getDataType()->isBuiltInType()) {
        if (node.getDataType() == DataTypes::getDataType("int") ) {
            if (bitvector_flag) z3_expr = context->bv_const(name.c_str(), 32);
            else z3_expr = context->int_const(name.c_str());
        } else if (node.getDataType() == DataTypes::getDataType("bool")) { //bool
            z3_expr = context->bool_const(name.c_str());
        } else if (node.getDataType() == DataTypes::getDataType("unsigned") ) { //unsigned
            if (bitvector_flag) z3_expr = context->bv_const(name.c_str(), 32);
            else z3_expr = context->int_const(name.c_str());
            unsigned_flag = true;

        } else throw std::runtime_error("Unknown datatype");
        this->functionOperandMap.insert(std::make_pair(name,&node));
        return;
    }
    //enum, added as an integer, but with range limit representing its possible values
    if (node.getDataType()->isEnumType()) {
        this->z3_expr = context->constant(name.c_str(), find_or_add_sort(node.getDataType()));
        this->functionOperandMap.insert(std::make_pair(name,&node));
        return;
    }

    //compound operands, should never appear since they are used only as lhs of assignments to communication calls
    throw std::runtime_error("ExprTranslator VariableOperand: did not expect compound type operand");

}

void SCAM::ExprTranslator::visit(struct SubSelect &node) {
    throw std::runtime_error("Not implemented");
}
