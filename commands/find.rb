class Command
  
  def self.find(start, current = false)
    
    # Find all possible resonances for all asteroids from start to stop
    axis_error = CONFIG['resonance']['axis_error']
    resonances = Array.new
    num_b      = CONFIG['integrator']['number_of_bodies']
    stop       = start + num_b

    debug = CONFIG['debug']

    delta = stop - start

    puts "Finding asteroids and possible resonances"
    delta.times do |i|
      num = start + i
      arr = AstDys.find_by_number(num)
      resonances.push(find_resonance_by_axis(arr[1], axis_error, false))
    end 

    number_of_steps = (stop-start)-1

    rdb = ResonanceDatabase.new('export/full.db')
    
    is_extracted = ResonanceArchive.extract(start) unless current
    
    puts "Find resonances"
    for i in 0..number_of_steps
      asteroid_num = start + i
      
      if (resonances[i])
        resonances[i].each do |resonance|
          has_resonance = false
          puts "Check asteroid #{asteroid_num}" if debug
          Mercury6.calc(asteroid_num, resonance)
          has_circulation = Series.findCirculation(asteroid_num, 0, CONFIG['gnuplot']['x_stop'], false, true)
          hash_r = hash_resonance(resonance)
          if (has_circulation)
            if (has_circulation[1])
              max = Series.max(has_circulation[0])
              puts "A#{asteroid_num}, % = #{has_circulation[1]}%, medium period = #{has_circulation[2]}, max = #{max}, resonance = #{resonance.inspect}"
              s = asteroid_num.to_s+';'+resonance.inspect+';2'+has_circulation[2].to_s+';'+max.to_s
              rdb.addString(s)
              has_resonance = true
            else
              max = Series.max(has_circulation[0])
              puts "A#{asteroid_num}, NO RESONANCE, resonance = #{resonance.inspect}, max=#{max}" if debug
            end
          else
            puts "A#{asteroid_num}, pure resonance #{resonance.inspect}"
            s = asteroid_num.to_s+';'+resonance.inspect+';1'
            rdb.addString(s)
            has_resonance = true
          end
        end
      end
    end
    
  end
  
  def self.find_mass(start, stop)
    num_b = CONFIG['integrator']['number_of_bodies']
    diff  = stop-start
    steps = (diff-diff%num_b)/num_b
    
    steps.times do |i|
      c_start = start+i*num_b
      puts `./console find --start=#{c_start}`
      `rm -f output/res/*.res`
    end
  end
  
end