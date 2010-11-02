#!/usr/bin/env ruby

require 'rubygems'
require 'ffi'
require 'ffi/tools/const_generator'


# File.open('ff-consts.txt', 'w') {|f| f.write(lines.map {|l| /^#define\s*FF_(\w*)/.match(l) }.reject {|m| m.nil?}.map {|m| m[1]}.sort.join("\n")) }

def load_const_list(constgenerator, const_type)
  const_names = []
  File.open("consts/#{const_type.downcase}-consts.txt", 'r') {|f|
    f.readlines.
      map {|line| line.chomp }.
      map {|name| const_names << name ; name }.  # Build a copy of the names to return
      map {|name| const_type.upcase + "_" + name }.
      map {|constname| constgenerator.const(constname, "%d") {|s| s.to_i}}
  }
  return const_names
end

c = FFI::ConstGenerator.new("Input")

c.include("linux/input.h")

input_names = {}

# Dir.glob("consts/*-consts.txt").map {|name| /^(\S+)-/.match(name)[1] }
types = ["snd", "ff", "id", "name", "btn", "event", "sw", "abs", "bus", "key", "rel", "msc", "rep", "led"]

types.each {|type|
  input_names[type] = load_const_list(c, type)
}

c.calculate()
# c.dump_constants(STDOUT)


