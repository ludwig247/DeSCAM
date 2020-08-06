macro (add_example)
    set(MACRO_ARG ${ARGN})
    list(LENGTH MACRO_ARG NUM_MACRO_ARG)
    set(test ${NUM_MACRO_ARG} LESS_EQUAL 2)

    if(${NUM_MACRO_ARG} LESS 1 OR ${NUM_MACRO_ARG} GREATER 3)
        message(FATAL_ERROR "wrong use of \"add_example\"!!!! You need to give at least the name of your example.")
    elseif(${NUM_MACRO_ARG} LESS 3)
        list(GET MACRO_ARG 0 FIRST_ARG)
#        list(GET MACRO_ARG 1 SECOND_ARG)
        if(IS_DIRECTORY "${CMAKE_SOURCE_DIR}/example/${FIRST_ARG}")
            if(EXISTS "${CMAKE_SOURCE_DIR}/example/${FIRST_ARG}/ESL")
                file(GLOB EXAMPLE_H "${FIRST_ARG}/ESL/*.h")
#                    message(STATUS "${first_arg}")
            else()
                file(GLOB EXAMPLE_H "${FIRST_ARG}/*.h")
#                message(STATUS "${EXAMPLE_H}")
            endif()
        else() #if new example: creates new directory tree for example and required CMakeLists
            create_directory(${FIRST_ARG})
        endif()
        list(APPEND EXAMPLE_NAMES_LIST ${FIRST_ARG})
    elseif(${NUM_MACRO_ARG} EQUAL 3)
        list(GET MACRO_ARG 0 FIRST_ARG)
#        list(GET MACRO_ARG 1 SECOND_ARG)
        list(GET MACRO_ARG 2 THIRD_ARG)
        if(IS_DIRECTORY "${CMAKE_SOURCE_DIR}/example/${THIRD_ARG}")
            if(EXISTS "${CMAKE_SOURCE_DIR}/example/${THIRD_ARG}/ESL")
                file(GLOB EXAMPLE_H "${THIRD_ARG}/ESL/*.h")
                #        message(STATUS "${EXAMPLE_H}")
            else()
                file(GLOB EXAMPLE_H "${THIRD_ARG}/*.h")
                #        message(STATUS "${EXAMPLE_H}")
            endif()
        else() #if new example: creates new directory tree for example and required CMakeLists
            create_directory(${THIRD_ARG})
        endif()
        list(APPEND EXAMPLE_NAMES_LIST ${THIRD_ARG})
    endif ()
list(APPEND EXAMPLE_H_LIST ${EXAMPLE_H}) #appends EXAMPLE_H to a list after each time the macro is called
endmacro(add_example)

function(create_directory)
    set(FUNCT_ARG ${ARGN})
    list(GET FUNCT_ARG 0 FIRST_ARG)
    message(WARNING "Given example directory ${FIRST_ARG} does not exist, add_example() will create a new example directory tree")
    set(EXAMPLE_NAME "${FIRST_ARG}_Simulation")
    file(MAKE_DIRECTORY ${CMAKE_SOURCE_DIR}/example/${FIRST_ARG}/ESL/env ${CMAKE_SOURCE_DIR}/example/${FIRST_ARG}/RTL/properties)
    file(WRITE ${CMAKE_SOURCE_DIR}/example/${FIRST_ARG}/ESL/env/CMakeLists.txt "file(GLOB ENV_SRC CONFIGURE_DEPENDS *.cpp *.hpp *.h)")
    file(WRITE ${CMAKE_SOURCE_DIR}/example/${FIRST_ARG}/CMakeLists.txt "add_subdirectory(ESL)")
#    file(APPEND ./CMakeLists.txt "#add_subdirectory(${FIRST_ARG})\n")
    configure_file ( #Creates new example header-file
            "templates/template_h.h.in"
            "${CMAKE_SOURCE_DIR}/example/${FIRST_ARG}/ESL/${FIRST_ARG}.h" @ONLY)
    configure_file ( #Creates CMakeLists for the ESL-folder
            "templates/New_Example_CMakeLists.txt.in"
            "${CMAKE_SOURCE_DIR}/example/${FIRST_ARG}/ESL/CMakeLists.txt" @ONLY)
    configure_file ( #Creates a sc_main.cpp for example
            "templates/template_sc_main.cpp.in"
            "${CMAKE_SOURCE_DIR}/example/${FIRST_ARG}/ESL/env/sc_main.cpp" @ONLY)
endfunction(create_directory)

macro(update_list)
#    message(STATUS "LIST: ${EXAMPLE_NAMES_LIST}")
    set(CMAKELISTS "${CMAKE_SOURCE_DIR}/example/add_example/CMakeLists.txt")
    file(STRINGS "${CMAKELISTS}" ADDED_EXAMPLES)
#   Wraps each Name in the list of names passed by add_example
#   to match with contents of the add_subdirectory-list in CMakeLists.txt:
    foreach(EXAMPLE_NAME_SUB ${EXAMPLE_NAMES_LIST})
        if(EXISTS "${CMAKE_SOURCE_DIR}/example/${EXAMPLE_NAME_SUB}/CMakeLists.txt")
            set(EXAMPLE_SUB_LIST ${EXAMPLE_SUB_LIST} "add_subdirectory(${EXAMPLE_NAME_SUB})\n")
        endif()
    endforeach()
string (REGEX REPLACE ";" "" EXAMPLE_SUB_LIST "${EXAMPLE_SUB_LIST}")

#    message(STATUS ${EXAMPLE_SUB_LIST})

#   Remakes the CMakeLists.txt, updating the add_subdirectory-list
configure_file (
#        "./add_example/templates/CMakeLists.txt.in"
        "./templates/CMakeLists.txt.in"
        "${CMAKE_SOURCE_DIR}/example/CMakeLists.txt" @ONLY)

endmacro(update_list)