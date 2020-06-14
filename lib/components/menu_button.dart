import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final String text;

  MenuButton(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.lightBlue,
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(child: Text(text)),
      ),
    );
  }
}