//
// Created by joakim on 10/18/16.
//

#include "aml_driver.h"

aml_driver::aml_driver()
        : trace_scanning(false), trace_parsing(false), model(nullptr), error_location(nullptr), error_code(0)
{
}

aml_driver::~aml_driver()
{


}

int aml_driver::parse(const std::string &f, SCAM::Model* m)
{
    filename = f;
    model = m;
    scan_begin();
    if (error_code)
        return error_code;
    yy::aml_parser parser(*this);
    parser.set_debug_level(trace_parsing);
    error_code = parser.parse();
    scan_end();
    return error_code;
}


void aml_driver::error(const yy::location& l, const std::string& m)
{
    error_location = l;
    error_msg = m;
}
void aml_driver::error(const std::string& m)
{
    error_msg = m;
}



bool aml_driver::addModule(SCAM::Module* m)
{
    //check name against the names of the already defined ones
    std::map<std::string,SCAM::Module*> tmp_map = model->getModules();

    if (tmp_map.find(m->getName()) != tmp_map.end()) {
        return false; //another module with this name is already created
    }

    //keep a pointer to allow direct access to during parsing
    this->module = m;

    //add to module list of model
    model->addModule(this->module);
    return true;
}

bool aml_driver::isConstExpr(SCAM::Expr* e) const {
    SCAM::ExprTranslator translator;
    z3::expr z3Expr = translator.translate(e);
    z3Expr = z3Expr.simplify();

    //in z3 : is_const() only means a terminal expression (could also be a single operand)
    //this "hack" works, to check for Integer values and boolean values
    return (z3Expr.decl().name().str() == "Int" || z3Expr.decl().name().str() == "true" || z3Expr.decl().name().str() == "false");
}

SCAM::ConstValue* aml_driver::reduzeToConstValue(SCAM::Expr* e) const {
    SCAM::ExprTranslator translator;
    z3::expr z3Expr = translator.translate(e);
    z3Expr = z3Expr.simplify();
    if (!z3Expr.is_const()) throw std::runtime_error("aml_driver reduzeToConstValue: not a constant value");

    if (e->isDataType("int")) {
        return (new SCAM::IntegerValue( z3Expr.get_numeral_int()));
    } else if (e->isDataType("bool")) {
        z3::solver s(z3Expr.ctx());
        s.add(!z3Expr);
        return (new SCAM::BoolValue( (s.check()==z3::unsat)));
    }
    throw std::runtime_error("aml_driver reduzeToConstValue: unsupported datatype");
}


