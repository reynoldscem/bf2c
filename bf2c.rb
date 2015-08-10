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
  @program = IO.read(filename).scan(/>|<|\+|-|\.|,|\[|\]/)
end

if @program.nil? || @program.length.zero?
  puts "No bf to convert"
  exit
end

head = "#include <stdio.h>
#include <stdlib.h>

int tSize        = 350;
int resizeFactor = 2;

int   tInd = 0;
char* tape;

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
    char* tempArray = calloc(newSize, sizeof(int));
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

def countToken(char)
  count = 1
  count += 1 until @program[@i + count] != char
  @i += count
  count
end

puts head

@i = 0
while @i < @program.length
  case @program[@i]
  when '>'
    indent()
    print "tInd += ", countToken('>'), ";"
    puts
    next
  when '<'
    indent()
    print "tInd -= ", countToken('<'), ";"
    puts
    next
  when '+'
    indent()
    print "writeTape(readTape() + ", countToken('+'), ");"
    puts
    next
  when '-'
    indent()
    print "writeTape(readTape() - ", countToken('-'), ");"
    puts
    next
  when ','
    indent()
    puts("getChar();")
  when '.'
    indent()
    puts("putChar();")
  when '['
    indent()
    puts("while(readTape()) {")
    @indentLevel += 1;
  when ']'
    @indentLevel -= 1;
    indent()
    puts("}")
  end
  @i += 1
end

puts tail
