#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <X11/X.h>
#include <X11/Xlib.h>
#include <X11/keysym.h>

int main() {
    int min_keycode = 0, max_keycode = 0, keysyms_per_keycode = 0;
    Display *display = NULL;
    KeySym *key_map;

    display = XOpenDisplay(NULL);
    if (display == NULL) {
        printf("Can't open display.\n");
        return(-1);
    }

    XDisplayKeycodes (display, &min_keycode, &max_keycode);
    key_map = XGetKeyboardMapping (display, min_keycode,
                                      (max_keycode - min_keycode + 1),
                                      &keysyms_per_keycode);

    printf("min: %d\tmax: %d\tkeysyms_per_keycode: %d\n", min_keycode, max_keycode, keysyms_per_keycode);

    // KeySym k = XStringToKeysym("A")

    XFree(key_map);
    XCloseDisplay(display);
    return 0;
}
