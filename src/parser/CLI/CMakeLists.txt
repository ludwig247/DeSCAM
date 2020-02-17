
add_library(CLI SHARED
        App.hpp
        CLI.hpp
        Config.hpp
        ConfigFwd.hpp
        Error.hpp
        Formatter.hpp
        FormatterFwd.hpp
        Macros.hpp
        Option.hpp
        Optional.hpp
        Split.hpp
        StringTools.hpp
        Timer.hpp
        TypeTools.hpp
        Validators.hpp
        Version.hpp
        )


set_target_properties(CLI PROPERTIES LINKER_LANGUAGE CXX)