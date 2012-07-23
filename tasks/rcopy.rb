class Command
  
  def self.rcopy(start, stop)
    ResonanceArchive.copy_from_server(start, stop)
  end
  
end