//
// Created by mi-alkoudsi 19.03.2020.
//

#ifndef SCAM_ERRORMSG_H
#define SCAM_ERRORMSG_H

#include <string>
#include <vector>
#include <unordered_set>
#include <memory>
#include "LoggerMsg.h"
#include "LoggerSink.h"
#include "TextFormatter.h"
#include "LoggingFilter.h"


namespace SCAM {

/*!
 * \brief A singelton that stores and reports logging messages during the creation of the SystemC PPA model
 */
    class Logger {
    public:

        static Logger &getInstance();

        static void setTerminate();

        static bool isTerminate();

        static void addMsg(LoggerMsg);

        static bool hasError();

        static void clear();

        static void addSink(std::shared_ptr<SCAM::LoggerSink> sink);

        static void setTextFormatOptions(SCAM::TextFormatter::FormatOptions formatOptions);

        static void setFilteringOptions(std::initializer_list<LoggingFilter::FilterOptions> filterOptions);

        static void setCurrentProcessedLocation(LoggerMsg::ProcessedLocation currentProcessedLocation);

        static LoggerMsg::ProcessedLocation getCurrentProcessedLocation();

        static void log();

        //DELETED
        Logger(Logger const &) = delete;             // copy constructor is private
        Logger &operator=(Logger const &) = delete; // assignment operator is private
    private:
        //CONSTRUCTOR
        Logger() = default;

        //Destructor
        ~Logger() = default;

        // a vector containing the logger messages
        std::vector<LoggerMsg> msgsVector{};
        // a vector holding the logger sinks
        std::vector<std::shared_ptr<LoggerSink>> sinksVector{};
        //a flag indicating whether termination is necessary due to errors
        static bool terminate;
        //logging options set
        std::unordered_set<LoggingFilter::FilterOptions> filterOptions;
        //log messages formatter
        TextFormatter::FormatOptions formatOptions = TextFormatter::FormatOptions::JSON;
        // a variable to track the violation location while processing a module
        LoggerMsg::ProcessedLocation currentProcessedLocation = LoggerMsg::ProcessedLocation::Parsing;

    };
}


#endif //SCAM_ERRORMSG_H
