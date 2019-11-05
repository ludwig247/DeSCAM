macro (add_plugin_option)
    set(macro_args ${ARGN})
    list(LENGTH macro_args num_macro_args)
    if(${num_macro_args} LESS 2 OR ${num_macro_args} GREATER 3)
        MESSAGE(FATAL_ERROR "wrong use of \"add_plugin_option\"!!!! You need to give at least the plugin name and the option name.")
    else()
        list(GET macro_args 0 first_arg)
        list(FIND PLUGIN_NAMES ${first_arg} plugin_arg)
        if(${plugin_arg} EQUAL -1)
            MESSAGE(FATAL_ERROR "wrong use of \"add_plugin_option\"!!!! No such plugin available.")
        elseif(${num_macro_args} EQUAL 2)
            list(GET macro_args 1 second_arg)
            MESSAGE(WARNING "You didn't give a description to your added option ${first_arg}")
            list(APPEND OPTION_NAMES ${first_arg} ${second_arg}) #one way to to use plugin name as a reference to its option
            list(APPEND OPTION_DESCRIPTIONS ${first_arg} "") #one way to to use plugin name as a reference to its option's description
        elseif(${num_macro_args} EQUAL 3)
            list(GET macro_args 1 second_arg)
            list(GET macro_args 2 third_arg)
            #        MESSAGE(STATUS "add_option ${first_arg}")
            list(APPEND OPTION_NAMES ${first_arg} ${second_arg}) #one way to to use plugin name as a reference to its option
            list(APPEND OPTION_DESCRIPTIONS ${first_arg} ${third_arg}) #one way to to use plugin name as a reference to its option's description
        endif ()
    endif ()
endmacro(add_plugin_option)