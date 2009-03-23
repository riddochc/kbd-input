#!/usr/bin/env ruby


k = KeyboardMapping.new()
k.each_code_in("riddochc@gmail.com") {|c, shift|
  puts "Char: #{c}, shift: #{shift}"
}
#puts k.code_for("C")


