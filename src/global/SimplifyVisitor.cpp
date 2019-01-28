//
// Created by pmorku on 19.06.18.
//

#include <ExprVisitor.h>
#include "SimplifyVisitor.h"
#include "NodePeekVisitor.h"
#include "StmtNodeAlloc.h"

namespace SCAM {

    SimplifyVisitor::SimplifyVisitor(Stmt *node) : nodePointer(node) {
        Stmt *tempNodePointer;
        // TODO loop is most likely not needed, left it just in case there is recursive pattern that I didn't cover
        do {
            tempNodePointer = nodePointer;
            nodePointer->accept(*this);
            if (tempNodePointer != nodePointer) {
                nodeSimplified = true;
            }
        } while (tempNodePointer != nodePointer);
    }

    Stmt *SimplifyVisitor::getSimplifiedNode() const {
        return nodePointer;
    }

    bool SimplifyVisitor::isNodeSimplified() const {
        return nodeSimplified;
    }

    void SimplifyVisitor::visit(class UnaryExpr &node) {
        bool localNodeUpdated = false;

        SimplifyVisitor simplifyVisitor(node.getExpr());
        if (node.getOperation() == "-") {
            NodePeekVisitor nodePeek(simplifyVisitor.getSimplifiedNode());
            if (nodePeek.nodePeekUnsignedValue() && (nodePeek.nodePeekUnsignedValue()->getValue() == 0)) {
                UnsignedValue newUnsignedValueNode(0);
                StmtNodeAlloc stmtNodeAlloc(newUnsignedValueNode, false);
                nodePointer = stmtNodeAlloc.getAllocNode();
                localNodeUpdated = true;
            } else if (nodePeek.nodePeekUnaryExpr() && (nodePeek.nodePeekUnaryExpr()->getOperation() == "-")) {
                nodePointer = nodePeek.nodePeekUnaryExpr()->getExpr();
                localNodeUpdated = true;
            }
        }

        if (node.getOperation() == "not") {
            NodePeekVisitor nodePeek(simplifyVisitor.getSimplifiedNode());
            if (nodePeek.nodePeekUnaryExpr() && nodePeek.nodePeekUnaryExpr()->getOperation() == "not") {
                nodePointer = nodePeek.nodePeekUnaryExpr()->getExpr();
                localNodeUpdated = true;
            }
        }

        if (!localNodeUpdated) {
            if (simplifyVisitor.isNodeSimplified()) {
                UnaryExpr newUnaryExpr(node.getOperation(), (Expr *) simplifyVisitor.getSimplifiedNode());
                StmtNodeAlloc stmtNodeAlloc(newUnaryExpr, false);
                nodePointer = stmtNodeAlloc.getAllocNode();
            }
        }
    }

    void SimplifyVisitor::visit(class Arithmetic &node) {
        bool localNodeUpdated = false;

        SimplifyVisitor simplifyVisitorLhs(node.getLhs());
        SimplifyVisitor simplifyVisitorRhs(node.getRhs());

        assert(((Expr *) simplifyVisitorLhs.getSimplifiedNode())->getDataType() ==
               ((Expr *) simplifyVisitorRhs.getSimplifiedNode())->getDataType());

        NodePeekVisitor nodePeekLhs(simplifyVisitorLhs.getSimplifiedNode());
        NodePeekVisitor nodePeekRhs(simplifyVisitorRhs.getSimplifiedNode());

        if (nodePeekLhs.isConstTypeNode() && nodePeekRhs.isConstTypeNode()) {
            if (nodePeekLhs.nodePeekUnsignedValue() && nodePeekRhs.nodePeekUnsignedValue()) {
                unsigned int result;
                unsigned int lhs = nodePeekLhs.nodePeekUnsignedValue()->getValue();
                unsigned int rhs = nodePeekRhs.nodePeekUnsignedValue()->getValue();
                if (node.getOperation() == "+") {
                    result = lhs + rhs;
                } else if (node.getOperation() == "-") {
                    result = lhs - rhs;
                } else if (node.getOperation() == "*") {
                    result = lhs * rhs;
                } else if (node.getOperation() == "/") {
                    result = lhs / rhs;
                } else if (node.getOperation() == "%") {
                    result = lhs % rhs;
                } else {
                    throw std::runtime_error("Arithmetic: unimplemented operator");
                }
                UnsignedValue newUnsignedValueNode(result);
                StmtNodeAlloc stmtNodeAlloc(newUnsignedValueNode, false);
                nodePointer = stmtNodeAlloc.getAllocNode();
                localNodeUpdated = true;
            } else if (nodePeekLhs.nodePeekIntegerValue() && nodePeekRhs.nodePeekIntegerValue()) {
                int result;
                int lhs = nodePeekLhs.nodePeekIntegerValue()->getValue();
                int rhs = nodePeekRhs.nodePeekIntegerValue()->getValue();
                if (node.getOperation() == "+") {
                    result = lhs + rhs;
                } else if (node.getOperation() == "-") {
                    result = lhs - rhs;
                } else if (node.getOperation() == "*") {
                    result = lhs * rhs;
                } else if (node.getOperation() == "/") {
                    result = lhs / rhs;
                } else if (node.getOperation() == "%") {
                    result = lhs % rhs;
                } else {
                    throw std::runtime_error("Arithmetic: unimplemented operator");
                }
                IntegerValue newIntegerValueNode(result);
                StmtNodeAlloc stmtNodeAlloc(newIntegerValueNode, false);
                nodePointer = stmtNodeAlloc.getAllocNode();
                localNodeUpdated = true;
            }
        } else if (node.getOperation() == "+") {
            if ((nodePeekLhs.nodePeekUnsignedValue() && (nodePeekLhs.nodePeekUnsignedValue()->getValue() == 0)) ||
                (nodePeekLhs.nodePeekIntegerValue() && (nodePeekLhs.nodePeekIntegerValue()->getValue() == 0))) {
                // (0 + var) = var
                nodePointer = simplifyVisitorRhs.getSimplifiedNode();
                localNodeUpdated = true;
            } else if ((nodePeekRhs.nodePeekUnsignedValue() &&
                        (nodePeekRhs.nodePeekUnsignedValue()->getValue() == 0)) ||
                       (nodePeekRhs.nodePeekIntegerValue() &&
                        (nodePeekRhs.nodePeekIntegerValue()->getValue() == 0))) {
                // (var + 0) = var
                nodePointer = simplifyVisitorLhs.getSimplifiedNode();
                localNodeUpdated = true;
            } else if (!(nodePeekLhs.nodePeekUnaryExpr() && (nodePeekLhs.nodePeekUnaryExpr()->getOperation() == "-")) &&
                       nodePeekRhs.nodePeekUnaryExpr() && (nodePeekRhs.nodePeekUnaryExpr()->getOperation() == "-")) {
                // (var1 + -var2) = var1 - var2
                Arithmetic newArithmetic((Expr *) simplifyVisitorLhs.getSimplifiedNode(), "-",
                                         nodePeekRhs.nodePeekUnaryExpr()->getExpr());
                StmtNodeAlloc stmtNodeAlloc(newArithmetic, false);
                nodePointer = stmtNodeAlloc.getAllocNode();
                localNodeUpdated = true;
            } else if (nodePeekLhs.nodePeekUnaryExpr() &&
                       (nodePeekLhs.nodePeekUnaryExpr()->getOperation() == "-") &&
                       !(nodePeekRhs.nodePeekUnaryExpr() &&
                         (nodePeekRhs.nodePeekUnaryExpr()->getOperation() == "-"))) {
                // (-var1 + var2) = var2 - var1
                Arithmetic newArithmetic((Expr *) simplifyVisitorRhs.getSimplifiedNode(), "-",
                                         nodePeekLhs.nodePeekUnaryExpr()->getExpr());
                StmtNodeAlloc stmtNodeAlloc(newArithmetic, false);
                nodePointer = stmtNodeAlloc.getAllocNode();
                localNodeUpdated = true;
            } else if (nodePeekLhs.nodePeekUnaryExpr() &&
                       (nodePeekLhs.nodePeekUnaryExpr()->getOperation() == "-") &&
                       nodePeekRhs.nodePeekUnaryExpr() &&
                       (nodePeekRhs.nodePeekUnaryExpr()->getOperation() == "-")) {
                // (-var1 + -var2) = -var1 - var2
                Arithmetic newArithmetic((Expr *) simplifyVisitorLhs.getSimplifiedNode(), "-",
                                         nodePeekRhs.nodePeekUnaryExpr()->getExpr());
                StmtNodeAlloc stmtNodeAlloc(newArithmetic, false);
                nodePointer = stmtNodeAlloc.getAllocNode();
                localNodeUpdated = true;
            }
        } else if (node.getOperation() == "*") {
            if ((nodePeekLhs.nodePeekUnsignedValue() && (nodePeekLhs.nodePeekUnsignedValue()->getValue() == 0)) ||
                (nodePeekRhs.nodePeekUnsignedValue() && (nodePeekRhs.nodePeekUnsignedValue()->getValue() == 0))) {
                // (var * 0) = 0 or (0 * var) = 0
                UnsignedValue newUnsignedValueNode(0);
                StmtNodeAlloc stmtNodeAlloc(newUnsignedValueNode, false);
                nodePointer = stmtNodeAlloc.getAllocNode();
                localNodeUpdated = true;
            } else if (nodePeekLhs.nodePeekUnaryExpr() && (nodePeekLhs.nodePeekUnaryExpr()->getOperation() == "-") &&
                       nodePeekRhs.nodePeekUnaryExpr() && (nodePeekRhs.nodePeekUnaryExpr()->getOperation() == "-")) {
                // (-var1 * -var2) = var1 * var2
                Arithmetic newArithmetic(nodePeekLhs.nodePeekUnaryExpr()->getExpr(), "*",
                                         nodePeekRhs.nodePeekUnaryExpr()->getExpr());
                StmtNodeAlloc stmtNodeAlloc(newArithmetic, false);
                nodePointer = stmtNodeAlloc.getAllocNode();
                localNodeUpdated = true;
            } else if (nodePeekLhs.nodePeekUnsignedValue() &&
                       (nodePeekLhs.nodePeekUnsignedValue()->getValue() == (unsigned int) (-1))) {
                if (nodePeekRhs.nodePeekUnaryExpr() && (nodePeekRhs.nodePeekUnaryExpr()->getOperation() == "-")) {
                    // (-1 * -var) = var
                    nodePointer = nodePeekRhs.nodePeekUnaryExpr()->getExpr();
                } else {
                    // (-1 * var) = -var
                    UnaryExpr newUnaryExpr("-", (Expr *) simplifyVisitorRhs.getSimplifiedNode());
                    StmtNodeAlloc stmtNodeAlloc(newUnaryExpr, false);
                    nodePointer = stmtNodeAlloc.getAllocNode();
                }
                localNodeUpdated = true;
            } else if (nodePeekRhs.nodePeekUnsignedValue() &&
                       (nodePeekRhs.nodePeekUnsignedValue()->getValue() == (unsigned int) (-1))) {
                if (nodePeekLhs.nodePeekUnaryExpr() && (nodePeekLhs.nodePeekUnaryExpr()->getOperation() == "-")) {
                    // (-var * -1) = var
                    nodePointer = nodePeekLhs.nodePeekUnaryExpr()->getExpr();
                } else {
                    // (var * -1) = -var
                    UnaryExpr newUnaryExpr("-", (Expr *) simplifyVisitorRhs.getSimplifiedNode());
                    StmtNodeAlloc stmtNodeAlloc(newUnaryExpr, false);
                    nodePointer = stmtNodeAlloc.getAllocNode();
                }
                localNodeUpdated = true;
            }
        }

        if (!localNodeUpdated) {
            // Check if unimplemented optimization cases ever happen
            if (ExprVisitor::isConstVal((Expr *) simplifyVisitorLhs.getSimplifiedNode()) &&
                ExprVisitor::isConstVal((Expr *) simplifyVisitorRhs.getSimplifiedNode())) {
                throw std::runtime_error("Potential optimization case found for SimplifyVisitor in Arithmetic");
            }

            if (simplifyVisitorLhs.isNodeSimplified() || simplifyVisitorRhs.isNodeSimplified()) {
                Arithmetic newArithmetic((Expr *) simplifyVisitorLhs.getSimplifiedNode(), node.getOperation(),
                                         (Expr *) simplifyVisitorRhs.getSimplifiedNode());
                StmtNodeAlloc stmtNodeAlloc(newArithmetic, false);
                nodePointer = stmtNodeAlloc.getAllocNode();
            }
        }
    }

    void SimplifyVisitor::visit(class Bitwise &node) {
        bool localNodeUpdated = false;

        SimplifyVisitor simplifyVisitorLhs(node.getLhs());
        SimplifyVisitor simplifyVisitorRhs(node.getRhs());

        assert(((Expr *) simplifyVisitorLhs.getSimplifiedNode())->getDataType() ==
               ((Expr *) simplifyVisitorRhs.getSimplifiedNode())->getDataType());

        NodePeekVisitor nodePeekRhs(simplifyVisitorRhs.getSimplifiedNode());
        NodePeekVisitor nodePeekLhs(simplifyVisitorLhs.getSimplifiedNode());
        if (nodePeekLhs.isConstTypeNode() && nodePeekRhs.isConstTypeNode()) {
            if (nodePeekLhs.nodePeekUnsignedValue() && nodePeekRhs.nodePeekUnsignedValue()) {
                unsigned int result;
                unsigned int lhs = nodePeekLhs.nodePeekUnsignedValue()->getValue();
                unsigned int rhs = nodePeekRhs.nodePeekUnsignedValue()->getValue();
                if (node.getOperation() == "&") {
                    result = lhs & rhs;
                } else if (node.getOperation() == "|") {
                    result = lhs | rhs;
                } else if (node.getOperation() == "<<") {
                    result = lhs << rhs;
                } else if (node.getOperation() == ">>") {
                    result = lhs >> rhs;
                } else if (node.getOperation() == "^") {
                    result = lhs ^ rhs;
                } else {
                    throw std::runtime_error("Bitwise: unimplemented operator");
                }
                UnsignedValue newUnsignedValueNode(result);
                StmtNodeAlloc stmtNodeAlloc(newUnsignedValueNode, false);
                nodePointer = stmtNodeAlloc.getAllocNode();
                localNodeUpdated = true;
            } else if (nodePeekLhs.nodePeekIntegerValue() && nodePeekRhs.nodePeekIntegerValue()) {
                int result;
                int lhs = nodePeekLhs.nodePeekIntegerValue()->getValue();
                int rhs = nodePeekRhs.nodePeekIntegerValue()->getValue();
                if (node.getOperation() == "&") {
                    result = lhs & rhs;
                } else if (node.getOperation() == "|") {
                    result = lhs | rhs;
                } else if (node.getOperation() == "<<") {
                    result = lhs << rhs;
                } else if (node.getOperation() == ">>") {
                    result = lhs >> rhs;
                } else if (node.getOperation() == "^") {
                    result = lhs ^ rhs;
                } else {
                    throw std::runtime_error("Bitwise: unimplemented operator");
                }
                IntegerValue newIntegerValueNode(result);
                StmtNodeAlloc stmtNodeAlloc(newIntegerValueNode, false);
                nodePointer = stmtNodeAlloc.getAllocNode();
                localNodeUpdated = true;
            }
        } else if ((node.getOperation() == "<<") || (node.getOperation() == ">>")) {
            if ((nodePeekLhs.nodePeekUnsignedValue() && (nodePeekLhs.nodePeekUnsignedValue()->getValue() == 0)) ||
                (nodePeekLhs.nodePeekIntegerValue() && (nodePeekLhs.nodePeekIntegerValue()->getValue() == 0))) {
                // (0 << var) = 0 or (0 >> var) = 0
                nodePointer = simplifyVisitorLhs.getSimplifiedNode();
                localNodeUpdated = true;
            } else if (
                    (nodePeekRhs.nodePeekUnsignedValue() && (nodePeekRhs.nodePeekUnsignedValue()->getValue() == 0)) ||
                    (nodePeekRhs.nodePeekIntegerValue() && (nodePeekRhs.nodePeekIntegerValue()->getValue() == 0))) {
                // (var << 0) or (var >> 0)
                nodePointer = simplifyVisitorLhs.getSimplifiedNode();
                localNodeUpdated = true;
            } else if (nodePeekRhs.nodePeekIntegerValue() && (nodePeekRhs.nodePeekIntegerValue()->getValue() < 0)) {
                // (var << neg_val) or (var >> neg_val)
                Bitwise bitwise((Expr *) simplifyVisitorLhs.getSimplifiedNode(), node.getOperation(),
                                (Expr *) simplifyVisitorRhs.getSimplifiedNode());
                throw std::runtime_error("Potential optimization case found for SimplifyVisitor in Bitwise:\n" +
                                         PrintStmt::toString(&bitwise));
            }
        } else if ((node.getOperation() == "|") || (node.getOperation() == "&")) {
            // Simplify expression using De Morgan's rule
            if (nodePeekLhs.nodePeekUnaryExpr() && (nodePeekLhs.nodePeekUnaryExpr()->getOperation() == "not") &&
                nodePeekRhs.nodePeekUnaryExpr() && (nodePeekRhs.nodePeekUnaryExpr()->getOperation() == "not")) {

                Bitwise newBitwise(nodePeekLhs.nodePeekUnaryExpr()->getExpr(), (node.getOperation() == "|") ? "&" : "|",
                                   nodePeekRhs.nodePeekUnaryExpr()->getExpr());
                UnaryExpr newUnaryExpr("not", &newBitwise);
                StmtNodeAlloc stmtNodeAlloc(newUnaryExpr, false);
                nodePointer = stmtNodeAlloc.getAllocNode();
                localNodeUpdated = true;
            }
        }

        if (!localNodeUpdated) {
            // Check if unimplemented optimization cases ever happen
            if (ExprVisitor::isConstVal((Expr *) simplifyVisitorLhs.getSimplifiedNode()) &&
                ExprVisitor::isConstVal((Expr *) simplifyVisitorRhs.getSimplifiedNode())) {
                Bitwise bitwise((Expr *) simplifyVisitorLhs.getSimplifiedNode(), node.getOperation(),
                                (Expr *) simplifyVisitorRhs.getSimplifiedNode());
                throw std::runtime_error("Potential optimization case found for SimplifyVisitor in Bitwise:\n" +
                                         PrintStmt::toString(&bitwise));
            }

            if (simplifyVisitorLhs.isNodeSimplified() || simplifyVisitorRhs.isNodeSimplified()) {
                Bitwise newBitwise((Expr *) simplifyVisitorLhs.getSimplifiedNode(), node.getOperation(),
                                   (Expr *) simplifyVisitorRhs.getSimplifiedNode());
                StmtNodeAlloc stmtNodeAlloc(newBitwise, false);
                nodePointer = stmtNodeAlloc.getAllocNode();
            }
        }
    }

    void SimplifyVisitor::visit(class Assignment &node) {
        SimplifyVisitor simplifyVisitorRhs(node.getRhs());
        if (simplifyVisitorRhs.isNodeSimplified()) {
            Assignment newAssignment(node.getLhs(), (Expr *) simplifyVisitorRhs.getSimplifiedNode());
            StmtNodeAlloc stmtNodeAlloc(newAssignment, false);
            nodePointer = stmtNodeAlloc.getAllocNode();
        }
    }

    void SimplifyVisitor::visit(class Cast &node) {
        bool localNodeUpdated = false;

        SimplifyVisitor simplifyVisitor(node.getSubExpr());
        NodePeekVisitor nodePeek(simplifyVisitor.getSimplifiedNode());

        if ((node.getDataType()->getName() == "unsigned") && nodePeek.nodePeekIntegerValue()) {
            // to_unsigned(signed_const) = unsigned_const
            UnsignedValue newUnsignedValueNode((unsigned int) nodePeek.nodePeekIntegerValue()->getValue());
            StmtNodeAlloc stmtNodeAlloc(newUnsignedValueNode, false);
            nodePointer = stmtNodeAlloc.getAllocNode();
            localNodeUpdated = true;
        } else if ((node.getDataType()->getName() == "int") && nodePeek.nodePeekUnsignedValue()) {
            // to_signed(unsigned_const) = signed_const
            IntegerValue newIntegerValueNode((int) nodePeek.nodePeekUnsignedValue()->getValue());
            StmtNodeAlloc stmtNodeAlloc(newIntegerValueNode, false);
            nodePointer = stmtNodeAlloc.getAllocNode();
            localNodeUpdated = true;
        } else if (nodePeek.nodePeekCast() &&
                   (nodePeek.nodePeekCast()->getSubExpr()->getDataType() == node.getDataType())) {
            // to_signed(to_unsigned(signed_var)) = signed_var or to_unsigned(to_signed(unsigned_var)) = unsigned_var
            nodePointer = nodePeek.nodePeekCast()->getSubExpr();
            localNodeUpdated = true;
        }

        if (!localNodeUpdated) {
            if (simplifyVisitor.isNodeSimplified()) {
                if (node.getDataType() == ((Expr *) simplifyVisitor.getSimplifiedNode())->getDataType()) {
                    nodePointer = simplifyVisitor.getSimplifiedNode();
                } else {
                    Cast newCast((Expr *) simplifyVisitor.getSimplifiedNode(), node.getDataType());
                    StmtNodeAlloc stmtNodeAlloc(newCast, false);
                    nodePointer = stmtNodeAlloc.getAllocNode();
                }
            }
        }
    }

    void SimplifyVisitor::visit(class UnsignedValue &node) {

    }

    void SimplifyVisitor::visit(class VariableOperand &node) {

    }

    void SimplifyVisitor::visit(class IntegerValue &node) {

    }

    void SimplifyVisitor::visit(class BoolValue &node) {

    }

    void SimplifyVisitor::visit(class EnumValue &node) {

    }

    void SimplifyVisitor::visit(class CompoundValue &node) {

    }

    void SimplifyVisitor::visit(class PortOperand &node) {

    }

    void SimplifyVisitor::visit(class While &node) {

    }

    void SimplifyVisitor::visit(class If &node) {

    }

    void SimplifyVisitor::visit(class SectionOperand &node) {

    }

    void SimplifyVisitor::visit(class SectionValue &node) {

    }

    void SimplifyVisitor::visit(class ITE &node) {

    }

    void SimplifyVisitor::visit(class Logical &node) {
        // TODO: Simplify expression using De Morgan's rule

    }

    void SimplifyVisitor::visit(class Relational &node) {

    }

    void SimplifyVisitor::visit(class Read &node) {

    }

    void SimplifyVisitor::visit(class Write &node) {

    }

    void SimplifyVisitor::visit(class NBRead &node) {

    }

    void SimplifyVisitor::visit(class NBWrite &node) {

    }

    void SimplifyVisitor::visit(class SyncSignal &node) {

    }

    void SimplifyVisitor::visit(class DataSignalOperand &node) {

    }

    void SimplifyVisitor::visit(class FunctionOperand &node) {

    }

    void SimplifyVisitor::visit(class SubSelect &node) {

    }

    void SimplifyVisitor::visit(class CompoundExpr &node) {

    }

    void SimplifyVisitor::visit(class ParamOperand &node) {

    }

    void SimplifyVisitor::visit(class Return &node) {

    }

    Stmt *SimplifyVisitor::simplifyNode(Stmt &node) {
        SimplifyVisitor simplifyVisitor(&node);
        return simplifyVisitor.getSimplifiedNode();
    }

    Expr *SimplifyVisitor::simplifyNode(Expr &node) {
        SimplifyVisitor simplifyVisitor(&node);
        return (Expr *) simplifyVisitor.getSimplifiedNode();
    }

    Branch *SimplifyVisitor::simplifyNode(Branch &node) {
        SimplifyVisitor simplifyVisitor(&node);
        return (Branch *) simplifyVisitor.getSimplifiedNode();
    }

    ConstValue *SimplifyVisitor::simplifyNode(ConstValue &node) {
        SimplifyVisitor simplifyVisitor(&node);
        return (ConstValue *) simplifyVisitor.getSimplifiedNode();
    }

    Operand *SimplifyVisitor::simplifyNode(Operand &node) {
        SimplifyVisitor simplifyVisitor(&node);
        return (Operand *) simplifyVisitor.getSimplifiedNode();
    }

    VariableOperand *SimplifyVisitor::simplifyNode(VariableOperand &node) {
        SimplifyVisitor simplifyVisitor(&node);
        return (VariableOperand *) simplifyVisitor.getSimplifiedNode();
    }

    IntegerValue *SimplifyVisitor::simplifyNode(IntegerValue &node) {
        SimplifyVisitor simplifyVisitor(&node);
        return (IntegerValue *) simplifyVisitor.getSimplifiedNode();
    }

    UnsignedValue *SimplifyVisitor::simplifyNode(UnsignedValue &node) {
        SimplifyVisitor simplifyVisitor(&node);
        return (UnsignedValue *) simplifyVisitor.getSimplifiedNode();
    }

    BoolValue *SimplifyVisitor::simplifyNode(BoolValue &node) {
        SimplifyVisitor simplifyVisitor(&node);
        return (BoolValue *) simplifyVisitor.getSimplifiedNode();
    }

    EnumValue *SimplifyVisitor::simplifyNode(EnumValue &node) {
        SimplifyVisitor simplifyVisitor(&node);
        return (EnumValue *) simplifyVisitor.getSimplifiedNode();
    }

    CompoundValue *SimplifyVisitor::simplifyNode(CompoundValue &node) {
        SimplifyVisitor simplifyVisitor(&node);
        return (CompoundValue *) simplifyVisitor.getSimplifiedNode();
    }

    PortOperand *SimplifyVisitor::simplifyNode(PortOperand &node) {
        SimplifyVisitor simplifyVisitor(&node);
        return (PortOperand *) simplifyVisitor.getSimplifiedNode();
    }

    Expr *SimplifyVisitor::simplifyNode(UnaryExpr &node) {
        SimplifyVisitor simplifyVisitor(&node);
        return (Expr *) simplifyVisitor.getSimplifiedNode();
    }

    SectionOperand *SimplifyVisitor::simplifyNode(SectionOperand &node) {
        SimplifyVisitor simplifyVisitor(&node);
        return (SectionOperand *) simplifyVisitor.getSimplifiedNode();
    }

    SectionValue *SimplifyVisitor::simplifyNode(SectionValue &node) {
        SimplifyVisitor simplifyVisitor(&node);
        return (SectionValue *) simplifyVisitor.getSimplifiedNode();
    }

    Expr *SimplifyVisitor::simplifyNode(Arithmetic &node) {
        SimplifyVisitor simplifyVisitor(&node);
        return (Expr *) simplifyVisitor.getSimplifiedNode();
    }

    Logical *SimplifyVisitor::simplifyNode(Logical &node) {
        SimplifyVisitor simplifyVisitor(&node);
        return (Logical *) simplifyVisitor.getSimplifiedNode();
    }

    Relational *SimplifyVisitor::simplifyNode(Relational &node) {
        SimplifyVisitor simplifyVisitor(&node);
        return (Relational *) simplifyVisitor.getSimplifiedNode();
    }

    Expr *SimplifyVisitor::simplifyNode(Bitwise &node) {
        SimplifyVisitor simplifyVisitor(&node);
        return (Expr *) simplifyVisitor.getSimplifiedNode();
    }

    NBRead *SimplifyVisitor::simplifyNode(NBRead &node) {
        SimplifyVisitor simplifyVisitor(&node);
        return (NBRead *) simplifyVisitor.getSimplifiedNode();
    }

    NBWrite *SimplifyVisitor::simplifyNode(NBWrite &node) {
        SimplifyVisitor simplifyVisitor(&node);
        return (NBWrite *) simplifyVisitor.getSimplifiedNode();
    }

    SyncSignal *SimplifyVisitor::simplifyNode(SyncSignal &node) {
        SimplifyVisitor simplifyVisitor(&node);
        return (SyncSignal *) simplifyVisitor.getSimplifiedNode();
    }

    DataSignalOperand *SimplifyVisitor::simplifyNode(DataSignalOperand &node) {
        SimplifyVisitor simplifyVisitor(&node);
        return (DataSignalOperand *) simplifyVisitor.getSimplifiedNode();
    }

    Expr *SimplifyVisitor::simplifyNode(Cast &node) {
        SimplifyVisitor simplifyVisitor(&node);
        return (Expr *) simplifyVisitor.getSimplifiedNode();
    }

    Read *SimplifyVisitor::simplifyNode(Read &node) {
        SimplifyVisitor simplifyVisitor(&node);
        return (Read *) simplifyVisitor.getSimplifiedNode();
    }

    Write *SimplifyVisitor::simplifyNode(Write &node) {
        SimplifyVisitor simplifyVisitor(&node);
        return (Write *) simplifyVisitor.getSimplifiedNode();
    }

    ITE *SimplifyVisitor::simplifyNode(ITE &node) {
        SimplifyVisitor simplifyVisitor(&node);
        return (ITE *) simplifyVisitor.getSimplifiedNode();
    }

    Assignment *SimplifyVisitor::simplifyNode(Assignment &node) {
        SimplifyVisitor simplifyVisitor(&node);
        return (Assignment *) simplifyVisitor.getSimplifiedNode();
    }

    While *SimplifyVisitor::simplifyNode(While &node) {
        SimplifyVisitor simplifyVisitor(&node);
        return (While *) simplifyVisitor.getSimplifiedNode();
    }

    If *SimplifyVisitor::simplifyNode(If &node) {
        SimplifyVisitor simplifyVisitor(&node);
        return (If *) simplifyVisitor.getSimplifiedNode();
    }

    FunctionOperand *SimplifyVisitor::simplifyNode(FunctionOperand &node) {
        SimplifyVisitor simplifyVisitor(&node);
        return (FunctionOperand *) simplifyVisitor.getSimplifiedNode();
    }
}

