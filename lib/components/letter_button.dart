import 'package:education_calculator/constants.dart';
import 'package:flutter/material.dart';

class LetterButton extends StatelessWidget {
  final String letter;
  LetterButton(this.letter);
  getLetter() => letter;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: letter == ' '
          ? BoxDecoration(color: Colors.transparent)
          : keyBoardActionButtonDecoration,
      width: letter == ' ' ? 1.0 : 50.0,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            letter,
            style: TextStyle(fontSize: 26),
          ),
        ),
      ),
    );
  }
}
