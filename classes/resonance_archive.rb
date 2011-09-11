class ResonanceArchive
  
  # Extract resonance file from archive to directory in export folder
  # start — first object number for extracting (start + number of bodies)
  # elements — should mercury6 create aei files for all objects?
  def self.extract(start, elements = false)
    
    debug = CONFIG['debug']
    
    if (!start)
      puts '[fail]'.to_red+' Specify please start value.'
      return false
    else
      start = start.to_i
    end
    
    # Start should have 0 remainder to number of bodies because of structure
    num_b      = CONFIG['integrator']['number_of_bodies'].to_i
    
    start = start - start%num_b
    
    export_dir = CONFIG['export']['base_dir']+'/'+start.to_s+'-'+(start+num_b).to_s
    tar_file   = 'integration'+start.to_s+'-'+(start+num_b).to_s+'.tar.gz' 
    export_tar = CONFIG['export']['base_dir']+'/'+tar_file

    if (!File.exists?(export_dir))
      puts '[fail]'.to_red+' Directory '+export_dir.to_s+' directory not exists.' if debug
      print "Trying to find archive and extract... " if debug
      STDOUT.flush
  
      if (File.exists?(export_tar))
        tmp = %x[ cd #{CONFIG['export']['base_dir']}; tar -xf #{tar_file}; cd ../  ]
        print "[done]\n".to_green if debug
        STDOUT.flush
      else
        print "[fail]\n".to_red if debug
        STDOUT.flush
        return false
      end
    end
    
    if (elements)
      print "Clean integrator directory... " if debug
      STDOUT.flush
      tmp = %x[ cd #{CONFIG['integrator']['dir']}; ./simple_clean.sh; cd ../ ]  
      print "[done]\n".to_green

      print "Copy integrator files... " if debug
      STDOUT.flush
      tmp = %x[ cp #{export_dir}/mercury/* mercury/ ]  
      print "[done]\n".to_green

      print "Creating aei files... " if debug
      STDOUT.flush
      tmp = %x[ cd #{CONFIG['integrator']['dir']}; ./element6; cd ../ ]
      print "[done]\n".to_green
    end
    
    # Check aei files in mercury directory
    # @todo diff integrators
    aei_filename = CONFIG['integrator']['dir']+'/A'+start.to_s+'.aei'
    if (!elements && !File.exists?(aei_filename))
      print "Copy integrator files... " if debug
      STDOUT.flush
      tmp = %x[ cp #{export_dir}/mercury/* mercury/ ]  
      print "[done]\n".to_green if debug

      # Copy aei files if exists
      print "Copy aei files... " if debug
      STDOUT.flush
      tmp = %x[ cp #{export_dir}/aei/* mercury/ ]  
      print "done\n".to_green if debug
      
      if (!File.exists?(aei_filename))
        puts  "[Warning] ".to_red+' AEI files not found'
        print "Creating aei files... " if debug
        STDOUT.flush
        tmp = %x[ cd #{CONFIG['integrator']['dir']}; ./element6; cd ../ ]
        print "[done]\n".to_green if debug
      end
      
    end
    
    true
  end
  
  # Clear data directory for given start value (e.g. export/2000-2100)
  def self.clear(start)
    if (!start)
      puts '[fail]'.to_red+' Specify please start value.'
      return false
    else
      start = start.to_i
    end

    num_b      = CONFIG['integrator']['number_of_bodies']
    tmp = %x[ cd #{CONFIG['export']['base_dir']}; rm -Rf #{start}-#{start+num_b} ]
  end
    
  # Create package (tar.gz archive) based on current mercury6 data
  # start: first object number
  # action: what to do. If "clean" specified then export directory for current data will be removed
  # res: copy res, gnu, png files or not
  # aei: copy aei files or not
  # zip: archive with tar?
  def self.package(start, action, res, aei, zip)
    if (!start)
      puts '[fail]'.to_red+' Specify please start value.'
      return false
    else
      start = start.to_i
    end

    num_b = CONFIG['integrator']['number_of_bodies']

    # Finding possible resonances
    # Create initial file for integrator

    offset = start

    export_base_dir = CONFIG['export']['base_dir']
    export_dir      = export_base_dir+'/'+start.to_s+'-'+(start+num_b).to_s
    integrator_dir  = CONFIG['integrator']['dir']

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

    # Creating structure directory
    print "Creating subdirectories... "
    STDOUT.flush
    structure = CONFIG['export']['structure']
    structure.each do |dir|
      tmp_dir = export_dir+'/'+dir
      tmp = %x[ mkdir #{tmp_dir} ]
    end
    print "[done]\n".to_green

    if (aei)  
      # Copy files from integrator and output
      # Copy aei files
      print "Copy aei files..."
      STDOUT.flush
      tmp = %x[ cp #{integrator_dir}/*.aei #{export_dir}/aei ]  
      print "[done]\n".to_green
    end

    # Copy dmp & tmp files
    print "Copy dmp and tmp files... "
    STDOUT.flush
    tmp = %x[ cp #{integrator_dir}/*.dmp #{export_dir}/mercury ]  
    tmp = %x[ cp #{integrator_dir}/*.tmp #{export_dir}/mercury ]  
    print "[done]\n".to_green

    # Copy out files
    print "Copy out files... "
    STDOUT.flush
    tmp = %x[ cp #{integrator_dir}/*.out #{export_dir}/mercury ]  
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
  
  # Copy archive files from server via ssh (scp)
  # start: specify first object number
  # steps: specify number of intervals [start, start+number_of_bodies]
  def self.copy_from_server(start, stop)
    if (!start)
      puts '[fail]'.to_red+' Specify please start value.'
      return false
    else
      start = start.to_i
    end
    
    num_b      = CONFIG['integrator']['number_of_bodies']
    
    if (!stop)
      stop = start + num_b
    end
    
    steps = ((stop - start)/num_b).round

    export_dir = CONFIG['export']['base_dir']
    username   = CONFIG['server']['username']
    address    = CONFIG['server']['address']
    source_dir = CONFIG['server']['source_dir']
    dest_dir   = CONFIG['server']['dest_dir']
    
    for i in 0..(steps-1)
      from = start + num_b*i
      to   = from + num_b
      puts "Copy #{from} to #{to}"
      tmp  = %x[ scp #{username}@#{address}:#{source_dir}/#{export_dir}/integration#{from}-#{to}.tar.gz #{dest_dir}/export/ ]
    end
  end
  
  # Calculate resonances and plot the png files for given object
  def self.calc_resonances(start, stop = false, elements = 1)
    num_b = CONFIG['integrator']['number_of_bodies']
    
    output_gnu    = CONFIG['output']['gnuplot']
    output_images = CONFIG['output']['images']
    
    rdb = ResonanceDatabase.new('export/full.db')
    
    if (!stop)
      stop = start.to_i + num_b
    end
    
    asteroids = rdb.find_between(start, stop)
    
    # Extract from archive data
    is_extracted = ResonanceArchive.extract(start, elements)

    asteroids.each do |asteroid|
      asteroid_num = asteroid.number.to_s
      puts "Plot for asteroid #{asteroid_num}"
      Mercury6.calc(asteroid_num, asteroid.resonance)
      has_circulation = Series.findCirculation(asteroid_num, 0, CONFIG['gnuplot']['x_stop'], false, true)
      if (has_circulation)
        max = Series.max(has_circulation[0])
        puts "% = #{has_circulation[1]}%, medium period = #{has_circulation[2]}, max = #{max}"
      else
        puts "pure resonance"
      end
      View.createGnuplotFile(asteroid_num)
      tmp = %x[ gnuplot #{output_gnu}/A#{asteroid_num}.gnu > #{output_images}/A#{asteroid_num}.png ]
    end
    
  end  
end
