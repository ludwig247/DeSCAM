add_library(PrintXML SHARED
        PrintXML.cpp
        #PrintXML.h
        DerivedExport.h)

# Boost library linking (for serialization with PrintXML)
target_include_directories(PrintXML PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}
        ${Boost_INCLUDE_DIRS})

target_link_libraries(PrintXML ${Boost_LIBRARIES})

