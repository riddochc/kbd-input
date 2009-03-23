#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <linux/input.h>
#include <linux/uinput.h>
#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
    int out = open("uinput_user_dev.dump", O_WRONLY | O_CREAT, 0644);
    if (out < 0)
    {
        perror("Unable to open output");
        close(out);
        return -1;
    }

    struct uinput_user_dev device;
    memset(&device, 0, sizeof(device)); // Initialize uinput device to NULL
    strncpy(device.name, "speech-input", UINPUT_MAX_NAME_SIZE);
    device.id.bustype = 1;
    device.id.vendor  = 2;
    device.id.product = 3;
    device.id.version = 4;
    device.ff_effects_max = 5;
    device.absmax[0] = 6;
    device.absmin[0] = 7;
    device.absfuzz[0] = 8;
    device.absflat[0] = 9;
    
    
    if (write(out, &device, sizeof(device)) < sizeof(device)) {
        perror("Failed to write device info to file");
        close (out);
        return -1;
    }

    close(out);


    out = open("input_event.dump", O_WRONLY | O_CREAT, 0644);
    if (out < 0)
    {
        perror("Unable to open output");
        close(out);
        return -1;
    }
    
    struct input_event event;
    memset(&event, 0, sizeof(event)); // Clear event structure.
        gettimeofday(&event.time, NULL);
    event.type = EV_KEY;  //indicates the keyboard event
    event.code = KEY_A;
    event.value = 1;      //key down
    if (write (out, &event, sizeof(event)) < sizeof(out)) {
        perror("Failed to write device info to file");
        close (out);
        return -1;
    }

    return 0;
}
