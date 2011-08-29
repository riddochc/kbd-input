#!/usr/bin/env ruby

require 'getoptlong'

def translate_kbd(str,tx)
  mapping = {}
  mapping[:dvqw] = {}
  mapping[:dvqw][:in] = "\[\{\]\}'\",<\.>pPyYfFgGcCrRlL\/\?=\+oOeEuUiIdDhHtTnNsS\-_;:qQjJkKxXbBwWvVzZ"
  mapping[:dvqw][:out] = "\-_=\+qQwWeErRtTyYuUiIoOpP\[\{\]\}sSdDfFgGhHjJkKlL;:'\"zZxXcCvVbBnN,<\.>\/"
  mapping[:qwdv] = {}
  mapping[:qwdv][:in] = "\-_=\+qQwWeErRtTyYuUiIoOpP\[\{\]\}sSdDfFgGhHjJkKlL;:zZxXcCvVbBnN,<\.>\/\?\"'"
  mapping[:qwdv][:out] = "\[\{\]\}'\",<\.>pPyYfFgGcCrRlL\/\?=\+oOeEuUiIdDhHtTnNsS;:qQjJkKxXbBwWvVzZ_-"
  str.tr(mapping[tx][:in], mapping[tx][:out])
end

def type(str)
  sleep(0.50)
  system("xdotool","type","--delay","50",str)
end

commands = {"key" => 0, "--window" => 2, "--clearmodifiers" => 1, "--delay" => 2,
            "keydown" => 0, "keyup" => 0, "type" => 0, "mousemove" => 0, "--screen" => 2,
            "--polar" => 1, "--sync" => 1, "click" => 0, "--repeat" => 2, "mousedown" => 0,
            "mouseup" => 0, "getmouselocation" => 0}

opts = GetoptLong.new(
  ["--window", GetoptLong::REQUIRED_ARGUMENT],
  ["--clearmodifiers", GetoptLong::NO_ARGUMENT],
  ["--delay", GetoptLong::REQUIRED_ARGUMENT],
  ["--screen", GetoptLong::REQUIRED_ARGUMENT],


)


if ARGV.length > 0
  command = ARGV[0]
  case command
  when "key":
    
  when "type":
    translated_args = []
    ARGV[1,ARGV.length].each_with_index {|arg, i|
      if arg
    }
    puts "Argument #{i} to #{command}: #{arg}"
  else
    puts "Unrecognized command"
  end
  translate_arg(arg)
  
  inputstr = translate_kbd(ARGV[0], :qwdv)
else
  inputstr = translate_kbd(STDIN.readlines().join("\n"), :qwdv)
end

puts "Typing: #{inputstr}"
type(inputstr)

#s = "'"
#puts "A #{s} translates to: " + translate_kbd(s, :qwdv)

