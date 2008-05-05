#!/usr/bin/env ruby


# From /usr/include/linux/input.h:
#struct input_id {
#        __u16 bustype;
#        __u16 vendor;
#        __u16 product;
#        __u16 version;
#};
# 
class Input_Id
    attr_accessor :bustype, :vendor, :product, :version

    def initialize()
    end
    
    def serialize_struct()
    end
end

# From /usr/include/linux/uinput.h:
# struct uinput_user_dev {
#        char name[UINPUT_MAX_NAME_SIZE];  # UINPUT_MAX_NAME_SIZE = 80
#        struct input_id id;               # in input.h
#        int ff_effects_max;
#        int absmax[ABS_MAX + 1];          # 0x3f + 1 = 0x40
#        int absmin[ABS_MAX + 1];
#        int absfuzz[ABS_MAX + 1];
#        int absflat[ABS_MAX + 1];
# };
class Uinput_User_Dev
    attr_accessor :name, input_id, ff_effects_max, absmax, absmin, absfuzz, absflat

    def initialize()
    end
    
    def serialize_struct()
    end
end