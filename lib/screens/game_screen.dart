import 'package:carousel_slider/carousel_slider.dart';
import 'package:education_calculator/classes/alphabets.dart';
import 'package:education_calculator/classes/game_master.dart';

import 'package:education_calculator/components/image_card.dart';
import 'package:education_calculator/components/keyboard.dart';
import 'package:education_calculator/components/letter_button.dart';
import 'package:education_calculator/components/letter_placeholder.dart';
import 'package:education_calculator/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

final String speaker = 'images/speaker.svg';
final String eraser = 'images/eraser.svg';
final String next = 'images/next.svg';

class GameScreen extends StatefulWidget {
  GameScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  GameMaster gameMaster;
  List<Widget> letterPlaceholders;
  int letterInputposition; // current index for the input
  int imageIndex; // current image index position
  List<Widget> keyboard;
  List<ImageCard> imageWidgets;
  String userInput;
  CarouselController carouselController;
  bool isHyphen;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    carouselController = CarouselController();
    loadGameData();
    initializeKeyboard();
    userInput = '';
    isHyphen = false;
    
    super.initState();
  }


  void loadGameData() async {
    print('load game data');
    gameMaster = GameMaster();
    imageIndex = 0;
    letterInputposition = 0;
    await gameMaster.initializeGame(widget.title);
    imageWidgets = await gameMaster.createImageWidgets();

    setState(() {
      print('set state called');
     
      letterPlaceholders = gameMaster
          .updateLetterPlaceholders(imageWidgets[imageIndex].getName());
    });
  }
  // cacheImages() async {
  //   imageWidgets.forEach((imageWidget) {
  //     precacheImage(NetworkImage(imageWidget.url), context);
  //   });
  // }



  updateLetterPlaceholder(String userInput) {
    setState(() {
      letterPlaceholders[letterInputposition] = LetterPlaceholder(userInput);
      letterInputposition++;
    });
  }

  initializeKeyboard() {
    Alphabets alphabets = Alphabets();
    List<LetterButton> alphabetKeysArray = alphabets.initializeAlphabetKeys();
    List<Widget> keyboardArray = [];
    alphabetKeysArray.forEach((letterButtonWidget) {
      keyboardArray.add(GestureDetector(
        onTap: () {
          String letter;
          if (letterInputposition == 0 || isHyphen) {
            letter = letterButtonWidget.getLetter();
            isHyphen = isHyphen ? !isHyphen : false;
          } else {
            letter = letterButtonWidget.getLetter().toLowerCase();
          }

          if (letterInputposition < imageWidgets[imageIndex].getName().length) {
            updateLetterPlaceholder(letter);
            userInput += letter;
            if (letterInputposition !=
                imageWidgets[imageIndex].getName().length) {
              print('checking for hyphen');
              checkHyphen(letterPlaceholders[letterInputposition]);
            }
          }

          if (userInput == imageWidgets[imageIndex].getName()) {
            print('correct');
            userInput = '';
            carouselController.nextPage(
                duration: Duration(milliseconds: 1000), curve: Curves.ease);

            imageIndex++;
          }
        },
        child: letterButtonWidget,
      ));
    });
    setState(() {
      keyboard = keyboardArray;
    });
  }

  displayMenu() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Return to categories'),
                  Text('Text to speech settings')
                ],
              ),
            ),
          );
        });
  }

  _speak(text) {
    FlutterTts flutterTts = FlutterTts();
    flutterTts.speak(text);
  }

  checkHyphen(LetterPlaceholder letterPlaceholder) {
    if (letterPlaceholder.getLetter() == '-') {
      print('found hyphen');
      setState(() {
        isHyphen = !isHyphen;
        letterInputposition++;
        userInput += '-';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
   
    return SafeArea(
      child: Scaffold(
          body: Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: imageWidgets == null
            ? SizedBox()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Stack(
                      children: <Widget>[
                        CarouselSlider(
                          items: imageWidgets,
                          carouselController: carouselController,
                          options: CarouselOptions(
                            height: MediaQuery.of(context).size.height * 0.25,
                            viewportFraction: 0.6,
                            initialPage: imageIndex,
                            enableInfiniteScroll: true,
                            enlargeCenterPage: true,
                            onPageChanged: (index, __) {
                              print('page change called');
                              imageIndex = index;
                              setState(() {
                                letterInputposition = 0;
                                letterPlaceholders =
                                    gameMaster.updateLetterPlaceholders(
                                        imageWidgets[imageIndex].getName());
                              });
                            },
                          ),
                        ),
                        // Positioned.fill(
                        //     child: Container(
                        //   color: Colors.transparent,
                        // ),),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      //alphabet inputs
                      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0),
                      child: Stack(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: letterPlaceholders ?? <Widget>[],
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 20,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 50.0),
                              child: Keyboard(keyboard),
                            ),
                          ),
                          Positioned(
                            bottom: 15,
                            right: 20,
                            child: Container(
                              decoration: keyBoardActionButtonDecoration,
                              width: 120,
                              height: 50,
                              child: RaisedButton(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                color: Colors.blueGrey,
                                onPressed: () {
                                  _speak(imageWidgets[imageIndex].getName());
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: SvgPicture.asset(speaker),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 20,
                            left: 20,
                            child: Container(
                              width: 120,
                              height: 50,
                              child: RaisedButton(
                                onPressed: () => displayMenu(),
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: Colors.blueGrey,
                                child: Text(
                                  'Menu',
                                  style: TextStyle(fontSize: 22),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 20,
                            right: 20,
                            child: Container(
                              width: 120,
                              height: 50,
                              child: RaisedButton(
                                onPressed: () {},
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: Colors.blueGrey,
                                child: SvgPicture.asset(next),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 15,
                            left: 20,
                            child: Container(
                              decoration: keyBoardActionButtonDecoration,
                              width: 120,
                              height: 50,
                              child: RaisedButton(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                color: Colors.blueGrey,
                                onPressed: () {
                                  print('earaser pressed');
                                  userInput = '';

                                  setState(() {
                                    letterInputposition = 0;
                                    print(imageWidgets[imageIndex].getName());
                                    letterPlaceholders =
                                        gameMaster.updateLetterPlaceholders(
                                            imageWidgets[imageIndex].getName());
                                  });
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: SvgPicture.asset(eraser),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
      )),
    );
  }
}