file(GLOB SOURCES
        "*.cpp"
        )
file(GLOB SOURCES_HLS
        "HLS/*.cpp"
        )

add_library(printHLS ${SOURCES} ${SOURCES_HLS})