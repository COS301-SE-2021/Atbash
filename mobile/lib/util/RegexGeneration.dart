import 'package:mobile/domain/ProfanityWord.dart';

String generateRegex(String word) {
  String newWord = r"(?<x>^|\s+)(?<y>";
  for (int i = 0; i < word.length; i++) {
    newWord += _replaceChar(word[i]);
  }

  return newWord + r")(?<z>$|\s+)";
}

String filterString(String unfiltered, List<ProfanityWord> words) {
  words.forEach((profanityWord) {
    unfiltered = unfiltered.replaceAllMapped(
        RegExp(profanityWord.regex, caseSensitive: false), (m) {
      final match = m as RegExpMatch;

      final preSpace = match.namedGroup("x") ?? "";
      final word = match.namedGroup("y") ?? "";
      final postSpace = match.namedGroup("z") ?? "";

      return preSpace + List.filled(word.length, "*").join() + postSpace;
    });
  });
  return unfiltered;
}

String _replaceChar(String c) {
  if (c.toLowerCase() == "e") {
    return "[e3]";
  }

  if (c.toLowerCase() == "s") {
    return r"[sz25$]";
  }

  if (c.toLowerCase() == "z") {
    return r"[z2s5$]";
  }

  if (c.toLowerCase() == "a") {
    return r"[a@4]";
  }

  if (c.toLowerCase() == "l") {
    return r"[l1I!|]";
  }

  if (c.toLowerCase() == "i") {
    return r"[i!1]";
  }

  if (c.toLowerCase() == "o") {
    return r"[o0]";
  }

  if (c.toLowerCase() == "t") {
    return r"[t7+]";
  }

  if (c.toLowerCase() == "f") {
    return r"(ph|f)";
  }

  if (c.toLowerCase() == "b") {
    return r"[b8]";
  }

  if (c.toLowerCase() == "g") {
    return r"[g9]";
  }

  return c;
}
