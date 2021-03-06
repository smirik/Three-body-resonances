class Numeric
  
  def to_deg()
    180.0*self/Math::PI
  end
  
  def from_deg()
    Math::PI*self/180.0
  end
  
  def to_sec()
    (180.0*self/Math::PI)*3600
  end

  def from_sec()
    (self/3600.0)*Math::PI/180.0
  end

  def from_day_to_year()
    self/365.25
  end

  def to_grad
    self*180.0/Math::PI
  end

  # Decrease / increase to [0, 2*Pi]
  def by_mod
    l = self
    if (l > Math::PI)
      while (l > Math::PI)
        l = l - 2*Math::PI
      end
    else
      while (l < -Math::PI)
        l = l + 2*Math::PI
      end
    end
    l
  end
  
end
