class Export
  
  @@format = CONFIG['export']['format']
  
  def self.array(data)
    s = ''
    data.each do |elem|
      s += Export.elem(elem)
      s += "  "  if @@format == 'simple'
      s += ";"   if @@format == 'csv'
      s += " & " if @@format == 'tex'
    end
    s += "\n"
    s.sub(";\n", "\n").sub(" & \n", "\\\\\\ \n").sub("  \n", "\n")
  end
  
  def self.elem(elem)
    if (elem.class == Fixnum)
      return sprintf(CONFIG['export']['variables']['Fixnum'], elem)
    elsif (elem.class == String)
      return sprintf(CONFIG['export']['variables']['String'], elem)
    elsif (elem.class == Float)
      return sprintf(CONFIG['export']['variables']['Float'], elem)
    elsif (elem.class == Array)
      return elem.inspect
    end
    puts elem.class
    raise
  end
  
end