set(PROPERTY_SUITE_FILES
        AbstractMacro.cpp
        AbstractProperty.cpp
        FunctionMacro.cpp
        Property.cpp
        PropertyConstraint.cpp
        PropertyMacro.cpp
        PropertySuite.cpp
        TemporalExpr.cpp)
add_library(propertySuite SHARED ${PROPERTY_SUITE_FILES})