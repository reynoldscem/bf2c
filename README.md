# bf2c
Simple converter of brainfuck to C

## Usage

./bf2c.rb ~/mandlebrot.b > mandlebrot.c

## Compilation

-std=c99 required

-Ofast recommended 

- gcc -std=c99 -Ofast mandlebrot.c -o mandlebrot.o

## Benchmark

./mandlebrot.o  7.48s user 0.00s system 99% cpu 7.492 total
