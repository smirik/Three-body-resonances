require 'axis/finder.rb'

arr = find_resonance_by_axis(3.8065, 0.001, true)
res_array = [2.0, -1.0, -1.0, 0.0, 3.8065]

if (arr == res_array)
  puts '[pass] for 3.8065'
else
  puts '[fail] for 3.8065'
end

#2 -1 1 2 3.8065 
