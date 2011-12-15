class Series
  
  # Find circulation in data array from key start to key stop
  # return position of break (or array of positions) if exists
  # return false if there is no circulations
  # return -1 if error
  def self.findCirculation(body_number, start, stop, transport = false, find_all = false)
    angle_dir = CONFIG['output']['angle']
    file = angle_dir+'/A'+body_number.to_s+'.res'

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
      
      # For apocentric libration resonant angle is increased on PI
      data[1] = (data[1]+Math::PI).by_mod if transport
      
      # If the distance (OY axis) between new point and previous more than PI then there is a break (circulation)
      if (data[1])
        if (previous && ((previous - data[1]).abs >= Math::PI) )
          if (!find_all)
            return data[0]
          end

          if ((previous - data[1]) > 0)
            c_break = 1
          else
            c_break = -1
          end
        
          # For apocentric libration there could be some breaks by following schema: break on 2*Pi, then break on 2*Pi e.t.c
          # So if the breaks are on the same value there is no circulation at this moment
          if ((c_break != p_break) && (p_break != 0))
            breaks.delete_at(breaks.size-1)
          end
        
          breaks.push(data[0])
          p_break = c_break
        end
      end
      previous = data[1]
    end
    # pure libration if there are no breaks (or just one for apocentric libration e.g.)
    if ((breaks.empty?) || (breaks.size == 1))
      false
    else
      previous = 0
      
      libration   = 0
      circulation = 0
      delta       = 0 # medium interval of circulations
      
      # Find the libration / circulation intervals
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
  
  def self.max(breaks)
    p = 0
    max = 0
    breaks.push(CONFIG['gnuplot']['x_stop'])
    breaks.each do |c|
      if ((c - p) > max)
        max = c-p
      end
      p = c
    end
    max
  end
  
  def self.calc_mediana(body_number)
    file = CONFIG['output']['angle']+'/A'+body_number.to_s+'.res'
    counter = 0
    axis    = 0.0
    ecc     = 0.0
    inc     = 0.0
    node    = 0.0
    plon    = 0.0
    File.open(file).each do |line|
      data = line.split(' ').map{|x| x.strip.to_f}
      counter+=1
      axis+=data[2].to_f
      ecc+= data[3].to_f
      inc+= data[4].to_f
      node+=data[5].to_f
      plon+=data[6].to_f
    end
    [axis/counter, ecc/counter, inc/counter, node/counter, plon/counter]
  end
  
  
end