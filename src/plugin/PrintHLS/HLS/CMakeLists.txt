add_library(HLS
            HLS.cpp
            PrintBitOperations.cpp
            #OptimizerHLS.cpp
            #PrintArrayStatements.cpp
            PrintStatement.cpp
            PrintReset.cpp
            Utilities.cpp)

target_compile_options(HLS PRIVATE -fPIC -O2 )