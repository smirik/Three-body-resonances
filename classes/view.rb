require 'yaml'

if (!defined? CONFIG)
  CONFIG = YAML.load_file('config/config.yml')
end

class View
  
  def self.createGnuplotFile(body_number, type = 1)
    output_gnu    = CONFIG['output']['gnuplot']
    output_res    = CONFIG['output']['angle']
    
    gnuplot_sample_file = File.open('output/multi.gnu', 'r')
    content = gnuplot_sample_file.read
    
    # Change filename
    content.gsub!("result", output_res+'/A'+body_number.to_s+'.res')
    
    # Change x range
    content.gsub!("set xrange [0:100000]", "set xrange [0:"+CONFIG['gnuplot']['x_stop'].to_s+"]")
    # Change type
    content.gsub!("with points", "with "+CONFIG['gnuplot']['type'])
    
    gnuplot_file = File.open(output_gnu+'/A'+body_number.to_s+'.gnu', 'w+')
    gnuplot_file.puts(content)
    
    gnuplot_sample_file.close
    gnuplot_file.close
  end
  
end