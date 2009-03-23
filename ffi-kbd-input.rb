#!/usr/bin/env ruby

require 'rubygems'
require 'ffi'

module MyLibrary
  class SomeObject < FFI::Struct
    layout :next,  :pointer,
           :name,  :string,
           :value, :double,
  end
end


