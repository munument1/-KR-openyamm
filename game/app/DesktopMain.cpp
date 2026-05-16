#include "game/app/OpenYammMain.h"

#include <exception>
#include <iostream>

int main(int argc, char **argv)
{
    try
    {
        return OpenYAMM::Game::runApplication(argc, argv);
    }
    catch (const std::exception &exception)
    {
        std::cerr << "Fatal error: " << exception.what() << '\n';
        return 1;
    }
}
