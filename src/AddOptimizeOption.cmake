macro (add_optimize_option)
    set(macro_args ${ARGN})
    list(LENGTH macro_args num_macro_args)
    if(${num_macro_args} LESS 1 OR ${num_macro_args} GREATER 2)
        MESSAGE(FATAL_ERROR "wrong use of \"add_optimize_option\"!!!! You need to give the option name and its description.")
    elseif(${num_macro_args} EQUAL 1)
        list(GET macro_args 0 first_arg)
        MESSAGE(WARNING "You didn't give a description to your added option ${first_arg}")
    else()
        list(GET macro_args 0 first_arg)
        list(GET macro_args 1 second_arg)
        list(APPEND OPTIMIZE_OPTIONS ${first_arg})
        list(APPEND OPTIMIZE_OPTIONS_DESCRIPTIONS ${second_arg})
    endif ()
endmacro(add_optimize_option)