start=$1
stop=$2

for (( i=$start; i<$stop; i=i+100 ))
do
  let next=i+100
  ruby calc.rb --start=$i --stop=$next
done