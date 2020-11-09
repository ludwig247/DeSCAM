
add_library(PrintITL SHARED
        ConditionVisitor.cpp
        DatapathVisitor.cpp
        TimePointVisitor.cpp
        PrintITL.cpp)

target_link_libraries(PrintITL Model)
target_link_libraries(PrintITL global)
#target_compile_options(PrintITL PRIVATE -fno-rtti)