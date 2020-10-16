add_library(PrintHLS SHARED
        PrintHLS.cpp

        Common/Constants.h
        Common/OptimizerHLS.cpp
        Common/PrintArrayStatements.cpp
        Common/Utilities.cpp

        HLS/HLS.cpp
        HLS/PrintBitOperations.cpp
        #HLS/PrintFunction.cpp
        HLS/PrintReset.cpp
        HLS/PrintStatement.cpp
        HLS/PrintStmtCPP.cpp

        SynthesisScript/SynthesisScripts.cpp

        VHDLWrapper/PrintStmtVHDL.cpp
        VHDLWrapper/SignalFactory.cpp
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