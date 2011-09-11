class Command
  
  def self.resonance_show(resonance)
    rdb = ResonanceDatabase.new('export/full.db')
    asteroids = rdb.find_asteroids_in_resonance(resonance)
    asteroids.each{|asteroid| puts asteroid.number }
  end
  
end
