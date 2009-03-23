require 'erb'
require 'yaml'

task 'consts' do
    rm_f ["consts.c", "consts"]
    template = ERB.new(File.open('consts.erb').read, 0, "%<>")
    c = template.result(binding)
    File.open('consts.c', 'w') do |f|
        f.puts(c)
    end
    sh "gcc -o consts consts.c"
    consts = YAML.load(`./consts`)
    puts "EVIOCGID is #{consts['EVIOCGID']}"
    template = ERB.new(File.open('consts-class.erb').read, 0, "%<>")
    c = template.result(binding)
    File.open('consts.rb', 'w') do |f|
        f.puts(c)
    end
end

task :clean do
    rm_f ["consts.c", "consts"]
end
