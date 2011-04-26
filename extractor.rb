# Extract integrator files from archive
require 'yaml'
require 'classes/functions.rb'
require 'classes/resonance_archive.rb'

start  = get_command_line_argument('start', false)
elements = get_command_line_argument('elements', false)

ResonanceArchive.extract(start, elements)