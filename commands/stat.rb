class Command
  
  def self.stat(gcd = false, export = false)
    rdb = ResonanceDatabase.new('export/full.db')

    resonances      = Hash.new
    resonances_pure = Hash.new

    File.open(rdb.db_file).each do |line|
      tmp = rdb.parse_line(line)
      if (tmp)
        next if (((tmp[2][0].to_i.abs % 2)==0.0) && ((tmp[2][1].to_i.abs % 2)==0.0) && ((tmp[2][2].to_i.abs % 2)==0.0) && (gcd))
        next if (((tmp[2][0].to_i.abs % 3)==0.0) && ((tmp[2][1].to_i.abs % 3)==0.0) && ((tmp[2][2].to_i.abs % 3)==0.0) && (gcd))
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
      if (export == 'csv')
        puts "#{key[6]};#{value};#{key[0]} #{key[1]} #{key[2]} #{key[3]} #{key[4]} #{key[5]}"
      else
        puts "#{key.inspect} : #{value} : #{tmp}"
      end
      tmp1+=value.to_i
      tmp2+=resonances_pure[key].to_i
    end

    puts "Total resonances: \n Pure: #{resonances.length} \n Transient: #{resonances_pure.length}"
    puts "Total asteroids: \n Total: #{tmp1}, \n Pure: #{tmp2} \n Transient: #{tmp1-tmp2}"    
  end
  
  def self.stat_table
    
    File.open('axis/'+CONFIG['resonance_table']['file']).each do |line|
      arr = line.split(' ')
      axis = arr[6].to_f
      arr.delete_at(6)
      arr.map!{|elem| elem.to_i}
      puts axis.to_s+';1'
    end
    
  end

  def self.stat_order(pure = false)
    rdb = ResonanceDatabase.new('export/full.db')
    
    orders = [0, 0, 0, 0, 0, 0, 0, 0]
    File.open(rdb.db_file).each do |line|
      tmp   = rdb.parse_line(line)
      next if (((tmp[2][0].to_i % 2)==0) && ((tmp[2][1].to_i % 2)==0) && ((tmp[2][2].to_i % 2)==0) )
      order = tmp[2][5].abs.to_i
      orders[order]+=1 if (!pure || (pure && ((tmp[1] == 1) || (tmp[1] == 3))))
    end
    
    orders.each_with_index do |value, key|
      puts "#{key};#{value}"
    end
    
  end
  
end
