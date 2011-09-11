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
  
end