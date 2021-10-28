import 'dart:io';
import 'util.dart';

class Interpreter {
  Map<String, dynamic> mem = {};

  void run(List tokens) {
    for (var i = 0; i < tokens.length; i++) {
      //print(mem);
      if (tokens[i]['id'] == 'keyword') {
        if (tokens[i]['value'] == 'echo') {
          i++;
          if (tokens[i]['id'] != 'string' && tokens[i]['id'] != 'identifier') 
            error('Failed to print: invalid parameter', -1);

          String toPrint;
          if (tokens[i]['id'] == 'identifier') {
            if (!mem.containsKey(tokens[i]['value']))
              error('Failed to print: invalid identifier', -3);
            toPrint = mem[tokens[i]['value']];
          } else {
            toPrint = tokens[i]['value'];
          }

          print(toPrint);
        }
        else if (tokens[i]['value'] == 'exit') {
          exit(0);
        }
        else if (tokens[i]['value'] == 'jmp') {
          i++;
          if (tokens[i]['id'] != 'identifier') {
            error('Failed to jmp: invalid parameter', -1);
          }
          int pos = _getLabelPos(tokens, tokens[i]['value']);
          if (pos == -1) {
            error('Failed to jump: invalid label', -2);
          }

          i = pos;
        }
        else if (tokens[i]['value'] == 'var') {
          if (tokens[i + 1]['id'] != 'identifier' ||
              !matchTokenField(tokens[i + 2], 'id', ['string', 'identifier'])) {
            error('Failed to declare variable: invalid parameter', -1);
          }

          mem[tokens[i + 1]['value']] = getVal(tokens[i + 2]);
        }
        else if (tokens[i]['value'] == 'concat') {
          if (tokens.length <= i + 2)
            error('Failed to concat: not enough parameters', -1);
          if (!matchTokenField(tokens[i + 1], 'id', ['string', 'identifier']) &&
              !matchTokenField(tokens[i + 2], 'id', ['string', 'identifier']))
            error('Failed to concat: invalid parameters', -1);

          //print('${tokens[i + 1]}, ${tokens[i + 2]}');
          //print('mem: ${mem}');

          String tok1Val = tokens[i + 1]['id'] == 'string' ? tokens[i + 1]['value'] : mem[tokens[i + 1]['value']];
          String tok2Val = tokens[i + 2]['id'] == 'string' ? tokens[i + 2]['value'] : mem[tokens[i + 2]['value']];
          //print(tok1Val + ' ' + tok2Val);

          mem[tokens[i + 1]['value']] = tok1Val + tok2Val;
          i += 2;
        }
        else if (tokens[i]['value'] == 'ifjmp') {
          //print('${mem}');
          if (tokens.length <= i + 4)
            error('Failed to ifjmp: not enough parameters', -1);
          if (tokens[i + 1]['id'] != 'identifier') {
            error('Failed to ifjmp: invalid parameters', -1);
          }

          //print('${tokens[i + 1]}\n${tokens[i + 2]}\n${tokens[i + 3]}\n\n');
          if (_getLabelPos(tokens, tokens[i + 1]['value']) != -1 &&
              matchTokenField(tokens[i + 2], 'id', ['string', 'identifier']) &&
              matchTokenField(tokens[i + 4], 'id', ['string', 'identifier'])) {
            var tok1Val = getVal(tokens[i + 2]);
            var tok2Val = getVal(tokens[i + 4]);

            bool eval = false;
            //print(tokens[i + 3]['value']);
            switch (tokens[i + 3]['value']) {
              case '==':
                eval = tok1Val == tok2Val;
                break;
              case '!=':
                eval = tok1Val != tok2Val;
                break;
              case '>':
                eval = int.parse(tok1Val) > int.parse(tok2Val);
                break;
              case '<':
                eval = int.parse(tok1Val) < int.parse(tok2Val);
                break;
              case '>=':
                eval = int.parse(tok1Val) >= int.parse(tok2Val);
                break;
              case '<=':
                eval = int.parse(tok1Val) <= int.parse(tok2Val);
                break;
              default:
                error("Failed to ifjmp: invalid operator", -1);
            }

            if (eval) {
             i = _getLabelPos(tokens, tokens[i + 1]['value']);
            } else {
             i += 4;
            }
          } else {
            error('Failed to ifjmp: invalid parameters', -1);
          }

          //if (!matchTokenField(tokens[i + 2], 'id', ['string', 'identifier']) ||
          //    !matchTokenField(tokens[i + 3], 'id', ['string', 'identifier']) ||
          //    !mem.containsKey(tokens[i + 1]['value']))
          //  error('Failed to ifjmp: invalid parameters', -1);
        }
        else if (tokens[i]['value'] == 'op') {
          if (tokens.length <= i + 3)
            error('Failed to op: not enough parameters', -1);

          if (tokens[i + 1]['id'] == 'identifier' && 
              tokens[i + 2]['id'] == 'identifier' &&
              matchTokenField(tokens[i + 3], 'id', ['string', 'identifier'])) {

            //print('${tokens[i + 1]}, ${getVal(tokens[i + 1])}');
            //print('${tokens[i + 3]}, ${getVal(tokens[i + 3])}');
            num? num1 = num.tryParse(getVal(tokens[i + 1]));
            num num2 = num.parse(getVal(tokens[i + 3]));
            switch (tokens[i + 2]['value']) {
              case '+':
                mem[tokens[i + 1]['value']] = (num1! + num2).toString();
                break;
              case '-':
                mem[tokens[i + 1]['value']] = (num1! - num2).toString();
                break;
              case '*':
                mem[tokens[i + 1]['value']] = (num1! * num2).toString();
                break;
              case '/':
                mem[tokens[i + 1]['value']] = (num1! / num2).toString();
                break;
              case '%':
                mem[tokens[i + 1]['value']] = (num1! % num2).toString();
                break;
              case '=':
                mem[tokens[i + 1]['value']] = num2.toString();
                break;
              default:
                error('Failed to op: invalid operator', -1);
            }

            i += 3;
          } else {
            error('Failed to op: invalid parameters', -1);
          }
        }
        else if (tokens[i]['value'] == 'destroy') {
          mem.remove(tokens[++i]['value']);
        }
      }
      //else if (tokens[i]['id'] == 'identifier') {
        //mem[tokens[i - 1]['value']] = concatStrTokens(tokens, i);
        //print('${tokens[i]}, ${tokens[i + 1]}');
        //mem[tokens[i]['value']] = tokens[i]['value'] = getVal(tokens[++i]);
      //}
    }
  }

  int _getLabelPos(List tokens, String label) {
    for (int i = 0; i < tokens.length; i++) {
      if (tokens[i]['id'] == 'label' && tokens[i]['value'] == label) {
        return i;
      }
    }

    return -1; 
  }

  String getVal(var token) {
    return token['id'] == 'string' ? token['value'] : mem[token['value']];
  }

  bool matchTokenField(var token, String field, List<String> matches) {
    for (var s in matches) {
      if (token[field] == s)
        return true;
    }

    return false;
  }

  @Deprecated('no longer being implemented')
  String concatStrTokens(List tokens, int pos) {
    pos++;
    String retVal = tokens[pos]['value'];
    print('${tokens[pos]}, ${tokens[pos + 2]}');
    pos += 2;

    while (
      pos < tokens.length &&
      (tokens[pos]['id'] == 'string' ||
      tokens[pos]['id']  == 'identifier') //&&
      //tokens[pos - 1]['id'] == 'operator'
    ) {
      print('concat: ${tokens[pos]}, "${retVal}"');
      if (tokens[pos]['id'] == 'identifier' && !mem.containsKey(tokens[pos]['value'])) {
        error("Could not resolve identifier", -4);
      }
      retVal += tokens[pos]['id'] == 'identifier' ? mem[tokens[pos]['value']] : tokens[pos]['value'];
      pos += 2;
    }

    return retVal;
  }
}