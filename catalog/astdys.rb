require 'yaml'
require 'classes/degrees.rb'

if (!defined? CONFIG)
  CONFIG = YAML.load_file('config/config.yml')
end

class AstDys
  
  # Find asteroid elements by number
  def self.find_by_number(number)
    file = CONFIG['catalog']['file']

    skip_lines = CONFIG['catalog']['astdys']['skip']
    counter    = 0
    File.open(file).each do |line|
      counter+=1
      if (counter > skip_lines)
        arr = line.split(' ')
        num = arr[0].delete("'").to_i
        if (num == number)
          arr.delete_at(0) # delete number from array
          # elem to float, then all degrees to radians
          arr.map!{|x| x.to_f}.each_with_index{|value, key| arr[key] = value.from_deg if ((key > 3) && (key < 7)) }
          return arr
        end
      end
    end
    
  end
  
end

arr = AstDys.find_by_number(2)
puts arr.inspect