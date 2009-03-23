#!/usr/bin/env ruby

require 'rubygems'
require 'bindata'

class UInput_User_Dev < BinData::Struct
  stringz :name, :max_length => 80
  uint8 :bustype
  uint8 :vendor
  uint8 :product
  uint8 :version
  array :absmax, :type => uint16, :initial_value => 0
  array :absmin, :type => uint16, :initial_value => 0
  array :absfuzz, :type => uint16, :initial_value => 0
  array :absflat, :type => uint16, :initial_value => 0
end

class Input_Event
  
end

