//
// Created by schwarz on 06.11.20.
//

#include "gtest/gtest.h"
#include "Stmts_all.h"
#include "StmtCastVisitor.h"

using namespace DESCAM;

class StmtCastVisitorTest : public ::testing::Test {
 protected:

  void SetUp() override {
    DataType *data = new DataType("unsigned");
    Variable *var = new Variable("var", DataTypes::getDataType("unsigned"));
//    DataSignal *dSignal = new DataSignal("Foo", data, ConstValue_);
    std::vector<ConstValue *> vector = {ConstValue_};
    std::map<std::string, Expr *> map = {std::make_pair("str", ConstValue_)};
    Parameter *param = new Parameter("unsigned", data);
    std::map<std::string, Parameter *> param_map = {std::make_pair("unsigned", param)};
    Function *function = new Function("function", data, param_map);
    Interface *interface = new Interface("shared", "in");
//    Port *port = new Port("port", interface, data);
    Timepoint *time_point = new Timepoint("time_point");

    ConstValue_ = new BoolValue(true);
    Expr_ = new BoolValue(true);
//    Arithmetic_ = new Arithmetic(ConstValue_, "==", ConstValue_);
    VariableOperand_ = new VariableOperand(var);
//    ArrayOperand_ = new ArrayOperand(VariableOperand_, ConstValue_);
//    Wait_ = new Wait();
//    ArrayExpr_ = new ArrayExpr(map, data);
//    Assignment_ = new Assignment(ConstValue_, ConstValue_);
//    Bitwise_ = new Bitwise(ConstValue_,"&&", ConstValue_);
    BoolValue_ = new BoolValue(true);
//    Cast_ = new Cast(ConstValue_, data);
//    CompoundExpr_ = new CompoundExpr(map, data);
//    CompoundValue_ = new CompoundValue(vector,data);
//    DataSignalOperand_ = new DataSignalOperand(dSignal);
//    EnumValue_ = new EnumValue("Enum", data);

//    FunctionOperand_ = new FunctionOperand(function,map);
    If_ = new If(BoolValue_);
    IntegerValue_ = new IntegerValue(0);
    ITE_ = new ITE(BoolValue_);
//    Logical_ = new Logical(ConstValue_,"&",ConstValue_);
////    Notify_ = new Notify(port);
//    ParamOperand_ = new ParamOperand(param);
////    Peek_ = new Peek(port);
//    PortOperand_ = new PortOperand(port);
////    Read_ = new Read(port, VariableOperand_);
//    Relational_ = new Relational(ConstValue_, "?", ConstValue_);
//    Return_ = new Return(ConstValue_);
//    SectionOperand_ = new SectionOperand(var);
//    SectionValue_ = new SectionValue("section_value",data);
////    SyncSignal_ = new SyncSignal(port);
//    Ternary_ = new Ternary(ConstValue_,ConstValue_,ConstValue_);
//    TimePointOperand_ = new TimePointOperand(time_point);
//    UnaryExpr_ = new UnaryExpr("unary",ConstValue_);
//    UnsignedValue_ = new UnsignedValue(0);
    While_ = new While(BoolValue_);
////    Write_ = new Write(port, ConstValue_);
  }

  DataType *data;
  Variable *var;
  DataSignal *dSignal;
  Parameter *param;
  Function *function;
  Interface *interface;
  Port *port;
  Timepoint *time_point;

  VariableOperand *VariableOperand_;
  IntegerValue *IntegerValue_;
  UnsignedValue *UnsignedValue_;
  BoolValue *BoolValue_;
  EnumValue *EnumValue_;
  CompoundValue *CompoundValue_;
  PortOperand *PortOperand_;
  Assignment *Assignment_;
  UnaryExpr *UnaryExpr_;
  While *While_;
  If *If_;
  SectionOperand *SectionOperand_;
  SectionValue *SectionValue_;
  ITE *ITE_;
  Arithmetic *Arithmetic_;
  Logical *Logical_;
  Relational *Relational_;
  Bitwise *Bitwise_;
  Read *Read_;
  Write *Write_;
  SyncSignal *SyncSignal_;
  DataSignalOperand *DataSignalOperand_;
  Cast *Cast_;
  FunctionOperand *FunctionOperand_;
  ArrayOperand *ArrayOperand_;
  CompoundExpr *CompoundExpr_;
  ParamOperand *ParamOperand_;
  Return *Return_;
  Notify *Notify_;
  Wait *Wait_;
  Peek *Peek_;
  ArrayExpr *ArrayExpr_;
  TimePointOperand *TimePointOperand_;
  Ternary *Ternary_;
  Expr *Expr_;
  ConstValue *ConstValue_;

  void TearDown() override {
    delete VariableOperand_;
    delete IntegerValue_;
    delete UnsignedValue_;
    delete BoolValue_;
    delete EnumValue_;
    delete CompoundValue_;
    delete PortOperand_;
    delete Assignment_;
    delete UnaryExpr_;
    delete While_;
    delete If_;
    delete SectionOperand_;
    delete SectionValue_;
    delete ITE_;
    delete Arithmetic_;
    delete Logical_;
    delete Relational_;
    delete Bitwise_;
    delete Read_;
    delete Write_;
    delete SyncSignal_;
    delete DataSignalOperand_;
    delete Cast_;
    delete FunctionOperand_;
    delete ArrayOperand_;
    delete CompoundExpr_;
    delete ParamOperand_;
    delete Return_;
    delete Notify_;
    delete Wait_;
    delete Peek_;
    delete ArrayExpr_;
    delete TimePointOperand_;
    delete Ternary_;
    delete Expr_;
    delete ConstValue_;
    delete data;
    delete var;
    delete dSignal;
    delete param;
    delete function;
    delete interface;
    delete port;
    delete time_point;
  }
};

TEST_F(StmtCastVisitorTest, VariableOperand) /* NOLINT */ {
  Stmt * test = VariableOperand_;
  auto ptr = StmtCastVisitor<VariableOperand>(test).Get();
  EXPECT_EQ(ptr, VariableOperand_);
}

TEST_F(StmtCastVisitorTest, IntegerValue) /* NOLINT */ {
  Stmt * test = IntegerValue_;
  auto ptr = StmtCastVisitor<IntegerValue>(test).Get();
  EXPECT_EQ(ptr, IntegerValue_);
}

//TEST_F(StmtCastVisitorTest, UnsignedValue) {}
//TEST_F(StmtCastVisitorTest, BoolValue) {}
//TEST_F(StmtCastVisitorTest, EnumValue) {}
//TEST_F(StmtCastVisitorTest, CompoundValue) {}
//TEST_F(StmtCastVisitorTest, PortOperand) {}
//TEST_F(StmtCastVisitorTest, Assignment) {}
//TEST_F(StmtCastVisitorTest, UnaryExpr) {}
TEST_F(StmtCastVisitorTest, While) /* NOLINT */ {
  Stmt * test = While_;
  auto ptr = StmtCastVisitor<While>(test).Get();
  EXPECT_EQ(ptr, While_);
}

TEST_F(StmtCastVisitorTest, If) /* NOLINT */ {
  Stmt * test = If_;
  auto ptr = StmtCastVisitor<If>(test).Get();
  EXPECT_EQ(ptr, If_);
}

//TEST_F(StmtCastVisitorTest, SectionOperand) {}
//TEST_F(StmtCastVisitorTest, SectionValue) {}

TEST_F(StmtCastVisitorTest, ITE) /* NOLINT */ {
  Stmt * test = ITE_;
  auto ptr = StmtCastVisitor<ITE>(test).Get();
  EXPECT_EQ(ptr, ITE_);
}
//
//TEST_F(StmtCastVisitorTest, Arithmetic) /* NOLINT */ {
//  Stmt * test = Arithmetic_;
//  auto ptr = StmtCastVisitor<Arithmetic>(test).Get();
//  EXPECT_EQ(ptr, Arithmetic_);
//}
//
//TEST_F(StmtCastVisitorTest, Logical) {}
//TEST_F(StmtCastVisitorTest, Relational) {}
//TEST_F(StmtCastVisitorTest, Bitwise) {}
//TEST_F(StmtCastVisitorTest, Read) {}
//TEST_F(StmtCastVisitorTest, Write) {}
//TEST_F(StmtCastVisitorTest, SyncSignal) {}
//TEST_F(StmtCastVisitorTest, DataSignalOperand) {}
//TEST_F(StmtCastVisitorTest, Cast) {}
//TEST_F(StmtCastVisitorTest, FunctionOperand) {}
//TEST_F(StmtCastVisitorTest, ArrayOperand) {}
//TEST_F(StmtCastVisitorTest, CompoundExpr) {}
//TEST_F(StmtCastVisitorTest, ParamOperand) {}
//TEST_F(StmtCastVisitorTest, Return) {}
//TEST_F(StmtCastVisitorTest, Notify) {}
//TEST_F(StmtCastVisitorTest, Wait) {}
//TEST_F(StmtCastVisitorTest, Peek) {}
//TEST_F(StmtCastVisitorTest, ArrayExpr) {}
//TEST_F(StmtCastVisitorTest, TimePointOperand) {}
//TEST_F(StmtCastVisitorTest, Ternary) {}

TEST_F(StmtCastVisitorTest, Expr) /* NOLINT */ {
  Stmt * test = Expr_;
  auto ptr = StmtCastVisitor<Expr>(test).Get();
  EXPECT_EQ(ptr, Expr_);
}

TEST_F(StmtCastVisitorTest, ConstValue_Cast_Succeeds) /* NOLINT */ {
  // Try casting a ConstValue to ConstValue
  Stmt * test = ConstValue_;
  auto ptr = StmtCastVisitor<ConstValue>(test).Get();
  EXPECT_EQ(ptr, ConstValue_);
}

TEST_F(StmtCastVisitorTest, ConstValue_Cast_Fails) /* NOLINT */ {
  // Try casting a ConstValue to ConstValue
  Stmt * test = VariableOperand_;
  auto ptr = StmtCastVisitor<ConstValue>(test).Get();
  EXPECT_EQ(ptr, nullptr);
}