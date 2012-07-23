require 'classes/asteroid.rb'
require 'axis/resonance.rb'

class ResonanceDatabase
  
  attr_accessor :db
  
  # Initialized database from db
  def initialize(db = false)
    (db) ? @db = db : @db = CONFIG['resonances']['db']
    self.createIfNotExists
  end
  
  # Create empty database file (for new actions)
  def create
    File.open(@db, "w" ) do |file|
    end
  end
  
  # Create empty database file (for new actions) if @db doesn't exists
  def createIfNotExists
    self.create unless File.exists?(@db)
  end
  
  # Checks has the given asteroid resonance or no
  # body_number: number of body
  def body?(body_number)
    File.open(@db, 'r').each do |line|
      arr = line.split(';')
      return true if (arr[0].to_i == body_number)
    end
    false
  end
  
  # Check is there in @db string ss
  # ss: given string
  def string?(ss)
    File.open(@db, 'r').each do |line|
      return true if line.include?(ss)
    end
    false
  end
  
  # Add new resonance to database (if not exists)
  # body_number: number of new body
  # resonance: array of resonance values
  # type: type of resonance
  def add(body_number, resonance, type = 1)  
    if !self.check?(body_number)
      File.open(@db, 'a+') do |db|
        db.puts(body_number.to_s+';'+type.to_s+';'+resonance.inspect)
      end
      return true
    end
    false
  end
  
  # Add new string to @db (if this string doesn't exist yet)
  # ss: given string
  def addString(ss)
    tmp = ss.split(';')
    s = tmp[0].to_s+';'+tmp[1].to_s
    unless self.checkString?(s)
      File.open(@db, 'a+') do |db|
        db.puts(ss) 
      end
    end
  end
  
  # Find all asteroids in resonances for given interval [start, stop] in body numbers
  # start: start of the interval
  # stop: stop of the interval
  def findByNumbers(start, stop)
    asteroids = []
    File.open(@db, 'r').each do |line|
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
  def findByResonance(r)
    asteroids = []
    File.open(@db, 'r').each do |line|
      arr = line.split(';')
      asteroids.push(Asteroid.new(arr[0].to_i, r.resonance)) if r.equals?(arr[1])
    end
    asteroids
  end
  
  # parse one line of database file 
  # line: string from database file
  def parse(line)
    return false unless line.include?(';')
    arr = line.split(';')
    [arr[0].to_i, arr[2].to_i, Resonance.from_s(arr[1])]
  end
  
end