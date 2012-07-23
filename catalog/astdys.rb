require 'catalog/catalog.rb'

class AstDySCatalog < Catalog
  
  @catalog = 'astdys'
  
  # # Find asteroid elements by number
  # def self.find2(number)
  #   file = CONFIG['catalog']['file']
  # 
  #   skip_lines = CONFIG['catalog']['astdys']['skip']
  #   counter    = 0
  #   
  #   f_file = File.open(file, 'r')
  #   
  #   f_file.each_line do |line|
  #     next unless f_file.lineno >= number+6
  #     
  #     arr = line.split(' ')
  #     arr.delete_at(0) # delete number from array
  #     # elem to float, then all degrees to radians
  #     # format: time a e i long arg M
  #     #arr.map!{|x| x.to_f}.each_with_index{|value, key| arr[key] = value.from_deg if ((key > 3) && (key < 7)) }
  #     arr.map!{|x| x.to_f}.each_with_index{|value, key| arr[key] = value if ((key > 3) && (key < 7)) }
  #     # new format: time a e i arg long M
  #     tmp    = arr[4]
  #     arr[4] = arr[5]
  #     arr[5] = tmp
  #     return arr
  # 
  #     break
  #   end
  #   
  # end
  
end
