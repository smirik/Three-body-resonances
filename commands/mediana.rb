class Command
  
  def self.mediana(number)
    rdb = ResonanceDatabase.new('export/full.db')
    
    start     = number - number%CONFIG['integrator']['number_of_bodies'].to_i
    asteroids = rdb.find_between(number, number)
    asteroid  = asteroids[0]
    is_extracted = ResonanceArchive.extract(start)
    
    Mercury6.calc(asteroid.number, asteroid.resonance)
    mediana = Series.calc_mediana(asteroid.number)
    puts mediana.inspect
  end
  
  def self.mediana_mass(start, stop, resonance = false)
    if resonance
      asteroids_numbers = `./console resonances --start=#{start} --stop=#{stop} --resonance="#{resonance}"`
    else
      asteroids_numbers = `./console resonances --start=#{start} --stop=#{stop}`
    end
    asteroids_numbers = asteroids_numbers.split("\n").map{|elem| elem.strip.to_i}
    asteroids_numbers.each{|num| puts "#{num};"+`./console mediana --start=#{num}`}
  end
  
end
