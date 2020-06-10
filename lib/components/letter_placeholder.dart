import 'package:flutter/material.dart';
import 'package:education_calculator/constants.dart';

class LetterPlaceholder extends StatelessWidget {
  final String letter;
  LetterPlaceholder(this.letter);
  getLetter() => letter;
  @override
  Widget build(BuildContext context) {
    return Padding(
      
      padding: const EdgeInsets.all(2.5),
      child: Container(

        width: 30,
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 5, color: Colors.pink))),
        child: Padding(
          padding: letterPlaceholderPadding,
          child: Text(
              letter,
              style: letterPlaceholderStyle,
              textAlign: TextAlign.center,
              
            ),
        ),
      ),
    );
  }
}
