import 'dart:io';

const keywords = [
  'print',
  'exit',
  'jmp',
  'var',
];

const operators = [
  '+',
  '-',
  '==',
  '>',
  '<',
  '>=',
  '<=',
];

void error(String msg, int code) {
  print(msg);
  exit(code);
}

String join(List arr) {
  String ret = '';

  for (dynamic s in arr) {
    ret += s.toString();
  }

  return ret;
}