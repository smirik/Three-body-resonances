# Copy all files for current 100 integrators
# and create the package
require 'yaml'
require 'classes/functions.rb'
require 'classes/resonance_archive.rb'

if (!defined? CONFIG)
  CONFIG = YAML.load_file('config/config.yml')
end

start  = get_command_line_argument('start', false)
action = get_command_line_argument('action', false)
res    = get_command_line_argument('res', false)
aei    = get_command_line_argument('aei', false)
zip    = get_command_line_argument('zip', false)

ResonanceArchive.package(start, action, res, aei, zip)