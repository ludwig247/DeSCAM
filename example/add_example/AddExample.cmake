
macro (add_example)
    set(MACRO_ARG ${ARGN})
    list(LENGTH MACRO_ARG NUM_MACRO_ARG)
#    message(STATUS "${CMAKE_CURRENT_SOURCE_DIR}")
    if(${NUM_MACRO_ARG} LESS 1 OR ${NUM_MACRO_ARG} GREATER 3)
        message(FATAL_ERROR "wrong use of \"add_example\"!!!! You need to give at least the name of your example.")
    elseif(${NUM_MACRO_ARG} LESS_EQUAL 2)
        list(GET MACRO_ARG 0 FIRST_ARG)
#        list(GET MACRO_ARG 1 SECOND_ARG)
        set(ADD_SUB_D ${FIRST_ARG})
        if(IS_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/${FIRST_ARG}")
            if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${FIRST_ARG}/ESL")
                file(GLOB EXAMPLE_H "${FIRST_ARG}/ESL/*.h")
#                    message(STATUS "${first_arg}")
            else()
                file(GLOB EXAMPLE_H "${FIRST_ARG}/*.h")
#                message(STATUS "${EXAMPLE_H}")
            endif()
        else() #if new example: creates new directory tree for example and required CMakeLists
            message(WARNING "Given example directory ${FIRST_ARG} does not exist, add_example() will create a new example directory tree")
            set(EXAMPLE_NAME "${FIRST_ARG}_Simulation")
#            add_custom_command(OUTPUT dir_gen
#            COMMAND cmake -P "${CMAKE_CURRENT_SOURCE_DIR}/add_example/NewExample.cmake")
            file(MAKE_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/${FIRST_ARG}/ESL/env ${CMAKE_CURRENT_SOURCE_DIR}/${FIRST_ARG}/RTL/properties)
            file(WRITE ${CMAKE_CURRENT_SOURCE_DIR}/${FIRST_ARG}/ESL/env/CMakeLists.txt "file(GLOB ENV_SRC CONFIGURE_DEPENDS *.cpp *.hpp *.h)")
            file(WRITE ${CMAKE_CURRENT_SOURCE_DIR}/${FIRST_ARG}/CMakeLists.txt "add_subdirectory(ESL)")
            file(APPEND ./CMakeLists.txt "add_subdirectory(${FIRST_ARG})\n")
            configure_file ( #Creates new example header-file
                "./add_example/template_h.h.in"
                "${CMAKE_CURRENT_SOURCE_DIR}/${FIRST_ARG}/ESL/${FIRST_ARG}.h" @ONLY)
            configure_file ( #Creates CMakeLists for the ESL-folder
                "./add_example/CMakeLists.txt.in"
                "${CMAKE_CURRENT_SOURCE_DIR}/${FIRST_ARG}/ESL/CMakeLists.txt" @ONLY)
            configure_file ( #Creates a sc_main.cpp for example
                    "./add_example/template_sc_main.cpp.in"
                    "${CMAKE_CURRENT_SOURCE_DIR}/${FIRST_ARG}/ESL/env/sc_main.cpp" @ONLY)
        endif()
        list(APPEND EXAMPLE_NAMES_LIST ${FIRST_ARG})
    elseif(${NUM_MACRO_ARG} EQUAL 3)
        list(GET MACRO_ARG 0 FIRST_ARG)
#        list(GET MACRO_ARG 1 SECOND_ARG)
        list(GET MACRO_ARG 2 THIRD_ARG)
        set(ADD_SUB_D ${THIRD_ARG})
        if(IS_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/${THIRD_ARG}")
            if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${THIRD_ARG}/ESL")
                file(GLOB EXAMPLE_H "${THIRD_ARG}/ESL/*.h")
                #        message(STATUS "${EXAMPLE_H}")
            else()
                file(GLOB EXAMPLE_H "${THIRD_ARG}/*.h")
                #        message(STATUS "${EXAMPLE_H}")
            endif()
        else() #if new example: creates new directory tree for example and required CMakeLists
            message(WARNING "Given example directory ${THIRD_ARG} does not exist, add_example() will create a new example directory tree")
            set(EXAMPLE_NAME "${THIRD_ARG}_Simulation")
            file(MAKE_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/${THIRD_ARG}/ESL/env ${CMAKE_CURRENT_SOURCE_DIR}/${THIRD_ARG}/RTL/properties)
            file(WRITE ${CMAKE_CURRENT_SOURCE_DIR}/${THIRD_ARG}/ESL/env/CMakeLists.txt "file(GLOB ENV_SRC CONFIGURE_DEPENDS *.cpp *.hpp *.h)")
            file(WRITE ${CMAKE_CURRENT_SOURCE_DIR}/${THIRD_ARG}/CMakeLists.txt "add_subdirectory(ESL)")
            file(APPEND ./CMakeLists.txt "add_subdirectory(${THIRD_ARG})\n")
            configure_file ( #Creates new example header-file
                    "./add_example/template_h.h.in"
                    "${CMAKE_CURRENT_SOURCE_DIR}/${THIRD_ARG}/ESL/${THIRD_ARG}.h" @ONLY)
            configure_file ( #Creates CMakeLists.txt for the ESL-folder
                    "./add_example/CMakeLists.txt.in"
                    "${CMAKE_CURRENT_SOURCE_DIR}/${THIRD_ARG}/ESL/CMakeLists.txt" @ONLY)
            configure_file ( #Creates a sc_main.cpp for example
                    "./add_example/template_sc_main.cpp.in"
                    "${CMAKE_CURRENT_SOURCE_DIR}/${THIRD_ARG}/ESL/env/sc_main.cpp" @ONLY)
        endif()
        list(APPEND EXAMPLE_NAMES_LIST ${THIRD_ARG})
    endif ()
list(APPEND EXAMPLE_H_LIST ${EXAMPLE_H}) #appends EXAMPLE_H to a list after each time the macro is called
endmacro(add_example)