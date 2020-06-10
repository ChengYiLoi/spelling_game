import 'package:education_calculator/constants.dart';
import 'package:education_calculator/screens/game_screen.dart';
import 'package:flutter/material.dart';


class CategoriesScreen extends StatelessWidget {
  static String id = 'categories_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Card(
            color: grey,
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GameScreen(title: 'Fruits'),
                ),
              ),
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Fruits'),
                //TODO add icon
              )),
            ),
          )
        ],
      ),
    );
  }
}
