String generateRegex(String word) {
  String newWord = word.replaceAll(RegExp(r'e'), '[e3]');
  newWord = newWord.replaceAll(RegExp(r's'), '[s\$]');
  newWord = newWord.replaceAll(RegExp(r'a'), '[a@]');
  newWord = newWord.replaceAll(RegExp(r'l'), '[l1]');
  newWord = newWord.replaceAll(RegExp(r'i'), '[i!]');
  newWord = newWord.replaceAll(RegExp(r'o'), '[o0]');
  newWord = newWord.replaceAll(RegExp(r't'), '[t+]');
  newWord = newWord.replaceAll(RegExp(r'f'), '(ph|f)');
  newWord = newWord.replaceAll(RegExp(r'ph'), '(ph|f)');
  newWord = newWord.replaceAll(RegExp(r'a'), '(a|er)');
  newWord = newWord.replaceAll(RegExp(r'er'), '(a|er)');

  return newWord;
}
