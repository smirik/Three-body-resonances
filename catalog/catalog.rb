require 'yaml'
require 'classes/degrees.rb'

if (!defined? CONFIG)
  CONFIG = YAML.load_file('config/config.yml')
end

class Catalog
end