#~ require 'erb'
#~ require 'yaml'

#~ task 'consts' do
    #~ rm_f ["consts.c", "consts"]
    #~ template = ERB.new(File.open('consts.erb').read, 0, "%<>")
    #~ c = template.result(binding)
    #~ File.open('consts.c', 'w') do |f|
        #~ f.puts(c)
    #~ end
    #~ sh "gcc -o consts consts.c"
    #~ consts = YAML.load(`./consts`)
    #~ puts "EVIOCGID is #{consts['EVIOCGID']}"
    #~ template = ERB.new(File.open('consts-class.erb').read, 0, "%<>")
    #~ c = template.result(binding)
    #~ File.open('consts.rb', 'w') do |f|
        #~ f.puts(c)
    #~ end
#~ end

desc "generate FFI structs"
task :ffi_generate do
  require 'ffi'
  require 'ffi/tools/generator'
  require 'ffi/tools/struct_generator'

  ffi_files = ["kbd-structs.rb.ffi"]
  ffi_options = "" # "-I/usr/local/mylibrary"
  ffi_files.each do |ffi_file|
    ruby_file = ffi_file.gsub(/\.ffi$/,'')
    unless uptodate?(ruby_file, ffi_file)
      puts "generating: #{ffi_file} => #{ruby_file}"
      FFI::Generator.new ffi_file, ruby_file, ffi_options    
    end
  end
end


task :clean do
    rm_f ["consts.c", "consts"]
end
