//
// Created by tobias on 10.06.16.
//

#ifndef SCAM_ERRORMSG_H
#define SCAM_ERRORMSG_H

#include <string>
#include <vector>
namespace SCAM {


/*!
 * \brief Singelton that stores all error Msg during translation of systemc to SCAMs
 */
    class ErrorMsg {
    public:
        enum ErrorType {error,warning,information };

        struct Error {
            Error(const std::string msg, const std::string astMsg, const std::string file, const std::string loc, const std::vector<std::string>& errorLog):
                    msg(msg),
                    astMsg(astMsg),
                    file(file),
                    loc(loc),
                    errorLog(errorLog){};
            Error(const std::string msg):
                    msg(msg),
                    astMsg(""),
                    file(""),
                    loc(""){};

            const std::string msg;
            const std::string astMsg;
            const std::string file;
            const std::string loc;
            const std::vector<std::string> errorLog;

        };

        //
        static void clear(); //! Clears all errormsgs from the log

        //GETTER
        static ErrorMsg &getInstance();
        static std::vector<Error> getErrorList();

        //SETTER
        static void addErrorLog(std::string msg);
        static void addError(std::string msg, std::string astMsg);
        static bool hasError();
        //DELETED
        ErrorMsg(ErrorMsg const &) = delete;             // copy constructor is private
        ErrorMsg &operator=(ErrorMsg const &) = delete; // assignment operator is private
    private:
        //CONSTRUCTOR
        ErrorMsg() { };
        //Destructor
        ~ErrorMsg() { };

        //error&warning log
        std::vector<std::string> errorLog; //! Contains an entry for every feedback; is added to Error

        //list containing the error information
        std::vector<Error> errorList;

    };

}


#endif //SCAM_ERRORMSG_H
