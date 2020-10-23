#include "Utilities.h"
#include <cassert>

using namespace DESCAM::HLSPlugin::VHDLWrapper;

//TODO switch to unsigned long int?
bool Utilities::isPowerOfTwo(long int n) {
  if ((n < 1) || (n & n - 1))
    return false;
  return true;
}
//TODO switch to unsigned long int?
int Utilities::bitPosition(long int n) {
  assert(isPowerOfTwo(n) == true);
  int count = 0;
  while (n > 0) {
    if (n & 1)
      return count;
    else {
      count++;
      n >>= 1;
    }
  }
  assert(false && "-E- Utilities::bitPosition returned non-sensible data. Couldn't find bit position");
}

std::string Utilities::typeToString(StmtType type) {
  switch (type) {
    case StmtType::ARITHMETIC:return "arithmetic";
    case StmtType::RELATIONAL:return "relational";
    case StmtType::LOGICAL:return "logical";
    case StmtType::BITWISE:return "bitwise";
    case StmtType::VARIABLE_OPERAND:return "variable operand";
    case StmtType::DATA_SIGNAL_OPERAND:return "data signal operand";
    case StmtType::ENUM_VALUE:return "enum value";
    case StmtType::UNARY_EXPR:return "unary expr";
    case StmtType::INTEGER_VALUE:return "integer value";
    case StmtType::UNSIGNED_VALUE:return "unsigned value";
    case StmtType::ARRAY_OPERAND:return "array operand";
    case StmtType::PARAM_OPERAND:return "param operand";
    case StmtType::ASSIGNMENT:return "assignment";
    case StmtType::UNKNOWN:return "unknown type";
    default:assert(false && "-E- Unexpected StmtType in Utilities::typeToString");
  }
}

std::string Utilities::subTypeBitwiseToString(SubTypeBitwise type) {
  switch (type) {
    case SubTypeBitwise::BITWISE_AND:return "&";
    case SubTypeBitwise::BITWISE_OR:return "|";
    case SubTypeBitwise::BITWISE_XOR:return "^";
    case SubTypeBitwise::LEFT_SHIFT:return "<<";
    case SubTypeBitwise::RIGHT_SHIFT:return ">>";
    case SubTypeBitwise::UNKNOWN:return "unknown operation";
    default:assert(false && "-E- Unexpected SubTypeBitwise in Utilities::subTypeBitwiseToString");
  }
}

DESCAM::HLSPlugin::SubTypeBitwise Utilities::getSubTypeBitwise(const std::string &name) {
  if (name == "&") {
    return SubTypeBitwise::BITWISE_AND;
  } else if (name == "|") {
    return SubTypeBitwise::BITWISE_OR;
  } else if (name == "^") {
    return SubTypeBitwise::BITWISE_XOR;
  } else if (name == "<<") {
    return SubTypeBitwise::LEFT_SHIFT;
  } else if (name == ">>") {
    return SubTypeBitwise::RIGHT_SHIFT;
  } else {
    return SubTypeBitwise::UNKNOWN;
  }
}
