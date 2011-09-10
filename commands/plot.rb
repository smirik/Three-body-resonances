class Command
  
  def self.plot(start, stop)
    
    num_b = CONFIG['integrator']['number_of_bodies']
    
    rdb = ResonanceDatabase.new('export/full.db')
    asteroids = rdb.find_between(start.to_i, stop.to_i)

    # Divide by num_b
    min = asteroids[0].number
    max = asteroids[asteroids.size-1].number
    
    ResonanceArchive.calc_resonances(start, stop, false)

  end
  
end