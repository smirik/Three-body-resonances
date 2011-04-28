# Copy all files for current 100 integrators
# and create the package
require 'yaml'
require 'classes/functions.rb'
require 'classes/resonance_archive.rb'

if (!defined? CONFIG)
  CONFIG = YAML.load_file('config/config.yml')
end

start = get_command_line_argument('start', false)
steps = get_command_line_argument('steps', false)

ResonanceArchive.copy_from_server(start.to_i, steps.to_i)