class Command
  
  def self.results(file, resonance, pure = 1, three_body = true)
    resonances = []
    File.open(file, 'r').each do |line|
      tmp = line.split(';')
      resonances.push(tmp[1]) if (!resonances.include?(tmp[1]) && pure.include?(tmp[2].to_i))
    end
    
    resonances.sort.each do |resonance|
      s = resonance.sub('[', '').sub(']', '').gsub(',', '').gsub('.0', '')
      tmp = s.split(' ')
      tmp.delete_at(tmp.size-1)
      tmp[tmp.size-1] = tmp[tmp.size-1].to_i.abs.to_s
      tmp.delete_at(tmp.size-2)
      tmp.delete_at(tmp.size-2) if three_body
      next if ((tmp[0].to_i % 2 == 0) && (tmp[1].to_i % 2 == 0) && (tmp[2].to_i % 2 == 0)) && three_body
      next if ((tmp[0].to_i % 3 == 0) && (tmp[1].to_i % 3 == 0) && (tmp[2].to_i % 3 == 0)) && three_body

      next if ((tmp[0].to_i % 2 == 0) && (tmp[1].to_i % 2 == 0)) && !three_body
      next if ((tmp[0].to_i % 3 == 0) && (tmp[1].to_i % 3 == 0)) && !three_body
      s = tmp.join(' & ')
      s += ' & '
      File.open(file, 'r').each do |line|
        tmp = line.split(';')
        s += tmp[0].to_s +  " " if ((resonance == tmp[1]) && (pure.include?(tmp[2].to_f)))
      end
      s += ' \\\\ '
      puts s
    end
    
  end
  
end