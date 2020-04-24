//
// Created by mi-alkoudsi on 13.04.20.
//

#ifndef DESCAM_LOGGINGFILTER_H
#define DESCAM_LOGGINGFILTER_H

#include <vector>
#include <set>
#include "LoggerMsg.h"

namespace SCAM {

    class LoggingFilter {
    public:
        enum class FilterOptions : char {
            showAllMsgs,
            showSyntaxMsgs,
            showCompilanceMsgs,
            showBehaviorMsgs,
            showVariableMsgs,
            showFunctionMsgs,
            showPortsMsgs,
            showGlobalConstantMsgs
        };

        static std::vector<LoggerMsg> applyFilters(const std::vector<LoggerMsg> &msgsVector,
                                                   const std::set<LoggingFilter::FilterOptions> &filterOptions) {
            if (filterOptions.empty() || filterOptions.find(FilterOptions::showAllMsgs) != filterOptions.end())
                return msgsVector;
            else {
                std::vector<LoggerMsg> filteredMsgsVector{};
                for (auto msg : msgsVector) {
                    if (filterOptions.find(FilterOptions::showSyntaxMsgs) == filterOptions.end() &&
                        msg.getViolationType() == "Syntax")
                        continue;
                    if (filterOptions.find(FilterOptions::showCompilanceMsgs) == filterOptions.end()) {
                        if (filterOptions.find(FilterOptions::showBehaviorMsgs) == filterOptions.end() &&
                            msg.getProcessedLocation() == LoggerMsg::ProcessedLocation::Behavior)
                            continue;
                        else if (filterOptions.find(FilterOptions::showVariableMsgs) == filterOptions.end() &&
                                 msg.getProcessedLocation() == LoggerMsg::ProcessedLocation::Variables)
                            continue;
                        else if (filterOptions.find(FilterOptions::showFunctionMsgs) == filterOptions.end() &&
                                 msg.getProcessedLocation() == LoggerMsg::ProcessedLocation::Functions)
                            continue;
                        else if (filterOptions.find(FilterOptions::showPortsMsgs) == filterOptions.end() &&
                                 msg.getProcessedLocation() == LoggerMsg::ProcessedLocation::Ports)
                            continue;
                        else if (filterOptions.find(FilterOptions::showGlobalConstantMsgs) == filterOptions.end() &&
                                 msg.getProcessedLocation() == LoggerMsg::ProcessedLocation::GlobalConstants)
                            continue;
                    }
                    filteredMsgsVector.push_back(msg);
                }
                return filteredMsgsVector;
            }
        }

    private:
        LoggingFilter() = default;

        ~LoggingFilter() = default;
    };
}
#endif //DESCAM_LOGGINGFILTER_H
