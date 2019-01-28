#ifndef _FIND_PORTS_H_
#define _FIND_PORTS_H_


#include <map>
#include <clang/AST/ASTContext.h>
#include "clang/AST/RecursiveASTVisitor.h"
#include "enums.h"

namespace SCAM {

    /**
     * \brief: Finds all ports of a given Module
     *
     * Ports are Members of the module, they might also be findable with FindMembers
     */
    class FindPorts : public clang::RecursiveASTVisitor<FindPorts> {
    public:
        FindPorts(clang::CXXRecordDecl *recordDecl,const clang::ASTContext& context);
        ~FindPorts();
        //Visitor
        virtual bool VisitFieldDecl(clang::FieldDecl* fieldDecl);

        //GETTER
        const std::map<std::string, std::string> &getInPortMap() const;
        const std::map<std::string, std::string> &getOutPortMap() const;

        const std::map<std::string, std::string> &getInSharedPortMap() const;
        const std::map<std::string, std::string> &getOutSharedPortMap() const;

        const std::map<std::string, std::string> &getMasterInPortMap() const;
        const std::map<std::string, std::string> &getMasterOutPortMap() const;

        const std::map<std::string, std::string> &getSlaveInPortMap() const;

        const std::map<std::string, std::string> &getSlaveOutPortMap() const;

    private:
        const clang::ASTContext& context;
        std::map<std::string,std::string > inPortMap; //! Map containing an entry for every rendezVouz in-port,type
        std::map<std::string,std::string > outPortMap; //! Map containing an entry for every rendezVouz out-port,type
        std::map<std::string,std::string > masterInPortMap; //! Map containing an entry for every master in-port,type
        std::map<std::string,std::string > masterOutPortMap; //! Map containing an entry for every master out-port,type
        std::map<std::string,std::string > slaveInPortMap; //! Map containing an entry for every slave in-port,type
        std::map<std::string,std::string > slaveOutPortMap; //! Map containing an entry for every slave out-port,type
        std::map<std::string,std::string > inSharedPortMap; //! Map containing an entry for every shared  in-port,type
        std::map<std::string,std::string > outSharedPortMap; //! Map containing an entry for every shared out-port,type
        int pass;

        //Helper
        std::vector<std::string> portTemplates; //! sc_port<sc_fifo_in_if<_Bool> > Contains an entry for each Template used {sc_port,sc_fifo_in,_Bool}
        std::map<std::string,clang::CXXRecordDecl*> compoundDataTypeMap;
        void recursiveTemplateVisitor(clang::QualType qualType);
    };



}
#endif
