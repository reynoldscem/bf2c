#!/usr/bin/ruby
filename    = ARGV[0]
@indentLevel = 1
@indentStr   = "  "

if filename.nil?
  puts "Provide a filename"
elsif !File.exists? filename
  puts "File does not exist"
elsif !File.readable? filename
  puts "File not readable"
else
  program = IO.read(filename).scan(/>|<|\+|-|\.|,|\[|\]/)
end

if program.nil? || program.length.zero?
  puts "No bf to convert"
  exit
end

head = "#include <stdio.h>
#include <stdlib.h>

int tSize        = 100;
int resizeFactor = 2;

int  tInd = 0;
int* tape;

void init (void);
void index(void);

int  readTape (void);
void writeTape(int);

void putChar(void);
void getChar(void);

int main(void) {
  init();
"

tail = "}

void putChar(void) {
  printf(\"%c\", readTape());
}

void getChar(void) {
  writeTape((int) getchar());
}

int readTape(void) {
  index();
  return tape[tInd];
}

void writeTape(int val) {
  index();
  tape[tInd] = val;
}

void index(void) {
  if (tInd >= tSize) {
    int newSize = tSize;
    while (newSize <= tInd) newSize *= resizeFactor;
    int* tempArray = calloc(newSize, sizeof(int));
    for (int i = 0; i < tSize; i++) tempArray[i] = tape[i];
    free(tape);
    tape = tempArray;
    tSize = newSize;
  }
}

void init(void) {
  tape = calloc(tSize, sizeof(int));
}"

def indent()
  print(@indentStr * @indentLevel)
end

puts head

program.each do |c|
  case c
  when '>'
    indent()
    puts "tInd++;"
  when '<'
    indent()
    puts "tInd--;"
  when '+'
    indent()
    puts "writeTape(readTape() + 1);"
  when '-'
    indent()
    puts "writeTape(readTape() - 1);"
  when ','
    indent()
    puts("getChar();")
  when '.'
    indent()
    puts("putChar();")
  when '['
    indent()
    puts("while(readTape() != 0) {")
    @indentLevel += 1;
  when ']'
    @indentLevel -= 1;
    indent()
    puts("}")
  end
end

puts tail
