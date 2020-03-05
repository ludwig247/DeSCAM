#include( CMakeParseArguments )

message(STATUS "${TESTS}")


macro (add_example)
    set(macro_arg ${ARGN})
    list(LENGTH macro_arg num_macro_arg)
    if(${num_macro_arg} LESS 1 OR ${num_macro_arg} GREATER 3)
        MESSAGE(FATAL_ERROR "wrong use of \"add_example\"!!!! You need to give at least the name of your example.")
    elseif(${num_macro_arg} EQUAL 1)
        list(GET macro_arg 0 first_arg)
        MESSAGE(WARNING "You didn't give a description to your example ${first_arg}")
        if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${first_arg}/ESL")
            file(GLOB EXAMPLE_H "${first_arg}/ESL/*.h")
            #        message(STATUS "${EXAMPLE_H}")
        else()
            file(GLOB EXAMPLE_H "${first_arg}/*.h")
            #        message(STATUS "${EXAMPLE_H}")
        endif()
        foreach(EXAMPLE_H_FILE ${EXAMPLE_H})
#            get_filename_component(EXAMPLE_H_FILE_NAME ${EXAMPLE_H_FILE} NAME)
            set(INCLUDE_HEADER "${INCLUDE_HEADER}#include \"${EXAMPLE_H_FILE}\" \n")
        endforeach()
        foreach(TEST_DIRS ${TESTS})
            configure_file (
                    "tests.h.in"
                    "${PROJECT_SOURCE_DIR}/tests/${TEST_DIRS}/TestCases/tests.h"
            )
        endforeach()
    elseif(${num_macro_arg} EQUAL 2)
        list(GET macro_arg 0 first_arg)
        list(GET macro_arg 1 second_arg)

        if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${first_arg}/ESL")
            file(GLOB EXAMPLE_H "${first_arg}/ESL/*.h")
            #        message(STATUS "${EXAMPLE_H}")
        else()
            file(GLOB EXAMPLE_H "${first_arg}/*.h")
            #        message(STATUS "${EXAMPLE_H}")
        endif()
        foreach(EXAMPLE_H_FILE ${EXAMPLE_H})
#            get_filename_component(EXAMPLE_H_FILE_NAME ${EXAMPLE_H_FILE} NAME)
            set(INCLUDE_HEADER "${INCLUDE_HEADER}#include \"${EXAMPLE_H_FILE}\" \n")
        endforeach()
        foreach(TEST_DIRS ${TESTS})
            configure_file (
                    "tests.h.in"
                    "${PROJECT_SOURCE_DIR}/tests/${TEST_DIRS}/TestCases/tests.h"
            )
        endforeach()
    elseif(${num_macro_arg} EQUAL 3)
        list(GET macro_arg 0 first_arg)
        list(GET macro_arg 1 second_arg)
        list(GET macro_arg 2 third_arg)

        if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${third_arg}/ESL")
            file(GLOB EXAMPLE_H "${third_arg}/ESL/*.h")
            #        message(STATUS "${EXAMPLE_H}")
        else()
            file(GLOB EXAMPLE_H "${third_arg}/*.h")
            #        message(STATUS "${EXAMPLE_H}")
        endif()
        foreach(EXAMPLE_H_FILE ${EXAMPLE_H})
#            get_filename_component(EXAMPLE_H_FILE_NAME ${EXAMPLE_H_FILE} NAME)
            set(INCLUDE_HEADER "${INCLUDE_HEADER}#include \"${EXAMPLE_H_FILE}\" \n")
        endforeach()
        foreach(TEST_DIRS ${TESTS})
            configure_file (
                    "tests.h.in"
                    "${PROJECT_SOURCE_DIR}/tests/${TEST_DIRS}/TestCases/tests.h"
            )
        endforeach()
       message(STATUS "add_example ${third_arg}")

    endif ()

endmacro(add_example)