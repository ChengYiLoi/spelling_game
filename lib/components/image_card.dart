import 'package:flutter/material.dart';


class ImageCard extends StatelessWidget {
  final Image image;
  final String name;
  ImageCard(this.name, this.image);

  getName() => name;

  
  @override
  Widget build(BuildContext context) {
    return Card(
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(child: image,)
          ],
        ),
      );
  }
}