require 'classes/colorize.rb'

if (!defined? CONFIG)
  CONFIG = YAML.load_file('config/config.yml')
end

# parse command line from format: ruby %script_name% --key1=value1 --key2=value2
# return Hash of values with keys
def parse_command_line
  args = Hash.new
  ARGV.each do |x|
    tmp = x.gsub('--', '').split('=')
    args[tmp[0]] = tmp[1]
  end
  args
end

# parse command line from format: ruby %script_name% --key1=value1 --key2=value2
# return value corresponding to name or false
def get_command_line_argument(name, default = false)
  ARGV.each do |x|
    tmp = x.gsub('--', '').split('=')
    if (tmp[0] == name)
      return tmp[1]
    end
  end
  default
end

def hash_resonance(resonance)
  i = 0 
  res = ''
  resonance.each do |elem|
    res+=elem.to_i.to_s if (i<6)
    i+=1
  end
  res
end
