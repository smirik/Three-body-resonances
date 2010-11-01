main: test.o functions.o
	gfortran -o main test.o functions.o

functions.o: functions.f90  
	gfortran -c test.f90 functions.f90
  
test.o: test.f90
	gfortran -c test.f90

clean:
	rm -f *.o main
