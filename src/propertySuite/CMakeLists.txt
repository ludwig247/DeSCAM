set(PROPERTY_SUITE_FILES
        AbstractMacro.cpp
        AbstractProperty.cpp
        FunctionMacro.cpp
        OperationProperty.cpp
        PropertyConstraint.cpp
        PropertyMacro.cpp
        PropertySuite.cpp
        ResetProperty.cpp
        WaitProperty.cpp)
add_library(propertySuite SHARED ${PROPERTY_SUITE_FILES})