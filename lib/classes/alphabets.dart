import 'package:education_calculator/components/letter_button.dart';

class Alphabets {
  final String alphabets = 'QWERTYUIOPASDFGHJKL ZXCVBNM';

  createAlphabetKeys() {
    List<LetterButton> keyboardArray = [];
    for (var i = 0; i < alphabets.length; i++) {
      var letter = alphabets[i];
      keyboardArray.add(
        LetterButton(letter),
      );
    }
    return keyboardArray;
  }
}
