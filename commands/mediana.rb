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
  
end
