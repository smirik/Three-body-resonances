class Command
  
  def self.calc(start)
    Mercury6.createSmallBodyFile
    
    num_b      = CONFIG['integrator']['number_of_bodies']
    
    puts "Create initial conditions for asteroids from #{start} to #{start+num_b}"
    num_b.times do |i|
      num = i+start
      arr = AstDys.find_by_number(num)
      Mercury6.addSmallBody(num, arr)
    end 
    
    print "Integrating orbits..."
    # Integrate orbits
    `cd mercury; ./simple_clean.sh; ./mercury6; ./element6; cd ../`
    print "[done]".to_green
    STDOUT.flush
    
  end
  
  def self.calc_mass(start, stop)
    num_b = CONFIG['integrator']['number_of_bodies']
    diff  = stop-start
    steps = (diff-diff%num_b)/num_b
    
    steps.times do |i|
      c_start = start+i*num_b
      `./console calc --start=#{start}`
      `./console find --start=#{start} --current=1`
      `./console package --start=#{start} --zip=1`
    end
  end
  
end