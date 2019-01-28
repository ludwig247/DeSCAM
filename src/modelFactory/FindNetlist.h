#ifndef _NETLIST_GEN_H_
#define _NETLIST_GEN_H_

#include "clang/AST/RecursiveASTVisitor.h"
#include <map>

namespace SCAM {

    /*!
     * \brief Searches within sc_main for binding of ports
     *     port = new port;
     *     module.portA.bind(port)
     *     //TODO: redo traversing of elements -> more visitors instead of dyn_cast
     */
    class FindNetlist : public clang::RecursiveASTVisitor<FindNetlist> {
    public:
        FindNetlist(clang::FunctionDecl *);
        FindNetlist(const FindNetlist &);
        ~FindNetlist();

        virtual bool VisitCXXOperatorCallExpr(clang::CXXOperatorCallExpr *ce);

        //GETTER
        std::map<std::string,std::string> getInstanceMap();
        std::map<std::pair<std::string,std::string>,clang::DeclRefExpr*> getChannelMap();


    private:
        int _pass;
        std::map<std::string,std::string> _instanceMap; //! <instance_name, sc_module>
        std::map<std::pair<std::string,std::string>,clang::DeclRefExpr*> _channelMap; //! <<Instance,Port>,channelDecl >
    };
}
#endif
