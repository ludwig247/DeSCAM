//
// Created by joakim on 10/18/16.
//

#ifndef NEWAML_AML_DRIVER_H
#define NEWAML_AML_DRIVER_H


#include <string>
#include <map>
#include "aml_parser.hpp"
#include <Model.h>
#include <Stmt.h>
#include "ExprTranslator.h"

// Tell Flex the lexer's prototype ...
# define YY_DECL yy::aml_parser::symbol_type yylex (aml_driver& driver)
// ... and declare it for the parser's sake.
YY_DECL;


class aml_driver
{
public:
    aml_driver();
    virtual ~aml_driver();

    int parse(const std::string& f, SCAM::Model* m);


    yy::location error_location;
    std::string error_msg;
    int error_code;

    std::string filename;
    bool trace_scanning;
    bool trace_parsing;


    // Called from within parse()
    void scan_begin();
    void scan_end();
    void error(const yy::location& l, const std::string& m);
    void error(const std::string& m);

    //Top level objects are added here to the model (instead of directly within the parser)
    bool addModule(SCAM::Module* module);

    //helper functions for checking constant expressions, using z3
    bool isConstExpr(SCAM::Expr* e) const;
    SCAM::ConstValue* reduzeToConstValue(SCAM::Expr* e) const;


    SCAM::Module* module; //data is added here during parsing only
    SCAM::Model* model; //upon success, this is the output, the entire parsed model
};


#endif //NEWAML_AML_DRIVER_H
