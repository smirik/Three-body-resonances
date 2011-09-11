class Command
  
  def self.stat
    rdb = ResonanceDatabase.new('export/full.db')

    resonances      = Hash.new
    resonances_pure = Hash.new

    File.open(rdb.db_file).each do |line|
      tmp = rdb.parse_line(line)
      if (tmp)
        if (resonances.has_key?(tmp[2]))
          resonances[tmp[2]] =resonances[tmp[2]]+1
          if (tmp[1] == 1)
            if (resonances_pure.has_key?(tmp[2]))
              resonances_pure[tmp[2]] =resonances_pure[tmp[2]]+1
            else
              resonances_pure[tmp[2]] = 1
            end
          end
        else
          resonances[tmp[2]] = 1
        end
      end
    end

    tmp1 = 0
    tmp2 = 0
    resonances.sort_by{|key, value| value}.reverse.each do |key, value|
      tmp  = resonances_pure[key]
      puts "#{key.inspect} : #{value} : #{tmp}"
      tmp1+=value.to_i
      tmp2+=resonances_pure[key].to_i
    end

    puts "Total resonances: \n Pure: #{resonances.length} \n Transient: #{resonances_pure.length}"
    puts "Total asteroids: \n Pure: #{tmp1} \n Transient: #{tmp2}"    
  end
  
end