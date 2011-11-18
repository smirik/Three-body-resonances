class Command
  
  def self.resonances(start, stop, resonance = false)
    rdb = ResonanceDatabase.new('export/full.db')
    asteroids = rdb.find_between(start, stop)
    asteroids.each do |asteroid|
      tmp = asteroid.resonance
      tmp.delete_at(6)
      puts asteroid.number if (!resonance || (resonance == asteroid.resonance))
    end
  end
end