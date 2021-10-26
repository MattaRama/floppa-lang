import 'dart:io';
import 'lexer.dart';
import 'parser.dart';
import 'interpreter.dart';

void main() {
  var f = File('../code.sf');

  var l = Lexer(f.readAsStringSync() + " \n");

  //print(f.readAsStringSync());

  l.tokenizer();

  var p = Parser(l.tokens);

  print(l.tokens);
  print('\n\n');

  p.build_AST();
  var inter = Interpreter(p.AST);
  inter.run();
}