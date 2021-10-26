class Parser {
  List tokens;
  List AST;

  Parser(this.tokens) : AST = [];

  void add_node(var parent, var node) {
    for (List a in AST) {
      if (a.contains(parent)) {
        a[parent].add(node);
      }
    }
  }

  void build_AST() {
    var saved = {};
    var parent = {};
    var collect = false;

    for (var token in tokens) {
      // process labels
      print(token);
      if (token['id'] == 'label') {
        var t = {token['value']: []};

        if (parent != t) {
          parent = t;
          AST.add(t);
        }
      }
      // keywords
      else if (token['id'] == 'keyword') {
        if (token['value'] == 'exit') {
          var t = {token['value']: 0};
          add_node(parent, t); 
        } else {
          if (!collect) {
            saved = token;
            collect = true;
          } else {
            var t = {saved['value']: token['value']};
            add_node(parent, t);
            collect = false;
          }
        }
      }
      // string literals 
      else if (token['id'] == 'string') {
        if (!collect) {
          saved = token;
          collect = true;
        } else {
          var t = {saved['value']: token['value']};
          add_node(parent, t);
          collect = false;
        }
      }
    }
  }
}