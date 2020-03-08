add_library(SynthesisScript
            SynthesisScripts.cpp)

target_compile_options(SynthesisScript PRIVATE -fPIC -O2 )