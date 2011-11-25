require 'yaml'

if (!defined? CONFIG)
  CONFIG = YAML.load_file('config/config.yml')
end

# @todo refactoring
# Return possible resonance for current s/m axis
# If just_one then return just one resonance with minimum delta
# Else return all possible resonances
def find_resonance_by_axis(axis, error = 0.0001, just_one = true)
  r_file = 'axis/'+CONFIG['resonance_table']['file']

  res       = Array.new
  min_array = Array.new # array for errors 

  File.open(r_file).each do |line|
    arr = line.split(' ').map{|x| x.to_f}
    if ((arr[4] - axis).abs <= error )
      res.push(arr)
      min_array.push(arr[4] - axis)
    end
  end
  
  if (!just_one && !res.empty?)
    res
  elsif (!res.empty?)
    min = min_array.min
    res[min]
  else
    false
  end
end