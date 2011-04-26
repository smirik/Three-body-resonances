class ResonanceDatabase
  
  attr_accessor :db_file
  
  def initialize
    @db_file = CONFIG['resonance']['db_file']
    self.createIfNotExists
  end
  
  def create
    File.open(@db_file, "w" ) do |file|
      file.puts "#Resonances database file"
    end
  end
  
  def createIfNotExists
    if (!File.exists?(@db_file))
      self.create
    end
  end
  
  def check?(body_number)
    File.open(@db_file, 'r').each do |line|
      arr = line.split(';')
      if (arr[0].to_i == body_number)
        return true
      end
    end
    false
  end
  
  def add(body_number, resonance, type = 1)  
    if !self.check?(body_number)
      File.open(@db_file, 'a+') do |db|
        db.puts(body_number.to_s+';'+type.to_s+';'+resonance.inspect)
      end
      true
    else
      false
    end
  end
  
  def find_between(start, stop)
    asteroids = Array.new
    File.open(@db_file, 'r').each do |line|
      arr = line.split(';')
      tmp = arr[0].to_i
      if ((tmp >= start) && (tmp < stop) )
        resonance = arr[2].delete('[').delete(']').split(',').map{|x| x.to_f}
        asteroids.push([arr[0].to_i, arr[1].to_i, resonance])
      end
    end
    asteroids
  end
  
end