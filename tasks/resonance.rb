require 'axis/resonance.rb'

class Command
  
  def self.make
    resonance = Console.argument('resonance', false, true)
    output    = Console.argument('output', 'numbers')

    r = Resonance.new(Resonance.from_s(resonance))

    rdb = ResonanceDatabase.new
    asteroids = rdb.findByResonance(r)
    case output
      when 'numbers'
        asteroids.each{|ast| puts ast.number }
    end
    
  end
end