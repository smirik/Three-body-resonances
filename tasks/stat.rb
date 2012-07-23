class Command
  
  def self.make
    rdb = ResonanceDatabase.new('export/full.db')

    export = Console.argument("export", false)

    ast  = Hash.new{0}
    pure = Hash.new{0}

    File.open(rdb.db).each do |line|
      data = rdb.parse(line)
      if (data)
        next if Resonance.gcd?(data[2])
        ast[data[2]]  = ast[data[2]]+1
        pure[data[2]] = pure[data[2]]+1 if ((data[1] == 1) || (data[1] == 3))
      end
    end
    
    total      = ast.inject(0){|res, elem| res + elem[1]}
    total_pure = pure.inject(0){|res, elem| res + elem[1]}
    ast.sort_by{|key, value| value}.reverse.each do |key, value|
      puts Export.array([key[0], key[1], key[2], key[3], key[4], key[5], key[6], value, pure[key]])
    end

    puts "Total resonances: \n Pure: #{ast.size} \n Transient: #{pure.size}"
    puts "Total asteroids: \n Total: #{total}, \n Pure: #{total_pure}, \%: #{total_pure.to_f/total*100} \n Transient: #{total-total_pure},"    
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

  def self.stat_order(pure = false, sum_module = false)
    rdb = ResonanceDatabase.new('export/full.db')
    
    orders = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    File.open(rdb.db_file).each do |line|
      tmp   = rdb.parse_line(line)
      #next if (((tmp[2][0].to_i % 2)==0) && ((tmp[2][1].to_i % 2)==0) )
      #next if (sum_module && ((tmp[2][0].to_i.abs + tmp[2][1].to_i.abs) > sum_module.to_i) )
      order = tmp[2][3].abs.to_i
      if (pure)
        if ((tmp[1].to_i == 1) || (tmp[1].to_i == 3))
          orders[order]+=1
        end
      end
      #orders[order]+=1 if (!pure || (pure && ((tmp[1] == 1) || (tmp[1] == 3))))
    end
    
    orders.each_with_index do |value, key|
      puts "#{key};#{value}"
    end
    
  end
  
end
