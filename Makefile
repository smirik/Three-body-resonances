calc: calc.o mercury_parser.o vendor/strings/stringmod.o astdys.o
	gfortran -o calc calc.o mercury_parser.o  axis/functions.o vendor/strings/stringmod.o astdys.o

mercury_parser.o: mercury_parser.f90
	gfortran -c axis/functions.o mercury_parser.f90

calc.o: calc.f90
	gfortran -c calc.f90

astdys.o:
	gfortran -c catalog/astdys.f90
clean:
	rm -f *.o calc result
