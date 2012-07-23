require 'config/config.rb'

class Catalog
  
  @catalog = 'astdys'
  
  def self.find(number)
    file = CONFIG['catalog'][@catalog]['file']
    skip = CONFIG['catalog'][@catalog]['skip']
    
    f_file = File.open(file, 'r')
    f_file.each_line do |line|
      next if f_file.lineno <= skip
      arr = line.split(' ')
      num =  arr[0].gsub('\'', '').to_i
      next if num != number
      return arr.each_with_index.map{|value, key| (key > 0) ? value.to_f : value }
    end
    false
  end
  
  def self.byClass(catalog = 'astdys')
    eval("return #{CONFIG['catalog'][catalog]['class']}")
  end
  
end
