require 'classes/body.rb'
require 'catalog/astdys.rb'

class Asteroid < Body
  
  attr_accessor :number
  attr_accessor :resonance
  attr_accessor :libration_type
  
  def initialize(number, resonance = false)
    @number = number.to_i
    if (resonance)
      @resonance = resonance
    end
  end
  
  def find_by_number
    AstDys.find_by_number(@number)
  end
  
  def resonance_to_string
    @resonance.inspect
  end
  
  
  
end