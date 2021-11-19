import 'dart:io';

void main() {
  
  for (int i = 1; i < 101; i++) {
    if (i % 3 == 0)
      stdout.write('Fizz');
    if (i % 5 == 0)
      stdout.write('Buzz');
    if (i % 3 != 0 && i % 5 != 0)
      stdout.write(i);
    print('');
  }
}