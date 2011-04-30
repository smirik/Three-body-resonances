# Extract integrator files from archive
require 'yaml'
require 'catalog/astdys.rb'
require 'mercury/mercury6.rb'
require 'classes/functions.rb'
require 'classes/resonance_archive.rb'
require 'classes/resonance_database.rb'
require 'classes/series.rb'
require 'classes/view.rb'
require 'axis/finder.rb'

start  = get_command_line_argument('start', false)
stop   = get_command_line_argument('stop',  false)

num_b = CONFIG['integrator']['number_of_bodies']

if (!stop)
  stop = start.to_i + num_b
end

rdb = ResonanceDatabase.new
asteroids = rdb.find_between(start.to_i, stop.to_i)

# Divide by num_b
min = asteroids[0][0]
max = asteroids[asteroids.size-1][0]

number_of_steps = ((max - max%num_b + num_b) - (min - min%num_b))/num_b - 1
start_base = (min - min%num_b)

for i in 0..number_of_steps
  start_from = start_base + i*num_b
  ResonanceArchive.calc_resonances(start_from)
end

