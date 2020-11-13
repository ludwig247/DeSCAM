#include "ConsoleSink.h"
#include "Logger.h"

void DESCAM::ConsoleSink::print(std::string formattedOutput) {
  if (Logger::getInstance().printDecorativeFrames)
    std::cout << "\033[1;31m<---------------------------- Logger ------------------------------->\033[0m" << std::endl;

  std::cout << formattedOutput;

  if (Logger::getInstance().printDecorativeFrames)
    std::cout << "\033[1;31m---------------------------------------------------------------------\033[0m" << std::endl;


}
