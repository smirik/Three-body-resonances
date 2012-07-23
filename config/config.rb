require 'yaml'
require 'classes/degrees.rb'
include Math

if (!defined? CONFIG)
  CONFIG = YAML.load_file('config/config.yml')
end

require 'classes/export.rb'

class Fixnum
  def null?
    return true if ((self.nil?) || (self == 0))
    false
  end
end

class Float
  def null?
    return true if ((self.nil?) || (self == 0))
    false
  end
end

class NilClass
  def null?
    false
  end
end
