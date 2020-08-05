//
// Created by ludwig on 19.01.18.
//

#ifndef PROJECT_CREATEINITSECTION2_H
#define PROJECT_CREATEINITSECTION2_H

#include <Module.h>
#include <Stmts/SectionOperand.h>
#include <Stmts/SectionValue.h>
#include <Stmts/VariableOperand.h>
//#include <Stmts/NBWrite.h>

namespace DESCAM {
    class CreateInitSection2 {
    public:
        CreateInitSection2() = default;

        static std::vector<Stmt *> createInitSection2(const DESCAM::Module *module);
    };
}


#endif //PROJECT_CREATEINITSECTION_H
