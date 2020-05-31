//
// Created by ludwig on 06.06.18.
//

#include <ModelGlobal.h>
#include <PrintStmt.h>
#include <ExprVisitor.h>
#include <Path.h>
#include <fstream>
#include "PrintXML.h"

// Derived classes for pointer-to-base-class serialization
//#include "DerivedExport.h"

#include <boost/serialization/export.hpp>
//BOOST_CLASS_EXPORT_KEY(SCAM::Port)
//BOOST_CLASS_EXPORT_KEY(SCAM::DataSignal)
//BOOST_CLASS_EXPORT_IMPLEMENT(SCAM::Port)
//BOOST_CLASS_EXPORT_IMPLEMENT(SCAM::DataSignal)

//BOOST_CLASS_EXPORT_KEY(SCAM::VariableTemplate<SCAM::DataSignal>)
//BOOST_CLASS_EXPORT_IMPLEMENT(SCAM::VariableTemplate<SCAM::DataSignal>)

// This macros are useful in conjunction with [ar.template register_type<derived_class>();]
//BOOST_SERIALIZATION_ASSUME_ABSTRACT(SCAM::Stmt)
//BOOST_SERIALIZATION_ASSUME_ABSTRACT(SCAM::Branch)
//BOOST_SERIALIZATION_ASSUME_ABSTRACT(SCAM::AbstractNode)
//BOOST_SERIALIZATION_ASSUME_ABSTRACT(SCAM::VariableTemplate)



namespace SCAM {
    class Serializer {
    public:

        //! ########## src > model ##########
        template<class Archive>
        static void serialize(Archive &ar, SCAM::AbstractNode &obj, const unsigned int) {
            ar & BOOST_SERIALIZATION_NVP(obj.name);
        }

        template<class Archive>
        static void serialize(Archive &ar, SCAM::Channel &obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(AbstractNode),
                                                boost::serialization::base_object<AbstractNode>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj.fromPort);
            ar & BOOST_SERIALIZATION_NVP(obj.toPort);
            ar & BOOST_SERIALIZATION_NVP(obj.fromInstance);
            ar & BOOST_SERIALIZATION_NVP(obj.toInstance);
        }

        template<class Archive>
        static void serialize(Archive &ar, SCAM::DataSignal &obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(VariableTemplate),
                                                boost::serialization::base_object<VariableTemplate<DataSignal>>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj.port);
        }

        template<class Archive>
        static void serialize(Archive &ar, DataType &obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(AbstractNode),
                                                boost::serialization::base_object<AbstractNode>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj.arraySize);
            ar & BOOST_SERIALIZATION_NVP(obj.arrayType);
            ar & BOOST_SERIALIZATION_NVP(obj.subVarMap);
            ar & BOOST_SERIALIZATION_NVP(obj.enumValueMap);
        }

        template<class Archive>
        static void serialize(Archive &ar, SCAM::FSM &obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(AbstractNode),
                                                boost::serialization::base_object<AbstractNode>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj.module);
            ar & BOOST_SERIALIZATION_NVP(obj.sectionVariable);
            ar & BOOST_SERIALIZATION_NVP(obj.nextSectionVariable);
            ar & BOOST_SERIALIZATION_NVP(obj.sectionMap); // Stmt
            ar & BOOST_SERIALIZATION_NVP(obj.stateMap); // State
            ar & BOOST_SERIALIZATION_NVP(obj.operationPathMap); // Operation, Path
        }

        template<class Archive>
        static void serialize(Archive &ar, SCAM::Function &obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(AbstractNode),
                                                boost::serialization::base_object<AbstractNode>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj.returnValueConditionList); // Return, Expr
            ar & BOOST_SERIALIZATION_NVP(obj.returnType);
            ar & BOOST_SERIALIZATION_NVP(obj.stmtList); // Stmt
            ar & BOOST_SERIALIZATION_NVP(obj.paramMap);
        }

        template<class Archive>
        static void serialize(Archive &ar, SCAM::Interface &obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(AbstractNode),
                                                boost::serialization::base_object<AbstractNode>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj._direction);
            ar & BOOST_SERIALIZATION_NVP(obj._interface);
        }

        template<class Archive>
        static void serialize(Archive &ar, SCAM::Model &obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(AbstractNode),
                                                boost::serialization::base_object<AbstractNode>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj.moduleMap);
            ar & BOOST_SERIALIZATION_NVP(obj.globalVariableMap);
            ar & BOOST_SERIALIZATION_NVP(obj.globalFunctionMap);
            ar & BOOST_SERIALIZATION_NVP(obj.moduleInstanceMap);
            ar & BOOST_SERIALIZATION_NVP(obj.topInstance);
        }

        template<class Archive>
        static void serialize(Archive &ar, SCAM::Module &obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(AbstractNode),
                                                boost::serialization::base_object<AbstractNode>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj.ports); // Port
            ar & BOOST_SERIALIZATION_NVP(obj.variableMap); // Variable
            ar & BOOST_SERIALIZATION_NVP(obj.functionMap); // Function
            ar & BOOST_SERIALIZATION_NVP(obj.fsm); // FSM
            ar & BOOST_SERIALIZATION_NVP(obj.cfg); // CfgNode
            ar & BOOST_SERIALIZATION_NVP(obj.commGroups); // CfgNode
            ar & BOOST_SERIALIZATION_NVP(obj.propertySuite); // PropertySuite
        }

        template<class Archive>
        static void serialize(Archive &ar, SCAM::ModuleInstance &obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(AbstractNode),
                                                boost::serialization::base_object<AbstractNode>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj.structure);
            ar & BOOST_SERIALIZATION_NVP(obj.channelMap);
            ar & BOOST_SERIALIZATION_NVP(obj.moduleInstanceMap);
            ar & BOOST_SERIALIZATION_NVP(obj.portChannelMap);
        }

        template<class Archive>
        static void serialize(Archive &ar, Parameter &obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(VariableTemplate),
                                                boost::serialization::base_object<VariableTemplate<Parameter>>(obj));
        }

        template<class Archive>
        static void serialize(Archive &ar, Port &obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(AbstractNode),
                                                boost::serialization::base_object<AbstractNode>(obj));
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(TypeInterface),
                                                boost::serialization::base_object<TypeInterface>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj._interface); // Interface
            ar & BOOST_SERIALIZATION_NVP(obj.synchSignal); // SyncSignal
            ar & BOOST_SERIALIZATION_NVP(obj.dataSignal); // DataSignal
            ar & BOOST_SERIALIZATION_NVP(obj.notify); // Notify
        }

        template<class Archive>
        static void serialize(Archive &ar, Timepoint &obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(VariableTemplate),
                                                boost::serialization::base_object<VariableTemplate<Timepoint>>(obj));
        }

        template<class Archive>
        static void serialize(Archive &ar, TypeInterface &obj, const unsigned int) {
            ar & BOOST_SERIALIZATION_NVP(obj.dataType);
        }

        template<class Archive>
        static void serialize(Archive &ar, SCAM::Variable &obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(VariableTemplate),
                                                boost::serialization::base_object<VariableTemplate<Variable>>(obj));
        }

        template<class Archive, class T>
        static void serialize(Archive &ar, SCAM::VariableTemplate<T> &obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(AbstractNode),
                                                boost::serialization::base_object<AbstractNode>(obj));
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(TypeInterface),
                                                boost::serialization::base_object<TypeInterface>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj.subVarList);
            ar & BOOST_SERIALIZATION_NVP(obj.subVar);
            ar & BOOST_SERIALIZATION_NVP(obj.parent);
            ar & BOOST_SERIALIZATION_NVP(obj.initialValue); // ConstValue
            ar & BOOST_SERIALIZATION_NVP(obj.constant);
        }

        //! ########## src > model > Stmts ##########

        template <class Archive>
        static void serialize(Archive &ar, SCAM::Arithmetic& obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(Expr),
                                                boost::serialization::base_object<Expr>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj.lhs); // Expr
            ar & BOOST_SERIALIZATION_NVP(obj.rhs); // Expr
            ar & BOOST_SERIALIZATION_NVP(obj.operation);
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::ArrayExpr& obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(Expr),
                                                boost::serialization::base_object<Expr>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj.valueMap); // Expr
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::ArrayOperand& obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(Expr),
                                                boost::serialization::base_object<Expr>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj.arrayVar); // Variable
            ar & BOOST_SERIALIZATION_NVP(obj.operand); // Operand
            ar & BOOST_SERIALIZATION_NVP(obj.idx); // Expr
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::Assignment& obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(Stmt),
                                                boost::serialization::base_object<Stmt>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj.lhs); // Expr
            ar & BOOST_SERIALIZATION_NVP(obj.rhs); // Expr
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::Bitwise& obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(Expr),
                                                boost::serialization::base_object<Expr>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj.lhs); // Expr
            ar & BOOST_SERIALIZATION_NVP(obj.rhs); // Expr
            ar & BOOST_SERIALIZATION_NVP(obj.operation);
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::BoolValue& obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(ConstValue),
                                                boost::serialization::base_object<ConstValue>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj.value);
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::Branch& obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(Stmt),
                                                boost::serialization::base_object<Stmt>(obj));
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::Cast& obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(Expr),
                                                boost::serialization::base_object<Expr>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj.expr); // Expr
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::Communication& obj, const unsigned int) {
            ar & BOOST_SERIALIZATION_NVP(obj.port); // Port
            ar & BOOST_SERIALIZATION_NVP(obj.is_non_blocking_access);
            ar & BOOST_SERIALIZATION_NVP(obj.stateName);
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::CompoundExpr& obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(Expr),
                                                boost::serialization::base_object<Expr>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj.valueMap); // Expr
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::CompoundValue& obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(ConstValue),
                                                boost::serialization::base_object<ConstValue>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj.values); // ConstValue
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::ConstValue& obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(Expr),
                                                boost::serialization::base_object<Expr>(obj));
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::DataSignalOperand& obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(Operand),
                                                boost::serialization::base_object<Operand>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj.dataSignal); // DataSignal
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::EnumValue& obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(ConstValue),
                                                boost::serialization::base_object<ConstValue>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj.enumValue);
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::Expr& obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(Stmt),
                                                boost::serialization::base_object<Stmt>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj.dataType);
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::FunctionOperand& obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(Operand),
                                                boost::serialization::base_object<Operand>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj.paramValueMap); // Expr
            ar & BOOST_SERIALIZATION_NVP(obj.function); // Function
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::If& obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(Branch),
                                                boost::serialization::base_object<Branch>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj.conditionStmt); // Expr
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::IntegerValue& obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(ConstValue),
                                                boost::serialization::base_object<ConstValue>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj.value);
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::ITE& obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(If),
                                                boost::serialization::base_object<If>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj.ifList); // Stmt
            ar & BOOST_SERIALIZATION_NVP(obj.elseList); // Stmt
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::Logical& obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(Expr),
                                                boost::serialization::base_object<Expr>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj.lhs); // Expr
            ar & BOOST_SERIALIZATION_NVP(obj.rhs); // Expr
            ar & BOOST_SERIALIZATION_NVP(obj.operation);
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::Notify& obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(Expr),
                                                boost::serialization::base_object<Expr>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj.port); // Port
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::Operand& obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(Expr),
                                                boost::serialization::base_object<Expr>(obj));
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::ParamOperand& obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(Operand),
                                                boost::serialization::base_object<Operand>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj.parameter); // Parameter
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::Peek& obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(Expr),
                                                boost::serialization::base_object<Expr>(obj));
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(Communication),
                                                boost::serialization::base_object<Communication>(obj));
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::PortOperand& obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(Operand),
                                                boost::serialization::base_object<Operand>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj.port); // Port
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::Read& obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(Stmt),
                                                boost::serialization::base_object<Stmt>(obj));
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(Communication),
                                                boost::serialization::base_object<Communication>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj.variable); // VariableOperand
            ar & BOOST_SERIALIZATION_NVP(obj.status); // VariableOperand
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::Relational& obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(Expr),
                                                boost::serialization::base_object<Expr>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj.lhs); // Expr
            ar & BOOST_SERIALIZATION_NVP(obj.rhs); // Expr
            ar & BOOST_SERIALIZATION_NVP(obj.operation);
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::Return& obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(Stmt),
                                                boost::serialization::base_object<Stmt>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj.returnValue); // Expr
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::SectionOperand& obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(Expr),
                                                boost::serialization::base_object<Expr>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj.sectionVariable); // Variable
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::SectionValue& obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(ConstValue),
                                                boost::serialization::base_object<ConstValue>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj.value);
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::Stmt& obj, const unsigned int) {
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::SyncSignal& obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(Expr),
                                                boost::serialization::base_object<Expr>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj.port); // Port
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::TimePointOperand& obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(Operand),
                                                boost::serialization::base_object<Operand>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj.timepoint); // Timepoint
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::UnaryExpr& obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(Expr),
                                                boost::serialization::base_object<Expr>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj.expr); // Expr
            ar & BOOST_SERIALIZATION_NVP(obj.operation);
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::UnsignedValue& obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(ConstValue),
                                                boost::serialization::base_object<ConstValue>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj.value);
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::VariableOperand& obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(Operand),
                                                boost::serialization::base_object<Operand>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj.variable); // Variable
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::Wait& obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(Stmt),
                                                boost::serialization::base_object<Stmt>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj.stateName);
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::While& obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(Branch),
                                                boost::serialization::base_object<Branch>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj.conditionStmt); // Expr
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::Write& obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(Communication),
                                                boost::serialization::base_object<Communication>(obj));
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(Stmt),
                                                boost::serialization::base_object<Stmt>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj.value); // Expr
            ar & BOOST_SERIALIZATION_NVP(obj.status); // VariableOperand
        }

        //! ########## src > functionFactory ##########
        template <class Archive>
        static void serialize(Archive &ar, SCAM::Path& obj, const unsigned int) {
            ar & BOOST_SERIALIZATION_NVP(obj.stmtList); // Stmt
        }

        //! ########## src > model > Behavior ##########
        template <class Archive>
        static void serialize(Archive &ar, SCAM::CfgNode& obj, const unsigned int) {
            ar & BOOST_SERIALIZATION_NVP(obj.id);
            ar & BOOST_SERIALIZATION_NVP(obj.successorList); // CfgNode
            ar & BOOST_SERIALIZATION_NVP(obj.predecessorList); // CfgNode
            ar & BOOST_SERIALIZATION_NVP(obj.stmt); // Stmt
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::Operation& obj, const unsigned int) {
            ar & BOOST_SERIALIZATION_NVP(obj.id);
            ar & BOOST_SERIALIZATION_NVP(obj.statementsList); // Stmt
            ar & BOOST_SERIALIZATION_NVP(obj.assumptionList); // Expr
            ar & BOOST_SERIALIZATION_NVP(obj.commitmentList); // Assignment
            ar & BOOST_SERIALIZATION_NVP(obj.state); // State
            ar & BOOST_SERIALIZATION_NVP(obj.nextState); // State
            ar & BOOST_SERIALIZATION_NVP(obj.resetOperation);
            ar & BOOST_SERIALIZATION_NVP(obj.waitOperation);
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::State& obj, const unsigned int) {
            ar & BOOST_SERIALIZATION_NVP(obj.stateId);
            ar & BOOST_SERIALIZATION_NVP(obj.name);
            ar & BOOST_SERIALIZATION_NVP(obj.init);
            ar & BOOST_SERIALIZATION_NVP(obj.wait);
            ar & BOOST_SERIALIZATION_NVP(obj.incomingOperationsList); // Operation
            ar & BOOST_SERIALIZATION_NVP(obj.outgoingOperationsList); // Operation
            ar & BOOST_SERIALIZATION_NVP(obj.incomingFreezeSignals); // Stmt
            ar & BOOST_SERIALIZATION_NVP(obj.outgoingAssignSignals); // Stmt
            // commStmt must be serialized at the end, because it is a pointer and subclasses of Communication (i.e.
            // Read, Peek, Write) may appear in the in-/outcomeOperationsList above. A pointer conflict exception
            // may occur if this order is not followed (e.g. a Communication object is serialized first as pointer at
            // commStmt and then as reference at in-/outcomeOperationsList).
            // The correct order of serialization for a given object must be first its reference and then any existing
            // pointers of it.
            // Sources: http://www.bnikolic.co.uk/blog/cpp-boost-ser-conflict.html
            //          https://www.boost.org/doc/libs/1_61_0/libs/serialization/doc/exceptions.html#pointer_conflict
            ar & BOOST_SERIALIZATION_NVP(obj.commStmt); // Communication
        }


        //! ########## src > model > propertySuite ##########
        template <class Archive>
        static void serialize(Archive &ar, SCAM::AbstractMacro& obj, const unsigned int) {
            ar & BOOST_SERIALIZATION_NVP(obj.name);
            ar & BOOST_SERIALIZATION_NVP(obj.expression); //Stmt
            ar & BOOST_SERIALIZATION_NVP(obj.active);
        }

/*        template <class Archive>
        static void serialize(Archive &ar, SCAM::AbstractProperty& obj, const unsigned int) {
            ar & BOOST_SERIALIZATION_NVP(obj.name);
            ar & BOOST_SERIALIZATION_NVP(obj.state);
            ar & BOOST_SERIALIZATION_NVP(obj.nextState);
            ar & BOOST_SERIALIZATION_NVP(obj.t_end);
            ar & BOOST_SERIALIZATION_NVP(obj.freezeSignals);
    //            ar & BOOST_SERIALIZATION_NVP(obj.assumptionList); // Expr
    //            ar & BOOST_SERIALIZATION_NVP(obj.commitmentList); // Assignment
            ar & BOOST_SERIALIZATION_NVP(obj.constraints);
        }*/

        template <class Archive>
        static void serialize(Archive &ar, SCAM::FunctionMacro& obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(AbstractMacro),
                    boost::serialization::base_object<AbstractMacro>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj.parameters);
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::Property& obj, const unsigned int) {
            ar & BOOST_SERIALIZATION_NVP(obj.name);
            ar & BOOST_SERIALIZATION_NVP(obj.operationList); // Operation
            ar & BOOST_SERIALIZATION_NVP(obj.constraints); // PropertyConstraint
            ar & BOOST_SERIALIZATION_NVP(obj.timePoints); // Timepoint, Expr
            ar & BOOST_SERIALIZATION_NVP(obj.timePointsOrdered); // Timepoint, Expr
            ar & BOOST_SERIALIZATION_NVP(obj.freezeSignals); // PropertyMacro, Timepoint
            ar & BOOST_SERIALIZATION_NVP(obj.assumptionList); // TemporalExpr
            ar & BOOST_SERIALIZATION_NVP(obj.commitmentList); // TemporalExpr
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::PropertyConstraint& obj, const unsigned int) {
            ar & BOOST_SERIALIZATION_NVP(obj.name);
            ar & BOOST_SERIALIZATION_NVP(obj.expression); // Stmt
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::PropertyMacro& obj, const unsigned int) {
            ar & boost::serialization::make_nvp(BOOST_PP_STRINGIZE(AbstractMacro),
                    boost::serialization::base_object<AbstractMacro>(obj));
            ar & BOOST_SERIALIZATION_NVP(obj.port); // Port
            ar & BOOST_SERIALIZATION_NVP(obj.notifySignal); // Notify
            ar & BOOST_SERIALIZATION_NVP(obj.syncSignal); // SyncSignal
            ar & BOOST_SERIALIZATION_NVP(obj.dataSignal); // DataSignal
            ar & BOOST_SERIALIZATION_NVP(obj.variable); // Variable
            ar & BOOST_SERIALIZATION_NVP(obj.variableOperand); // VariableOperand
            ar & BOOST_SERIALIZATION_NVP(obj.parent); // PropertyMacro
            ar & BOOST_SERIALIZATION_NVP(obj.macroType); // enum class MacroType
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::PropertySuite& obj, const unsigned int) {
            ar & BOOST_SERIALIZATION_NVP(obj.name);
            ar & BOOST_SERIALIZATION_NVP(obj.resetSignal); // Variable
            ar & BOOST_SERIALIZATION_NVP(obj.syncSignals); // PropertyMacro
            ar & BOOST_SERIALIZATION_NVP(obj.notifySignals); // PropertyMacro
            ar & BOOST_SERIALIZATION_NVP(obj.dpSignals); // PropertyMacro
            ar & BOOST_SERIALIZATION_NVP(obj.visibleRegisters); // PropertyMacro
            ar & BOOST_SERIALIZATION_NVP(obj.states); // PropertyMacro
            ar & BOOST_SERIALIZATION_NVP(obj.functions); // Function
            ar & BOOST_SERIALIZATION_NVP(obj.constraints); // PropertyConstraint
            ar & BOOST_SERIALIZATION_NVP(obj.resetProperty); // Property
            ar & BOOST_SERIALIZATION_NVP(obj.propertyList); // Property
        }

        template <class Archive>
        static void serialize(Archive &ar, SCAM::TemporalExpr& obj, const unsigned int) {
            ar & BOOST_SERIALIZATION_NVP(obj.type); // enum class Type
            ar & BOOST_SERIALIZATION_NVP(obj.timepointList); // Expr
            ar & BOOST_SERIALIZATION_NVP(obj.statement); // Stmt
            ar & BOOST_SERIALIZATION_NVP(obj.freezeAt);
        }


        //! ########## Non-default constructors handling ##########
        /*template<class Archive>
        static inline void save_construct_data(
                Archive & ar, const SCAM::Port * t, const unsigned int version
        ){
            // save data required to construct instance
            ar << boost::serialization::make_nvp("name", t->name);
            ar << boost::serialization::make_nvp("_interface", t->_interface);
            ar << boost::serialization::make_nvp("dataType", t->dataType);
        }

        template<class Archive>
        static inline void load_construct_data(
                Archive & ar, SCAM::Port * t, const unsigned int version
        ){
            // retrieve data from archive required to construct new instance
            std::string name;
            SCAM::Interface *_interface;
            SCAM::DataType *dataType;
            ar >> boost::serialization::make_nvp("name", name);
            ar >> boost::serialization::make_nvp("_interface", _interface);
            ar >> boost::serialization::make_nvp("dataType", dataType);

            // invoke inplace constructor to initialize instance of my_class
            ::new(t)Port(name, _interface, dataType);
        }

        template<class Archive>
        static inline void save_construct_data(
                Archive & ar, const SCAM::DataSignal * t, const unsigned int version
        ){
            // save data required to construct instance
            ar << boost::serialization::make_nvp("port", t->port);
            ar << boost::serialization::make_nvp("name", t->name);
            ar << boost::serialization::make_nvp("dataType", t->dataType);
            ar << boost::serialization::make_nvp("initialValue", t->initialValue);
            ar << boost::serialization::make_nvp("parent", t->parent);
        }

        template<class Archive>
        static inline void load_construct_data(
                Archive & ar, SCAM::DataSignal * t, const unsigned int version
        ){
            // retrieve data from archive required to construct new instance
            SCAM::Port *port;
            std::string name;
            SCAM::DataType *dataType;
            SCAM::ConstValue *initialValue;
            SCAM::DataSignal *parent;

            ar >> boost::serialization::make_nvp("port", port);
            ar >> boost::serialization::make_nvp("name", name);
            ar >> boost::serialization::make_nvp("dataType", dataType);
            ar >> boost::serialization::make_nvp("initialValue", initialValue);
            ar >> boost::serialization::make_nvp("parent", parent);

            // invoke inplace constructor to initialize instance of my_class
            ::new(t)DataSignal(name, dataType, initialValue, parent, port);
        }

        template<class Archive>
        static inline void save_construct_data(
                Archive & ar, const SCAM::DataType * t, const unsigned int version){
            // save data required to construct instance
            ar << boost::serialization::make_nvp("name", t->name);
        }

        template<class Archive>
        static inline void load_construct_data(
                Archive & ar, SCAM::DataType * t, const unsigned int version){
            // retrieve data from archive required to construct new instance
            std::string name;

            ar >> boost::serialization::make_nvp("name", name);

            // invoke inplace constructor to initialize instance of my_class
            ::new(t)DataType(name);
        }

        template<class Archive>
        static inline void save_construct_data(
                Archive & ar, const SCAM::Notify * t, const unsigned int version){
            // save data required to construct instance
            ar << boost::serialization::make_nvp("port", t->port);
        }

        template<class Archive>
        static inline void load_construct_data(
                Archive & ar, SCAM::Notify * t, const unsigned int version){
            // retrieve data from archive required to construct new instance
            SCAM::Port *port;

            ar >> boost::serialization::make_nvp("port", port);

            // invoke inplace constructor to initialize instance of my_class
            ::new(t)Notify(port);
        }

        template<class Archive>
        static inline void save_construct_data(
                Archive & ar, const SCAM::SyncSignal * t, const unsigned int version){
            // save data required to construct instance
            ar << boost::serialization::make_nvp("port", t->port);
        }

        template<class Archive>
        static inline void load_construct_data(
                Archive & ar, SCAM::SyncSignal * t, const unsigned int version){
            // retrieve data from archive required to construct new instance
            SCAM::Port *port;

            ar >> boost::serialization::make_nvp("port", port);

            // invoke inplace constructor to initialize instance of my_class
            ::new(t)SyncSignal(port);
        }

        template<class Archive, class T>
        inline void save_construct_data(Archive & ar, const SCAM::VariableTemplate<T> * t, const unsigned int version){
            // save data required to construct instance
            ar << boost::serialization::make_nvp("name", t->name);
            ar << boost::serialization::make_nvp("dataType", t->dataType);
            ar << boost::serialization::make_nvp("initialValue", t->initialValue);
            ar << boost::serialization::make_nvp("parent", t->parent);
        }

        template<class Archive, class T>
        inline void load_construct_data(Archive & ar, SCAM::VariableTemplate<T> * t, const unsigned int version){
            // retrieve data from archive required to construct new instance
            std::string name;
            SCAM::DataType *dataType;
            SCAM::ConstValue *initialValue;
            SCAM::VariableTemplate<T> *parent;

            ar >> boost::serialization::make_nvp("name", name);
            ar >> boost::serialization::make_nvp("dataType", dataType);
            ar >> boost::serialization::make_nvp("initialValue", initialValue);
            ar >> boost::serialization::make_nvp("parent", parent);

            // invoke inplace constructor to initialize instance of my_class
            ::new(t)DataSignal(name, dataType, initialValue, parent);
        }*/
    };
}
// Serialization router
//! Redirects Boost serialization to serialize functions on Serializer class.
namespace boost {
    namespace serialization {

//        BOOST_SERIALIZATION_ASSUME_ABSTRACT(SCAM::Stmt)
        //! ########## src > model ##########
        template<class Archive>
        void serialize(Archive &ar, SCAM::AbstractNode &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::Channel &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::DataSignal &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::DataType &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::FSM &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::Function &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::Interface &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::Model &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::Module &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::ModuleInstance &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::Parameter &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::Port &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::Timepoint &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::TypeInterface &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::Variable &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive, class T>
        void serialize(Archive &ar, SCAM::VariableTemplate<T> &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }


        //! ########## src > model > Stmts ##########

        template<class Archive>
        void serialize(Archive &ar, SCAM::Arithmetic &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::ArrayExpr &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::ArrayOperand &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::Assignment &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::Bitwise &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::BoolValue &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::Branch &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::Cast &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::Communication &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::CompoundExpr &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::CompoundValue &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::ConstValue &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::DataSignalOperand &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::EnumValue &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::Expr &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::FunctionOperand &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::If &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::IntegerValue &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::ITE &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::Logical &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::Notify &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::Operand &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::ParamOperand &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::Peek &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::PortOperand &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::Read &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::Relational &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::Return &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::SectionOperand &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::SectionValue &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::Stmt &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::SyncSignal &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::TimePointOperand &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::UnaryExpr &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::UnsignedValue &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::VariableOperand &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::Wait &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::While &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::Write &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }


        //! ########## src > functionFactory ##########
        template<class Archive>
        void serialize(Archive &ar, SCAM::Path &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }


        //! ########## src > model > Behavior ##########
        template<class Archive>
        void serialize(Archive &ar, SCAM::CfgNode &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::Operation &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::State &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        //! ########## src > model > propertySuite ##########
        template<class Archive>
        void serialize(Archive &ar, SCAM::AbstractMacro &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

//        template<class Archive>
//        void serialize(Archive &ar, SCAM::AbstractProperty &obj, const unsigned int version) {
//            SCAM::Serializer::serialize(ar, obj, version);
//        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::FunctionMacro &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::Property &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::PropertyConstraint &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::PropertyMacro &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::PropertySuite &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        template<class Archive>
        void serialize(Archive &ar, SCAM::TemporalExpr &obj, const unsigned int version) {
            SCAM::Serializer::serialize(ar, obj, version);
        }

        //! ########## Non-default constructors handling ##########
        /*template<class Archive>
        inline void save_construct_data(Archive & ar, const SCAM::Port * t, const unsigned int version){
            std::cout<<"in save_construct_data Port ..."<<std::endl;
            SCAM::Serializer::save_construct_data(ar, t, version);
            std::cout<<"out save_construct_data Port ..."<<std::endl;
        }

        template<class Archive>
        inline void load_construct_data(Archive & ar, SCAM::Port * t, const unsigned int version){
            std::cout<<"in load_construct_data Port ..."<<std::endl;
            SCAM::Serializer::load_construct_data(ar, t, version);
            std::cout<<"out load_construct_data Port ..."<<std::endl;
        }

        template<class Archive>
        inline void save_construct_data(Archive & ar, const SCAM::DataSignal * t, const unsigned int version){
            std::cout<<"in save_construct_data DataSignal ..."<<std::endl;
            SCAM::Serializer::save_construct_data(ar, t, version);
            std::cout<<"out save_construct_data DataSignal ..."<<std::endl;
        }

        template<class Archive>
        inline void load_construct_data(Archive & ar, SCAM::DataSignal * t, const unsigned int version){
            std::cout<<"in load_construct_data DataSignal ..."<<std::endl;
            SCAM::Serializer::load_construct_data(ar, t, version);
            std::cout<<"out load_construct_data DataSignal ..."<<std::endl;
        }

        template<class Archive>
        inline void save_construct_data(Archive & ar, const SCAM::DataType * t, const unsigned int version){
            std::cout<<"in save_construct_data DataType ..."<<std::endl;
            SCAM::Serializer::save_construct_data(ar, t, version);
            std::cout<<"out save_construct_data DataType ..."<<std::endl;
        }

        template<class Archive>
        inline void load_construct_data(Archive & ar, SCAM::DataType * t, const unsigned int version){
            std::cout<<"in load_construct_data DataType ..."<<std::endl;
            SCAM::Serializer::load_construct_data(ar, t, version);
            std::cout<<"out load_construct_data DataType ..."<<std::endl;
        }

        template<class Archive>
        inline void save_construct_data(Archive & ar, const SCAM::Notify * t, const unsigned int version){
            std::cout<<"in save_construct_data Notify ..."<<std::endl;
            SCAM::Serializer::save_construct_data(ar, t, version);
            std::cout<<"out save_construct_data Notify ..."<<std::endl;
        }

        template<class Archive>
        inline void load_construct_data(Archive & ar, SCAM::Notify * t, const unsigned int version){
            std::cout<<"in load_construct_data Notify ..."<<std::endl;
            SCAM::Serializer::load_construct_data(ar, t, version);
            std::cout<<"out load_construct_data Notify ..."<<std::endl;
        }

        template<class Archive>
        inline void save_construct_data(Archive & ar, const SCAM::SyncSignal * t, const unsigned int version){
            std::cout<<"in save_construct_data SyncSignal ..."<<std::endl;
            SCAM::Serializer::save_construct_data(ar, t, version);
            std::cout<<"out save_construct_data SyncSignal ..."<<std::endl;
        }

        template<class Archive>
        inline void load_construct_data(Archive & ar, SCAM::SyncSignal * t, const unsigned int version){
            std::cout<<"in load_construct_data SyncSignal ..."<<std::endl;
            SCAM::Serializer::load_construct_data(ar, t, version);
            std::cout<<"out load_construct_data SyncSignal ..."<<std::endl;
        }

        template<class Archive, class T>
        inline void save_construct_data(Archive & ar, const SCAM::VariableTemplate<T> * t, const unsigned int version){
            std::cout<<"in save_construct_data VariableTemplate ..."<<std::endl;
            SCAM::Serializer::save_construct_data(ar, t, version);
            std::cout<<"out save_construct_data VariableTemplate ..."<<std::endl;
        }

        template<class Archive, class T>
        inline void load_construct_data(Archive & ar, SCAM::VariableTemplate<T> * t, const unsigned int version){
            std::cout<<"in load_construct_data VariableTemplate ..."<<std::endl;
            SCAM::Serializer::load_construct_data(ar, t, version);
            std::cout<<"out load_construct_data VariableTemplate ..."<<std::endl;
        }

        template<class Archive>
        inline void save_construct_data(Archive & ar, const SCAM::Interface * t, const unsigned int version){
            std::cout<<"in save_construct_data Interface ..."<<std::endl;
            SCAM::Serializer::save_construct_data(ar, t, version);
            std::cout<<"out save_construct_data Interface ..."<<std::endl;
        }

        template<class Archive>
        inline void load_construct_data(Archive & ar, SCAM::Interface * t, const unsigned int version){
            std::cout<<"in load_construct_data Interface ..."<<std::endl;
            SCAM::Serializer::load_construct_data(ar, t, version);
            std::cout<<"out load_construct_data Interface ..."<<std::endl;
        }*/
    }
}

std::map<std::string, std::string> PrintXML::printModel(Model *node) {

    // TODO: Disable this error, because the serialization can handle a Model with multiple Modules!
//    if(node->getModules().size() != 1){
//        throw std::runtime_error("Please only run single modules.\n");
//    }
//    auto module = node->getModules().begin()->second;

    // Serialization

    //// Output to terminal
    std::stringstream output;
    boost::archive::xml_oarchive oa(output);

    SCAM::PrintXML::regCommunicationDerivedTypes(oa);
    SCAM::PrintXML::regStmtDerivedTypes(oa);
    SCAM::PrintXML::regConstValueDerivedTypes(oa);
    SCAM::PrintXML::regExprDerivedTypes(oa);
    SCAM::PrintXML::regBranchDerivedTypes(oa);
    SCAM::PrintXML::regIfDerivedTypes(oa);

    SCAM::PrintXML::regOperandDerivedTypes(oa);

    oa << boost::serialization::make_nvp("Model", node); // Saving the whole Model and not only the first module.

    //// Output to file
//    std::string filePath("../src/plugin/PrintXML/serialized_model.xml");
//    std::ofstream output_xml(filePath);
//    boost::archive::xml_oarchive oa2(output_xml);
//
//    SCAM::PrintXML::regCommunicationDerivedTypes(oa2);
//    SCAM::PrintXML::regStmtDerivedTypes(oa2);
//    SCAM::PrintXML::regConstValueDerivedTypes(oa2);
//    SCAM::PrintXML::regExprDerivedTypes(oa2);
//    SCAM::PrintXML::regBranchDerivedTypes(oa2);
//    SCAM::PrintXML::regIfDerivedTypes(oa2);
//
//    SCAM::PrintXML::regOperandDerivedTypes(oa2);
//
//    oa2 << boost::serialization::make_nvp("Model", node); // Saving the whole Model and not only the first module.

    return {std::make_pair(node->getName()+".xml",output.str())}; // When serializing from Model
//    return {std::make_pair(module->getName()+".xml",output.str())}; // When serializing from Module
//    return {std::make_pair(module->getName()+".xml",test.print())};
}

template<class Archive>
void PrintXML::regConstValueDerivedTypes(Archive &ar) {
    ar.template register_type<SCAM::BoolValue>();
    ar.template register_type<SCAM::CompoundValue>();
    ar.template register_type<SCAM::EnumValue>();
    ar.template register_type<SCAM::IntegerValue>();
    ar.template register_type<SCAM::SectionValue>();
    ar.template register_type<SCAM::UnsignedValue>();

}

template<class Archive>
void PrintXML::regStmtDerivedTypes(Archive &ar) {
    ar.template register_type<SCAM::Assignment>();
    ar.template register_type<SCAM::Branch>();
    ar.template register_type<SCAM::Expr>();
//    ar.template register_type<SCAM::Read>(); //TODO
    ar.template register_type<SCAM::Return>();
    ar.template register_type<SCAM::Wait>();
//    ar.template register_type<SCAM::Write>(); //TODO

//    ar.template register_type<SCAM::AbstractNode>();
//    ar.template register_type<SCAM::Channel>();
//    ar.template register_type<SCAM::DataSignal>();
//    ar.template register_type<SCAM::DataType>();
//    ar.template register_type<SCAM::FSM>();
//    ar.template register_type<SCAM::Function>();
//    ar.template register_type<SCAM::Interface>();
//    ar.template register_type<SCAM::Model>();
//    ar.template register_type<SCAM::Module>();
//    ar.template register_type<SCAM::ModuleInstance>();
//    ar.template register_type<SCAM::Parameter>();
//    ar.template register_type<SCAM::Port>();
//    ar.template register_type<SCAM::TypeInterface>();
//    ar.template register_type<SCAM::Variable>();
//    ar.template register_type<SCAM::VariableTemplate<Variable>>();
//    ar.template register_type<SCAM::VariableTemplate<DataSignal>>();
//    ar.template register_type<SCAM::VariableTemplate<Parameter>>();
//    ar.template register_type<SCAM::VariableTemplate<Timepoint>>();


}

template<class Archive>
void PrintXML::regExprDerivedTypes(Archive &ar) {
    ar.template register_type<SCAM::Arithmetic>();
    ar.template register_type<SCAM::ArrayExpr>();
    ar.template register_type<SCAM::ArrayOperand>();
    ar.template register_type<SCAM::Bitwise>();
    ar.template register_type<SCAM::Cast>();
    ar.template register_type<SCAM::CompoundExpr>();
    ar.template register_type<SCAM::ConstValue>();
    ar.template register_type<SCAM::Logical>();
//    ar.template register_type<SCAM::Peek>(); //TODO
    ar.template register_type<SCAM::Notify>();
    ar.template register_type<SCAM::Operand>();
    ar.template register_type<SCAM::Relational>();
    ar.template register_type<SCAM::SectionOperand>();
    ar.template register_type<SCAM::SyncSignal>();
    ar.template register_type<SCAM::UnaryExpr>();
}

template<class Archive>
void PrintXML::regBranchDerivedTypes(Archive &ar) {
    ar.template register_type<SCAM::If>();
    ar.template register_type<SCAM::While>();

    // Derived from If (alternative to having a separate function)
//    ar.template register_type<SCAM::ITE>();
}

template<class Archive>
void PrintXML::regIfDerivedTypes(Archive &ar) {
    ar.template register_type<SCAM::ITE>();
}

template<class Archive>
void PrintXML::regCommunicationDerivedTypes(Archive &ar) {
    ar.template register_type<SCAM::Peek>(); // Already registered within regExprDerivedTypes().
    ar.template register_type<SCAM::Read>(); // Already registered within regStmtDerivedTypes().
    ar.template register_type<SCAM::Write>(); // Already registered within regStmtDerivedTypes().
}

template<class Archive>
void PrintXML::regOperandDerivedTypes(Archive &ar) {
    ar.template register_type<SCAM::DataSignalOperand>();
    ar.template register_type<SCAM::FunctionOperand>();
    ar.template register_type<SCAM::ParamOperand>();
    ar.template register_type<SCAM::PortOperand>();
    ar.template register_type<SCAM::TimePointOperand>();
    ar.template register_type<SCAM::VariableOperand>();
}