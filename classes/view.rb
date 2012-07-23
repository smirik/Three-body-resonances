require 'config/config.rb'

class Gnuplot
  
  def self.create(body_number, type = 1)
    output_gnu = CONFIG['output']['gnuplot']
    output_res = CONFIG['output']['angle']
    
    sample  = File.open('output/multi.gnu', 'r')
    content = sample.read
    
    # Change filename
    content.gsub!("result", output_res+'/A'+body_number.to_s+'.res')
    
    # Change x range
    content.gsub!("set xrange [0:100000]", "set xrange [0:"+CONFIG['gnuplot']['x_stop'].to_s+"]")
    # Change type
    content.gsub!("with points", "with "+CONFIG['gnuplot']['type'])
    
    gnuplot_file = File.open(output_gnu+'/A'+body_number.to_s+'.gnu', 'w+')
    gnuplot_file.puts(content)
    
    sample.close
    gnuplot_file.close
  end
  
end