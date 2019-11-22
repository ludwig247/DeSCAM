//
// Created by johannes on 27.10.19.
//

#ifndef SCAM_UTILITIES_HLS_H
#define SCAM_UTILITIES_HLS_H


#include <set>

#include <PluginFactory.h>

enum class Side {
    UNKNOWN,
    LHS,
    RHS
};

enum class StmtType {
    UNKNOWN, ARITHMETIC, RELATIONAL, LOGICAL, BITWISE, VARIABLE_OPERAND, DATA_SIGNAL_OPERAND, ENUM_VALUE,
    UNARY_EXPR, INTEGER_VALUE, UNSIGNED_VALUE, ARRAY_OPERAND, PARAM_OPERAND, ASSIGNMENT
};

enum class SubTypeBitwise {
    UNKNOWN, BITWISE_AND, BITWISE_OR, BITWISE_XOR, LEFT_SHIFT, RIGHT_SHIFT
};

class Utilities {

public:
    explicit Utilities(PropertySuite *propertySuite, Module* module);
    ~Utilities() = default;

    static std::string convertDataType(const std::string& type);

    std::set<Variable* > getOutputRegisterParents();
    std::map<DataSignal*, Variable*> getParentMap();

    static std::string typeToString(StmtType type);
    static std::string subTypeBitwiseToString(SubTypeBitwise type);

    inline std::set<Variable* > getRegisters();
    inline std::set<Variable* > getOutputRegisters();
    inline std::map<DataSignal*, Variable*> getOutputToRegisterMap();

private:
    PropertySuite *propertySuite;
    Module* module;
    std::set<Variable* > regs;
    std::set<Variable* > regsReplaceByOutput;
    std::set<Variable* > outputRegisters;
    std::map<Variable*, DataSignal*> registerToOutputMap;
    std::map<DataSignal*, Variable*> outputToRegisterMap;

    void setRegisters();
    void getStmtType();
    void removeRedundantConditions();
    void mapOutputRegistersToOutput();
    void simplifyCommitments();
    void getRHSExpr(DataSignal *dataSignal, std::set<Variable*> candidates);
};

inline std::set<Variable *> Utilities::getRegisters() {
    return regs;
}

inline std::set<Variable* > Utilities::getOutputRegisters() {
    return outputRegisters;
}

inline std::map<DataSignal*, Variable*> Utilities::getOutputToRegisterMap() {
    return outputToRegisterMap;
}

#endif //SCAM_UTILITIES_HLS_H
