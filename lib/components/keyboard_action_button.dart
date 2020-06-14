import 'package:education_calculator/components/image_card.dart';
import 'package:flutter/material.dart';
import 'package:education_calculator/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class KeyboardActionButton extends StatelessWidget {
  const KeyboardActionButton({
    Key key,
    @required this.content,
    @required this.imageWidgets,
    @required this.imageIndex,
    @required this.onTapFunction,
  }) : super(key: key);

  final List<ImageCard> imageWidgets;
  final int imageIndex;
  final Function onTapFunction;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: keyBoardActionButtonDecoration,
      width: 120,
      height: 50,
      child: RaisedButton(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Colors.blueGrey,
        onPressed: () {
          onTapFunction(imageWidgets[imageIndex].getName());
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: content.contains('svg')
              ? SvgPicture.asset(content)
              : Text(
                  content,
                  style: TextStyle(fontSize: 22),
                ),
        ),
      ),
    );
  }
}