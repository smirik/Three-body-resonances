# Copy all files for current 100 integrators
# and create the package
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
res    = get_command_line_argument('res', false)
aei    = get_command_line_argument('aei', false)
zip    = get_command_line_argument('zip', false)

if (!start)
  puts '[fail]'.to_red+' Specify please start value.'
  exit
else
  start = start.to_i
end

num_b      = CONFIG['integrator']['number_of_bodies']

# Finding possible resonances
# Create initial file for integrator

offset = start

export_base_dir = CONFIG['export']['base_dir']
export_dir = export_base_dir+'/'+start.to_s+'-'+(start+num_b).to_s

if (action == 'clean')
  if (File.exists?(export_dir))
    print "Clear directory #{export_dir}... "
    STDOUT.flush
    tmp = %x[ rm -Rf #{export_dir} ]
    print "[done]\n".to_green
    exit
  else
    puts "Nothing to delete".to_red
    exit
  end
end

puts "\nCreating archive directories for asteroids #{start}—#{start+num_b}"
print "Creating main directory... "
STDOUT.flush

# Check existing directory in export
if (File.exists?(export_dir))
  print "[fail]".to_red
  puts "\n\n Directory #{export_dir} already exists\n".to_red
  exit
end

tmp = %x[ mkdir #{export_dir} ]
print "[done]\n".to_green

print "Creating subdirectories... "
STDOUT.flush
# Creating structure directory
structure = CONFIG['export']['structure']
structure.each do |dir|
  tmp_dir = export_dir+'/'+dir
  tmp = %x[ mkdir #{tmp_dir} ]
end
print "[done]\n".to_green

if (aei)  
  # Copy files from integrator and output
  # Copy aei files
  print "Copy aei files... "
  STDOUT.flush
  tmp = %x[ cp mercury/*.aei #{export_dir}/aei ]  
  print "[done]\n".to_green
end

# Copy dmp & tmp files
print "Copy dmp and tmp files... "
STDOUT.flush
tmp = %x[ cp mercury/*.dmp #{export_dir}/mercury ]  
tmp = %x[ cp mercury/*.tmp #{export_dir}/mercury ]  
print "[done]\n".to_green

# Copy out files
print "Copy out files... "
STDOUT.flush
tmp = %x[ cp mercury/*.out #{export_dir}/mercury ]  
print "[done]\n".to_green

if (res)
  # Copy res and png files
  print "Copy res, gnu and png files... "
  STDOUT.flush
  for i in start..(start+num_b)
    tmp = %x[ cp output/res/A#{i.to_s}.res #{export_dir}/res ]  if (File.exists?('output/res/A'+i.to_s+'.res'))
    tmp = %x[ cp output/gnu/A#{i.to_s}.gnu #{export_dir}/gnu ]  if (File.exists?('output/gnu/A'+i.to_s+'.gnu'))
    tmp = %x[ cp output/png/A#{i.to_s}.png #{export_dir}/png ]  if (File.exists?('output/png/A'+i.to_s+'.png'))
  end
  print "[done]\n".to_green
end

if (zip)
  print "Archive files... "
  STDOUT.flush
  archive_name = 'integration'+start.to_s+'-'+(start+num_b).to_s+'.tar'
  directory = start.to_s+'-'+(start+num_b).to_s
  tmp = %x[ cd #{export_base_dir}; tar -cf #{archive_name} #{directory}; gzip #{archive_name} ]
  print "[done]\n".to_green
end

puts "SUCCESS!\n".to_green