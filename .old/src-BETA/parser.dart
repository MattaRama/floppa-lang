import 'util.dart';

class Parser {
  List tokens;
  List AST;

  Parser(this.tokens) : AST = [];

  void append_AST(dynamic node) {
    if (node != []) 
     AST.add(node);
    node = [];
  }

  void build_AST() {
    List node = [];

    for (int i = 0; i < tokens.length; i++) {
      var token = tokens[i];

      if (token['id'] == 'keyword') {
        if (token['value'] == 'print') {
          append_AST(node);

          //if (!matchTokenField(tokens[i + 1], 'id', ['string', 'identifier']))
          //  error('Failed to parse print: invalid parameter', -1);

          node.add(token);
          break;
        } else if (token['value'] == 'exit') {
          append_AST(node);

          AST.add(token);
        } else if (token['value'] == 'jmp')
      }
    }
  }
  
  bool matchTokenField(var token, String field, List<String> matches) {
    for (var s in matches) {
      if (token[field] == s)
        return true;
    }

    return false;
  }
}