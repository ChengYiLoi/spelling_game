import 'package:education_calculator/screens/catergories_screen.dart';
import 'package:flutter/material.dart';
import 'screens/intro_screen.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'BalsamiqSansRegular',
       
        primarySwatch: Colors.blue,
       
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: IntroScreen.id,
      routes: {
        IntroScreen.id : (context) => IntroScreen(),
        CategoriesScreen.id : (context) => CategoriesScreen(),
      },
    );
  }
}


