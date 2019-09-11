project(parseAML C CXX)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

find_package(BISON 3.0.4 REQUIRED)
find_package(FLEX 2.5 REQUIRED)

BISON_TARGET(MyParser aml_parser.ypp ${CMAKE_SOURCE_DIR}/src/ParseAML/aml_parser.cpp)
FLEX_TARGET(MyScanner aml_scanner.lpp ${CMAKE_SOURCE_DIR}/src/ParseAML/aml_scanner.cpp)

ADD_FLEX_BISON_DEPENDENCY(MyScanner MyParser)


set(SOURCE_FILES
        ${BISON_MyParser_OUTPUTS}
        ${FLEX_MyScanner_OUTPUTS}
        aml_driver.cpp)

set (BISON_EXTRA_HEADERS
        ${CMAKE_SOURCE_DIR}/src/ParseAML/position.hh
        ${CMAKE_SOURCE_DIR}/src/ParseAML/location.hh
        ${CMAKE_SOURCE_DIR}/src/ParseAML/stack.hh)
set_property(DIRECTORY APPEND PROPERTY ADDITIONAL_MAKE_CLEAN_FILES  "${BISON_EXTRA_HEADERS}")


include_directories(${CMAKE_SOURCE_DIR})
add_library(AMLparser ${SOURCE_FILES})

set(GLOBAL_FILES
        ${CMAKE_SOURCE_DIR}/src/global/ErrorMsg.cpp
        ${CMAKE_SOURCE_DIR}/src/global/DataTypes.cpp
        ${CMAKE_SOURCE_DIR}/src/global/CommandLineParameter.cpp
        ${CMAKE_SOURCE_DIR}/src/global/ModelGlobal.h
        ${CMAKE_SOURCE_DIR}/src/global/ExprTranslator.cpp
        ${CMAKE_SOURCE_DIR}/src/global/CommandlineControl.cpp)


add_executable(ParseAML main.cpp ${GLOBAL_FILES})

target_link_libraries(ParseAML AMLparser)
target_link_libraries(ParseAML ITLSynth)
target_link_libraries(ParseAML VHDLSynth)
target_link_libraries(ParseAML SynthVHDL)
target_link_libraries(ParseAML PromelaSynth)
target_link_libraries(ParseAML PropertySynth)
target_link_libraries(ParseAML Model)
target_link_libraries(ParseAML Stmts)
target_link_libraries(ParseAML z3)
target_link_libraries(ParseAML OperationsToDot) 
