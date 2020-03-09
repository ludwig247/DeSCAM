add_library(CommonHLS
            PropertySuiteHelper.cpp
            PropertyHelper.cpp
            OptimizerHLS.cpp
            PrintArrayStatements.cpp
            Constants.h
)

target_compile_options(CommonHLS PRIVATE -fPIC -O2 )