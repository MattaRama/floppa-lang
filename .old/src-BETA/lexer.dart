import 'dart:io';

import 'util.dart';

class Lexer {
  String data;
  List tokens;

  Lexer(this.data) : tokens = [];

  void tokenizer() {
    // for every line
    for (var loc in data.split('\n')) {
      loc += ' ';
      var tid = ''; // token id
      var tmp = []; // temp token

      // for every char
      for (var l in loc.split('')) {
        print('${l}, ${tid}, ${tmp}');
        if (l == '"' && tid == '') {
          tid = 'string';
          tmp = [];
        }
        else if (l == '"' && tid == 'string') {
          tokens.add({'id': tid, 'value': join(tmp)});
          tid = '';
          tmp = [];
        }
        else if (l == ':') {
          tokens.add({'id': 'label', 'value': join(tmp)});
          tid = '';
          tmp = [];
        }
        else if (keywords.contains(join(tmp))) {
          tokens.add({'id': 'keyword', 'value': join(tmp)});
          tid = '';
          tmp = [];
        }
        else if (operators.contains(join(tmp))) {
          tokens.add({'id': 'operator', 'value': join(tmp)});
          tid = '';
          tmp = [];
        }
        else if (l == ' ' && tid == '' && tmp.length != 0) {
          tokens.add({'id': 'identifier', 'value': join(tmp)});
          tid = '';
          tmp = [];
        }
        else if (l == ' ' && tid != 'string') continue;
        else {
          //stdout.write(l);
          tmp.add(l);
        }
      }
      if (tmp.length != 0) {
        tokens.add({'id': 'identifier', 'value': join(tmp)});
      }
    }
  }
}