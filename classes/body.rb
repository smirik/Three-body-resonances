require 'classes/body_elements.rb'
require 'classes/degrees.rb'

class Body
  
  attr_accessor :mass, :pos, :vel, :time

  def pp
    puts "Axis: #{@axis}, mean motion: #{@mean_motion}"
  end
end