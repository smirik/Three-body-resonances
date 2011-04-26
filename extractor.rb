# Extract integrator files from archive
require 'yaml'
require 'catalog/astdys.rb'
require 'mercury/mercury6.rb'
require 'classes/functions.rb'
require 'classes/series.rb'
require 'classes/view.rb'
require 'axis/finder.rb'

if (!defined? CONFIG)
  CONFIG = YAML.load_file('config/config.yml')
end

start  = get_command_line_argument('start', false)
action = get_command_line_argument('action', false)
elements = get_command_line_argument('elements', false)

if (!start)
  puts '[fail]'.to_red+' Specify please start value.'
  exit
else
  start = start.to_i
end

num_b      = CONFIG['integrator']['number_of_bodies']
export_dir = CONFIG['export']['base_dir']+'/'+start.to_s+'-'+(start+num_b).to_s

if (!File.exists?(export_dir))
  puts '[fail]'.to_red+' Export directory not exists.'
  exit
end

# Clean integrator directory
print "Clean integrator directory... "
STDOUT.flush
tmp = %x[ cd mercury; ./simple_clean.sh; cd ../ ]  
print "[done]\n".to_green

# Copy integrator files to integrator directory
print "Copy integrator files... "
STDOUT.flush
tmp = %x[ cp #{export_dir}/mercury/* mercury/ ]  
print "[done]\n".to_green

if (elements)
  print "Creating aei files... "
  STDOUT.flush
  tmp = %x[ cd mercury; ./element6; cd ../ ]
  print "[done]\n".to_green
end
  