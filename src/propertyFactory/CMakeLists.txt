add_library(propertyFactory SHARED
        CreatePropertySuite.cpp
        TrueOperation.cpp
        PropertyFactory.cpp )

target_link_libraries(propertyFactory Model)