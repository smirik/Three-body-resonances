class ResonanceArchive
  def self.extract(start, elements)
    
    if (!start)
      puts '[fail]'.to_red+' Specify please start value.'
      return false
    else
      start = start.to_i
    end

    num_b      = CONFIG['integrator']['number_of_bodies']
    export_dir = CONFIG['export']['base_dir']+'/'+start.to_s+'-'+(start+num_b).to_s
    tar_file   = 'integration'+start.to_s+'-'+(start+num_b).to_s+'.tar.gz' 
    export_tar = CONFIG['export']['base_dir']+'/'+tar_file

    if (!File.exists?(export_dir))
      puts '[fail]'.to_red+' Export directory not exists.'
      print "Trying to find archive and extract... "
      STDOUT.flush
  
      if (File.exists?(export_tar))
        tmp = %x[ cd #{CONFIG['export']['base_dir']}; tar -xf #{tar_file}; cd ../  ]
        print "[done]\n".to_green
      else
        print "[fail]\n".to_red
        return false
      end
    end

    # Clean integrator directory
    print "Clean integrator directory... "
    STDOUT.flush
    tmp = %x[ cd mercury; ./simple_clean.sh; cd ../ ]  
    print "[done]\n".to_green

    # Copy integrator files to integrator directory
    print "Copy integrator files... "
    STDOUT.flush
    tmp = %x[ cp #{export_dir}/mercury/* mercury/ ]  
    print "[done]\n".to_green

    if (elements)
      print "Creating aei files... "
      STDOUT.flush
      tmp = %x[ cd mercury; ./element6; cd ../ ]
      print "[done]\n".to_green
    end
    true
  end
    
  def self.package(start, action, res, aei, zip)
    if (!start)
      puts '[fail]'.to_red+' Specify please start value.'
      return false
    else
      start = start.to_i
    end

    num_b      = CONFIG['integrator']['number_of_bodies']

    # Finding possible resonances
    # Create initial file for integrator

    offset = start

    export_base_dir = CONFIG['export']['base_dir']
    export_dir = export_base_dir+'/'+start.to_s+'-'+(start+num_b).to_s

    if (action == 'clean')
      if (File.exists?(export_dir))
        print "Clear directory #{export_dir}... "
        STDOUT.flush
        tmp = %x[ rm -Rf #{export_dir} ]
        print "[done]\n".to_green
        return true
      else
        puts "Nothing to delete".to_red
        return false
      end
    end

    puts "\nCreating archive directories for asteroids #{start}—#{start+num_b}"
    print "Creating main directory... "
    STDOUT.flush

    # Check existing directory in export
    if (File.exists?(export_dir))
      print "[fail]".to_red
      puts "\n\n Directory #{export_dir} already exists\n".to_red
      return false
    end

    tmp = %x[ mkdir #{export_dir} ]
    print "[done]\n".to_green

    print "Creating subdirectories... "
    STDOUT.flush
    # Creating structure directory
    structure = CONFIG['export']['structure']
    structure.each do |dir|
      tmp_dir = export_dir+'/'+dir
      tmp = %x[ mkdir #{tmp_dir} ]
    end
    print "[done]\n".to_green

    if (aei)  
      # Copy files from integrator and output
      # Copy aei files
      print "Copy aei files... "
      STDOUT.flush
      tmp = %x[ cp mercury/*.aei #{export_dir}/aei ]  
      print "[done]\n".to_green
    end

    # Copy dmp & tmp files
    print "Copy dmp and tmp files... "
    STDOUT.flush
    tmp = %x[ cp mercury/*.dmp #{export_dir}/mercury ]  
    tmp = %x[ cp mercury/*.tmp #{export_dir}/mercury ]  
    print "[done]\n".to_green

    # Copy out files
    print "Copy out files... "
    STDOUT.flush
    tmp = %x[ cp mercury/*.out #{export_dir}/mercury ]  
    print "[done]\n".to_green

    if (res)
      # Copy res and png files
      print "Copy res, gnu and png files... "
      STDOUT.flush
      for i in start..(start+num_b)
        tmp = %x[ cp output/res/A#{i.to_s}.res #{export_dir}/res ]  if (File.exists?('output/res/A'+i.to_s+'.res'))
        tmp = %x[ cp output/gnu/A#{i.to_s}.gnu #{export_dir}/gnu ]  if (File.exists?('output/gnu/A'+i.to_s+'.gnu'))
        tmp = %x[ cp output/png/A#{i.to_s}.png #{export_dir}/png ]  if (File.exists?('output/png/A'+i.to_s+'.png'))
      end
      print "[done]\n".to_green
    end

    if (zip)
      print "Archive files... "
      STDOUT.flush
      archive_name = 'integration'+start.to_s+'-'+(start+num_b).to_s+'.tar'
      directory = start.to_s+'-'+(start+num_b).to_s
      tmp = %x[ cd #{export_base_dir}; tar -cf #{archive_name} #{directory}; gzip #{archive_name} ]
      print "[done]\n".to_green
    end

    puts "SUCCESS!\n".to_green
    true
  end
  
end
