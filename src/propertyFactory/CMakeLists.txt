add_library(propertyFactory SHARED
        CreatePropertySuite.cpp
        TrueOperation.cpp
        PropertyFactory.cpp )

target_link_libraries(propertyFactory Model)
target_compile_options(propertyFactory PRIVATE -fno-rtti)