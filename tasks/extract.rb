class Command
  
  def self.extract(start, copy_aei = false)
    ResonanceArchive.extract(start, false, copy_aei)  
  end
  
  def self.extract_mass(start, stop, copy_aei = false)
    num_b = CONFIG['integrator']['number_of_bodies']
    diff  = stop-start
    steps = (diff-diff%num_b)/num_b
    
    steps.times do |i|
      c_start = start+i*num_b
      `./console extract --start=#{c_start} --copy_aei=1`
      `rm -f mercury/*.aei`
    end
  end
  
end