# Copy all files for current 100 integrators
# and create the package
require 'yaml'
require 'classes/functions.rb'
require 'classes/resonance_archive.rb'
require 'classes/resonance_database.rb'

rdb = ResonanceDatabase.new

resonances = Hash.new

File.open(rdb.db_file).each do |line|
  tmp = rdb.parse_line(line)
  if (tmp)
    if (resonances.has_key?(tmp[2]))
      resonances[tmp[2]] =resonances[tmp[2]]+1
    else
      resonances[tmp[2]] = 1
    end
  end
end

resonances.sort_by{|key, value| value}.reverse.each do |key, value|
  puts "#{key.inspect} = #{value}"
end