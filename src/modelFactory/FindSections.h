//
// Created by tobias on 19.11.15.
//

#ifndef SCAM_FINDSTATES_H
#define SCAM_FINDSTATES_H


#include <clang/AST/RecursiveASTVisitor.h>
#include <map>

namespace SCAM {
    bool containsSubstring(std::string, std::string);


    /*
     * Search through the AST and returns a vector with all possible sections defined in the section-enum
     */

    class FindSections : public clang::RecursiveASTVisitor<FindSections> {
    public:
        FindSections(clang::CXXRecordDecl *recordDecl);
        virtual bool VisitCXXConstructorDecl(clang::CXXConstructorDecl* constructorDecl);
        virtual bool VisitDeclRefExpr(clang::DeclRefExpr* declRefExpr);
        virtual bool VisitEnumDecl(clang::EnumDecl *enumDecl);
        virtual bool VisitFieldDecl(clang::FieldDecl *enumDecl);


        std::vector<std::string> getSectionList();
        std::string getInitialState();
        bool hasSections(); //! Returns true, if States and state variable are correct
        std::pair<std::string,clang::FieldDecl*> getStateVar();
        std::pair<std::string,clang::FieldDecl*> getNextStateVar();

    private:
        std::vector<std::string> sectionList; //! List of StateNames

        std::pair<std::string,clang::FieldDecl*> sectionVar; //! Contains the current state of the system
        std::pair<std::string,clang::FieldDecl*> nextSectionVar; //!Contains the next state of the system
        int pass;
        bool hasSectionVar;
        bool hasNextSectionVar;
        bool hasSectionEnum;
        std::string initialSection; //! InitialValue of states; nextstate==state
    };
}


#endif //SCAM_FINDSTATES_H
