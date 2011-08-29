#!/usr/bin/env ruby

require 'yaml'
$LOAD_PATH << File.dirname(__FILE__)
load 'kbd-consts.rb'

# Conversions we want:
# 
# In order to type a string directly:
# ASCII/Unicode characters to a list of [input.h constant, modifier_info] pairs
# 
# We really don't care about xmodmap, for this version.
# Just want a list of what characters are shifted versions of at others.


class KeyboardMapping
  def initialize(layout = "qwerty")
    @layout = layout
    @remap_chars = {}

    if layout == "dvorak"
      # If I want to hit a "q", tell it to hit "x" instead.
      # 
      @remap_chars = {
      # A and M don't get remapped.
      "b"=>"n", "B"=>"N",
      "c"=>"i", "C"=>"I",
      "d"=>"h", "D"=>"H",
      "e"=>"d", "E"=>"D",
      "f"=>"y", "F"=>"Y",
      "g"=>"u", "G"=>"U",
      "h"=>"j", "H"=>"J",
      "i"=>"g", "I"=>"G",
      "j"=>"c", "J"=>"C",
      "k"=>"v", "K"=>"V",
      "l"=>"p", "L"=>"P",
      "n"=>"l", "N"=>"L",
      "o"=>"s", "O"=>"S",
      "p"=>"r", "P"=>"R",
      "q"=>"x", "Q"=>"X",
      "r"=>"o", "R"=>"O",
      "s"=>";", "S"=>":",
      "t"=>"k", "T"=>"K",
      "u"=>"f", "U"=>"F",
      "v"=>".", "V"=>"<",
      "w"=>",", "W"=>">",
      "x"=>"b", "X"=>"B",
      "y"=>"t", "Y"=>"T",
      "z"=>"/", "Z"=>"?",

      "'"=>"q", "\""=>"Q",
      ","=>"w", "<"=>"W",
      "."=>"e", ">"=>"E",
      ";"=>"z", ":"=>"Z",

      "["=>"-", "{"=>"_",
      "]"=>"=", "}"=>"+",
      "="=>"]", "+"=>"}",
      "-"=>"'", "_"=>"\"",
      "/"=>"[", "?"=>"{",
       }
    end
    


    @char_to_evconst = {
      "`" => [UInput::KEY::GRAVE, :no_modifier],
      "~" => [UInput::KEY::GRAVE, :shift],
      '1' => [UInput::KEY::KEY_1, :no_modifier],
      '!' => [UInput::KEY::KEY_1, :shift],
      '2' => [UInput::KEY::KEY_2, :no_modifier],
      '@' => [UInput::KEY::KEY_2, :shift],
      '3' => [UInput::KEY::KEY_3, :no_modifier],
      '#' => [UInput::KEY::KEY_3, :shift],
      '4' => [UInput::KEY::KEY_4, :no_modifier],
      '$' => [UInput::KEY::KEY_4, :shift],
      '5' => [UInput::KEY::KEY_5, :no_modifier],
      '%' => [UInput::KEY::KEY_5, :shift],
      '6' => [UInput::KEY::KEY_6, :no_modifier],
      '^' => [UInput::KEY::KEY_6, :shift],
      '7' => [UInput::KEY::KEY_7, :no_modifier],
      '&' => [UInput::KEY::KEY_7, :shift],
      '8' => [UInput::KEY::KEY_8, :no_modifier],
      '*' => [UInput::KEY::KEY_8, :shift],
      '9' => [UInput::KEY::KEY_9, :no_modifier],
      '(' => [UInput::KEY::KEY_9, :shift],
      '0' => [UInput::KEY::KEY_0, :no_modifier],
      ')' => [UInput::KEY::KEY_0, :shift],
      "-" => [UInput::KEY::MINUS, :no_modifier],
      "_" => [UInput::KEY::MINUS, :shift],
      "=" => [UInput::KEY::EQUAL, :no_modifier],
      "+" => [UInput::KEY::EQUAL, :shift],
      "[" => [UInput::KEY::LEFTBRACE, :no_modifier],
      "{" => [UInput::KEY::LEFTBRACE, :shift],
      "]" => [UInput::KEY::RIGHTBRACE, :no_modifier],
      "}" => [UInput::KEY::RIGHTBRACE, :shift],
      "\\" => [UInput::KEY::BACKSLASH, :no_modifier],
      "|" => [UInput::KEY::BACKSLASH, :shift],
      ";" => [UInput::KEY::SEMICOLON, :no_modifier],
      ":" => [UInput::KEY::SEMICOLON, :shift],
      "'" => [UInput::KEY::APOSTROPHE, :no_modifier],
      "\"" => [UInput::KEY::APOSTROPHE, :shift],
      "." => [UInput::KEY::DOT, :no_modifier],
      "<" => [UInput::KEY::DOT, :shift],
      "," => [UInput::KEY::COMMA, :no_modifier],
      ">" => [UInput::KEY::COMMA, :shift],
      "\n" => [UInput::KEY::ENTER, :no_modifier],
      "/" => [UInput::KEY::SLASH, :no_modifier],
      "?" => [UInput::KEY::SLASH, :shift],
      " " => [UInput::KEY::SPACE, :no_modifier],
      "\t" => [UInput::KEY::TAB, :no_modifier],
    }

    ("a".."z").each do |letter|
       code = UInput::KEY.const_get(letter.upcase)
       @char_to_evconst[letter] = [code, :no_modifier]
       @char_to_evconst[letter.upcase] = [code, :shift]
    end

  end

  # Given either a number or an numeric ascii value,
  # get the code and modifier for it.
  def get_code_for(i)
    if i.is_a?(String)
      c = i[0]
    else
      c = i
    end

    return @remap_chars[c.chr] || c.chr
  end

  def each_code_in(str)
    str.each_byte { |c|
      char = @remap_chars[c.chr] || c.chr

      keydata = @char_to_evconst[char]
      yield(keydata)
    }
  end
end

class Input_Id
    attr_accessor :bustype, :vendor, :product, :version

    def initialize()
      @bustype = 0
      @vendor = 0
      @product = 0
      @version = 0
    end
    
    def to_s()
        [@bustype, @vendor, @product, @version].pack("SSSS")
    end
end

class UInput_User_Dev
    attr_accessor :name, :input_id, :ff_effects_max, :absmax, :absmin, :absfuzz, :absflat

    def initialize(name = "Generic Ruby UInput User Device")
        @name = name
        @input_id = Input_Id.new
        @ff_effects_max = 0
        @absmax = Array.new(64, 0)
        @absmin = Array.new(64, 0)
        @absfuzz = Array.new(64, 0)
        @absflat = Array.new(64, 0)
    end
    
    def to_s()
        out = [@name].pack("a80")
        out << input_id.to_s
        out << [@ff_effects_max].pack("I")
        
        out << @absmax.pack("I" * 64)
        out << @absmin.pack("I" * 64)
        out << @absfuzz.pack("I" * 64)
        out << @absflat.pack("I" * 64)
        out
    end
end

class Input_Event
    attr_accessor :timeval, :type, :code, :value
    
    def initialize()
        @timeval = Time.now
        @type = 0
        @code = 0
        @value = 0
    end
    
    def to_s()
        out = [@timeval.tv_sec, @timeval.tv_usec].pack("LL")
        out << [@type].pack("S")
        out << [@code].pack("S")
        out << [@value].pack("i")
        out
    end
end

class Keyboard
  def initialize()
    @mapping = KeyboardMapping.new('dvorak')
    @fh = File.open('/dev/uinput', 'w')
    if @fh.nil?
      puts "Couldn't open /dev/uinput!"
      return
    end

    @fh.sync = true
    dev = UInput_User_Dev.new()

    @fh.ioctl(UInput::UI_SET_EVBIT, UInput::EV::KEY)
    @fh.ioctl(UInput::UI_SET_EVBIT, UInput::EV::REP)
    # Finally create the thing.
    @fh.write(dev)
    @fh.flush

    UInput::KEY::constants.each {|c|
      # puts c.to_s + " = " + UInput::KEY.const_get(c).to_s
      @fh.ioctl(UInput::UI_SET_KEYBIT, UInput::KEY.const_get(c))
    }

    # 255.times do |i|
    #   @fh.ioctl(UInput::UI_SET_KEYBIT, i)
    # end

    null = [0].pack("i")
    retval = @fh.ioctl(UInput::UI_DEV_CREATE, null)
    if retval != 0
      puts "Unable to create input device!"
      @fh.close
      exit(-1)
    end
  end

  # TODO: Make use of key remapping here?
  def key_combination(*keys)
    keys.each {|k| press(k) }
    keys.reverse.each {|k| release(k) }
  end

  # TODO: Make use of key remapping here?
  def press_and_release(key, sleep_for = 0.05)
    press(key)
    release(key)
    sleep(sleep_for) unless sleep_for == 0      
  end

  def press(key)
    i = Input_Event.new()
    i.type = UInput::EV::KEY  # 1
    i.code = key
    i.value = 1  # Key press
    @fh.write(i.to_s)
  end

  def release(key)
    i = Input_Event.new()
    i.type = UInput::EV::KEY
    i.code = key
    i.value = 0  # Key release
    @fh.write(i.to_s)
  end

  def type_string(str, delay=0.1)
    sleep delay unless delay == 0
    @mapping.each_code_in(str) do |pair|
      code = pair[0]
      mod = pair[1]
      if mod == :shift
        key_combination(UInput::KEY::LEFTSHIFT, code)
      else
        press_and_release(code)
      end
    end
    sleep delay unless delay == 0
  end

  def close()
    @fh.close
  end


end


#k = Keyboard.new()

#k.press_and_release(UInput::KEY::P)
#sleep 0.5
#k.press_and_release(UInput::KEY::S)

#3.times do
#  k.key_combination(UInput::KEY::LEFTALT, UInput::KEY::TAB)
#  sleep 2
#end

#str = ("a".."z").inject("") {|a, s| a << s} + ("A".."Z").inject("") {|a, s| a << s}
#k.type_string(str)
# k.type_string(s)
# k.type_string("a")

#k.close()



