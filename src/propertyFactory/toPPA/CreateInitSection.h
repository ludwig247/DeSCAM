//
// Created by ludwig on 19.01.18.
//

#ifndef PROJECT_CREATEINITSECTION_H
#define PROJECT_CREATEINITSECTION_H

#include <Module.h>
#include <Stmts/SectionOperand.h>
#include <Stmts/SectionValue.h>
#include <Stmts/VariableOperand.h>
#include <Stmts/NBWrite.h>

namespace SCAM{
    class CreateInitSection {
    public:
        CreateInitSection()= default;
        static std::vector<Stmt *> createInitSection(const Module& module);
    };
}



#endif //PROJECT_CREATEINITSECTION_H
