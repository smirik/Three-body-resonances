class Command
  
  def self.package(start, action, res, aei, zip)
    start  = get_command_line_argument('start', false)
    ResonanceArchive.package(start, action, res, aei, zip)
  end
end