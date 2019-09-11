//
// Created by ludwig on 05.07.16.
//

#ifndef SCAM_PATH_H
#define SCAM_PATH_H


#include <vector>
#include <Model.h>

namespace SCAM{
 /*!
  * \brief Represents a path, that is:
  * Section, Next Section, Conditions within the path(one for each branch) and all stmts among a path
  *
  *
  */

class Path {

public:
    Path(std::string state);
    Path(const Path& path); //Copy
    Path(const Path& path,const std::vector<SCAM::Stmt*>& stmtList); //Copies everything except of the stmtList
    virtual ~Path();

    //Add
    void addStmt(SCAM::Stmt *stmt);
    void addCondition(Expr *stmt);

    // GETTER
    std::string getSection() const;
    std::string getNextSection() const;
    std::string getSubState() const;
    std::string getSubNext() const;
    int getPathId() const;

    static void resetPathCnt();

    const std::vector<Expr *> &getConditionList() const;
    const std::vector<SCAM::Assignment*>& getDataPathList() const;
    const std::vector<Expr *> &getCommunicationConditionList() const;
    const std::map<Stmt *, std::string> &getStmtNextstateMap();
    const std::vector<Stmt *> &getStmtList() const;
    bool isWait() const;
    //Setter
    void setSection(const std::string state);
    void setWait(bool wait);
    void setNextSection(const std::string nextstate);
    void setSubSection(const std::string substate);
    void setSubNext(const std::string substate);
    void setCommunicationCondition(PortOperand *portOperand, bool ready);
    void setConditionList(const std::vector<SCAM::Expr*>& conditionList);
    void setDataPathList(const std::vector<SCAM::Assignment *> &dataPathList);
    void setCommunicationConditionList(const std::vector<Expr *> &communicationConditionList);

    Return *getReturnValue() const;

    void setReturnValue(Return *returnValue);

    //Print out
    std::string print() ;
    Path& operator+=(const Path& newPath);
    const bool operator < ( const Path &p ) const;


private:
    std::string  state;
    std::string  nextstate;
    std::string  subState; //! Current state is a substate
    std::string  subNext;  //! Nextstate is a substate
    static int pathCnt; //! Counts the number of existing paths
    int pathId;
    bool wait;
    Return * returnValue;

    std::vector<SCAM::Expr *> communicationConditionList; //! Contains an entry with port == true/false for port sync
    std::vector<SCAM::Expr*> conditionList; //! Contains an entry for every branch within the path
    std::vector<SCAM::Assignment*> dataPathList; //! Contains an entry for every change of value in a variable
    std::map<std::string,SCAM::Expr*> dataPathMap; //! Contains an entry: variable = assigned_value
    std::vector<SCAM::Stmt*> stmtList;

    std::map<SCAM::Stmt*,std::string> stmtNextstateMap; //! Contains an entry : stmt := target nextstate


};
    inline SCAM::Path operator+(SCAM::Path lhs, const SCAM::Path& rhs)
    {
        lhs += rhs;
        return lhs;
    }
}

#endif //SCAM_PATH_H
