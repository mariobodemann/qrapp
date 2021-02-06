//BEGIN_INCLUDE(all)
#include <initializer_list>

#include <android_native_app_glue.h>
using namespace std;


void android_main(struct android_app *state) {
    int events = 0;
    struct android_poll_source *source;

    while (ALooper_pollAll(-1, nullptr, &events, (void **) &source) >= 0) {

        if (source != nullptr) {
            source->process(state, source);
        }

        if (state->destroyRequested != 0) {
            return;
        }
    }
}

//END_INCLUDE(all)
