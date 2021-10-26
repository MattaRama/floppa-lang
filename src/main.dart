import 'dart:io';
import 'lexer.dart';
import 'interpreter.dart';

void main() {
  var f = File('../code.sf');

  var l = Lexer(f.readAsStringSync() + " \n");

  //print(f.readAsStringSync());

  l.tokenizer();

  print(l.tokens);
  print('\n\n');

  var inter = Interpreter();
  inter.run(l.tokens);
}