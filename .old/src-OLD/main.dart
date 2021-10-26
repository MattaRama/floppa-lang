import 'lexer.dart';
import 'parser.dart';

import 'dart:io';

void main() {
  var text = File('../code.sf').readAsStringSync() + ' \n';
  var lexer = Lexer(text);

  lexer.tokenizer();
  
  var parser = Parser(lexer.tokens);
  parser.build_AST();

  print(text);
  print(lexer.tokens);
  print(parser.AST);
}