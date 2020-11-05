
file(GLOB OPERATIONMISCELLANEOUS "OperationMiscellaneous/*.cpp")
file(GLOB OPERATIONOPTIMIZATIONS "OperationOptimizations/*.cpp")

add_library(operationFactory SHARED
        ${OPERATIONDATASTRUCTURE}
        ${OPERATIONMISCELLANEOUS}
        ${OPERATIONOPTIMIZATIONS}
        FindOperations.cpp
        CreateOperations.cpp
        CreateOperationsSlave.cpp
        ReconstructOperations.cpp
        ValidOperations.cpp
        OperationFactory.cpp
        OperationOptimizations/TernaryOptimizer.cpp
        )


target_link_libraries(operationFactory propertySuite)
#target_compile_options(operationFactory PRIVATE -fno-rtti)
