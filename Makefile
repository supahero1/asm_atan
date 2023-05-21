.PHONY: build
build: atan.s main.c
	nasm -f elf64 atan.s
	gcc main.c -O3 -c
	gcc atan.o main.o -o main -lm -lshnet
	./main

.PHONY: test
test: atan.s test.c
	nasm -f elf64 atan.s
	gcc test.c -O0 -g3 -ggdb -c
	gcc atan.o test.o -o test -O0 -g3 -ggdb -lm
	./test
