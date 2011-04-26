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

start  = get_command_line_argument('start', 1).to_i
action = get_command_line_argument('action', false)

Mercury6.createSmallBodyFile

axis_error = CONFIG['resonance']['axis_error']
resonances = Array.new
num_b      = CONFIG['integrator']['number_of_bodies']

# Finding possible resonances
# Create initial file for integrator

offset = start

export_dir = CONFIG['export']['base_dir']+'/'+start.to_s+'-'+(start+num_b).to_s

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
  
# Copy files from integrator and output
# Copy aei files
print "Copy aei files... "
STDOUT.flush
tmp = %x[ cp mercury/*.aei #{export_dir}/aei ]  
print "[done]\n".to_green

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

# Copy res and png files
print "Copy res, gnu and png files... "
STDOUT.flush
for i in start..(start+num_b)
  tmp = %x[ cp output/res/A#{i.to_s}.res #{export_dir}/res ]  if (File.exists?('output/res/A'+i.to_s+'.res'))
  tmp = %x[ cp output/gnu/A#{i.to_s}.gnu #{export_dir}/gnu ]  if (File.exists?('output/gnu/A'+i.to_s+'.gnu'))
  tmp = %x[ cp output/png/A#{i.to_s}.png #{export_dir}/png ]  if (File.exists?('output/png/A'+i.to_s+'.png'))
end
print "[done]\n".to_green

# num_b.times do |i|
#   num = i+offset
# 
#   arr = AstDys.find_by_number(num)
#   Mercury6.addSmallBody(num, arr)
# 
#   resonances.push(find_resonance_by_axis(arr[1], axis_error, true))
# end
# 
# # Delete mercury_package directory
# `rm -Rf vendor/mercury_package; mkdir vendor/mercury_package`
# # Copy base mercury files to directory vendor/mercury_packager
# `cp vendor/mercury_clean/* vendor/mercury_package/`
# # Copy .in files
# `cp input/mercury/*.in vendor/mercury_package/`
# # Zip file
# tmp = %x[ cd vendor; tar -cf mercury#{start}.tar.gz mercury_package ]
