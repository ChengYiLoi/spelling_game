import 'dart:io';
import 'package:education_calculator/classes/text_to_speech_settings.dart';
import 'package:education_calculator/screens/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';

checkConnection() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connection available');
      return true;
    }
  } catch (e) {
    return false;
  }
}

class CategoryCard extends StatelessWidget {
  final String category;

  CategoryCard(this.category);

  @override
  Widget build(BuildContext context) {
    bool hasConnection;

    noConnectionDialog() {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('An internet connection is required'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                    child: Center(
                      child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey,
                              ),
                              width: 100,
                              child: Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Ok'),
                              )))),
                    ),
                  )
                ],
              ),
            );
          });
    }

    return Container(
      constraints: BoxConstraints(
          maxWidth: (MediaQuery.of(context).size.width * 0.5 - 16.0)),
      child: Card(
        color: grey,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () async {
            hasConnection = await checkConnection();
            hasConnection
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                          create: (context) => TextToSpeechSettings(),
                          child: GameScreen(category)),
                    ),
                  )
                : noConnectionDialog();
          },
          child: Center(
              child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(category),
            //TODO add icon
          )),
        ),
      ),
    );
  }
}
