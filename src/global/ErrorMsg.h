//
// Created by tobias on 10.06.16.
//

#ifndef SCAM_ERRORMSG_H
#define SCAM_ERRORMSG_H

#include <string>
#include <vector>
#include <map>

namespace SCAM {


/*!
 * \brief Singelton that stores all error Msg during translation of systemc to SCAMs
 */
    class ErrorMsg {
    public:
        enum ErrorType {
            error, warning, information
        };

        struct Error {
            Error(const std::string statement, const std::string astMsg ="", const std::string file="", const std::string lineNumber="", const std::map<std::string,std::string> &errorMsgs={}) :
                    statement(statement),
                    astMsg(astMsg),
                    file(file),
                    lineNumber(lineNumber),
                    errorMsgs(errorMsgs){};
            const std::string statement;
            const std::string astMsg;
            const std::string file;
            const std::string lineNumber;
            const std::map<std::string,std::string> errorMsgs;
        };

        //
        static void clear(); //! Clears all errormsgs from the log

        //GETTER
        static ErrorMsg &getInstance();

        static std::vector<Error> getErrorList();

        //SETTER
        static void addErrorLog(std::string msg, std::string severityLevel);

        static void addError(std::string msg, std::string astMsg, std::string file = "", std::string loc="");


        static bool hasError();

        //DELETED
        ErrorMsg(ErrorMsg const &) = delete;             // copy constructor is private
        ErrorMsg &operator=(ErrorMsg const &) = delete; // assignment operator is private
    private:
        //CONSTRUCTOR
        ErrorMsg() {};

        //Destructor
        ~ErrorMsg() {};

        //error&warning log
        std::map<std::string,std::string> errorMsgs; //! Contains an entry for every feedback; is added to Error

        //list containing the error information
        std::vector<Error> errorList;

    };

}


#endif //SCAM_ERRORMSG_H
