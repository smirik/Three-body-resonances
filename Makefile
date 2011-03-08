calc: calc.o mercury_parser.o
	gfortran -o calc calc.o mercury_parser.o

mercury_parser.o: mercury_parser.f90  
	gfortran -c mercury_parser.f90

calc.o: calc.f90
	gfortran -c calc.f90

clean:
	rm -f *.o calc result
