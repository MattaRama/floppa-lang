import 'util.dart';
import 'constants.dart';

class Lexer {
  String data;
  List tokens;

  Lexer(this.data) : tokens = [];

  void tokenizer() {
    // for every line
    for (var loc in data.split('\n')) {
      var tmp = [];
      var tid = '';

      // for every char on line
      for (var l in loc.split('')) {
        // detects string literals
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
        }
        else if (keywords.contains(join(tmp))) {
          tokens.add({'id': 'keyword', 'value': join(tmp)});
          tmp = [];
        }
        else if (l == ' ' && tid != 'string') continue;
        else {
          tmp.add(l);
        }
      }
    }
  }
}