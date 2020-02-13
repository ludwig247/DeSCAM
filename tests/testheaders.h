
#ifndef PROJECT_TESTHEADERS_H
#define PROJECT_TESTHEADERS_H


#include <vector>
#include <fstream>
#include <sstream>

#define TEST_NAMES "I2C"
#define TEST_DESCRIPTIONS "something"
#define TEST_DIRECTORIES "I2C"
#define OPTION_NAMES ""
#define OPTION_DESCRIPTIONS ""
#define OPTIMIZE_OPTIONS ""
#define OPTIMIZE_OPTIONS_DESCRIPTIONS ""

std::vector<std::string> split(const std::string &s, char delimiter) {
    std::vector<std::string> tokens;
    std::string token;
    std::istringstream tokenStream(s);
    while (std::getline(tokenStream, token, delimiter)) {
        tokens.push_back(token);
    }
    return tokens;
}

#endif //PROJECT_TESTHEADERS_H
