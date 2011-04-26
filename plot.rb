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

rdb = ResonanceDatabase.new
asteroids = rdb.find_between(start.to_i, start.to_i+CONFIG['integrator']['number_of_bodies'])

# Extract from archive data
is_extracted = ResonanceArchive.extract(start, 1)

asteroids.each do |asteroid|
  asteroid_num = asteroid[0]
  puts "Plot for asteroid #{asteroid_num}"
  Mercury6.calc(asteroid_num, asteroid[2])
  has_circulation = Series.findCirculation(asteroid_num, 0, CONFIG['gnuplot']['x_stop'], false, true)
  if (has_circulation)
    max = Series.max(has_circulation[0])
    puts "% = #{has_circulation[1]}%, medium period = #{has_circulation[2]}, max = #{max}"
  else
    puts "pure resonance"
  end
  View.createGnuplotFile(asteroid_num)
  tmp = %x[ gnuplot output/gnu/A#{asteroid_num}.gnu > output/png_res/A#{asteroid_num}.png ]
end