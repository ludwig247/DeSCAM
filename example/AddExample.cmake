
macro (add_example)
    set(MACRO_ARG ${ARGN})
    list(LENGTH MACRO_ARG NUM_MACRO_ARG)
    if(${NUM_MACRO_ARG} LESS 1 OR ${NUM_MACRO_ARG} GREATER 3)
        MESSAGE(FATAL_ERROR "wrong use of \"add_example\"!!!! You need to give at least the name of your example.")
    elseif(${NUM_MACRO_ARG} LESS_EQUAL 2)
        list(GET MACRO_ARG 0 FIRST_ARG)
#        list(GET macro_arg 1 second_arg)
        if(IS_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/${FIRST_ARG}")
            if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${FIRST_ARG}/ESL")
                file(GLOB EXAMPLE_H "${FIRST_ARG}/ESL/*.h")
#                    message(STATUS "${first_arg}")
            else()
                file(GLOB EXAMPLE_H "${FIRST_ARG}/*.h")
#                message(STATUS "${EXAMPLE_H}")
            endif()
        else()
              MESSAGE(FATAL_ERROR "Given example directory for example ${FIRST_ARG} does not exist")
        endif()
        list(APPEND EXAMPLE_NAMES_LIST ${FIRST_ARG})
#        list(APPEND EXAMPLE_H_LIST ${EXAMPLE_H})
    elseif(${NUM_MACRO_ARG} EQUAL 3)
        list(GET MACRO_ARG 0 FIRST_ARG)
        list(GET MACRO_ARG 1 SECOND_ARG)
        list(GET MACRO_ARG 2 THIRD_ARG)
        if(IS_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/${THIRD_ARG}")
            if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${THIRD_ARG}/ESL")
                file(GLOB EXAMPLE_H "${THIRD_ARG}/ESL/*.h")
                #        message(STATUS "${EXAMPLE_H}")
            else()
                file(GLOB EXAMPLE_H "${THIRD_ARG}/*.h")
                #        message(STATUS "${EXAMPLE_H}")
            endif()
        else()
            MESSAGE(FATAL_ERROR "Given example directory for example ${FIRST_ARG} does not exist")
        endif()
#        list(APPEND EXAMPLE_H_LIST ${EXAMPLE_H})
        list(APPEND EXAMPLE_NAMES_LIST ${THIRD_ARG})
    endif ()
    list(APPEND EXAMPLE_H_LIST ${EXAMPLE_H})
endmacro(add_example)