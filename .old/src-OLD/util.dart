String join(List arr) {
  String ret = '';

  for (dynamic s in arr) {
    ret += s.toString();
  }

  return ret;
}