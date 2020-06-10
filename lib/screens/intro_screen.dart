import 'package:education_calculator/screens/catergories_screen.dart';
import 'package:flutter/material.dart';
import 'package:education_calculator/constants.dart';

class IntroScreen extends StatelessWidget {
  static const String id = 'intro_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF26BCFD),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('WORD GAME', style: mainTitleStyle,),
            SizedBox(height: 30),
            Center(
                child: RaisedButton(
              onPressed: () => Navigator.pushNamed(context, CategoriesScreen.id),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)
                
              ),
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Text('START LEARNING', style: mainButtonStyle,),
              ),
            ))
          ],
        ));
  }
}
