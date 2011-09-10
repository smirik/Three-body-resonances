class ResonanceDatabase
  
  attr_accessor :db_file
  
  # Initialized database from db_file
  def initialize(db_file = false)
    if (db_file)
      @db_file = db_file
    else
      @db_file = CONFIG['resonance']['db_file']
    end
    self.createIfNotExists
  end
  
  # Create empty database file (for new actions)
  def create
    File.open(@db_file, "w" ) do |file|
    end
  end
  
  # Create empty database file (for new actions) if @db_file doesn't exists
  def createIfNotExists
    if (!File.exists?(@db_file))
      self.create
    end
  end
  
  # Checks has the given asteroid resonance or no
  # body_number: number of body
  def check?(body_number)
    File.open(@db_file, 'r').each do |line|
      arr = line.split(';')
      if (arr[0].to_i == body_number)
        return true
      end
    end
    false
  end
  
  # Check is there in @db_file string ss
  # ss: given string
  def checkString?(ss)
    File.open(@db_file, 'r').each do |line|
      return true if (line.include?(ss))
    end
    false
  end
  
  # Add new resonance to database (if not exists)
  # body_number: number of new body
  # resonance: array of resonance values
  # type: type of resonance
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
  
  # Add new string to @db_file (if this string doesn't exist yet)
  # ss: given string
  def addString(ss)
    tmp = ss.split(';')
    s = tmp[0].to_s+';'+tmp[1].to_s
    if (!self.checkString?(s))
      File.open(@db_file, 'a+') do |db|
        db.puts(ss) 
      end
    end
  end
  
  # Find all asteroids in resonances for given interval [start, stop] in body numbers
  # start: start of the interval
  # stop: stop of the interval
  def find_between(start, stop)
    asteroids = Array.new
    File.open(@db_file, 'r').each do |line|
      arr = line.split(';')
      tmp = arr[0].to_i
      if ((tmp >= start) && (tmp <= stop) )
        resonance = arr[1].delete('[').delete(']').split(',').map{|x| x.to_f}
        asteroids.push(Asteroid.new(arr[0], resonance))
      end
    end
    asteroids
  end
  
  # Find all asteroids in given resonance
  # resonance: resonance array
  def find_asteroids_in_resonance(resonance)
  end
  
  # parse one line of database file 
  # line: string from database file
  def parse_line(line)
    if (line.include?(';'))
      arr = line.split(';')
      tmp = arr[0].to_i
      resonance = arr[1].delete('[').delete(']').split(',').map{|x| x.to_f}
      [tmp, arr[2].to_i, resonance]
    else
      false
    end
  end
  
end