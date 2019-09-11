//
// Created by ludwig on 28.09.15.
//

#include "FindProcess.h"

SCAM::FindProcess::FindProcess(clang::CXXRecordDecl* recordDecl):
        recordDecl(recordDecl),
        processType(PROCESS_TYPE ::NONE),
        _constructorStmt (NULL),
        _pass(1){

    /// Pass 1:
    /// Find the constructor definition, and the Stmt* that has the code for it.
    /// Set the _constructorStmt pointer.
    //  _os << "\n>>>> PASS 1\n";

    TraverseDecl (recordDecl);
    //  _os << "\n EntryFunctions found: " << _entryFunctions.size() << "\n";
    _pass = 2;

    //    _os << "\n>>>> PASS 2\n";
    /// Pass 2:
    /// Get the entry function name from constructor
    TraverseStmt (_constructorStmt);
    _pass = 3;

    /// Pass 3:
    /// Find the CXXMethodDecl* to the entry function
    TraverseDecl (recordDecl);
    _pass = 4;

}

SCAM::FindProcess::~FindProcess() {

}

/* ! First visitor that is called
 * 	Find the constructor definition, and the Stmts* that has the code for it.
 * 	set the _constructorStmt pointer.
 * 	*/
bool SCAM::FindProcess::VisitCXXMethodDecl(clang::CXXMethodDecl *md) {

    //Track all methods
    otherFunctions.push_back (md);

    switch (_pass){
        case 1:{
            /// Check if method is a constructor
            if (clang::CXXConstructorDecl * cd = clang::dyn_cast<clang::CXXConstructorDecl>(md))            {
                const clang::FunctionDecl * fd = NULL;
                cd->getBody (fd);
                if (cd->hasBody ()){
                    _constructorStmt = cd->getBody ();
                }
            }
            break;
        }
        case 2:break;
        case 3:{
            /// Check if name is the same as in processMap
            for (auto& process: this->processMap){
                if (md->getNameAsString () == process.first){
                    if (md != NULL){
                        process.second.first = md;
                    }
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
bool SCAM::FindProcess::VisitMemberExpr(clang::MemberExpr *e) {
    switch (_pass){
        case 2:{
            std::string	memberName = e->getMemberDecl ()->getNameAsString ();
            if (memberName == "create_method_process"){
                processType = PROCESS_TYPE ::METHOD;
            }
            else if (memberName == "create_thread_process"){
                processType = PROCESS_TYPE ::THREAD;
            }
            else if (memberName == "create_cthread_process"){
                processType = PROCESS_TYPE ::CTHREAD;
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
bool SCAM::FindProcess::VisitStringLiteral(clang::StringLiteral *s){
    switch (_pass){
        case 2:{
            //Create new entry for process
            std::string processName = s->getString();
            auto innerEntry = std::pair<clang::CXXMethodDecl*, SCAM::PROCESS_TYPE>(nullptr, processType);
            auto entry = std::pair<std::string, std::pair<clang::CXXMethodDecl*, SCAM::PROCESS_TYPE> >(processName,innerEntry);

            /// Create the object to handle multiple entry functions.
            if (processType != 0){
                this->processMap.insert(entry);
            }
            break;
        }
        default:break;
    }
    return true;
}


const std::map<std::string, std::pair<clang::CXXMethodDecl *, SCAM::PROCESS_TYPE>> & SCAM::FindProcess::getProcessMap() {
    return this->processMap;
}

std::vector<clang::CXXMethodDecl *> SCAM::FindProcess::getOtherFunctions() {
    return this->otherFunctions;
}
