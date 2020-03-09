add_library(VHDLWrapper
            VHDLWrapper.cpp
            VHDLWrapperOneClkCycle.cpp
            VHDLWrapperMultiClkCycle.cpp
            Utilities.cpp
            PrintStatement.cpp
            PrintReset.cpp
            PrintBitOperations.cpp
            #OperationModuleInterface.cpp
            SignalFactory.cpp
)

target_compile_options(VHDLWrapper PRIVATE -fPIC -O2 )

