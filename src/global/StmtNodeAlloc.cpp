//
// Created by pmorku on 7/17/18.
//


#include "StmtNodeAlloc.h"
#include "SimplifyVisitor.h"

namespace SCAM {

    // Expr node tables
    std::vector<VariableOperand *> StmtNodeAlloc::allocTableVariableOperand;
    std::vector<TimePointOperand *> StmtNodeAlloc::allocTableTimeExprOperand;
    std::vector<IntegerValue *> StmtNodeAlloc::allocTableIntegerValue;
    std::vector<UnsignedValue *> StmtNodeAlloc::allocTableUnsignedValue;
    std::vector<BoolValue *> StmtNodeAlloc::allocTableBoolValue;
    std::vector<EnumValue *> StmtNodeAlloc::allocTableEnumValue;
    std::vector<CompoundValue *> StmtNodeAlloc::allocTableCompoundValue;
    std::vector<PortOperand *> StmtNodeAlloc::allocTablePortOperand;
    std::vector<UnaryExpr *> StmtNodeAlloc::allocTableUnaryExpr;
    std::vector<SectionOperand *> StmtNodeAlloc::allocTableSectionOperand;
    std::vector<SectionValue *> StmtNodeAlloc::allocTableSectionValue;
    std::vector<Arithmetic *> StmtNodeAlloc::allocTableArithmetic;
    std::vector<Logical *> StmtNodeAlloc::allocTableLogical;
    std::vector<Relational *> StmtNodeAlloc::allocTableRelational;
    std::vector<Bitwise *> StmtNodeAlloc::allocTableBitwise;
    std::vector<SyncSignal *> StmtNodeAlloc::allocTableSyncSignal;
    std::vector<DataSignalOperand *> StmtNodeAlloc::allocTableDataSignalOperand;
    std::vector<Cast *> StmtNodeAlloc::allocTableCast;

    // Stmt node tables
    std::vector<Read *> StmtNodeAlloc::allocTableRead;
    std::vector<Write *> StmtNodeAlloc::allocTableWrite;
    std::vector<ITE *> StmtNodeAlloc::allocTableITE;
    std::vector<Assignment *> StmtNodeAlloc::allocTableAssignment;
    std::vector<While *> StmtNodeAlloc::allocTableWhile;
    std::vector<If *> StmtNodeAlloc::allocTableIf;
    std::vector<FunctionOperand *> StmtNodeAlloc::allocTableFunctionOperand;
    std::vector<ArrayOperand *> StmtNodeAlloc::allocTableSubSelect;
    std::vector<CompoundExpr *> StmtNodeAlloc::allocTableCompoundExpr;
    std::vector<ParamOperand *> StmtNodeAlloc::allocTableParamOperand;
    std::vector<Return *> StmtNodeAlloc::allocTableReturn;

    StmtNodeAlloc::StmtNodeAlloc(Stmt &node, bool simplifyNode) {
        this->allocNodeAddress = nullptr;
        if (simplifyNode) {
            SimplifyVisitor simplifyVisitor(&node);
            if (simplifyVisitor.isNodeSimplified()) {
                this->allocNodeAddress = simplifyVisitor.getSimplifiedNode();
            } else {
                node.accept(*this);
            }
        } else {
            node.accept(*this);
        }
    }

    Stmt *StmtNodeAlloc::getAllocNode() const {
        assert(this->allocNodeAddress != nullptr);
        return this->allocNodeAddress;
    }

    Stmt *StmtNodeAlloc::allocNode(Stmt &node, bool simplifyNode) {
        StmtNodeAlloc nodeAlloc(node, simplifyNode);
        return nodeAlloc.getAllocNode();
    }

    Expr *StmtNodeAlloc::allocNode(Expr &node, bool simplifyNode) {
        StmtNodeAlloc nodeAlloc(node, simplifyNode);
        return (Expr *) nodeAlloc.getAllocNode();
    }

    Branch *StmtNodeAlloc::allocNode(Branch &node, bool simplifyNode) {
        StmtNodeAlloc nodeAlloc(node, simplifyNode);
        return (Branch *) nodeAlloc.getAllocNode();
    }

    ConstValue *StmtNodeAlloc::allocNode(ConstValue &node, bool simplifyNode) {
        StmtNodeAlloc nodeAlloc(node, simplifyNode);
        return (ConstValue *) nodeAlloc.getAllocNode();
    }

    Operand *StmtNodeAlloc::allocNode(Operand &node, bool simplifyNode) {
        StmtNodeAlloc nodeAlloc(node, simplifyNode);
        return (Operand *) nodeAlloc.getAllocNode();
    }

    VariableOperand *StmtNodeAlloc::allocNode(VariableOperand &node, bool simplifyNode) {
        StmtNodeAlloc nodeAlloc(node, simplifyNode);
        return (VariableOperand *) nodeAlloc.getAllocNode();
    }

    TimePointOperand *StmtNodeAlloc::allocNode(TimePointOperand &node, bool simplifyNode) {
        StmtNodeAlloc nodeAlloc(node, simplifyNode);
        return (TimePointOperand *) nodeAlloc.getAllocNode();
    }

    IntegerValue *StmtNodeAlloc::allocNode(IntegerValue &node, bool simplifyNode) {
        StmtNodeAlloc nodeAlloc(node, simplifyNode);
        return (IntegerValue *) nodeAlloc.getAllocNode();
    }

    UnsignedValue *StmtNodeAlloc::allocNode(UnsignedValue &node, bool simplifyNode) {
        StmtNodeAlloc nodeAlloc(node, simplifyNode);
        return (UnsignedValue *) nodeAlloc.getAllocNode();
    }

    BoolValue *StmtNodeAlloc::allocNode(BoolValue &node, bool simplifyNode) {
        StmtNodeAlloc nodeAlloc(node, simplifyNode);
        return (BoolValue *) nodeAlloc.getAllocNode();
    }

    EnumValue *StmtNodeAlloc::allocNode(EnumValue &node, bool simplifyNode) {
        StmtNodeAlloc nodeAlloc(node, simplifyNode);
        return (EnumValue *) nodeAlloc.getAllocNode();
    }

    CompoundValue *StmtNodeAlloc::allocNode(CompoundValue &node, bool simplifyNode) {
        StmtNodeAlloc nodeAlloc(node, simplifyNode);
        return (CompoundValue *) nodeAlloc.getAllocNode();
    }

    PortOperand *StmtNodeAlloc::allocNode(PortOperand &node, bool simplifyNode) {
        StmtNodeAlloc nodeAlloc(node, simplifyNode);
        return (PortOperand *) nodeAlloc.getAllocNode();
    }

    UnaryExpr *StmtNodeAlloc::allocNode(UnaryExpr &node) {
        StmtNodeAlloc nodeAlloc(node, false);
        return (UnaryExpr *) nodeAlloc.getAllocNode();
    }

    SectionOperand *StmtNodeAlloc::allocNode(SectionOperand &node, bool simplifyNode) {
        StmtNodeAlloc nodeAlloc(node, simplifyNode);
        return (SectionOperand *) nodeAlloc.getAllocNode();
    }

    SectionValue *StmtNodeAlloc::allocNode(SectionValue &node, bool simplifyNode) {
        StmtNodeAlloc nodeAlloc(node, simplifyNode);
        return (SectionValue *) nodeAlloc.getAllocNode();
    }

    Arithmetic *StmtNodeAlloc::allocNode(Arithmetic &node) {
        StmtNodeAlloc nodeAlloc(node, false);
        return (Arithmetic *) nodeAlloc.getAllocNode();
    }

    Logical *StmtNodeAlloc::allocNode(Logical &node) {
        StmtNodeAlloc nodeAlloc(node, false);
        return (Logical *) nodeAlloc.getAllocNode();
    }

    Relational *StmtNodeAlloc::allocNode(Relational &node, bool simplifyNode) {
        StmtNodeAlloc nodeAlloc(node, simplifyNode);
        return (Relational *) nodeAlloc.getAllocNode();
    }

    Bitwise *StmtNodeAlloc::allocNode(Bitwise &node) {
        StmtNodeAlloc nodeAlloc(node, false);
        return (Bitwise *) nodeAlloc.getAllocNode();
    }

    SyncSignal *StmtNodeAlloc::allocNode(SyncSignal &node, bool simplifyNode) {
        StmtNodeAlloc nodeAlloc(node, simplifyNode);
        return (SyncSignal *) nodeAlloc.getAllocNode();
    }

    DataSignalOperand *StmtNodeAlloc::allocNode(DataSignalOperand &node, bool simplifyNode) {
        StmtNodeAlloc nodeAlloc(node, simplifyNode);
        return (DataSignalOperand *) nodeAlloc.getAllocNode();
    }

    Cast *StmtNodeAlloc::allocNode(Cast &node) {
        StmtNodeAlloc nodeAlloc(node, false);
        return (Cast *) nodeAlloc.getAllocNode();
    }

    Read *StmtNodeAlloc::allocNode(Read &node, bool simplifyNode) {
        StmtNodeAlloc nodeAlloc(node, simplifyNode);
        return (Read *) nodeAlloc.getAllocNode();
    }

    Write *StmtNodeAlloc::allocNode(Write &node, bool simplifyNode) {
        StmtNodeAlloc nodeAlloc(node, simplifyNode);
        return (Write *) nodeAlloc.getAllocNode();
    }

    ITE *StmtNodeAlloc::allocNode(ITE &node, bool simplifyNode) {
        StmtNodeAlloc nodeAlloc(node, simplifyNode);
        return (ITE *) nodeAlloc.getAllocNode();
    }

    Assignment *StmtNodeAlloc::allocNode(Assignment &node, bool simplifyNode) {
        StmtNodeAlloc nodeAlloc(node, simplifyNode);
        return (Assignment *) nodeAlloc.getAllocNode();
    }

    While *StmtNodeAlloc::allocNode(While &node, bool simplifyNode) {
        StmtNodeAlloc nodeAlloc(node, simplifyNode);
        return (While *) nodeAlloc.getAllocNode();
    }

    If *StmtNodeAlloc::allocNode(If &node, bool simplifyNode) {
        StmtNodeAlloc nodeAlloc(node, simplifyNode);
        return (If *) nodeAlloc.getAllocNode();
    }

    FunctionOperand *StmtNodeAlloc::allocNode(FunctionOperand &node, bool simplifyNode) {
        StmtNodeAlloc nodeAlloc(node, simplifyNode);
        return (FunctionOperand *) nodeAlloc.getAllocNode();
    }

    ArrayOperand *StmtNodeAlloc::allocNode(ArrayOperand &node, bool simplifyNode) {
        StmtNodeAlloc nodeAlloc(node, simplifyNode);
        return (ArrayOperand *) nodeAlloc.getAllocNode();
    }

    CompoundExpr *StmtNodeAlloc::allocNode(CompoundExpr &node, bool simplifyNode) {
        StmtNodeAlloc nodeAlloc(node, simplifyNode);
        return (CompoundExpr *) nodeAlloc.getAllocNode();
    }

    ParamOperand *StmtNodeAlloc::allocNode(ParamOperand &node, bool simplifyNode) {
        StmtNodeAlloc nodeAlloc(node, simplifyNode);
        return (ParamOperand *) nodeAlloc.getAllocNode();
    }

    Return *StmtNodeAlloc::allocNode(Return &node, bool simplifyNode) {
        StmtNodeAlloc nodeAlloc(node, simplifyNode);
        return (Return *) nodeAlloc.getAllocNode();
    }

    void StmtNodeAlloc::visit(class VariableOperand &node) {
        for (auto lookup_it : allocTableVariableOperand) {
            if (*lookup_it == node) {
                this->allocNodeAddress = lookup_it;
                return;
            }
        }
        auto tempPtr = new VariableOperand(node.getVariable());
        allocTableVariableOperand.push_back(tempPtr);
        this->allocNodeAddress = tempPtr;
    }

    void StmtNodeAlloc::visit(class TimePointOperand &node) {
        for (auto lookup_it : allocTableTimeExprOperand) {
            if (*lookup_it == node) {
                this->allocNodeAddress = lookup_it;
                return;
            }
        }
        auto tempPtr = new TimePointOperand(node.getTimepoint());
        allocTableTimeExprOperand.push_back(tempPtr);
        this->allocNodeAddress = tempPtr;
    }

    void StmtNodeAlloc::visit(class IntegerValue &node) {
        for (auto lookup_it : allocTableIntegerValue) {
            if (*lookup_it == node) {
                this->allocNodeAddress = lookup_it;
                return;
            }
        }
        auto tempPtr = new IntegerValue(node.getValue());
        allocTableIntegerValue.push_back(tempPtr);
        this->allocNodeAddress = tempPtr;
    }

    void StmtNodeAlloc::visit(class UnsignedValue &node) {
        for (auto lookup_it : allocTableUnsignedValue) {
            if (*lookup_it == node) {
                this->allocNodeAddress = lookup_it;
                return;
            }
        }
        auto tempPtr = new UnsignedValue(node.getValue());
        allocTableUnsignedValue.push_back(tempPtr);
        this->allocNodeAddress = tempPtr;
    }

    void StmtNodeAlloc::visit(class BoolValue &node) {
        // TODO no need for table, only two values possible
        for (auto lookup_it : allocTableBoolValue) {
            if (*lookup_it == node) {
                this->allocNodeAddress = lookup_it;
                return;
            }
        }
        auto tempPtr = new BoolValue(node.getValue());
        allocTableBoolValue.push_back(tempPtr);
        this->allocNodeAddress = tempPtr;
    }

    void StmtNodeAlloc::visit(class EnumValue &node) {
        for (auto lookup_it : allocTableEnumValue) {
            if (*lookup_it == node) {
                this->allocNodeAddress = lookup_it;
                return;
            }
        }
        auto tempPtr = new EnumValue(node.getEnumValue(), node.getDataType());
        allocTableEnumValue.push_back(tempPtr);
        this->allocNodeAddress = tempPtr;
    }

    void StmtNodeAlloc::visit(class CompoundValue &node) {
        for (auto lookup_it : allocTableCompoundValue) {
            if (*lookup_it == node) {
                this->allocNodeAddress = lookup_it;
                return;
            }
        }
        std::vector<ConstValue *> compoundValues;
        for (auto value_it : node.getValues()) {
            value_it.second->accept(*this);
            compoundValues.push_back((ConstValue *) this->allocNodeAddress);
        }
        auto tempPtr = new CompoundValue(compoundValues, node.getDataType());
        allocTableCompoundValue.push_back(tempPtr);
        this->allocNodeAddress = tempPtr;
    }

    void StmtNodeAlloc::visit(class PortOperand &node) {
        for (auto lookup_it : allocTablePortOperand) {
            if (*lookup_it == node) {
                this->allocNodeAddress = lookup_it;
                return;
            }
        }
        auto tempPtr = new PortOperand(node.getPort());
        allocTablePortOperand.push_back(tempPtr);
        this->allocNodeAddress = tempPtr;
    }

    void StmtNodeAlloc::visit(class UnaryExpr &node) {
        for (auto lookup_it : allocTableUnaryExpr) {
            if (*lookup_it == node) {
                this->allocNodeAddress = lookup_it;
                return;
            }
        }
        node.getExpr()->accept(*this);
        auto tempPtr = new UnaryExpr(node.getOperation(), (Expr *) this->allocNodeAddress);
        allocTableUnaryExpr.push_back(tempPtr);
        this->allocNodeAddress = tempPtr;
    }

    void StmtNodeAlloc::visit(class SectionOperand &node) {
        for (auto lookup_it : allocTableSectionOperand) {
            if (*lookup_it == node) {
                this->allocNodeAddress = lookup_it;
                return;
            }
        }
        auto tempPtr = new SectionOperand(node.getSectionVariable());
        allocTableSectionOperand.push_back(tempPtr);
        this->allocNodeAddress = tempPtr;
    }

    void StmtNodeAlloc::visit(class SectionValue &node) {
        for (auto lookup_it : allocTableSectionValue) {
            if (*lookup_it == node) {
                this->allocNodeAddress = lookup_it;
                return;
            }
        }
        auto tempPtr = new SectionValue(node.getValueAsString(), node.getDataType());
        allocTableSectionValue.push_back(tempPtr);
        this->allocNodeAddress = tempPtr;
    }

    void StmtNodeAlloc::visit(class Arithmetic &node) {
        for (auto lookup_it : allocTableArithmetic) {
            if (*lookup_it == node) {
                this->allocNodeAddress = lookup_it;
                return;
            }
        }
        node.getLhs()->accept(*this);
        auto relocatedNodeAddressLhs = (Expr *) this->allocNodeAddress;
        node.getRhs()->accept(*this);
        auto relocatedNodeAddressRhs = (Expr *) this->allocNodeAddress;
        auto tempPtr = new Arithmetic(relocatedNodeAddressLhs, node.getOperation(), relocatedNodeAddressRhs);
        allocTableArithmetic.push_back(tempPtr);
        this->allocNodeAddress = tempPtr;
    }

    void StmtNodeAlloc::visit(class Logical &node) {
        for (auto lookup_it : allocTableLogical) {
            if (*lookup_it == node) {
                this->allocNodeAddress = lookup_it;
                return;
            }
        }
        node.getLhs()->accept(*this);
        auto relocatedNodeAddressLhs = (Expr *) this->allocNodeAddress;
        node.getRhs()->accept(*this);
        auto relocatedNodeAddressRhs = (Expr *) this->allocNodeAddress;
        auto tempPtr = new Logical(relocatedNodeAddressLhs, node.getOperation(), relocatedNodeAddressRhs);
        allocTableLogical.push_back(tempPtr);
        this->allocNodeAddress = tempPtr;
    }

    void StmtNodeAlloc::visit(class Relational &node) {
        for (auto lookup_it : allocTableRelational) {
            if (*lookup_it == node) {
                this->allocNodeAddress = lookup_it;
                return;
            }
        }
        node.getLhs()->accept(*this);
        auto relocatedNodeAddressLhs = (Expr *) this->allocNodeAddress;
        node.getRhs()->accept(*this);
        auto relocatedNodeAddressRhs = (Expr *) this->allocNodeAddress;
        auto tempPtr = new Relational(relocatedNodeAddressLhs, node.getOperation(), relocatedNodeAddressRhs);
        allocTableRelational.push_back(tempPtr);
        this->allocNodeAddress = tempPtr;
    }

    void StmtNodeAlloc::visit(class Bitwise &node) {
        for (auto lookup_it : allocTableBitwise) {
            if (*lookup_it == node) {
                this->allocNodeAddress = lookup_it;
                return;
            }
        }
        node.getLhs()->accept(*this);
        auto relocatedNodeAddressLhs = (Expr *) this->allocNodeAddress;
        node.getRhs()->accept(*this);
        auto relocatedNodeAddressRhs = (Expr *) this->allocNodeAddress;
        auto tempPtr = new Bitwise(relocatedNodeAddressLhs, node.getOperation(), relocatedNodeAddressRhs);
        allocTableBitwise.push_back(tempPtr);
        this->allocNodeAddress = tempPtr;
    }

    void StmtNodeAlloc::visit(class SyncSignal &node) {
        for (auto lookup_it : allocTableSyncSignal) {
            if (*lookup_it == node) {
                this->allocNodeAddress = lookup_it;
                return;
            }
        }
        auto tempPtr = new SyncSignal(node.getPort());
        allocTableSyncSignal.push_back(tempPtr);
        this->allocNodeAddress = tempPtr;
    }

    void StmtNodeAlloc::visit(class DataSignalOperand &node) {
        for (auto lookup_it : allocTableDataSignalOperand) {
            if (*lookup_it == node) {
                this->allocNodeAddress = lookup_it;
                return;
            }
        }
        auto tempPtr = new DataSignalOperand(node.getDataSignal());
        allocTableDataSignalOperand.push_back(tempPtr);
        this->allocNodeAddress = tempPtr;
    }

    void StmtNodeAlloc::visit(class Cast &node) {
        for (auto lookup_it : allocTableCast) {
            if (*lookup_it == node) {
                this->allocNodeAddress = lookup_it;
                return;
            }
        }
        node.getSubExpr()->accept(*this);
        auto tempPtr = new Cast((Expr *) this->allocNodeAddress, node.getDataType());
        allocTableCast.push_back(tempPtr);
        this->allocNodeAddress = tempPtr;
    }

    void StmtNodeAlloc::visit(class Read &node) {
        for (auto lookup_it : allocTableRead) {
            if (*lookup_it == node) {
                this->allocNodeAddress = lookup_it;
                return;
            }
        }
        node.getVariableOperand()->accept(*this); //FIXME: shouldn't this be included
        auto *tempVar = (VariableOperand *) this->allocNodeAddress;
        auto *tempStatus = node.getStatusOperand();
        if (node.getStatusOperand() != nullptr) {
            node.getStatusOperand()->accept(*this);
            tempStatus = (VariableOperand *) this->allocNodeAddress;
        }

        Read *tempPtr = new Read(node.getPort(), tempVar, node.isNonBlockingAccess(), tempStatus);
//        Read* tempPtr;
//        if(!node.isNonBlockingAccess() || (node.isNonBlockingAccess() && (node.getStatusOperand() == nullptr) ) )
//            tempPtr = new Read(node.getPort(), tempVar, node.isNonBlockingAccess());
//        else {
//            node.getStatusOperand()->accept(*this);
//            tempPtr = new Read(node.getPort(), tempVar, (VariableOperand*) this->allocNodeAddress);
//        }
        allocTableRead.push_back(tempPtr);
        this->allocNodeAddress = tempPtr;
    }

    void StmtNodeAlloc::visit(class Write &node) {
        for (auto lookup_it : allocTableWrite) {
            if (*lookup_it == node) {
                this->allocNodeAddress = lookup_it;
                return;
            }
        }
        node.getValue()->accept(*this);
        auto *tempValue = (Expr *) this->allocNodeAddress;
        auto *tempStatus = node.getStatusOperand();
        if (node.getStatusOperand() != nullptr) {
            node.getStatusOperand()->accept(*this);
            tempStatus = (VariableOperand *) this->allocNodeAddress;
        }

        Write *tempPtr = new Write(node.getPort(), tempValue, node.isNonBlockingAccess(), tempStatus);
//        Write* tempPtr;
//        if(!node.isNonBlockingAccess() || (node.isNonBlockingAccess() && (node.getStatusOperand() == nullptr) ) ) {
//            tempPtr = new Write(node.getPort(), tempValue, node.isNonBlockingAccess());
//        } else {
//            node.getStatusOperand()->accept(*this);
//            tempPtr = new Write(node.getPort(), tempValue, true, (VariableOperand*) this->allocNodeAddress);
//        }
        allocTableWrite.push_back(tempPtr);
        this->allocNodeAddress = tempPtr;
    }

    void StmtNodeAlloc::visit(class ITE &node) {
        for (auto lookup_it : allocTableITE) {
            if (*lookup_it == node) {
                this->allocNodeAddress = lookup_it;
                return;
            }
        }
        node.getConditionStmt()->accept(*this);
        auto tempPtr = new ITE((Expr *) this->allocNodeAddress);
        for (auto ifList_it : node.getIfList()) {
            ifList_it->accept(*this);
            tempPtr->addIfList(this->allocNodeAddress);
        }
        for (auto elseList_it : node.getElseList()) {
            elseList_it->accept(*this);
            tempPtr->addElseList(this->allocNodeAddress);
        }
        allocTableITE.push_back(tempPtr);
        this->allocNodeAddress = tempPtr;
    }

    void StmtNodeAlloc::visit(class Assignment &node) {
        for (auto lookup_it : allocTableAssignment) {
            if (*lookup_it == node) {
                this->allocNodeAddress = lookup_it;
                return;
            }
        }
        node.getLhs()->accept(*this);
        auto relocatedNodeAddressLhs = (Expr *) this->allocNodeAddress;
        node.getRhs()->accept(*this);
        auto relocatedNodeAddressRhs = (Expr *) this->allocNodeAddress;
        auto tempPtr = new Assignment(relocatedNodeAddressLhs, relocatedNodeAddressRhs);
        allocTableAssignment.push_back(tempPtr);
        this->allocNodeAddress = tempPtr;
    }

    void StmtNodeAlloc::visit(class While &node) {
        for (auto lookup_it : allocTableWhile) {
            if (*lookup_it == node) {
                this->allocNodeAddress = lookup_it;
                return;
            }
        }
        node.getConditionStmt()->accept(*this);
        auto tempPtr = new While((Expr *) this->allocNodeAddress);
        allocTableWhile.push_back(tempPtr);
        this->allocNodeAddress = tempPtr;
    }

    void StmtNodeAlloc::visit(class If &node) {
        for (auto lookup_it : allocTableIf) {
            if (*lookup_it == node) {
                this->allocNodeAddress = lookup_it;
                return;
            }
        }
        node.getConditionStmt()->accept(*this);
        auto tempPtr = new If((Expr *) this->allocNodeAddress);
        allocTableIf.push_back(tempPtr);
        this->allocNodeAddress = tempPtr;
    }

    void StmtNodeAlloc::visit(class FunctionOperand &node) {
        for (auto lookup_it : allocTableFunctionOperand) {
            if (*lookup_it == node) {
                this->allocNodeAddress = lookup_it;
                return;
            }
        }
        auto tempPtr = new FunctionOperand(node.getFunction(), node.getParamValueMap());
        allocTableFunctionOperand.push_back(tempPtr);
        this->allocNodeAddress = tempPtr;
    }

    void StmtNodeAlloc::visit(class ArrayOperand &node) {
        throw std::runtime_error("Not implemented");
//        for (auto lookup_it : allocTableSubSelect) {
//            if (*lookup_it == node) {
//                this->allocNodeAddress = lookup_it;
//                return;
//            }
//        }
//        auto tempPtr = new ArrayOperand(node.getOperand(), node.getSub());
//        allocTableSubSelect.push_back(tempPtr);
//        this->allocNodeAddress = tempPtr;
    }

    void StmtNodeAlloc::visit(class CompoundExpr &node) {
        for (auto lookup_it : allocTableCompoundExpr) {
            if (*lookup_it == node) {
                this->allocNodeAddress = lookup_it;
                return;
            }
        }
        auto tempPtr = new CompoundExpr(node.getValueMap(), node.getDataType());
        allocTableCompoundExpr.push_back(tempPtr);
        this->allocNodeAddress = tempPtr;
    }


    CompareOperator *StmtNodeAlloc::allocNode(CompareOperator &node, bool simplifyNode) {
        throw std::runtime_error("StmtNodeAlloc::visit: CompareOperator not implemented");
    }


    void StmtNodeAlloc::visit(class ArrayExpr &node) {
            throw std::runtime_error("Not implemented");
    }

    void StmtNodeAlloc::visit(class ParamOperand &node) {
        for (auto lookup_it : allocTableParamOperand) {
            if (*lookup_it == node) {
                this->allocNodeAddress = lookup_it;
                return;
            }
        }
        auto tempPtr = new ParamOperand(node.getParameter());
        allocTableParamOperand.push_back(tempPtr);
        this->allocNodeAddress = tempPtr;
    }

    void StmtNodeAlloc::visit(class Return &node) {
        for (auto lookup_it : allocTableReturn) {
            if (*lookup_it == node) {
                this->allocNodeAddress = lookup_it;
                return;
            }
        }
        node.getReturnValue()->accept(*this);
        auto tempPtr = new Return(node.getReturnValue());
        allocTableReturn.push_back(tempPtr);
        this->allocNodeAddress = tempPtr;
    }

    void StmtNodeAlloc::visit(class Notify &node) {
        throw std::runtime_error("Not implemented");

    }

    Wait *StmtNodeAlloc::allocNode(Wait &node, bool simplifyNode) {
        //TODO: implement StmtNodeAlloc
        throw std::runtime_error("Not implemented");
    }

    void StmtNodeAlloc::visit(class Wait &node) {
        throw std::runtime_error("Not implemented");
    }

    Peek *StmtNodeAlloc::allocNode(Peek &node, bool simplifyNode) {
        //TODO: implement StmtNodeAlloc
        throw std::runtime_error("StmtNodeAlloc::allocNode: Peek not implemented");
    }

    void StmtNodeAlloc::visit(class Peek &node) {
        throw std::runtime_error("StmtNodeAlloc::visit: Peek not implemented");
    }

    ArrayExpr *StmtNodeAlloc::allocNode(ArrayExpr &node, bool simplifyNode) {
        throw std::runtime_error("StmtNodeAlloc::visit: ArrayExpr not implemented");
    }

    void StmtNodeAlloc::visit(class CompareOperator &node) {
        throw std::runtime_error("StmtNodeAlloc::visit: CompareOperator not implemented");
    }


}


