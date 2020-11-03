//
// Created by burr on 22.10.20.
//

#include "GetClangProcess.h"
#include "FatalError.h"
#include "Logger/Logger.h"
#include "clangCastVisitor.h"

DESCAM::GetClangProcess::GetClangProcess(bool &success, clang::CXXRecordDecl *record_decl) :
    record_decl_(record_decl),
    process_type_(PROCESS_TYPE::NONE),
    constructor_stmt_(nullptr) {
  pass_ = 1;
  /// Pass 1:
  /// Find the constructor definition, and the Stmt* that has the code for it.
  /// Set the _constructorStmt pointer.
  //  _os << "\n>>>> PASS 1\n";
  success = TraverseDecl(record_decl);
  //  _os << "\n EntryFunctions found: " << _entryFunctions.size() << "\n";
  pass_ = 2;

  //    _os << "\n>>>> PASS 2\n";
  /// Pass 2:
  /// Get the entry function name from constructor
  success &= TraverseStmt(constructor_stmt_);
  pass_ = 3;

  /// Pass 3:
  /// Find the CXXMethodDecl* to the entry function
  success &= TraverseDecl(record_decl);
  pass_ = 4;
}

/* ! First visitor that is called
 * 	Find the constructor definition, and the Stmts* that has the code for it.
 * 	set the _constructorStmt pointer.
 * 	*/
bool DESCAM::GetClangProcess::VisitCXXMethodDecl(clang::CXXMethodDecl *md) {

  //Track all methods
  other_functions_.push_back(md);

  switch (pass_) {
    case 1: {
      /// Check if method is a constructor
      if (auto *cd = clangCastVisitor(md).GetCxxConstructorDecl()) {
        const clang::FunctionDecl *fd = nullptr;
        cd->getBody(fd);
        if (cd->hasBody()) {
          constructor_stmt_ = cd->getBody();
        }
      }
      break;
    }
    case 2:break;
    case 3: {
      /// Check if name is the same as in processMap
      for (auto &process: this->process_map_) {
        if (md->getNameAsString() == process.first) {
//          if (md != nullptr) {
//            process.second.first = md;
//          }
          assert(md);
          process.second.first = md;
        }
      }
      break;
    }
  }
  return true;
}

/*!
 * \brief second visitor that is called
 */
bool DESCAM::GetClangProcess::VisitMemberExpr(clang::MemberExpr *e) {
  switch (pass_) {
    case 2: {
      std::string memberName = e->getMemberDecl()->getNameAsString();
      if (memberName == "create_method_process") {
        process_type_ = PROCESS_TYPE::METHOD;
      } else if (memberName == "create_thread_process") {
        process_type_ = PROCESS_TYPE::THREAD;
      } else if (memberName == "create_cthread_process") {
        process_type_ = PROCESS_TYPE::CTHREAD;
      }
      break;
    }
    default:break;
  }
  return true;
}

/*!
 * \brief The third visitor that is called
 */
bool DESCAM::GetClangProcess::VisitStringLiteral(clang::StringLiteral *s) {
  switch (pass_) {
    case 2: {
      //Create new entry for process
      std::string processName = s->getString().str();
      auto innerEntry = std::pair<clang::CXXMethodDecl *, DESCAM::PROCESS_TYPE>(nullptr, process_type_);
      auto entry =
          std::pair<std::string, std::pair<clang::CXXMethodDecl *, DESCAM::PROCESS_TYPE> >(processName, innerEntry);

      /// Create the object to handle multiple entry functions.
      if (process_type_ != 0) {
        this->process_map_.insert(entry);
      }
      break;
    }
    default:break;
  }
  return true;
}

bool DESCAM::GetClangProcess::isValidProcess() const {
  if (this->process_map_.size() == 1) {
    auto process = (*this->process_map_.begin());
    if (process.second.second == DESCAM::PROCESS_TYPE::THREAD) {
      return true;
    } else TERMINATE("Process: " + process.first + " is not an SC_THREAD")
  } else TERMINATE(" Multiple processes defined. Only one allowed")
}

clang::CXXMethodDecl *DESCAM::GetClangProcess::getProcess() const {
  if (this->process_map_.size() == 1) {
    return this->process_map_.begin()->second.first;
  } else TERMINATE(" Zero or >2 processes defined. Exactly one process is required")
}
