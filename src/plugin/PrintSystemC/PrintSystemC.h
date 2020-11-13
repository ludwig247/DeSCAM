//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 17.04.18.
//

#ifndef PROJECT_PRINTSYSTEMC_H
#define PROJECT_PRINTSYSTEMC_H

#include <PluginFactory.h>
#include <sstream>
#include "Model.h"
#include "PrintStmtForSystemC.h"

/** \brief
 * This class can function through the CommandlineParameters: "PrintSystemC".
 *
 * This class recreates the Systemc code from the generated model structure.
 * Prints on the console the created Systemc code for the passed model
 *          - Prints used datatypes in the top model.
 *          - Prints used modules classes that are used in the top model design.
 *          - Prints sc_main (model) that links these modules.
 *
 */

class PrintSystemC : public PluginFactory, public AbstractVisitor {
 public:
  PrintSystemC() = default;

  ~PrintSystemC() override = default;

  std::map<std::string, std::string> printModel(Model *node) override;

  std::map<std::string, bool> getOptionMap() override;

 private:
  void visit(Model &node) override;

  void visit(DESCAM::Module &node) override;

  void visit(ModuleInstance &node) override;

  void visit(Port &node) override;

  void visit(DataSignal &node) override; //not used
  void visit(Channel &node) override;

  void visit(Interface &node) override;
  void visit(Variable &node) override;

  void visit(FSM &node) override;

  void visit(DataType &node) override;

  void visit(Function &node) override;

  void visit(Parameter &node) override;

  void visit(Timepoint &node) override;

 private:
  unsigned int indent = 0;
  unsigned int indentSize = 2;

  ////////////////
  std::string Text_CMake();

  void Text_DataTypes();

  void printSpace(unsigned int size);

  std::stringstream ss;
};

#endif //PROJECT_PRINTSYSTEMC_H
