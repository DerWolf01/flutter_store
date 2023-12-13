import 'package:characters/characters.dart';

class AlphabetUtility {
  AlphabetUtility();
  final List<String> alphabet = [
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z'
  ];

  List<String> orderByAlphabet(List<String> strings) {
    var res = strings;

    for (int i = 0; i < strings.length; i++) {
      if (i == strings.length - 1) {
        continue;
      }
      var actual = strings[i];
      var actualLetterIndeces = getStringLetterIndeces(strings[i]);

      var next = strings[i];
      var nextLetterIndeces = getStringLetterIndeces(strings[i + 1]);
      if (nextLetterIndeces < actualLetterIndeces) {
        res[i] = next;
        res[i + 1] = actual;
      }
    }
    return res;
  }

  int getStringLetterIndeces(String string) {
    int indexIndecesSum = 0;
    for (var letter in string.characters) {
      if (!alphabet.contains(letter)) {
        continue;
      }
      indexIndecesSum += alphabet.indexOf(letter);
    }

    return indexIndecesSum;
  }
}
