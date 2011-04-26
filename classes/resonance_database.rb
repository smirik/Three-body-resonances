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
  
  def check(body_number)
  end
  
  def add(body_number, resonance, type = 1)  
    File.open(@db_file, 'a+') do |db|
      db.puts(body_number.to_s+';'+type.to_s+';'+resonance.inspect)
    end
  end
  
end