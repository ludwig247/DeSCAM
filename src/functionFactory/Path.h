//
// Created by ludwig on 05.07.16.
//

#ifndef SCAM_PATH_H
#define SCAM_PATH_H


#include <vector>
#include <Model.h>

namespace DESCAM{
 /*!
  * \brief Used to store paths to returns within functions
  */

class Path {

public:
    Path() = default;
    Path(const Path& path); //Copy
    Path(const Path& path,const std::vector<DESCAM::Stmt*>& stmtList); //Copies everything except of the stmtList
    virtual ~Path();

    Path& operator+=(const Path& newPath);

    //Add
    void addStmt(DESCAM::Stmt *stmt);
    const std::vector<Stmt *> &getStmtList() const;

private:
    std::vector<DESCAM::Stmt*> stmtList;
};
    inline DESCAM::Path operator+(DESCAM::Path lhs, const DESCAM::Path& rhs)
    {
        lhs += rhs;
        return lhs;
    }
}

#endif //SCAM_PATH_H
