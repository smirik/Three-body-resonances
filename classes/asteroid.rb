require 'classes/body.rb'

class Asteroid < Body
  
  attr_accessor :number
  attr_accessor :resonance
  attr_accessor :libration_type
  attr_accessor :catalog
  
  def initialize(number, resonance = false, catalog = 'astdys')
    @number = number.to_i
    @resonance = resonance if (resonance)
    @catalog = catalog
  end
  
  def find
    catalog = Catalog.byClass(@catalog)
    eval("#{catalog}.find(#{@number})")
  end
  
  def to_s
    p "#{@number};#{@resonance.inspect}"
  end
  
end