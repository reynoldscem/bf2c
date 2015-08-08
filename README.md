# bf2c
Simple converter of brainfuck to C

## Usage

./bf2c.rb ~/mandlebrot.b > mandlebrot.c

## Compilation

-std=c99 required

-Ofast recommended 

- gcc -std=c99 -Ofast mandlebrot.c -o mandlebrot.o
