import 'package:flutter/material.dart';

class Keyboard extends StatelessWidget {
  final List<Widget> letterWidgets;
  Keyboard(this.letterWidgets);
  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 18,
      runSpacing: 16,
      direction: Axis.horizontal,
      children: letterWidgets,
    );
  }
}
