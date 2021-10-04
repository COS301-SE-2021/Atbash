String generateRegex(String word) {
  String newWord = word.replaceAll(RegExp(r'e'), '[e3]');
  newWord = newWord.replaceAll(RegExp(r's'), '[s5z2\$]');
  newWord = newWord.replaceAll(RegExp(r'z'), '[z2s5\$]');
  newWord = newWord.replaceAll(RegExp(r'a'), '[a@4]');
  newWord = newWord.replaceAll(RegExp(r'l'), '[l1I!|]');
  newWord = newWord.replaceAll(RegExp(r'i'), '[i!1]');
  newWord = newWord.replaceAll(RegExp(r'o'), '[o0]');
  newWord = newWord.replaceAll(RegExp(r't'), '[t7+]');
  newWord = newWord.replaceAll(RegExp(r'f'), '(ph|f)');
  newWord = newWord.replaceAll(RegExp(r'ph'), '(ph|f)');
  newWord = newWord.replaceAll(RegExp(r'a'), '(a|er)');
  newWord = newWord.replaceAll(RegExp(r'er'), '(a|er)');
  newWord = newWord.replaceAll(RegExp(r'b'), '[b8]');
  newWord = newWord.replaceAll(RegExp(r'g'), '[g9]');

  return newWord;
}
