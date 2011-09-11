class Command
  
  def self.resonances(start, stop)
    rdb = ResonanceDatabase.new('export/full.db')
    asteroids = rdb.find_between(start, stop)
    asteroids.each{|asteroid| puts asteroid.number }
  end
end