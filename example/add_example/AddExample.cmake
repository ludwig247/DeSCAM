#set(TEMPLATE_H
#        "#ifndef PROJECT_${FIRST_ARG}_H
#         #define PROJECT_${FIRST_ARG}_H
#         #endif //PROJECT_${FIRST_ARG}_H
#         #include \"../Interfaces/Interfaces.h\"
#         #include \"systemc.h\"")

macro (add_example)
    set(MACRO_ARG ${ARGN})
    list(LENGTH MACRO_ARG NUM_MACRO_ARG)
#    message(STATUS "${CMAKE_CURRENT_SOURCE_DIR}")
    if(${NUM_MACRO_ARG} LESS 1 OR ${NUM_MACRO_ARG} GREATER 3)
        message(FATAL_ERROR "wrong use of \"add_example\"!!!! You need to give at least the name of your example.")
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
#           message(FATAL_ERROR "Given example directory for example ${FIRST_ARG} does not exist")
            set(EXAMPLE_NAME "${FIRST_ARG}_Simulation")
            set(TEMPLATE_H "#include \"../Interfaces/Interfaces.h\" #include \"systemc.h\"")
            message(WARNING "Given example directory ${FIRST_ARG} does not exist, add_example() will create a new example directory tree")
            file(MAKE_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/${FIRST_ARG}/ESL/env ${CMAKE_CURRENT_SOURCE_DIR}/${FIRST_ARG}/RTL/properties)
            file(WRITE ${CMAKE_CURRENT_SOURCE_DIR}/${FIRST_ARG}/ESL/env/CMakeLists.txt "file(GLOB ENV_SRC *.cpp *.hpp *.h)")
            file(WRITE ${CMAKE_CURRENT_SOURCE_DIR}/${FIRST_ARG}/CMakeLists.txt "add_subdirectory(ESL)")
            file(WRITE ${CMAKE_CURRENT_SOURCE_DIR}/${FIRST_ARG}/ESL/env/sc_main.cpp "#include\"../${FIRST_ARG}.h\"")
            file(APPEND ../CMakeLists.txt "add_subdirectory(${FIRST_ARG})\n")
            configure_file ( #Creates new example header-file
                "template_h.h.in"
                "${CMAKE_CURRENT_SOURCE_DIR}/${FIRST_ARG}/ESL/${FIRST_ARG}.h" @ONLY)
            configure_file ( #Creates CMakeLists for the ESL-folder
                "CMakeLists.txt.in"
                "${CMAKE_CURRENT_SOURCE_DIR}/${FIRST_ARG}/ESL/CMakeLists.txt" @ONLY)
        endif()
        list(APPEND EXAMPLE_NAMES_LIST ${FIRST_ARG})
    elseif(${NUM_MACRO_ARG} EQUAL 3)
        list(GET MACRO_ARG 0 FIRST_ARG)
#        list(GET MACRO_ARG 1 SECOND_ARG)
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
#            message(FATAL_ERROR "Given example directory for example ${FIRST_ARG} does not exist")
            set(EXAMPLE_NAME "${THIRD_ARG}_Simulation")
            message(WARNING "Given example directory ${THIRD_ARG} does not exist, add_example() will create a new example directory tree")
            file(MAKE_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/${THIRD_ARG}/ESL/env ${CMAKE_CURRENT_SOURCE_DIR}/${THIRD_ARG}/RTL/properties)
            file(WRITE ${CMAKE_CURRENT_SOURCE_DIR}/${THIRD_ARG}/ESL/env/CMakeLists.txt "file(GLOB ENV_SRC *.cpp *.hpp *.h)")
            file(WRITE ${CMAKE_CURRENT_SOURCE_DIR}/${THIRD_ARG}/CMakeLists.txt "add_subdirectory(ESL)")
            file(WRITE ${CMAKE_CURRENT_SOURCE_DIR}/${THIRD_ARG}/ESL/env/sc_main.cpp "#include\"../${THIRD_ARG}.h\"")
            file(APPEND ../CMakeLists.txt "add_subdirectory(${THIRD_ARG})\n")
            configure_file ( #Creates new example header-file
                    "template_h.h.in"
                    "${CMAKE_CURRENT_SOURCE_DIR}/${THIRD_ARG}/ESL/${THIRD_ARG}.h" @ONLY)
            configure_file ( #Creates CMakeLists.txt for the ESL-folder
                    "CMakeLists.txt.in"
                    "${CMAKE_CURRENT_SOURCE_DIR}/${THIRD_ARG}/ESL/CMakeLists.txt" @ONLY)
        endif()
        list(APPEND EXAMPLE_NAMES_LIST ${THIRD_ARG})
    endif ()
    list(APPEND EXAMPLE_H_LIST ${EXAMPLE_H})
endmacro(add_example)