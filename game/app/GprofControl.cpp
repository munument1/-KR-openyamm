#include "game/app/GprofControl.h"

#if defined(__GNUC__) && !defined(__ANDROID__) && !defined(_WIN32)
extern "C" void moncontrol(int mode) __attribute__((weak));
#endif

namespace OpenYAMM::Game
{
void setGprofProfilingEnabled(bool enabled)
{
#if defined(__GNUC__) && !defined(__ANDROID__) && !defined(_WIN32)
    if (moncontrol != nullptr)
    {
        moncontrol(enabled ? 1 : 0);
    }
#else
    (void)enabled;
#endif
}
}
