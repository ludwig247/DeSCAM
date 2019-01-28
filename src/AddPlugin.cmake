macro (add_plugin)
    set(macro_args ${ARGN})
    list(LENGTH macro_args num_macro_args)
    if(${num_macro_args} LESS 1 OR ${num_macro_args} GREATER 3)
        MESSAGE(FATAL_ERROR "wrong use of \"add_plugin\"!!!! You need to give at least the name of your plugin.")
    elseif(${num_macro_args} EQUAL 1)
        list(GET macro_args 0 first_arg)
        MESSAGE(WARNING "You didn't give a description to your plugin ${first_arg}")
        list(APPEND PLUGIN_NAMES ${first_arg})
        list(APPEND PLUGIN_DESCRIPTIONS "")
        list(APPEND PLUGIN_DIRECTORIES ${first_arg}) # defualt will be same as plugin name
    elseif(${num_macro_args} EQUAL 2)
        list(GET macro_args 0 first_arg)
        list(GET macro_args 1 second_arg)
        #            MESSAGE(STATUS "add_plugin ${first_arg}")
        list(APPEND PLUGIN_NAMES ${first_arg})
        list(APPEND PLUGIN_DESCRIPTIONS ${second_arg})
        list(APPEND PLUGIN_DIRECTORIES ${first_arg}) # defualt will be same as plugin name
    elseif(${num_macro_args} EQUAL 3)
        list(GET macro_args 0 first_arg)
        list(GET macro_args 1 second_arg)
        list(GET macro_args 2 third_arg)
        #            MESSAGE(STATUS "add_plugin ${first_arg}")
        list(APPEND PLUGIN_NAMES ${first_arg})
        list(APPEND PLUGIN_DESCRIPTIONS ${second_arg})

        list(APPEND PLUGIN_DIRECTORIES ${third_arg}) # always append the directory even if it's repeated,
        # later before adding the subdirectories duplicates will be removed

    endif ()
endmacro(add_plugin)