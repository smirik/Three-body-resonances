require 'yaml'
require 'catalog/astdys.rb'
require 'mercury/mercury6.rb'
require 'classes/view.rb'
require 'axis/finder.rb'

if (!defined? CONFIG)
  CONFIG = YAML.load_file('config/config.yml')
end
debug = CONFIG['debug']
debug = true

Mercury6.createSmallBodyFile

axis_error = CONFIG['resonance']['axis_error']
resonances = Array.new
num_b      = CONFIG['integrator']['number_of_bodies']

# Finding possible resonances
# Create initial file for integrator

offset = 3460

puts "Finding asteroids and possible resonances"
num_b.times do |i|
  num = i+offset

  arr = AstDys.find_by_number(num)
  Mercury6.addSmallBody(num, arr)

  resonances.push(find_resonance_by_axis(arr[1], axis_error, true))
end 

puts "Integrating orbits"
# Integrate orbits
`cd mercury; ./simple_clean.sh; ./mercury6; ./element6; cd ../`
puts "Integration is over, calculating angles"

# Create result files, gnuplot files and png
num_b.times do |i|
  if (resonances[i])
    puts "resonance #{resonances[i].inspect} for #{offset+i} asteroid"
    Mercury6.calc(offset+i, resonances[i])
    View.createGnuplotFile(offset+i)
    tmp = %x[ gnuplot output/gnu/A#{offset+i}.gnu > output/png/A#{offset+i}.png ]
  else
    puts "no resonance for #{offset+i} asteroid"
  end
end