set(PROPERTY_SUITE_FILES
        AbstractMacro.cpp
        AbstractProperty.cpp
        FunctionMacro.cpp
        OperationProperty.cpp
        PropertyConstraint.cpp
        PropertyMacro.cpp
        PropertySuite.cpp
        ResetProperty.cpp
        WaitProperty.cpp TemporalExpr.cpp TemporalExpr.h)
add_library(propertySuite ${PROPERTY_SUITE_FILES})