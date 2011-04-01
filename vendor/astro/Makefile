astro_tests: tests.o astro.o
	gfortran -o astro_tests tests.o astro.o
tests.o: tests.f90 $(flags)
	gfortran -c tests.f90 
astro.o: astro.f90
	gfortran -c astro.f90 $(flags)

clean:
	rm -f *.o astro_tests
