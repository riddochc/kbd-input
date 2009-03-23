#!/usr/bin/env ruby

require 'kbd-input'

f = File.open('/dev/uinput', 'w')

dev = UInput_User_Dev.new
dev.name = "speech-input"
dev.input_id.bustype = 0
dev.input_id.vendor = 0
dev.input_id.product = 0
dev.input_id.version = 0

f.ioctl(UInput::UI_SET_EVBIT, UInput::EV::KEY)
f.ioctl(UInput::UI_SET_EVBIT, UInput::EV::REP)

255.times do |i|
    f.ioctl(UInput::UI_SET_KEYBIT, i)
end

# Finally create the thing.
f.write(dev.serialize)

INT_NULL = [0].pack("I")
if f.ioctl(UInput::UI_DEV_CREATE, INT_NULL)
    puts "Unable to create input device!"
    f.close
    exit(-1)
end

sleep 5

[UInput::KEY::P, UInput::KEY::S, UInput::KEY::SPACE,
 UInput::KEY::A, UInput::KEY::U, UInput::KEY::X, UInput::KEY::ENTER].each do |key|
    event = Input_Event.new()
    event.type = UInput::EV::Key
    event.code = key
    event.value = 1  # Key Down event
    f.write(event.serialize)
    
    event = Input_Event.new()
    event.type = UInput::EV::SYN
    event.code = UInput::SYN::Report
    event.value = 0
    f.write(event.serialize)
    
    event = Input_Event.new()
    event.type = UInput::EV::Key
    event.code = key
    event.value = 0 # Key Release Event
    f.write(event.serialize)
    
    event = Input_Event.new()
    event.type = UInput::EV::SYN
    event.code = UInput::SYN::Report
    event.value = 0
    f.write(event.serialize)
    
    sleep 0.5
end

f.ioctl(UInput::UI_DEV_DESTROY)
f.close
