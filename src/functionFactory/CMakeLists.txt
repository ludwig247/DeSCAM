add_library(functionFactory SHARED
        Path.cpp
        FindPathsToReturn.cpp
        FunctionFactory.cpp)
target_link_libraries(functionFactory cfgFactory)


