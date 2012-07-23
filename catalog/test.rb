require 'catalog/catalog.rb'
require 'catalog/proper.rb'
require 'catalog/mean.rb'
require 'catalog/synt.rb'
require 'catalog/astdys.rb'
require 'classes/resonance_database.rb'
require 'axis/resonance.rb'

#rdb = ResonanceDatabase.new
#ast = rdb.findByResonance([4.0, -2.0, -1.0, 0.0, 0.0, -1.0])

objects = File.read("catalog/4-2-1.list").split("\n").map{|elem| elem.strip.to_i}

objects.each do |num|
  data = SyntheticCatalog.find(num)
  printf("%d %f %f %f %f %f %f %f %f %d \n", data[0], data[1], data[2], data[3], data[4], data[5], data[6], data[7], data[8], data[9]) if data
end

raise

ast.each do |obj|
  p obj.number
  # data_proper = ProperCatalog.find(obj.number)
  # data_mean = MeanCatalog.find(obj.number)
  # p "#{obj.number};#{data_proper[1]};#{data_proper[2]};#{data_mean[2]};#{data_mean[3]}" if data_mean && data_proper
end