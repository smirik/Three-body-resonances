for i in input/mercury/*.in; do
  echo $i
  ln -s '../'$i `echo $i | sed 's/input\/mercury/mercury/g'`
#  cp $i `echo $i | sed 's/.sample//g'`
done
