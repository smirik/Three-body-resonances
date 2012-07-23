require 'config/config.rb'
require 'classes/colorize.rb'

class Console

  # parse command line from format: ruby %script_name% --key1=value1 --key2=value2
  # return Hash of values with keys
  def self.input
    args = Hash.new
    ARGV.each do |x|
      tmp = x.gsub('--', '').split('=')
      args[tmp[0]] = tmp[1]
    end
    args
  end

  # parse command line from format: ruby %script_name% --key1=value1 --key2=value2
  # return value corresponding to name or false
  def self.argument(name, default = false, required = false)
    ARGV.each do |x|
      tmp = x.gsub('--', '').split('=')
      return tmp[1] if (tmp[0] == name) && (tmp[1] != '') && (tmp[1])
    end
    Console.error("Missing required parameter #{name}") if required
    default
  end

  def self.hash_resonance(resonance)
    resonance.each_with_index.map{|value, index| (index < 6) ? value.to_i.to_s : value.to_s }
  end
  
  def self.action(check = true)
    action = false
    action = ARGV[0].strip unless ARGV.empty?
    Console.error('No action specified') if (!action || action.include?("="))
    if check
      unless File.exists?('tasks/'+action+'.rb')
        Console.error("There is no action #{action}")
      end
      action = action.gsub(":", "_")
      require "tasks/"+action+'.rb'
      action
    else
      action
    end
  end
  
  def self.error(message)
    puts "[ERROR]".to_red+' '+message
    exit
  end

end