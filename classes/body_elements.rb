class Body
  
  # Kepler elements
  attr_accessor :axis, :eccentricity, :inclination, :argument_of_periapsis, :longitude_node, :mean_anomaly
  attr_accessor :longitude_of_periapsis, :mean_longitude
  attr_accessor :parameter, :square_constant, :true_anomaly, :g,
                :eccentric_anomaly, :ecliptic_longitude, :ecliptic_latitude, :argument_of_latitude, 
                :mean_motion

  def mean_motion_from_axis()
    @mean_motion = Math.sqrt(CONFIG['constants']['k2'] / (@axis**3))
  end
  
  def self.mean_motion_from_axis(axe)
    mean_motion = Math.sqrt(0.0002959122082855911025 / (axe**3))
    mean_motion
  end
  
  def axis_from_mean_motion()
    @axis = (CONFIG['constants']['k'] / (@mean_motion))**(2.0/3)
  end

  def full_pp
    puts "a = #{@axis}, ecc = #{@eccentricity}, parameter = #{parameter}, mean motion = #{mean_motion}"
    puts "true anomaly = #{@true_anomaly}, node longitude = #{longitude_node}, incl = #{inclination}"
    puts "mean anomaly = #{@mean_anomaly}, square const = #{@square_constant}, ecliptic longitude = #{ecliptic_longitude}"
    puts "argument of latitude = #{@argument_of_latitude}, eclipt. latitude = #{ecliptic_latitude}"
    puts "eccentric_anomaly = #{eccentric_anomaly}, argument of periapsis = #{argument_of_periapsis}"
    raise
  end
  
  def from(pos, vel)
    @pos = pos
    @vel = vel
    
    self.to_elem
  end
  
  def to_elem
    kappa2 = CONFIG['constants']['u']
    kappa  = Math.sqrt(kappa2)

    c_tmp = 1731.45833

    # calculating orbit plane
    
    a_big = @pos[1]*@vel[2]-@pos[2]*@vel[1]
    b_big = @pos[2]*@vel[0]-@pos[0]*@vel[2]
    c_big = @pos[0]*@vel[1]-@pos[1]*@vel[0]
    
    dist = Math.sqrt(a_big**2+b_big**2+c_big**2)
    @square_constant = dist
    
    a_small = a_big/dist
    b_small = b_big/dist
    c_small = c_big/dist
    
    ecc_v = @pos*@vel.module/kappa - @vel*(@pos*@vel)/@pos.module - @pos/@pos.module
    
    #puts "A = #{a_big}, B = #{b_big}, C = #{c_big}"
    #puts "a= #{a_small}, b = #{b_small}, c = #{c_small}"
    
    # calculating a, e, n, c
    @axis = @pos.module/(2.0-@pos.module*((@vel.module)**2)/kappa2)
    @parameter = @square_constant**2/kappa2
    @eccentricity = Math.sqrt(1.0-@parameter/@axis)
    @mean_motion = Math.sqrt(kappa2 / (@axis**3))
    
    # calculating i, omega, u
    @inclination    = Math.acos(c_small)
    @longitude_node = Math.acos(-b_small/(Math.sqrt(a_small**2+b_small**2)))
    if (a_big < 0)
      @longitude_node = 2*Math::PI - @longitude_node
    end
    @ecliptic_latitude = Math.asin(@pos[2]/@pos.module)
    @ecliptic_longitude = Math.acos(-@pos[0]/Math.sqrt(@pos[0]**2+@pos[1]**2))
    @argument_of_latitude = Math.asin(@pos[2]/(@pos.module*Math.sin(@inclination)))
    # another
    # Math.asin(a_small/(Math.sqrt(a_small**2+b_small**2))) 
    
    @true_anomaly = Math.acos(1.0/@eccentricity*(@parameter/@pos.module-1.0))
    if (@pos*@vel < 0)
      @true_anomaly = 2*Math::PI - @true_anomaly
    end
    @argument_of_periapsis = @true_anomaly - @argument_of_latitude
    #if (ecc_v[2] < 0)
      #@argument_of_periapsis = 2*Math::PI - @argument_of_periapsis
    #end
    @eccentric_anomaly = Math.acos((@eccentricity + Math.cos(@true_anomaly))/(1.0+@eccentricity*Math.cos(@true_anomaly)))
    @mean_anomaly = @eccentric_anomaly - @eccentricity*Math.sin(@eccentric_anomaly)
    
    @longitude_of_periapsis = @longitude_of_periapsis + @argument_of_periapsis
        
  end 
  
end

