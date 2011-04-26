class Series
  
  # Find circulation in data array from key start to key stop
  # return position of break (or array of positions) if exists
  # return false if there is no circulations
  # return -1 if error
  def self.findCirculation(body_number, start, stop, transport = false, find_all = false)
    file = 'output/res/A'+body_number.to_s+'.res'

    data     = Array.new
    breaks   = Array.new # circulation breaks by OX
    previous = false
    
    libration_min = CONFIG['resonance']['libration']['min']
    
    if (!File.exist?(file))
      return -1
    end
    
    c_break  = 0
    p_break  = 0
    pp_break = 0
    File.open(file).each do |line|
      
      data = line.split(' ').map{|x| x.strip.to_f}
      data[1] = (data[1]+Math::PI).by_mod if transport
      if (previous && ((previous - data[1]).abs >= Math::PI) )
        if (!find_all)
          return data[0]
        end

        if ((previous - data[1]) > 0)
          c_break = 1
        else
          c_break = -1
        end
        
        if ((c_break != p_break) && (p_break != 0))
          breaks.delete_at(breaks.size-1)
        end
        breaks.push(data[0])
        p_break = c_break
      end
      previous = data[1]
    end
    if ((breaks.empty?) || (breaks.size == 1))
      false
    else
      previous = 0
      
      libration   = 0
      circulation = 0
      delta       = 0 # medium interval of circulations
      
      breaks.each do |x|
        delta+=(x-previous)
        if ((x - previous) > libration_min)
          libration+=(x-previous)
        else
          circulation+=(x-previous)
        end
        previous = x
      end
      delta = delta/breaks.size
      libration_percent = libration/(stop-start)*100 # years in libration in percents

      if (libration_percent > 0)
        [breaks, libration_percent, delta]
      else
        [breaks, false, false]
      end
      
    end
  end
  
end