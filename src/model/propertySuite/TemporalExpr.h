//
// Created by lucas on 16.01.20.
//

#ifndef DESCAM_TEMPORALEXPR_H
#define DESCAM_TEMPORALEXPR_H

#include <vector>
#include <Stmt.h>
#include <Timepoint.h>

namespace SCAM {
    /*!
     * \brief statement of type ->  at t: xyz = 3 or during[t_start,t_end]: xyz = 3
     *
     * 
     */
    class TemporalExpr {

    public:
        enum class Type {
            AT, DURING
        };

        TemporalExpr() = delete;
        TemporalExpr(Expr *timepoint, Stmt *statement);
        TemporalExpr(Expr *t_start, Expr *t_end, Stmt *statement);

        Type getType() const;

        Stmt *getStatement() const;

        const std::vector<Expr *> &getTimepointList() const;

        const std::string &getFreezeAt() const;

        void setFreezeAt(const std::string &freezeAt);

        bool isAt();

        bool isDuring();

        // Serialization
        friend class Serializer;

    private:

        Type type;
        std::vector<Expr *> timepointList;
        Stmt *statement;

        std::string freezeAt = "_at_t"; //! For commitment: xyz = value@freezeAt

    };

}

#endif //DESCAM_TEMPORALEXPR_H
