set(PROPERTY_SUITE_FILES
        AbstractMacro.cpp
        AbstractProperty.cpp
        FunctionMacro.cpp
        #OperationProperty.cpp
        Property.cpp
        PropertyConstraint.cpp
        PropertyMacro.cpp
        PropertySuite.cpp
        #ResetProperty.cpp
        #WaitProperty.cpp
        TemporalExpr.cpp)
add_library(propertySuite ${PROPERTY_SUITE_FILES})