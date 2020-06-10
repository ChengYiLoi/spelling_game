import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


class ImageCard extends StatelessWidget {
  final String url;
  final String name;
  ImageCard(this.name, this.url);

  getName() => name;

  
  @override
  Widget build(BuildContext context) {
  
    return Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(child: CachedNetworkImage(imageUrl: url)),
          ],
        ),
      );
  }
}