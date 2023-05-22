.PHONY: all
all: build

atan.o: atan.s
	nasm -f elf64 -Wall atan.s

.PHONY: build
build: atan.o main.c
	gcc main.c -O3 -c
	gcc atan.o main.o -o main -lm -lshnet
	./main

.PHONY: test
test: atan.o test.c
	gcc test.c -O0 -g3 -ggdb -c
	gcc atan.o test.o -o test -O0 -g3 -ggdb -lm
	./test
