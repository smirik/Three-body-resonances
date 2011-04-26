# Extract integrator files from archive
require 'yaml'
require 'classes/functions.rb'
require 'classes/resonance_archive.rb'

start = get_command_line_argument('start', false)
steps = get_command_line_argument('steps', false)

if (!start || !steps)
  raise
end

start = start.to_i
steps = steps.to_i

puts "Start"
for i in 0..steps
  num = start + 100*i
  puts "Start from #{num} "
  tmp = %x[ ruby resonance.rb --start=#{num}  --integrate=1 ]
  puts "Package results for #{num}"
  tmp = %x[ ruby packager.rb --start=#{num} --zip=1 ]
end
puts "End"