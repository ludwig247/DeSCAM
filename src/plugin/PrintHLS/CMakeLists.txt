add_library(PrintHLS SHARED
        PrintHLS.cpp

        Common/OptimizerHLS.cpp
        Common/PrintArrayStatements.cpp
        Common/PropertyHelper.cpp
        Common/PropertySuiteHelper.cpp
        Common/Constants.h

        HLS/HLS.cpp
        HLS/PrintBitOperations.cpp
        HLS/PrintFunction.cpp
        HLS/PrintReset.cpp
        HLS/PrintStatement.cpp
        HLS/Utilities.cpp

        SynthesisScript/SynthesisScripts.cpp

        VHDLWrapper/PrintBitOperations.cpp
        VHDLWrapper/PrintReset.cpp
        VHDLWrapper/PrintStatement.cpp
        VHDLWrapper/SignalFactory.cpp
        VHDLWrapper/Utilities.cpp
        VHDLWrapper/VHDLWrapper.cpp
        VHDLWrapper/VHDLWrapperMCO.cpp
        VHDLWrapper/VHDLWrapperSCO.cpp
)

target_include_directories(PrintHLS
    PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/Common
    ${CMAKE_CURRENT_SOURCE_DIR}/HLS
    ${CMAKE_CURRENT_SOURCE_DIR}/SynthesisScript
    ${CMAKE_CURRENT_SOURCE_DIR}/VHDLWrapper
)