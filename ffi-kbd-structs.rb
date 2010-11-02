#!/usr/bin/env ruby

require 'rubygems'
require 'ffi'
require 'ffi/tools/const_generator'
require 'ffi/tools/struct_generator'

cg = FFI::ConstGenerator.new("Input")
cg.include("linux/uinput.h")
cg.const("ABS_MAX", "%d") {|s| s.to_i}
cg.const("UINPUT_MAX_NAME_SIZE", "%d") {|s| s.to_i}
cg.calculate

# puts "abs max is: " + c["ABS_MAX"].to_s
abs_max = cg["ABS_MAX"]
uinput_max_name_size = cg["UINPUT_MAX_NAME_SIZE"]


sg = FFI::StructGenerator.new("Input")

module Input::Input_ID < FFI::Struct
  @@@
  name "struct input_id"
  include("linux/input.h")
  
  field :bustype, :uint16
  field :vendor, :uint16
  field :product, :uint16
  field :version, :uint16
  @@@
end


class Timeval < FFI::Struct
  @@@
  name "struct timeval"
  include("sys/time.h")
  
  field :tv_sec, :ulong
  field :tv_usec, :ulong
  @@@
end
  
module Input::Input_Event < FFI::Struct
  @@@
  name "struct input_event"
  include("linux/input.h")
  
  field :time, :pointer
  field :type, :uint16
  field :code, :uint16
  field :value, :int32
  @@@
end

module Input::UInput_User_Dev < FFI::Struct
  @@@
  name "struct uinput_user_dev"
  include("linux/uinput.h")
  
  field :name, :string
  field :input_id, :pointer
  field :ff_effects_max, :int
  field :absmax, :pointer
  field :absmin, :pointer
  field :absfuzz, :pointer
  field :absflat, :pointer
  @@@
end

