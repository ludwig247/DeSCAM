//
// Created by ibrahim on 19.03.20.
//

#ifndef DESCAM_STMTLOCATIONINFO_H
#define DESCAM_STMTLOCATIONINFO_H

#include <iostream>

namespace SCAM {

/**
 * \brief holds basic statement information such as to which file it belongs and at what line row/column number it can be found in that file.
 */

    class StmtLocationInfo {
    public:
        StmtLocationInfo() = default;

        StmtLocationInfo(const std::string &file, int rowStartNumber, int rowEndNumber, int columnStartNumber,
                         int columnEndNumber);

        const std::string &getFile();

        int getRowStartNumber();

        int getRowEndNumber();

        int getColumnStartNumber();

        int getColumnEndNumber();

        void setInfo(const std::string &file, int rowStartNumber, int rowEndNumber, int columnStartNumber,
                     int columnEndNumber);

        void setFile(const std::string &file);

        void setRowStartNumber(int rowStartNumber);

        void setRowEndNumber(int rowEndNumber);

        void setColumnStartNumber(int columnStartNumber);

        void setColumnEndNumber(int columnEndNumber);

    private:
        std::string fileDir = "";
        int rowStartNumber = 0, rowEndNumber = 0, columnStartNumber = 0, columnEndNumber = 0;

    };
}

#endif //DESCAM_STMTLOCATIONINFO_H
