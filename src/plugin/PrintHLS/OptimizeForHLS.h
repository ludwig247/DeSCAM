//
// Created by johannes on 27.10.19.
//

#ifndef SCAM_UTILITIES_HLS_H
#define SCAM_UTILITIES_HLS_H

#include <set>
#include <queue>

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

class OptimizeForHLS {

public:
    explicit OptimizeForHLS(PropertySuite *propertySuite, Module* module);
    ~OptimizeForHLS();

    static std::string convertDataType(const std::string& type);

    bool getCorrespondingRegisterName(const std::string& outputName, std::string& registerName);

    std::set<DataSignal*> getOutputs();
    std::set<Variable* > getVariables();

    static std::string typeToString(StmtType type);
    static std::string subTypeBitwiseToString(SubTypeBitwise type);

    inline std::set<DataSignal*> getModuleOutputs() const ;

private:
    PropertySuite *propertySuite;
    std::queue<std::vector<Assignment* > > originalCommitmentLists;
    Module* module;

    std::set<DataSignal*> moduleOutputs;
    std::map<Variable*, DataSignal*> registerToOutputMap;
    std::map<DataSignal*, Variable*> outputToRegisterMap;

    std::multimap<Variable*, DataSignal*> getParentMap(const std::multimap<Variable*, DataSignal*> &multimap);

    void replaceDataSignals(const std::map<DataSignal*, DataSignal*> &dataSignalMap);
    void replaceVariables();
    DataSignal* getCombinedDataSignal(const std::vector<DataSignal*> &dataSignals);
    void removeRedundantConditions();
    void mapOutputRegistersToOutput();

    template <typename Key, typename Value>
    std::map<Key *, Value *> getSubVarMap(std::map<Key *, Value *> map);
};

inline std::set<DataSignal* > OptimizeForHLS::getModuleOutputs() const {
    return moduleOutputs;
}

#endif //SCAM_UTILITIES_HLS_H
