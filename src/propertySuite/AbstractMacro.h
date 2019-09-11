//
// Created by deutschmann on 23.11.18.
//

#ifndef PROJECT_ABSTRACTMACRO_H
#define PROJECT_ABSTRACTMACRO_H

#include "DataType.h"
#include "Stmt.h"


namespace SCAM {

    class AbstractMacro {

    public:

        // Constructor
        AbstractMacro(const std::string &name, const DataType * type);

        // Getter
        const std::string &getName() const;
        const DataType * getDataType() const;
        Stmt * getExpression();

        // Setter
        void setExpression(Stmt * expr);

        // Active (used to specify, if macro is commented out)
        const bool &isActive() const;
        void activateMacro();
        void deactivateMacro();

    private:

        const std::string name;
        const DataType * dataType;
        Stmt* expression;
        bool active;

    };

}

#endif //PROJECT_ABSTRACTMACRO_H