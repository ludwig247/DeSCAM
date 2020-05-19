//
// Created by ibrahim on 19.03.20.
//

#ifndef DESCAM_LOCATIONINFO_H
#define DESCAM_LOCATIONINFO_H

#include <iostream>

namespace SCAM {

/**
 * \brief holds basic statement information such as to which file it belongs and at what line row/column number it can be found in that file.
 */

    class LocationInfo {
    public:
        LocationInfo() = default;

        LocationInfo(const std::string &stmt, const std::string &file, int rowStartNumber, int rowEndNumber,
                     int columnStartNumber,
                     int columnEndNumber);

        const std::string &getFile();

        const std::string &getStmt();

        int getRowStartNumber();

        int getRowEndNumber();

        int getColumnStartNumber();

        int getColumnEndNumber();

        inline void setInfo(const std::string &stmt, const std::string &file, int rowStartNumber, int rowEndNumber,
                            int columnStartNumber,
                            int columnEndNumber);

        inline void setFile(const std::string &file);

        inline void setStmt(const std::string &stmt);

        inline void setRowStartNumber(int rowStartNumber);

        inline void setRowEndNumber(int rowEndNumber);

        inline void setColumnStartNumber(int columnStartNumber);

        inline void setColumnEndNumber(int columnEndNumber);

        bool operator==(const LocationInfo &other) const;

    private:
        std::string stmt = "", fileDir = "";
        int rowStartNumber = 0, rowEndNumber = 0, columnStartNumber = 0, columnEndNumber = 0;

    };
}

#endif //DESCAM_LOCATIONINFO_H
