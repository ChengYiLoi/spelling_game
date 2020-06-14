import 'package:flutter/material.dart';
import 'package:education_calculator/components/category_card.dart';

class CategoriesScreen extends StatelessWidget {
  static String id = 'categories_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                CategoryCard('Fruits'),
                CategoryCard('Countries')
              ],
            ),
          ],
        ),
      ),
    );
  }
}


