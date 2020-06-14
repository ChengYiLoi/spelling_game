import 'package:education_calculator/classes/alphabets.dart';
import 'package:education_calculator/classes/game_master.dart';
import 'package:education_calculator/classes/text_to_speech_settings.dart';
import 'package:education_calculator/components/image_card.dart';
import 'package:education_calculator/components/keyboard.dart';
import 'package:education_calculator/components/letter_button.dart';
import 'package:education_calculator/components/letter_placeholder.dart';
import 'package:education_calculator/components/menu_button.dart';
import 'package:education_calculator/components/text_to_speech_settings_dialog.dart';
import 'package:education_calculator/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:education_calculator/components/tTs_slider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:education_calculator/components/keyboard_action_button.dart';

final String speaker = 'images/speaker.svg';
final String eraser = 'images/eraser.svg';
final String next = 'images/next.svg';
final String previous = 'images/previous.svg';

class GameScreen extends StatefulWidget {
  final String category;

  GameScreen(this.category);

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
  FlutterTts flutterTts;
  SpinKitWave spinkit;

  TextToSpeechSettings tTsSettings;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    carouselController = CarouselController();
    imageIndex = 0;
    letterInputposition = 0;
    loadGameData();
    initializeKeyboard();
    userInput = '';
    isHyphen = false;
    spinkit = SpinKitWave(
      color: Colors.blueGrey,
      size: 50,
    );

    flutterTts = FlutterTts();
    tTsSettings = Provider.of<TextToSpeechSettings>(context, listen: false);

    super.initState();
  }

  void loadGameData() async {
    print('loading game data');
    gameMaster = GameMaster();

    await gameMaster.initializeGame(widget.category);
    imageWidgets = await gameMaster.createImageWidgets();
    preCacheImages(imageWidgets);
    setState(() {
      print('set state called');
      letterPlaceholders = gameMaster
          .updateLetterPlaceholders(imageWidgets[imageIndex].getName());
    });
  }

  updateLetterPlaceholder(String userInput) {
    setState(() {
      letterPlaceholders[letterInputposition] = LetterPlaceholder(userInput);
      letterInputposition++;
    });
  }

  preCacheImages(List<ImageCard> imageWidgets) {
    print('cache images');
    imageWidgets.forEach((imageWidget) {
      precacheImage(imageWidget.image.image, context);
    });
  }

  initializeKeyboard() {
    print('initializing keyboard');
    Alphabets alphabets = Alphabets();
    List<LetterButton> alphabetKeysArray = alphabets.createAlphabetKeys();
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
            letterInputposition = 0;
            carouselController.nextPage(
                duration: carouselDurarion, curve: carouselCurve);
          }
        },
        child: letterButtonWidget,
      ));
    });
    setState(() {
      keyboard = keyboardArray;
    });
  }

  resetPlaceholders(String _) {
    print('eraser pressed');
    setState(() {
      userInput = '';
      letterInputposition = 0;
      letterPlaceholders = gameMaster
          .updateLetterPlaceholders(imageWidgets[imageIndex].getName());
    });
  }

  displayMenu(String _) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: MenuButton('Return to Categories'),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  GestureDetector(
                    onTap: () {
                      displayTtsSettings();
                    },
                    child: MenuButton('Text to Speech Settings'),
                  )
                ],
              ),
            ),
          );
        });
  }

  displayTtsSettings() {
    double volume = tTsSettings.getVolume();
    double pitch = tTsSettings.getPitch();
    double rate = tTsSettings.getRate();
    updateValue(text, value) {
      switch (text) {
        case 'Volume':
          {
            volume = value;
          }
          break;
        case 'Pitch':
          {
            pitch = value;
          }
          break;
        case 'Rate':
          {
            rate = value;
          }
          break;
      }
    }

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          List<TextToSpeechSlider> sliderArray = [
            TextToSpeechSlider(
                'Volume', volume, 0.0, 1.0, updateValue, speakSettings),
            TextToSpeechSlider(
                'Pitch', pitch, 0.5, 2.0, updateValue, speakSettings),
            TextToSpeechSlider(
                'Rate', rate, 0.0, 1.0, updateValue, speakSettings)
          ];
          return TextToSpeechSettingsDialog(
            tTsSettings: tTsSettings,
            sliderArray: sliderArray,
            volume: volume,
            pitch: pitch,
            rate: rate,
            speak: speak,
            speakSettings: speakSettings,
          );
        });
  }

  speak(text) {
    flutterTts.speak(text);
  }

  speakSettings(String text, double value) {
    switch (text) {
      case 'Volume':
        {
          flutterTts.setVolume(value);
        }
        break;
      case 'Pitch':
        {
          flutterTts.setPitch(value);
        }
        break;
      case 'Rate':
        {
          flutterTts.setSpeechRate(value);
        }
        break;
    }
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
          resizeToAvoidBottomInset: false,
          body: Container(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: imageWidgets == null
                ? spinkit
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          CarouselSlider(
                            items: imageWidgets,
                            carouselController: carouselController,
                            options: CarouselOptions(
                              height: MediaQuery.of(context).size.height * 0.25,
                              viewportFraction: 0.6,
                              initialPage: imageIndex,
                              enlargeCenterPage: true,
                              onPageChanged: (index, __) {
                                print('page change called');
                                imageIndex = index;
                                letterInputposition = 0;
                                setState(() {
                                  speak(imageWidgets[imageIndex].getName());
                                  letterPlaceholders =
                                      gameMaster.updateLetterPlaceholders(
                                          imageWidgets[imageIndex].getName());
                                });
                              },
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          //alphabet inputs
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50.0),
                                  child: Keyboard(keyboard),
                                ),
                              ),
                              Positioned(
                                bottom: 15,
                                right: 20,
                                child: KeyboardActionButton(
                                  content: speaker,
                                  imageWidgets: imageWidgets,
                                  imageIndex: imageIndex,
                                  onTapFunction: speak,
                                ),
                              ),
                              Positioned(
                                  top: 20,
                                  left: 20,
                                  child: KeyboardActionButton(
                                    content: 'Menu',
                                    imageWidgets: imageWidgets,
                                    imageIndex: imageIndex,
                                    onTapFunction: displayMenu,
                                  )),
                              Positioned(
                                top: 15,
                                right: 0,
                                child: Row(
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () =>
                                          carouselController.previousPage(
                                              duration: carouselDurarion,
                                              curve: carouselCurve),
                                      child: SizedBox(
                                        width: 70,
                                        height: 50,
                                        child: SvgPicture.asset(previous),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        carouselController.nextPage(
                                            duration: carouselDurarion,
                                            curve: carouselCurve);
                                      },
                                      child: SizedBox(
                                        width: 70,
                                        height: 50,
                                        child: SvgPicture.asset(next),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                  bottom: 15,
                                  left: 20,
                                  child: KeyboardActionButton(
                                    content: eraser,
                                    imageWidgets: imageWidgets,
                                    imageIndex: imageIndex,
                                    onTapFunction: resetPlaceholders,
                                  )),
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
